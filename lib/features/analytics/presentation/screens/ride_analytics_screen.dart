import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../shared/components/ride_stat_card.dart';
import '../controllers/analytics_controller.dart';
import '../providers/analytics_provider.dart';
import '../widgets/weekly_distance_chart.dart';
import '../widgets/speed_distribution_chart.dart';

class RideAnalyticsScreen extends ConsumerWidget {
  const RideAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(rideSessionsProvider);
    final weeklyAsync = ref.watch(weeklyStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SrAppBar(
        title: 'Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () =>
                ref.read(analyticsControllerProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.battery_charging_full_outlined),
            onPressed: () => context.pushNamed(RouteNames.batteryAnalytics),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async =>
            ref.read(analyticsControllerProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            weeklyAsync.when(
              loading: () => const AnalyticsSkeleton(),
              error: (e, _) => SrErrorWidget(
                message: 'Could not load weekly stats',
                onRetry: () => ref.invalidate(weeklyStatsProvider),
              ),
              data: (stats) {
                if (stats == null) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 1.5,
                      children: [
                        RideStatCard(
                          label: 'Total Distance',
                          value: stats.totalDistanceKm.toStringAsFixed(1),
                          unit: 'km',
                          icon: Icons.route_outlined,
                          color: AppColors.primary,
                        ),
                        RideStatCard(
                          label: 'Total Rides',
                          value: stats.totalRides.toString(),
                          unit: 'rides',
                          icon: Icons.directions_bike_outlined,
                          color: AppColors.success,
                        ),
                        RideStatCard(
                          label: 'Avg Speed',
                          value: stats.avgSpeedKmh.toStringAsFixed(1),
                          unit: 'km/h',
                          icon: Icons.speed_outlined,
                          color: AppColors.warning,
                        ),
                        RideStatCard(
                          label: 'Energy Used',
                          value: stats.totalEnergyKwh.toStringAsFixed(2),
                          unit: 'kWh',
                          icon: Icons.bolt_outlined,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SrCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Distance (km)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          WeeklyDistanceChart(stats: stats),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                );
              },
            ),
            sessionsAsync.when(
              loading: () => const GenericListSkeleton(count: 4),
              error: (e, _) => SrErrorWidget(
                message: 'Could not load ride sessions',
                onRetry: () => ref.invalidate(rideSessionsProvider),
              ),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const SrEmptyState(
                    icon: Icons.directions_bike_outlined,
                    title: 'No rides yet',
                    subtitle: 'Your ride history will appear here.',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SrCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Speed Distribution',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SpeedDistributionChart(sessions: sessions),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Recent Rides',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...sessions.take(10).map(
                          (s) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _RideSessionTile(session: s),
                          ),
                        ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _RideSessionTile extends StatelessWidget {
  const _RideSessionTile({required this.session});
  final dynamic session;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM d, yyyy · h:mm a');
    return SrCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_bike_outlined,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFmt.format(session.startTime as DateTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${(session.distanceKm as double).toStringAsFixed(1)} km  ·  ${(session.avgSpeedKmh as double).toStringAsFixed(1)} km/h avg',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(session.energyConsumedKwh as double).toStringAsFixed(2)} kWh',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
