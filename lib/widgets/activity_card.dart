import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onDelete,
    this.onEdit,
  });

  Widget _buildEvalIcon(Evaluation eval) {
    return Icon(
      AppIcons.getEvaluationIcon(eval),
      color: AppColors.getEvaluationColor(eval),
      size: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          AppIcons.getActivityIcon(activity.type),
          color: AppColors.getTypeColor(activity.type),
        ),
        title: Text(
          activity.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: activity.comment.isNotEmpty ? Text(activity.comment) : null,
        trailing: Wrap(
          spacing: 6,
          children: [
            _buildEvalIcon(activity.evaluation),
            const SizedBox(width: 0),
            if (onEdit != null)
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, color: Colors.white70, size: 20),
              ),
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child:
                    const Icon(Icons.delete, color: Colors.white70, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
