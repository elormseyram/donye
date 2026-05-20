import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../shared/components/map_overlay_card.dart';

class SpeedOverlayChip extends StatelessWidget {
  const SpeedOverlayChip({super.key, required this.speedKmh});
  final double speedKmh;

  @override
  Widget build(BuildContext context) {
    return MapOverlayCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.speed, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${speedKmh.toStringAsFixed(0)} km/h',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
