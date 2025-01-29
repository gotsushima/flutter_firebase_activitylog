import 'package:flutter/material.dart';
import '../models/activity.dart';

class AppColors {
  static Color getTypeColor(ActivityType type) {
    switch (type) {
      case ActivityType.concert:
        return Colors.purple[300]!;
      case ActivityType.museum:
        return Colors.amber[300]!;
      case ActivityType.book:
        return Colors.green[300]!;
      case ActivityType.travel:
        return Colors.cyan[300]!;
      case ActivityType.movie:
        return Colors.red[300]!;
      case ActivityType.music:
        return Colors.purple[300]!;
    }
  }

  static Color getEvaluationColor(Evaluation eval) {
    switch (eval) {
      case Evaluation.superHappy:
        return Colors.yellow[300]!;
      case Evaluation.cool:
        return Colors.cyan[300]!;
      case Evaluation.party:
        return Colors.purple[300]!;
      case Evaluation.inLove:
        return Colors.pink[300]!;
      case Evaluation.excited:
        return Colors.orange[300]!;
      case Evaluation.laughing:
        return Colors.green[300]!;
    }
  }
}
