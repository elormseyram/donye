import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/weekly_stats_entity.dart';

class EnergyConsumptionChart extends StatelessWidget {
  const EnergyConsumptionChart({super.key, required this.stats});
  final WeeklyStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final data = stats.dailyDistance;
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No data this week',
          style: TextStyle(color: AppColors.onSurfaceSecondary),
        ),
      );
    }

    final dayFmt = DateFormat('E');
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.energyKwh);
    }).toList();

    final maxY = data.map((d) => d.energyKwh).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY > 0 ? maxY * 1.3 : 1,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColors.success,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                    radius: 3,
                    color: AppColors.success,
                    strokeWidth: 0,
                    strokeColor: Colors.transparent,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.success.withValues(alpha: 0.08),
                ),
              ),
            ],
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
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
                    val.toStringAsFixed(1),
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
