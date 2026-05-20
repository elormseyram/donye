import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/components/fault_code_chip.dart';
import '../../domain/entities/fault_code.dart';
import '../../../../shared/enums/fault_severity.dart';

class FaultCodeList extends StatelessWidget {
  const FaultCodeList({super.key, required this.faultCodes});
  final List<FaultCode> faultCodes;

  @override
  Widget build(BuildContext context) {
    if (faultCodes.isEmpty) {
      return _EmptyFaults();
    }

    final critical = faultCodes.where((f) => f.severity == FaultSeverity.critical && f.isActive).toList();
    final major = faultCodes.where((f) => f.severity == FaultSeverity.major && f.isActive).toList();
    final minor = faultCodes.where((f) => f.severity == FaultSeverity.minor && f.isActive).toList();
    final resolved = faultCodes.where((f) => !f.isActive).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (critical.isNotEmpty) ...[
          _SectionHeader(label: 'Critical', color: AppColors.error),
          const SizedBox(height: AppSpacing.sm),
          ...critical.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: FaultCodeChip(faultCode: f),
              )),
          const SizedBox(height: AppSpacing.md),
        ],
        if (major.isNotEmpty) ...[
          _SectionHeader(
            label: 'Major',
            color: AppColors.error.withValues(alpha: 0.8),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...major.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: FaultCodeChip(faultCode: f),
              )),
          const SizedBox(height: AppSpacing.md),
        ],
        if (minor.isNotEmpty) ...[
          _SectionHeader(label: 'Minor', color: AppColors.warning),
          const SizedBox(height: AppSpacing.sm),
          ...minor.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: FaultCodeChip(faultCode: f),
              )),
          const SizedBox(height: AppSpacing.md),
        ],
        if (resolved.isNotEmpty) ...[
          _SectionHeader(
            label: 'Resolved (${resolved.length})',
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...resolved.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Opacity(opacity: 0.5, child: FaultCodeChip(faultCode: f)),
              )),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _EmptyFaults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
        const SizedBox(width: AppSpacing.sm),
        const Text(
          'No fault codes detected',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
