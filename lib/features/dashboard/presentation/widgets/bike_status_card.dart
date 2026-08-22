import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/sr_card.dart';
import '../../../../../core/widgets/sr_status_badge.dart';
import '../../../../../core/widgets/sr_divider.dart';
import '../../../../../core/widgets/dornye_logo.dart';

class BikeStatusCard extends StatelessWidget {
  const BikeStatusCard({
    super.key,
    this.bikeModel,
    this.serialNumber,
    this.registrationNumber,
    this.isLocked,
    this.isLoading = false,
  });

  final String? bikeModel;
  final String? serialNumber;
  final String? registrationNumber;
  final bool? isLocked;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: DornyeLogo(size: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading || bikeModel == null ? 'My Bike' : bikeModel!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (registrationNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        registrationNumber!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLoading)
                SrStatusBadge(
                  label: isLocked == null
                      ? 'Unknown'
                      : isLocked!
                          ? 'Locked'
                          : 'Unlocked',
                  variant: isLocked == null
                      ? SrBadgeVariant.neutral
                      : isLocked!
                          ? SrBadgeVariant.error
                          : SrBadgeVariant.success,
                ),
            ],
          ),
          if (serialNumber != null) ...[
            const SizedBox(height: AppSpacing.md),
            const SrDivider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.tag,
                  size: 14,
                  color: AppColors.onSurfaceSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'S/N: $serialNumber',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
