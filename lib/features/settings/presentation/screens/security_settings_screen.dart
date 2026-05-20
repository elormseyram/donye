import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/settings_section_header.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SrAppBar(title: 'Security'),
      body: ListView(
        children: [
          const SettingsSectionHeader(title: 'Authentication'),
          SrCard(
            child: SettingsSwitchTile(
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or Face ID to sign in',
              leading: const Icon(Icons.fingerprint_outlined,
                  size: 20, color: AppColors.onSurfaceSecondary),
              value: settings.biometricAuthEnabled,
              onChanged: (v) => notifier.toggle(biometricAuthEnabled: v),
            ),
          ),
          const SettingsSectionHeader(title: 'Account'),
          SrCard(
            child: SettingsListTile(
              title: 'Change Password',
              leading: const Icon(Icons.lock_outline,
                  size: 20, color: AppColors.onSurfaceSecondary),
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.onSurfaceSecondary),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
