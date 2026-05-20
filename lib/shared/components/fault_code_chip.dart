import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../features/diagnostics/domain/entities/fault_code.dart';
import '../../shared/enums/fault_severity.dart';

class FaultCodeChip extends StatelessWidget {
  const FaultCodeChip({super.key, required this.faultCode});
  final FaultCode faultCode;

  Color get _color => switch (faultCode.severity) {
        FaultSeverity.minor => AppColors.warning,
        FaultSeverity.major => AppColors.error.withValues(alpha: 0.8),
        FaultSeverity.critical => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            faultCode.code,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _color,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              faultCode.description,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
