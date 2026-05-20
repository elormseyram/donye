import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_avatar.dart';
import '../../../auth/domain/entities/rider_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.rider});
  final RiderEntity rider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        SrAvatar(
          imageUrl: rider.avatarUrl,
          initials: rider.fullName,
          size: 88,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          rider.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rider.email,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        const SizedBox(height: 4),
        if (rider.phoneNumber.isNotEmpty)
          Text(
            rider.phoneNumber,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
