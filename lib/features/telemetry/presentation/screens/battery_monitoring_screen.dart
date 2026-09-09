import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../core/widgets/sr_metric_tile.dart';
import '../../../../shared/components/telemetry_gauge.dart';
import '../providers/telemetry_provider.dart';

class BatteryMonitoringScreen extends ConsumerWidget {
  const BatteryMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider);
    final historyAsync = ref.watch(telemetryHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Battery')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: TelemetryGauge(
              value: telemetry?.batteryPercentage ?? 0,
              min: 0,
              max: 100,
              label: 'Battery',
              unit: '%',
              color: _color(telemetry?.batteryPercentage),
              size: 180,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SrCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                SrMetricTile(
                  icon: Icons.bolt,
                  label: 'Voltage',
                  value: telemetry?.voltageV.toStringAsFixed(1) ?? '--',
                  unit: 'V',
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                SrMetricTile(
                  icon: Icons.electric_meter_outlined,
                  label: 'Current',
                  value: telemetry?.currentA.toStringAsFixed(1) ?? '--',
                  unit: 'A',
                  iconColor: AppColors.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SrCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discharge Trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 150,
                  child: historyAsync.when(
                    loading: () => const SkeletonPulse(
                      child: SkeletonBox(height: 150, radius: 8),
                    ),
                    error: (_, __) => const Center(child: Text('No data')),
                    data: (history) {
                      if (history.isEmpty) {
                        return const Center(child: Text('No history yet'));
                      }
                      final sorted = history.toList()
                        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                      final spots = sorted.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value.batteryPercentage,
                        );
                      }).toList();
                      return LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.success,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.success.withValues(
                                  alpha: 0.08,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _color(double? pct) {
    if (pct == null) return AppColors.onSurfaceSecondary;
    if (pct <= 20) return AppColors.error;
    if (pct <= 50) return AppColors.warning;
    return AppColors.success;
  }
}
