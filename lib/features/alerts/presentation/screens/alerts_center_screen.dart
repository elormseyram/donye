import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../../../shared/components/alert_list_tile.dart';
import '../../../../shared/enums/alert_severity.dart';
import '../../domain/entities/alert_entity.dart';
import '../controllers/alerts_controller.dart';
import '../providers/alerts_provider.dart';
import '../widgets/alert_detail_sheet.dart';
import '../widgets/alert_severity_filter.dart';

class AlertsCenterScreen extends ConsumerStatefulWidget {
  const AlertsCenterScreen({super.key});

  @override
  ConsumerState<AlertsCenterScreen> createState() => _AlertsCenterScreenState();
}

class _AlertsCenterScreenState extends ConsumerState<AlertsCenterScreen> {
  AlertSeverity? _filter;

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(activeAlertsProvider);
    final unreadCount = ref.watch(unreadAlertCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SrAppBar(
        title: unreadCount > 0 ? 'Alerts ($unreadCount)' : 'Alerts',
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () async {
                final alerts = alertsAsync.value ?? [];
                final controller = ref.read(alertsControllerProvider.notifier);
                for (final a in alerts.where((a) => !a.isRead)) {
                  await controller.markRead(a.id);
                }
              },
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: alertsAsync.when(
        loading: () => const AlertsListSkeleton(),
        error: (e, _) => Center(
          child: SrErrorWidget(
            message: 'Could not load alerts',
            onRetry: () => ref.invalidate(activeAlertsProvider),
          ),
        ),
        data: (alerts) {
          final filtered = _filter == null
              ? alerts
              : alerts.where((a) => a.severity == _filter).toList();

          return Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              AlertSeverityFilter(
                selected: _filter,
                onChanged: (v) => setState(() => _filter = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: SrEmptyState(
                          icon: Icons.notifications_none_outlined,
                          title: 'No alerts',
                          subtitle: 'You\'re all caught up! No active alerts.',
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final alert = filtered[index];
                          return AlertListTile(
                            alert: alert,
                            onTap: () => _showDetail(context, alert),
                            onMarkRead: alert.isRead
                                ? null
                                : () => ref
                                    .read(alertsControllerProvider.notifier)
                                    .markRead(alert.id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, AlertEntity alert) {
    AlertDetailSheet.show(
      context,
      alert,
      onMarkRead: alert.isRead
          ? null
          : () => ref.read(alertsControllerProvider.notifier).markRead(alert.id),
    );
  }
}
