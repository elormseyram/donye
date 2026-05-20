import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class BatteryIndicator extends StatelessWidget {
  const BatteryIndicator({
    super.key,
    required this.percentage,
    this.showLabel = true,
    this.height = 8,
    this.width,
  });

  final double percentage;
  final bool showLabel;
  final double height;
  final double? width;

  Color get _color {
    if (percentage <= 20) return AppColors.batteryLow;
    if (percentage <= 50) return AppColors.batteryMedium;
    return AppColors.batteryHigh;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = percentage.clamp(0.0, 100.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: LinearProgressIndicator(
                    value: clamped / 100,
                    backgroundColor: AppColors.outline,
                    valueColor: AlwaysStoppedAnimation<Color>(_color),
                  ),
                ),
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${clamped.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _color,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
