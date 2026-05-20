import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../shared/components/speed_ring.dart';
import '../../../../../shared/components/battery_indicator.dart';
import '../providers/telemetry_provider.dart';

class TelemetryLiveHeader extends ConsumerWidget {
  const TelemetryLiveHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider);
    final isConnected = telemetry != null;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          SpeedRing(speedKmh: telemetry?.speedKmh ?? 0),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _StatChip(
                icon: Icons.battery_charging_full,
                value: isConnected
                    ? '${telemetry.batteryPercentage.toStringAsFixed(0)}%'
                    : '--',
                label: 'Battery',
                color: _batteryColor(telemetry?.batteryPercentage),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                icon: Icons.bolt,
                value: isConnected
                    ? '${telemetry.voltageV.toStringAsFixed(1)}V'
                    : '--',
                label: 'Voltage',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                icon: Icons.thermostat,
                value: isConnected
                    ? '${telemetry.temperatureCelsius.toStringAsFixed(0)}°C'
                    : '--',
                label: 'Temp',
                color: _tempColor(telemetry?.temperatureCelsius),
              ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: AppSpacing.md),
            BatteryIndicator(
              percentage: telemetry.batteryPercentage,
              height: 6,
            ),
          ],
        ],
      ),
    );
  }

  Color _batteryColor(double? pct) {
    if (pct == null) return AppColors.onSurfaceSecondary;
    if (pct <= 20) return AppColors.error;
    if (pct <= 50) return AppColors.warning;
    return AppColors.success;
  }

  Color _tempColor(double? temp) {
    if (temp == null) return AppColors.onSurfaceSecondary;
    if (temp >= 70) return AppColors.error;
    if (temp >= 55) return AppColors.warning;
    return AppColors.success;
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
