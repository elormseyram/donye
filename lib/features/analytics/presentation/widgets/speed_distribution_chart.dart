import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/ride_session_entity.dart';

class SpeedDistributionChart extends StatelessWidget {
  const SpeedDistributionChart({super.key, required this.sessions});
  final List<RideSessionEntity> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'No ride data available',
          style: TextStyle(color: AppColors.onSurfaceSecondary),
        ),
      );
    }

    // Bucket speeds: 0-20, 20-30, 30-40, 40-50, 50+
    final buckets = [0, 0, 0, 0, 0];
    for (final s in sessions) {
      final avg = s.avgSpeedKmh;
      if (avg < 20) {
        buckets[0]++;
      } else if (avg < 30) {
        buckets[1]++;
      } else if (avg < 40) {
        buckets[2]++;
      } else if (avg < 50) {
        buckets[3]++;
      } else {
        buckets[4]++;
      }
    }

    final labels = ['<20', '20-30', '30-40', '40-50', '50+'];
    final total = buckets.fold(0, (s, b) => s + b);
    final sections = List.generate(buckets.length, (i) {
      if (buckets[i] == 0) return null;
      final pct = buckets[i] / total * 100;
      final colors = [
        AppColors.success,
        AppColors.primary,
        AppColors.warning,
        AppColors.error.withValues(alpha: 0.7),
        AppColors.error,
      ];
      return PieChartSectionData(
        value: pct,
        color: colors[i],
        title: '${pct.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    }).whereType<PieChartSectionData>().toList();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 36,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.center,
          children: List.generate(labels.length, (i) {
            if (buckets[i] == 0) return const SizedBox.shrink();
            final colors = [
              AppColors.success,
              AppColors.primary,
              AppColors.warning,
              AppColors.error.withValues(alpha: 0.7),
              AppColors.error,
            ];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${labels[i]} km/h',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
