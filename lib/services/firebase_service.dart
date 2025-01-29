import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/activity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseService {
  static String get baseUrl =>
      dotenv.env['FIREBASE_URL'] ?? 'YOUR_FIREBASE_URL_HERE';

  Future<List<Activity>> getActivities() async {
    if (!baseUrl.startsWith('http')) {
      throw Exception(baseUrl);
    }
    final response = await http.get(Uri.parse('$baseUrl/activities.json'));

    if (response.statusCode == 200) {
      if (response.body == 'null') return [];

      final Map<String, dynamic> data = json.decode(response.body);
      return data.entries
          .map((e) => Activity.fromJson({...e.value, 'id': e.key}))
          .toList();
    }
    throw Exception('Failed to load activities');
  }

  Future<Activity> createActivity(Activity activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/activities.json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(activity.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Activity.fromJson({...activity.toJson(), 'id': data['name']});
      } else {
        throw Exception('Failed to create activity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> deleteActivity(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/activities/$id.json'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }

  Future<Activity> updateActivity(Activity activity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/activities/${activity.id}.json'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(activity.toJson()),
    );

    if (response.statusCode == 200) {
      return activity;
    }
    throw Exception('Failed to update activity');
  }
}
