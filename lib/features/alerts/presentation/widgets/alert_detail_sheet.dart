import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/enums/alert_severity.dart';
import '../../../../shared/enums/alert_type.dart';
import '../../domain/entities/alert_entity.dart';

class AlertDetailSheet extends StatelessWidget {
  const AlertDetailSheet({super.key, required this.alert, this.onMarkRead});
  final AlertEntity alert;
  final VoidCallback? onMarkRead;

  Color get _severityColor => switch (alert.severity) {
        AlertSeverity.info => AppColors.primary,
        AlertSeverity.warning => AppColors.warning,
        AlertSeverity.critical => AppColors.error,
      };

  String get _typeLabel => switch (alert.type) {
        AlertType.batteryLow => 'Battery Low',
        AlertType.overheat => 'Overheat',
        AlertType.geofence => 'Geofence',
        AlertType.tamper => 'Tamper Detected',
        AlertType.crash => 'Crash Detected',
        AlertType.fault => 'Fault',
      };

  static void show(
    BuildContext context,
    AlertEntity alert, {
    VoidCallback? onMarkRead,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlertDetailSheet(alert: alert, onMarkRead: onMarkRead),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMMM d, yyyy · h:mm a');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  alert.severity == AlertSeverity.critical
                      ? Icons.error_outline
                      : alert.severity == AlertSeverity.warning
                          ? Icons.warning_amber_outlined
                          : Icons.info_outline,
                  color: _severityColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      _typeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _severityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.outline),
          const SizedBox(height: AppSpacing.md),
          Text(
            alert.message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            dateFmt.format(alert.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          if (!alert.isRead && onMarkRead != null) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onMarkRead!();
                  Navigator.pop(context);
                },
                child: const Text('Mark as Read'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
