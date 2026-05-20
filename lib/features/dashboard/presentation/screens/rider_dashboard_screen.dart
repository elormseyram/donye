import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_avatar.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../shared/components/connection_status_banner.dart';
import '../../../telemetry/domain/entities/telemetry_entity.dart';
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

class _DashboardBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              BikeStatusCard(isLoading: isLoading),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: AppSpacing.sm),
              QuickActionsRow(
                isLoading: isLoading,
                onLock: () => _showCommandSnackbar(context, 'Lock'),
                onUnlock: () => _showCommandSnackbar(context, 'Unlock'),
                onHonk: () => _showCommandSnackbar(context, 'Honk'),
                onLights: () => _showCommandSnackbar(context, 'Lights'),
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

  void _showCommandSnackbar(BuildContext context, String command) {
    SrSnackbar.show(
      context,
      message: '$command command will be available after MQTT connects.',
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
      ),
      (
        icon: Icons.electric_bike_outlined,
        label: 'Controls',
        route: RouteNames.bikeControl,
        color: AppColors.onSurface,
      ),
      (
        icon: Icons.build_outlined,
        label: 'Diagnostics',
        route: RouteNames.diagnostics,
        color: AppColors.warning,
      ),
      (
        icon: Icons.bar_chart_outlined,
        label: 'Analytics',
        route: RouteNames.analytics,
        color: AppColors.success,
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
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
