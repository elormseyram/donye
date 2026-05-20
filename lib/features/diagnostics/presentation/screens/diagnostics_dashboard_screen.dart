import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../shared/enums/maintenance_status.dart';
import '../providers/diagnostics_provider.dart';
import '../widgets/fault_code_list.dart';
import '../widgets/health_score_ring.dart';
import '../controllers/diagnostics_controller.dart';

class DiagnosticsDashboardScreen extends ConsumerWidget {
  const DiagnosticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosticsAsync = ref.watch(diagnosticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SrAppBar(
        title: 'Diagnostics',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.read(diagnosticsControllerProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => context.pushNamed(RouteNames.maintenanceLogs),
          ),
        ],
      ),
      body: diagnosticsAsync.when(
        loading: () => const DiagnosticsSkeleton(),
        error: (e, _) => Center(
          child: SrErrorWidget(
            message: 'Could not load diagnostics',
            onRetry: () => ref.invalidate(diagnosticsProvider),
          ),
        ),
        data: (diagnostic) {
          if (diagnostic == null) {
            return const Center(
              child: SrErrorWidget(message: 'No diagnostics data available'),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ref.read(diagnosticsControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _HealthScoreSection(
                  score: diagnostic.healthScore,
                  maintenanceStatus: diagnostic.maintenanceStatus,
                  lastChecked: diagnostic.lastDiagnosticAt,
                ),
                const SizedBox(height: AppSpacing.md),
                _MaintenanceStatusCard(status: diagnostic.maintenanceStatus),
                const SizedBox(height: AppSpacing.md),
                SrCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fault Codes',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (diagnostic.faultCodes.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${diagnostic.faultCodes.where((f) => f.isActive).length} active',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FaultCodeList(faultCodes: diagnostic.faultCodes),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(RouteNames.maintenanceLogs),
                  icon: const Icon(Icons.build_outlined, size: 18),
                  label: const Text('View Maintenance History'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HealthScoreSection extends StatelessWidget {
  const _HealthScoreSection({
    required this.score,
    required this.maintenanceStatus,
    required this.lastChecked,
  });

  final int score;
  final MaintenanceStatus maintenanceStatus;
  final DateTime lastChecked;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Center(child: HealthScoreRing(score: score)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Last scanned: ${_formatDate(lastChecked)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _MaintenanceStatusCard extends StatelessWidget {
  const _MaintenanceStatusCard({required this.status});
  final MaintenanceStatus status;

  Color get _color => switch (status) {
        MaintenanceStatus.ok => AppColors.success,
        MaintenanceStatus.dueSoon => AppColors.warning,
        MaintenanceStatus.overdue => AppColors.error,
      };

  String get _label => switch (status) {
        MaintenanceStatus.ok => 'Maintenance Up to Date',
        MaintenanceStatus.dueSoon => 'Maintenance Due Soon',
        MaintenanceStatus.overdue => 'Maintenance Overdue',
      };

  String get _description => switch (status) {
        MaintenanceStatus.ok => 'Your bike is in good shape. Keep riding!',
        MaintenanceStatus.dueSoon =>
          'Schedule a service appointment soon to keep your bike performing well.',
        MaintenanceStatus.overdue =>
          'Service is overdue. Please schedule maintenance immediately.',
      };

  IconData get _icon => switch (status) {
        MaintenanceStatus.ok => Icons.check_circle_outline,
        MaintenanceStatus.dueSoon => Icons.schedule_outlined,
        MaintenanceStatus.overdue => Icons.warning_amber_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
