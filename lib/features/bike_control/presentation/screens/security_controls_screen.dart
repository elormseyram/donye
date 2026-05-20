import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../controllers/bike_control_controller.dart';
import '../providers/bike_control_provider.dart';
import '../widgets/bike_status_indicator.dart';
import '../widgets/control_action_card.dart';

class SecurityControlsScreen extends ConsumerWidget {
  const SecurityControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(bikeControlControllerProvider.notifier);
    final bikeId = ref.watch(assignedBikeIdProvider);

    ref.listen(bikeControlControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => SrSnackbar.error(context, e.toString()),
        data: (status) {
          if (status != null) {
            SrSnackbar.success(context, 'Command sent successfully');
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Security Controls')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: BikeStatusIndicator(
              securityState: BikeSecurityState.unknown,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SrCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anti-Theft',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Commands are sent instantly over MQTT and logged for audit.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ControlActionCard(
            title: 'Lock / Unlock',
            actions: [
              CommandAction(
                label: 'Lock',
                icon: Icons.lock_outline,
                onPressed: bikeId != null ? controller.lock : () async {},
                isDestructive: false,
              ),
              CommandAction(
                label: 'Unlock',
                icon: Icons.lock_open_outlined,
                onPressed: bikeId != null ? controller.unlock : () async {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ControlActionCard(
            title: 'Motor Control',
            actions: [
              CommandAction(
                label: 'Enable',
                icon: Icons.power_settings_new,
                onPressed: bikeId != null ? controller.enable : () async {},
              ),
              CommandAction(
                label: 'Disable',
                icon: Icons.power_off_outlined,
                onPressed: bikeId != null ? controller.disable : () async {},
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
