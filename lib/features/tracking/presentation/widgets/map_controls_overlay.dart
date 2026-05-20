import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class MapControlsOverlay extends StatelessWidget {
  const MapControlsOverlay({
    super.key,
    required this.onCenterBike,
    required this.onToggleRoute,
    this.isRouteVisible = true,
  });

  final VoidCallback onCenterBike;
  final VoidCallback onToggleRoute;
  final bool isRouteVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ControlButton(
          icon: Icons.my_location,
          tooltip: 'Center on bike',
          onTap: onCenterBike,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ControlButton(
          icon: isRouteVisible ? Icons.route : Icons.route_outlined,
          tooltip: isRouteVisible ? 'Hide route' : 'Show route',
          onTap: onToggleRoute,
          active: isRouteVisible,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? Colors.white : AppColors.onSurface,
        ),
      ),
    );
  }
}
