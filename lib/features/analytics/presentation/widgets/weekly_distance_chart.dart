import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/weekly_stats_entity.dart';

class WeeklyDistanceChart extends StatelessWidget {
  const WeeklyDistanceChart({super.key, required this.stats});
  final WeeklyStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final data = stats.dailyDistance;
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No rides this week',
          style: TextStyle(color: AppColors.onSurfaceSecondary),
        ),
      );
    }

    final maxY = data.map((d) => d.distanceKm).reduce((a, b) => a > b ? a : b);
    final dayFmt = DateFormat('E');

    final bars = data.asMap().entries.map((entry) {
      final i = entry.key;
      final d = entry.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: d.distanceKm,
            color: AppColors.primary,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: BarChart(
          BarChartData(
            maxY: maxY > 0 ? maxY * 1.3 : 1,
            barGroups: bars,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY > 0 ? maxY / 4 : 1,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: AppColors.outline, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (val, _) => Text(
                    val.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, _) {
                    final idx = val.toInt();
                    if (idx < 0 || idx >= data.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        dayFmt.format(data[idx].date),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
