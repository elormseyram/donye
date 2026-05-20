import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

enum ChartRange { day, week, month }

class ChartHeader extends StatelessWidget {
  const ChartHeader({
    super.key,
    required this.title,
    required this.selectedRange,
    required this.onRangeChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final ChartRange selectedRange;
  final ValueChanged<ChartRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _RangePicker(selected: selectedRange, onChanged: onRangeChanged),
      ],
    );
  }
}

class _RangePicker extends StatelessWidget {
  const _RangePicker({required this.selected, required this.onChanged});
  final ChartRange selected;
  final ValueChanged<ChartRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ChartRange.values.map((r) {
          final isSelected = r == selected;
          return GestureDetector(
            onTap: () => onChanged(r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                r.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.onSurfaceSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension on ChartRange {
  String get label => switch (this) {
        ChartRange.day => '24h',
        ChartRange.week => '7d',
        ChartRange.month => '30d',
      };
}
