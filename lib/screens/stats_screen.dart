import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/activity.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class StatsScreen extends StatelessWidget {
  final List<Activity> activities;

  const StatsScreen({
    super.key,
    required this.activities,
  });

  Map<ActivityType, int> _getActivityTypeCounts() {
    final counts = <ActivityType, int>{};
    for (var type in ActivityType.values) {
      counts[type] =
          activities.where((activity) => activity.type == type).length;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final typeCounts = _getActivityTypeCounts();
    final maxCount =
        typeCounts.values.fold(0, (max, count) => count > max ? count : max);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar Chart
            Container(
              height: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.blue[300]!.withAlpha(51),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[300]!.withAlpha(51),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: maxCount.toDouble() + 1,
                  barGroups: ActivityType.values.map((type) {
                    return BarChartGroupData(
                      x: type.index,
                      barRods: [
                        BarChartRodData(
                          toY: typeCounts[type]!.toDouble(),
                          color: AppColors.getTypeColor(type),
                          width: 32,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxCount.toDouble() + 1,
                            color: AppColors.getTypeColor(type).withAlpha(26),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final type = ActivityType.values[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Icon(
                              AppIcons.getActivityIcon(type),
                              color: AppColors.getTypeColor(type),
                              size: 32,
                            ),
                          );
                        },
                        reservedSize: 60,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == value.roundToDouble()) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white10,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
