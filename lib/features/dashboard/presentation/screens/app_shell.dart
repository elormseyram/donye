import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _tabs = [
    (icon: Icons.dashboard_outlined, active: Icons.dashboard, label: 'Dashboard', route: RouteNames.dashboard),
    (icon: Icons.location_on_outlined, active: Icons.location_on, label: 'Tracking', route: RouteNames.tracking),
    (icon: Icons.electric_bike_outlined, active: Icons.electric_bike, label: 'Controls', route: RouteNames.bikeControl),
    (icon: Icons.notifications_outlined, active: Icons.notifications, label: 'Alerts', route: RouteNames.alerts),
    (icon: Icons.bar_chart_outlined, active: Icons.bar_chart, label: 'Analytics', route: RouteNames.analytics),
  ];

  int _currentIndex(String location) {
    if (location.startsWith('/tracking')) return 1;
    if (location.startsWith('/bike-control')) return 2;
    if (location.startsWith('/alerts')) return 3;
    if (location.startsWith('/analytics')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _currentIndex(location);
    final unreadCount = ref.watch(unreadAlertCountProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outline)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => context.goNamed(_tabs[i].route),
          items: _tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value;
            final isAlertsTab = i == 3;
            final showBadge = isAlertsTab && unreadCount > 0;

            Widget iconWidget = Icon(t.icon);
            Widget activeIconWidget = Icon(t.active);

            if (showBadge) {
              final badge = Badge(
                label: unreadCount < 100
                    ? Text('$unreadCount')
                    : const Text('99+'),
                backgroundColor: AppColors.error,
                child: Icon(t.icon),
              );
              final activeBadge = Badge(
                label: unreadCount < 100
                    ? Text('$unreadCount')
                    : const Text('99+'),
                backgroundColor: AppColors.error,
                child: Icon(t.active),
              );
              iconWidget = badge;
              activeIconWidget = activeBadge;
            }

            return BottomNavigationBarItem(
              icon: iconWidget,
              activeIcon: activeIconWidget,
              label: t.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
