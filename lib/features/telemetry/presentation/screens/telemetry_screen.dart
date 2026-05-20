import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_divider.dart';
import '../../../../shared/components/connection_status_banner.dart';
import '../providers/telemetry_provider.dart';
import '../widgets/telemetry_live_header.dart';
import '../widgets/telemetry_chart_section.dart';

class TelemetryScreen extends ConsumerWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(
      mqttServiceProvider.select((s) => s.connectionStatus),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Telemetry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => context.goNamed(RouteNames.rideMetrics),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<dynamic>(
          stream: connectionStatus,
          builder: (context, snap) {
            final status = snap.data;
            return Column(
              children: [
                if (status != null)
                  ConnectionStatusBanner(status: status),
                Expanded(
                  child: ListView(
                    children: [
                      const TelemetryLiveHeader(),
                      const SrDivider(),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            _QuickNavRow(),
                            const SizedBox(height: AppSpacing.md),
                            const TelemetryChartSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuickNavRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavTile(
          label: 'Battery',
          icon: Icons.battery_charging_full_outlined,
          color: AppColors.success,
          onTap: () => context.goNamed(RouteNames.batteryMonitoring),
        ),
        const SizedBox(width: AppSpacing.sm),
        _NavTile(
          label: 'Voltage',
          icon: Icons.bolt_outlined,
          color: AppColors.primary,
          onTap: () => context.goNamed(RouteNames.voltageMonitoring),
        ),
        const SizedBox(width: AppSpacing.sm),
        _NavTile(
          label: 'Metrics',
          icon: Icons.speed_outlined,
          color: AppColors.warning,
          onTap: () => context.goNamed(RouteNames.rideMetrics),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SrCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
