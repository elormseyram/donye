import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/settings_section_header.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SrAppBar(title: 'Notification Settings'),
      body: ListView(
        children: [
          const SettingsSectionHeader(title: 'Alerts'),
          SrCard(
            child: Column(
              children: [
                SettingsSwitchTile(
                  title: 'All Notifications',
                  subtitle: 'Master toggle for all push notifications',
                  leading: const Icon(Icons.notifications_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  value: settings.notificationsEnabled,
                  onChanged: (v) => notifier.toggle(notificationsEnabled: v),
                ),
                const Divider(height: 1, indent: 16, color: AppColors.outline),
                SettingsSwitchTile(
                  title: 'Alert Sounds',
                  subtitle: 'Play sound when alerts arrive',
                  leading: const Icon(Icons.volume_up_outlined,
                      size: 20, color: AppColors.onSurfaceSecondary),
                  value: settings.mqttAlertSounds,
                  onChanged: (v) => notifier.toggle(mqttAlertSounds: v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
