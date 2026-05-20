import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../features/alerts/domain/entities/alert_entity.dart';
import '../../shared/enums/alert_severity.dart';

class AlertListTile extends StatelessWidget {
  const AlertListTile({
    super.key,
    required this.alert,
    this.onTap,
    this.onMarkRead,
  });

  final AlertEntity alert;
  final VoidCallback? onTap;
  final VoidCallback? onMarkRead;

  Color get _severityColor => switch (alert.severity) {
        AlertSeverity.info => AppColors.primary,
        AlertSeverity.warning => AppColors.warning,
        AlertSeverity.critical => AppColors.error,
      };

  IconData get _severityIcon => switch (alert.severity) {
        AlertSeverity.info => Icons.info_outline,
        AlertSeverity.warning => Icons.warning_amber_outlined,
        AlertSeverity.critical => Icons.error_outline,
      };

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('MMM d · h:mm a');
    final isUnread = !alert.isRead;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnread
              ? _severityColor.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? _severityColor.withValues(alpha: 0.2)
                : AppColors.outline,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _severityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_severityIcon, size: 18, color: _severityColor),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _severityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        timeFmt.format(alert.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (isUnread && onMarkRead != null)
                        GestureDetector(
                          onTap: onMarkRead,
                          child: Text(
                            'Mark read',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _severityColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
