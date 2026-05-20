import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../controllers/bike_control_controller.dart';
import '../providers/bike_control_provider.dart';
import '../widgets/bike_status_indicator.dart';
import '../widgets/control_action_card.dart';

class BikeControlsScreen extends ConsumerWidget {
  const BikeControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bikeControlControllerProvider.notifier);
    final state = ref.watch(bikeControlControllerProvider);
    final bikeId = ref.watch(assignedBikeIdProvider);

    ref.listen(bikeControlControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => SrSnackbar.error(context, e.toString()),
      );
    });

    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Controls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.security_outlined),
            onPressed: () => context.goNamed(RouteNames.securityControls),
          ),
        ],
      ),
      body: bikeId == null
          ? const Center(
              child: Text(
                'No bike assigned.\nContact your operator.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onSurfaceSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Center(
                  child: BikeStatusIndicator(
                    securityState: BikeSecurityState.unknown,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ControlActionCard(
                  title: 'Security',
                  actions: [
                    CommandAction(
                      label: 'Lock',
                      icon: Icons.lock_outline,
                      onPressed: controller.lock,
                      isDestructive: false,
                    ),
                    CommandAction(
                      label: 'Unlock',
                      icon: Icons.lock_open_outlined,
                      onPressed: controller.unlock,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ControlActionCard(
                  title: 'Signals',
                  actions: [
                    CommandAction(
                      label: 'Honk',
                      icon: Icons.campaign_outlined,
                      onPressed: controller.honk,
                      requireConfirm: false,
                    ),
                    CommandAction(
                      label: 'Lights On',
                      icon: Icons.highlight_outlined,
                      onPressed: controller.lightsOn,
                      requireConfirm: false,
                    ),
                    CommandAction(
                      label: 'Lights Off',
                      icon: Icons.highlight_off_outlined,
                      onPressed: controller.lightsOff,
                      requireConfirm: false,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ControlActionCard(
                  title: 'Power',
                  actions: [
                    CommandAction(
                      label: 'Enable',
                      icon: Icons.power_settings_new,
                      onPressed: controller.enable,
                    ),
                    CommandAction(
                      label: 'Disable',
                      icon: Icons.power_off_outlined,
                      onPressed: controller.disable,
                      isDestructive: true,
                    ),
                  ],
                ),
                if (isLoading) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const LinearProgressIndicator(color: AppColors.primary),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
    );
  }
}
