import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_card.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/sr_error_widget.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../../data/models/maintenance_log_model.dart';
import '../providers/diagnostics_provider.dart';
import '../controllers/diagnostics_controller.dart';

class MaintenanceLogsScreen extends ConsumerWidget {
  const MaintenanceLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(maintenanceLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SrAppBar(title: 'Maintenance History'),
      body: logsAsync.when(
        loading: () => const GenericListSkeleton(),
        error: (e, _) => Center(
          child: SrErrorWidget(
            message: 'Could not load maintenance logs',
            onRetry: () => ref.invalidate(maintenanceLogsProvider),
          ),
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: SrEmptyState(
                icon: Icons.build_outlined,
                title: 'No maintenance records',
                subtitle: 'Service history will appear here after your first maintenance visit.',
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ref.read(diagnosticsControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: logs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _MaintenanceLogTile(log: logs[index]),
            ),
          );
        },
      ),
    );
  }
}

class _MaintenanceLogTile extends StatelessWidget {
  const _MaintenanceLogTile({required this.log});
  final MaintenanceLogModel log;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final performedAt = DateTime.tryParse(log.performedAt) ?? DateTime.now();
    final nextDue = log.nextDueAt != null ? DateTime.tryParse(log.nextDueAt!) : null;
    final now = DateTime.now();

    return SrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.build_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(performedAt),
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
          if (log.technician != null || nextDue != null) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1, color: AppColors.outline),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (log.technician != null) ...[
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: AppColors.onSurfaceSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    log.technician!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                ],
                const Spacer(),
                if (nextDue != null) ...[
                  const Icon(
                    Icons.event_outlined,
                    size: 14,
                    color: AppColors.onSurfaceSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Next: ${dateFormat.format(nextDue)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: nextDue.isBefore(now)
                          ? AppColors.error
                          : AppColors.onSurfaceSecondary,
                      fontWeight: nextDue.isBefore(now)
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
