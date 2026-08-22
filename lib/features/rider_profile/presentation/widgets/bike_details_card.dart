import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_status_badge.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../../../../shared/enums/bike_status.dart';
import '../../domain/entities/bike_entity.dart';

class BikeDetailsCard extends StatelessWidget {
  const BikeDetailsCard({super.key, required this.bike});
  final BikeEntity bike;

  SrBadgeVariant get _statusVariant => switch (bike.status) {
        BikeStatus.active => SrBadgeVariant.success,
        BikeStatus.maintenance => SrBadgeVariant.warning,
        BikeStatus.inactive => SrBadgeVariant.neutral,
      };

  String get _statusLabel => switch (bike.status) {
        BikeStatus.active => 'Active',
        BikeStatus.maintenance => 'In Maintenance',
        BikeStatus.inactive => 'Inactive',
      };

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM d, yyyy');
    return SrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: DornyeLogo(size: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bike.model,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      bike.serialNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SrStatusBadge(label: _statusLabel, variant: _statusVariant),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.outline),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'Registration', value: bike.registrationNumber),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Battery Capacity',
            value: '${bike.batteryCapacityKwh.toStringAsFixed(1)} kWh',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Last Service',
            value: dateFmt.format(bike.lastServiceDate),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
