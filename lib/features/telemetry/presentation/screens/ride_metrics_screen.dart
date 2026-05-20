import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_metric_tile.dart';
import '../../../../shared/components/telemetry_gauge.dart';
import '../providers/telemetry_provider.dart';

class RideMetricsScreen extends ConsumerWidget {
  const RideMetricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Metrics')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: TelemetryGauge(
              value: telemetry?.speedKmh ?? 0,
              min: 0,
              max: 60,
              label: 'Speed',
              unit: 'km/h',
              color: AppColors.primary,
              size: 180,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SrCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                SrMetricTile(
                  icon: Icons.settings_input_component_outlined,
                  label: 'Motor RPM',
                  value: telemetry?.motorRpm.toString() ?? '--',
                  unit: 'rpm',
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                SrMetricTile(
                  icon: Icons.route_outlined,
                  label: 'Odometer',
                  value: telemetry?.odometer.toStringAsFixed(1) ?? '--',
                  unit: 'km',
                  iconColor: AppColors.onSurfaceSecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                SrMetricTile(
                  icon: Icons.thermostat_outlined,
                  label: 'Motor Temperature',
                  value: telemetry?.temperatureCelsius.toStringAsFixed(0) ??
                      '--',
                  unit: '°C',
                  iconColor: _tempColor(telemetry?.temperatureCelsius),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _tempColor(double? temp) {
    if (temp == null) return AppColors.onSurfaceSecondary;
    if (temp >= 70) return AppColors.error;
    if (temp >= 55) return AppColors.warning;
    return AppColors.success;
  }
}
