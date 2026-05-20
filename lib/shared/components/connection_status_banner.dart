import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/enums/mqtt_connection_status.dart';

class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key, required this.status});
  final MqttConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == MqttConnectionStatus.connected) return const SizedBox.shrink();

    final isReconnecting = status == MqttConnectionStatus.reconnecting ||
        status == MqttConnectionStatus.connecting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      color: isReconnecting
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          if (isReconnecting)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.warning,
              ),
            )
          else
            const Icon(
              Icons.wifi_off_rounded,
              size: 14,
              color: AppColors.error,
            ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isReconnecting ? AppColors.warning : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
