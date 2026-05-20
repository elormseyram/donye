import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_button.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_divider.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../../../../core/widgets/sr_text_field.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../controllers/profile_controller.dart';
import '../providers/profile_provider.dart';
import '../widgets/bike_details_card.dart';
import '../widgets/profile_header.dart';

class RiderProfileScreen extends ConsumerStatefulWidget {
  const RiderProfileScreen({super.key});

  @override
  ConsumerState<RiderProfileScreen> createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends ConsumerState<RiderProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final riderAsync = ref.watch(currentRiderProvider);
    final bikeAsync = ref.watch(currentBikeProvider);
    final controllerState = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SrAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.close : Icons.edit_outlined),
            onPressed: () {
              if (_editing) {
                setState(() => _editing = false);
              } else {
                final rider = riderAsync.value;
                if (rider != null) {
                  _nameCtrl.text = rider.fullName;
                  _phoneCtrl.text = rider.phoneNumber;
                  setState(() => _editing = true);
                }
              }
            },
          ),
        ],
      ),
      body: riderAsync.when(
        loading: () => const ProfileSkeleton(),
        error: (e, _) => Center(
          child: SrErrorWidget(
            message: 'Could not load profile',
            onRetry: () => ref.invalidate(currentRiderProvider),
          ),
        ),
        data: (rider) {
          if (rider == null) {
            return const Center(
              child: SrErrorWidget(message: 'Profile not found'),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            children: [
              ProfileHeader(rider: rider),
              if (_editing) ...[
                SrCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SrTextField(
                        controller: _nameCtrl,
                        label: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline,
                            size: 20, color: AppColors.onSurfaceSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SrTextField(
                        controller: _phoneCtrl,
                        label: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_outlined,
                            size: 20, color: AppColors.onSurfaceSecondary),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      controllerState.isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : SrPrimaryButton(
                              label: 'Save Changes',
                              onPressed: _save,
                            ),
                    ],
                  ),
                ),
              ] else ...[
                SrCard(
                  child: Column(
                    children: [
                      _ProfileRow(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: rider.fullName,
                      ),
                      const SrDivider(),
                      _ProfileRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: rider.email,
                      ),
                      const SrDivider(),
                      _ProfileRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: rider.phoneNumber.isEmpty
                            ? 'Not set'
                            : rider.phoneNumber,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                'Assigned Bike',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              bikeAsync.when(
                loading: () => const ProfileSkeleton(),
                error: (_, __) => const SrErrorWidget(
                  message: 'Could not load bike info',
                ),
                data: (bike) {
                  if (bike == null) {
                    return const SrErrorWidget(message: 'No bike assigned');
                  }
                  return GestureDetector(
                    onTap: () => context.pushNamed(RouteNames.assignedBike),
                    child: BikeDetailsCard(bike: bike),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SrSecondaryButton(
                label: 'Settings',
                onPressed: () => context.pushNamed(RouteNames.settings),
              ),
              const SizedBox(height: AppSpacing.sm),
              SrGhostButton(
                label: 'Sign Out',
                onPressed: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .logout();
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    final ok = await ref.read(profileControllerProvider.notifier).updateProfile(
          fullName: _nameCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
        );
    if (!mounted) return;
    if (ok) {
      setState(() => _editing = false);
      SrSnackbar.show(context, message: 'Profile updated');
    } else {
      SrSnackbar.error(context, 'Failed to update profile');
    }
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.onSurfaceSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
