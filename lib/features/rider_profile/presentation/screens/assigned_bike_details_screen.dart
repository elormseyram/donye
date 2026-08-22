import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../providers/profile_provider.dart';
import '../widgets/bike_details_card.dart';

class AssignedBikeDetailsScreen extends ConsumerWidget {
  const AssignedBikeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bikeAsync = ref.watch(currentBikeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SrAppBar(title: 'My Bike'),
      body: bikeAsync.when(
        loading: () => const ProfileSkeleton(),
        error: (e, _) => Center(
          child: SrErrorWidget(
            message: 'Could not load bike details',
            onRetry: () => ref.invalidate(currentBikeProvider),
          ),
        ),
        data: (bike) {
          if (bike == null) {
            return const Center(
              child: SrEmptyState(
                iconWidget: DornyeLogo(size: 64),
                title: 'No bike assigned',
                subtitle: 'Contact your operator to get a bike assigned.',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [BikeDetailsCard(bike: bike)],
          );
        },
      ),
    );
  }
}
