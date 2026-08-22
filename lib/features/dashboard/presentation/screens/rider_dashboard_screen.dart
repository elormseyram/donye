import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_avatar.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../shared/components/connection_status_banner.dart';
import '../../../telemetry/domain/entities/telemetry_entity.dart';
import '../../../telemetry/presentation/providers/telemetry_provider.dart';
import '../../../rider_profile/presentation/providers/profile_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/telemetry_summary_card.dart';
import '../widgets/bike_status_card.dart';
import '../widgets/quick_actions_row.dart';

class RiderDashboardScreen extends ConsumerWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riderAsync = ref.watch(dashboardRiderProvider);
    final mqttStatusAsync = ref.watch(mqttConnectionStatusProvider);
    final telemetry = ref.watch(latestTelemetryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            mqttStatusAsync.when(
              data: (s) => ConnectionStatusBanner(status: s),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Expanded(
              child: riderAsync.when(
                loading: () => const _DashboardBody(
                  isLoading: true,
                  riderName: null,
                  avatarUrl: null,
                  telemetry: null,
                ),
                error: (e, _) => Center(
                  child: SrErrorWidget(
                    message: 'Failed to load profile',
                    onRetry: () => ref.invalidate(dashboardRiderProvider),
                  ),
                ),
                data: (rider) => _DashboardBody(
                  isLoading: false,
                  riderName: rider?.fullName,
                  avatarUrl: rider?.avatarUrl,
                  telemetry: telemetry,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({
    required this.isLoading,
    required this.riderName,
    required this.avatarUrl,
    required this.telemetry,
  });

  final bool isLoading;
  final String? riderName;
  final String? avatarUrl;
  final TelemetryEntity? telemetry;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _firstName {
    if (riderName == null || riderName!.isEmpty) return 'Rider';
    return riderName!.split(' ').first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttConnected = ref.watch(mqttConnectionStatusProvider).valueOrNull?.isConnected ?? false;
    final bikeAsync = ref.watch(currentBikeProvider);

    void sendCommand(String type) {
      if (!mqttConnected) {
        SrSnackbar.show(context, message: 'MQTT not connected yet. Try again shortly.');
        return;
      }
      try {
        ref.read(mqttServiceProvider).publishCommand({'type': type});
        SrSnackbar.show(context, message: '${type[0].toUpperCase()}${type.substring(1)} command sent.');
      } catch (_) {
        SrSnackbar.show(context, message: 'Failed to send command. Try again.', isError: true);
      }
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.background,
          floating: true,
          snap: true,
          elevation: 0,
          toolbarHeight: 72,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceSecondary,
                                ),
                      ),
                      Text(
                        isLoading ? '...' : _firstName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                _ProfileButton(
                  avatarUrl: avatarUrl,
                  initials: riderName,
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColors.outline),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              TelemetrySummaryCard(
                isLoading: isLoading && telemetry == null,
                batteryPercentage: telemetry?.batteryPercentage,
                speedKmh: telemetry?.speedKmh,
                temperatureCelsius: telemetry?.temperatureCelsius,
                odometer: telemetry?.odometer,
              ),
              const SizedBox(height: AppSpacing.md),
              bikeAsync.when(
                loading: () => const BikeStatusCard(isLoading: true),
                error: (_, __) => const BikeStatusCard(),
                data: (bike) => BikeStatusCard(
                  bikeModel: bike?.model,
                  serialNumber: bike?.serialNumber,
                  registrationNumber: bike?.registrationNumber,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: AppSpacing.sm),
              QuickActionsRow(
                isLoading: isLoading,
                onLock: () => sendCommand('lock'),
                onUnlock: () => sendCommand('unlock'),
                onHonk: () => sendCommand('honk'),
                onLights: () => sendCommand('lights_on'),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(
                title: 'Navigation',
                actionLabel: 'View all',
                onAction: () => context.goNamed(RouteNames.analytics),
              ),
              const SizedBox(height: AppSpacing.sm),
              _NavGrid(),
              const SizedBox(height: AppSpacing.xl),
            ]),
          ),
        ),
      ],
    );
  }


}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({this.avatarUrl, this.initials});
  final String? avatarUrl;
  final String? initials;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed(RouteNames.profile),
      child: SrAvatar(
        imageUrl: avatarUrl,
        initials: initials,
        size: 38,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
      ],
    );
  }
}

class _NavGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.location_on_outlined,
        label: 'Tracking',
        route: RouteNames.tracking,
        color: AppColors.primary,
        useLogo: false,
      ),
      (
        icon: Icons.tune_outlined,
        label: 'Controls',
        route: RouteNames.bikeControl,
        color: AppColors.onSurface,
        useLogo: true,
      ),
      (
        icon: Icons.build_outlined,
        label: 'Diagnostics',
        route: RouteNames.diagnostics,
        color: AppColors.warning,
        useLogo: false,
      ),
      (
        icon: Icons.bar_chart_outlined,
        label: 'Analytics',
        route: RouteNames.analytics,
        color: AppColors.success,
        useLogo: false,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items
          .map(
            (item) => _NavCard(
              icon: item.icon,
              label: item.label,
              color: item.color,
              useLogo: item.useLogo,
              onTap: () => context.goNamed(item.route),
            ),
          )
          .toList(),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.useLogo,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool useLogo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            if (useLogo)
              const DornyeLogo(size: 22)
            else
              Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
