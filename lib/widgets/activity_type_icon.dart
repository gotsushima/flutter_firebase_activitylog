import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class ActivityTypeIcon extends StatelessWidget {
  final ActivityType type;
  final ActivityType? selectedType;
  final VoidCallback onTap;
  final bool showLabel;

  const ActivityTypeIcon({
    super.key,
    required this.type,
    required this.selectedType,
    required this.onTap,
    this.showLabel = true,
  });

  String _getTypeLabel(ActivityType type) {
    switch (type) {
      case ActivityType.concert:
        return 'Concert';
      case ActivityType.museum:
        return 'Museum';
      case ActivityType.book:
        return 'Book';
      case ActivityType.travel:
        return 'Travel';
      case ActivityType.movie:
        return 'Movie';
      case ActivityType.music:
        return 'Music';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selectedType == type
                    ? AppColors.getTypeColor(type).withAlpha(51)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedType == type
                      ? AppColors.getTypeColor(type).withAlpha(77)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: selectedType == type
                    ? [
                        BoxShadow(
                          color: AppColors.getTypeColor(type).withAlpha(51),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                AppIcons.getActivityIcon(type),
                size: 20,
                color: selectedType == type
                    ? AppColors.getTypeColor(type)
                    : Colors.white70,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Text(
                _getTypeLabel(type),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: selectedType == type
                      ? AppColors.getTypeColor(type)
                      : Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
