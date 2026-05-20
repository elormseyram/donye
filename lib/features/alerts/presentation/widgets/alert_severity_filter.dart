import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/enums/alert_severity.dart';

class AlertSeverityFilter extends StatelessWidget {
  const AlertSeverityFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AlertSeverity? selected;
  final ValueChanged<AlertSeverity?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selected == null,
            color: AppColors.onSurface,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Critical',
            isSelected: selected == AlertSeverity.critical,
            color: AppColors.error,
            onTap: () => onChanged(AlertSeverity.critical),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Warning',
            isSelected: selected == AlertSeverity.warning,
            color: AppColors.warning,
            onTap: () => onChanged(AlertSeverity.warning),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Info',
            isSelected: selected == AlertSeverity.info,
            color: AppColors.primary,
            onTap: () => onChanged(AlertSeverity.info),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
