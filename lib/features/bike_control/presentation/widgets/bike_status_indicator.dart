import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

enum BikeSecurityState { locked, unlocked, unknown }

class BikeStatusIndicator extends StatelessWidget {
  const BikeStatusIndicator({super.key, required this.securityState});

  final BikeSecurityState securityState;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (securityState) {
      BikeSecurityState.locked => (Icons.lock, AppColors.error, 'Locked'),
      BikeSecurityState.unlocked => (
        Icons.lock_open,
        AppColors.success,
        'Unlocked',
      ),
      BikeSecurityState.unknown => (
        Icons.lock_outline,
        AppColors.onSurfaceSecondary,
        'Unknown',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
