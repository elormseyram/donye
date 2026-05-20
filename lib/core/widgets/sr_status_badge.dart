import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum SrBadgeVariant { success, warning, error, info, neutral }

class SrStatusBadge extends StatelessWidget {
  const SrStatusBadge({
    super.key,
    required this.label,
    this.variant = SrBadgeVariant.neutral,
    this.showDot = true,
  });

  final String label;
  final SrBadgeVariant variant;
  final bool showDot;

  Color get _dotColor {
    switch (variant) {
      case SrBadgeVariant.success:
        return AppColors.success;
      case SrBadgeVariant.warning:
        return AppColors.warning;
      case SrBadgeVariant.error:
        return AppColors.error;
      case SrBadgeVariant.info:
        return AppColors.alertInfo;
      case SrBadgeVariant.neutral:
        return AppColors.onSurfaceSecondary;
    }
  }

  Color get _backgroundColor => _dotColor.withValues(alpha: 0.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _dotColor,
            ),
          ),
        ],
      ),
    );
  }
}
