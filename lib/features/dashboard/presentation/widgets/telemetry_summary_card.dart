import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/sr_card.dart';
import '../../../../../core/widgets/sr_metric_tile.dart';
import '../../../../../shared/components/battery_indicator.dart';

class TelemetrySummaryCard extends StatelessWidget {
  const TelemetrySummaryCard({
    super.key,
    this.batteryPercentage,
    this.speedKmh,
    this.temperatureCelsius,
    this.odometer,
    this.isLoading = false,
  });

  final double? batteryPercentage;
  final double? speedKmh;
  final double? temperatureCelsius;
  final double? odometer;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.electric_bolt,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Live Telemetry',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLoading
                      ? AppColors.warning
                      : batteryPercentage != null
                          ? AppColors.success
                          : AppColors.outline,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                isLoading
                    ? 'Connecting…'
                    : batteryPercentage != null
                        ? 'Live'
                        : 'No signal',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _BatteryRow(percentage: batteryPercentage, isLoading: isLoading),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: SrMetricTile(
                  icon: Icons.speed,
                  label: 'Speed',
                  value: isLoading || speedKmh == null
                      ? '--'
                      : speedKmh!.toStringAsFixed(1),
                  unit: 'km/h',
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SrMetricTile(
                  icon: Icons.thermostat_outlined,
                  label: 'Temp',
                  value: isLoading || temperatureCelsius == null
                      ? '--'
                      : temperatureCelsius!.toStringAsFixed(0),
                  unit: '°C',
                  iconColor: _tempColor(temperatureCelsius),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SrMetricTile(
                  icon: Icons.route_outlined,
                  label: 'Odo.',
                  value: isLoading || odometer == null
                      ? '--'
                      : odometer!.toStringAsFixed(0),
                  unit: 'km',
                  iconColor: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
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

class _BatteryRow extends StatelessWidget {
  const _BatteryRow({this.percentage, required this.isLoading});
  final double? percentage;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.battery_charging_full_outlined,
              size: 16,
              color: AppColors.onSurfaceSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Battery',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isLoading || percentage == null)
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        else
          BatteryIndicator(percentage: percentage!, height: 10),
      ],
    );
  }
}
