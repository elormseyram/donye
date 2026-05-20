import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/settings_section_header.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SrAppBar(title: 'Settings'),
      body: ListView(
        children: [
          const SettingsSectionHeader(title: 'Notifications'),
          SrCard(
            child: Column(
              children: [
                SettingsSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts and updates',
                  leading: const Icon(Icons.notifications_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  value: settings.notificationsEnabled,
                  onChanged: (v) => notifier.toggle(notificationsEnabled: v),
                ),
                const Divider(height: 1, indent: 16, color: AppColors.outline),
                SettingsSwitchTile(
                  title: 'Alert Sounds',
                  subtitle: 'Play sound for MQTT alerts',
                  leading: const Icon(Icons.volume_up_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  value: settings.mqttAlertSounds,
                  onChanged: (v) => notifier.toggle(mqttAlertSounds: v),
                ),
              ],
            ),
          ),
          const SettingsSectionHeader(title: 'Privacy'),
          SrCard(
            child: SettingsSwitchTile(
              title: 'Location Sharing',
              subtitle: 'Share GPS location for tracking',
              leading: const Icon(Icons.location_on_outlined,
                  size: 20, color: AppColors.onSurfaceSecondary),
              value: settings.locationSharing,
              onChanged: (v) => notifier.toggle(locationSharing: v),
            ),
          ),
          const SettingsSectionHeader(title: 'More'),
          SrCard(
            child: Column(
              children: [
                SettingsListTile(
                  title: 'Notification Settings',
                  leading: const Icon(Icons.tune_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.onSurfaceSecondary),
                  onTap: () =>
                      context.pushNamed(RouteNames.notificationSettings),
                ),
                const Divider(height: 1, indent: 16, color: AppColors.outline),
                SettingsListTile(
                  title: 'Security',
                  leading: const Icon(Icons.security_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.onSurfaceSecondary),
                  onTap: () =>
                      context.pushNamed(RouteNames.securitySettings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
