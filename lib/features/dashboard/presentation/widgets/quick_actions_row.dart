import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.onLock,
    required this.onUnlock,
    required this.onHonk,
    required this.onLights,
    this.isLoading = false,
  });

  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final VoidCallback onHonk;
  final VoidCallback onLights;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.lock_outline,
          label: 'Lock',
          onTap: isLoading ? null : onLock,
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionButton(
          icon: Icons.lock_open_outlined,
          label: 'Unlock',
          onTap: isLoading ? null : onUnlock,
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionButton(
          icon: Icons.campaign_outlined,
          label: 'Honk',
          onTap: isLoading ? null : onHonk,
        ),
        const SizedBox(width: AppSpacing.sm),
        _ActionButton(
          icon: Icons.highlight_outlined,
          label: 'Lights',
          onTap: isLoading ? null : onLights,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.surfaceVariant
                : AppColors.outline.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: enabled
                    ? AppColors.onSurface
                    : AppColors.onSurfaceSecondary,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: enabled
                          ? AppColors.onSurface
                          : AppColors.onSurfaceSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
