import 'package:flutter/material.dart';
import '../models/activity.dart';

class AppIcons {
  static IconData getEvaluationIcon(Evaluation eval) {
    switch (eval) {
      case Evaluation.superHappy:
        return Icons.star;
      case Evaluation.cool:
        return Icons.thumb_up;
      case Evaluation.party:
        return Icons.celebration;
      case Evaluation.inLove:
        return Icons.favorite;
      case Evaluation.excited:
        return Icons.psychology;
      case Evaluation.laughing:
        return Icons.sentiment_satisfied_alt;
    }
  }

  static IconData getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.concert:
        return Icons.festival;
      case ActivityType.museum:
        return Icons.account_balance;
      case ActivityType.book:
        return Icons.auto_stories;
      case ActivityType.travel:
        return Icons.travel_explore;
      case ActivityType.movie:
        return Icons.local_movies;
      case ActivityType.music:
        return Icons.music_note;
    }
  }
}
