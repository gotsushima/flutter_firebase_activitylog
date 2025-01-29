enum ActivityType {
  concert,
  museum,
  book,
  travel,
  movie,
  music,
}

enum Evaluation {
  superHappy,
  cool,
  party,
  inLove,
  excited,
  laughing,
}

class Activity {
  final String? id;
  final ActivityType type;
  final String name;
  final String comment;
  final Evaluation evaluation;
  final DateTime createdAt;

  Activity({
    this.id,
    required this.type,
    required this.name,
    required this.comment,
    required this.evaluation,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Activity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'name': name,
      'comment': comment,
      'evaluation': evaluation.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Activity from JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String?,
      type: ActivityType.values[json['type'] as int],
      name: json['name'] as String,
      comment: json['comment'] as String,
      evaluation: Evaluation.values[json['evaluation'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
