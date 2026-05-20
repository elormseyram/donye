import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../shared/components/ride_stat_card.dart';
import '../controllers/analytics_controller.dart';
import '../providers/analytics_provider.dart';
import '../widgets/energy_consumption_chart.dart';

class BatteryAnalyticsScreen extends ConsumerWidget {
  const BatteryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyStatsProvider);
    final sessionsAsync = ref.watch(rideSessionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SrAppBar(
        title: 'Battery Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () =>
                ref.read(analyticsControllerProvider.notifier).refresh(),
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
                message: 'Could not load battery stats',
                onRetry: () => ref.invalidate(weeklyStatsProvider),
              ),
              data: (stats) {
                if (stats == null) return const SizedBox();
                final avgDrain = sessionsAsync.value == null ||
                        sessionsAsync.value!.isEmpty
                    ? 0.0
                    : sessionsAsync.value!
                            .fold(0.0, (s, r) => s + r.avgBatteryDrain) /
                        sessionsAsync.value!.length;

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
                          label: 'Total Energy Used',
                          value: stats.totalEnergyKwh.toStringAsFixed(2),
                          unit: 'kWh',
                          icon: Icons.bolt_outlined,
                          color: AppColors.success,
                        ),
                        RideStatCard(
                          label: 'Avg Battery Drain',
                          value: avgDrain.toStringAsFixed(1),
                          unit: '%/ride',
                          icon: Icons.battery_4_bar_outlined,
                          color: AppColors.warning,
                        ),
                        RideStatCard(
                          label: 'Total Distance',
                          value: stats.totalDistanceKm.toStringAsFixed(1),
                          unit: 'km',
                          icon: Icons.route_outlined,
                          color: AppColors.primary,
                        ),
                        RideStatCard(
                          label: 'Efficiency',
                          value: stats.totalDistanceKm > 0
                              ? (stats.totalDistanceKm /
                                      stats.totalEnergyKwh.clamp(0.001, double.infinity))
                                  .toStringAsFixed(1)
                              : '—',
                          unit: 'km/kWh',
                          icon: Icons.eco_outlined,
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
                            'Daily Energy Consumption (kWh)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          EnergyConsumptionChart(stats: stats),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                );
              },
            ),
            sessionsAsync.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const SrEmptyState(
                    icon: Icons.battery_charging_full_outlined,
                    title: 'No battery data yet',
                    subtitle: 'Complete a ride to see battery analytics.',
                  );
                }

                final drainSpots = sessions
                    .asMap()
                    .entries
                    .map((e) => FlSpot(
                          e.key.toDouble(),
                          e.value.avgBatteryDrain,
                        ))
                    .toList();

                return SrCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Battery Drain Per Ride (%)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 160,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: drainSpots,
                                isCurved: true,
                                color: AppColors.warning,
                                barWidth: 2.5,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.warning.withValues(alpha: 0.08),
                                ),
                              ),
                            ],
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: AppColors.outline,
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (val, _) => Text(
                                    '${val.toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.onSurfaceSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
