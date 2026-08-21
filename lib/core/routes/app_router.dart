import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/app_shell.dart';
import '../../features/dashboard/presentation/screens/rider_dashboard_screen.dart';
import '../../features/telemetry/presentation/screens/telemetry_screen.dart';
import '../../features/telemetry/presentation/screens/battery_monitoring_screen.dart';
import '../../features/telemetry/presentation/screens/voltage_monitoring_screen.dart';
import '../../features/telemetry/presentation/screens/ride_metrics_screen.dart';
import '../../features/tracking/presentation/screens/live_gps_tracking_screen.dart';
import '../../features/tracking/presentation/screens/ride_route_screen.dart';
import '../../features/bike_control/presentation/screens/bike_controls_screen.dart';
import '../../features/bike_control/presentation/screens/security_controls_screen.dart';
import '../../features/alerts/presentation/screens/alerts_center_screen.dart';
import '../../features/alerts/presentation/screens/notification_center_screen.dart';
import '../../features/analytics/presentation/screens/battery_analytics_screen.dart';
import '../../features/analytics/presentation/screens/ride_analytics_screen.dart';
import '../../features/rider_profile/presentation/screens/assigned_bike_details_screen.dart';
import '../../features/rider_profile/presentation/screens/rider_profile_screen.dart';
import '../../features/settings/presentation/screens/app_settings_screen.dart';
import '../../features/settings/presentation/screens/notification_settings_screen.dart';
import '../../features/settings/presentation/screens/security_settings_screen.dart';
import '../../features/diagnostics/presentation/screens/diagnostics_dashboard_screen.dart';
import '../../features/diagnostics/presentation/screens/maintenance_logs_screen.dart';
import 'route_names.dart';


final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            name: RouteNames.forgotPassword,
            builder: (_, __) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/auth/signup',
        name: RouteNames.signup,
        builder: (_, __) => const SignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: RouteNames.dashboard,
            builder: (_, __) => const RiderDashboardScreen(),
            routes: [
              GoRoute(
                path: 'telemetry',
                name: RouteNames.telemetryDetails,
                builder: (_, __) => const TelemetryScreen(),
                routes: [
                  GoRoute(
                    path: 'battery',
                    name: RouteNames.batteryMonitoring,
                    builder: (_, __) => const BatteryMonitoringScreen(),
                  ),
                  GoRoute(
                    path: 'voltage',
                    name: RouteNames.voltageMonitoring,
                    builder: (_, __) => const VoltageMonitoringScreen(),
                  ),
                  GoRoute(
                    path: 'metrics',
                    name: RouteNames.rideMetrics,
                    builder: (_, __) => const RideMetricsScreen(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/tracking',
            name: RouteNames.tracking,
            builder: (_, __) => const LiveGpsTrackingScreen(),
            routes: [
              GoRoute(
                path: 'route',
                name: RouteNames.rideRoute,
                builder: (_, __) => const RideRouteScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/bike-control',
            name: RouteNames.bikeControl,
            builder: (_, __) => const BikeControlsScreen(),
            routes: [
              GoRoute(
                path: 'security',
                name: RouteNames.securityControls,
                builder: (_, __) => const SecurityControlsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/alerts',
            name: RouteNames.alerts,
            builder: (_, __) => const AlertsCenterScreen(),
            routes: [
              GoRoute(
                path: 'notifications',
                name: RouteNames.notificationCenter,
                builder: (_, __) => const NotificationCenterScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/analytics',
            name: RouteNames.analytics,
            builder: (_, __) => const RideAnalyticsScreen(),
            routes: [
              GoRoute(
                path: 'rides',
                name: RouteNames.rideAnalytics,
                builder: (_, __) => const RideAnalyticsScreen(),
              ),
              GoRoute(
                path: 'battery',
                name: RouteNames.batteryAnalytics,
                builder: (_, __) => const BatteryAnalyticsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/diagnostics',
            name: RouteNames.diagnostics,
            builder: (_, __) => const DiagnosticsDashboardScreen(),
            routes: [
              GoRoute(
                path: 'logs',
                name: RouteNames.maintenanceLogs,
                builder: (_, __) => const MaintenanceLogsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (_, __) => const RiderProfileScreen(),
            routes: [
              GoRoute(
                path: 'bike',
                name: RouteNames.assignedBike,
                builder: (_, __) => const AssignedBikeDetailsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: RouteNames.settings,
            builder: (_, __) => const AppSettingsScreen(),
            routes: [
              GoRoute(
                path: 'notifications',
                name: RouteNames.notificationSettings,
                builder: (_, __) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'security',
                name: RouteNames.securitySettings,
                builder: (_, __) => const SecuritySettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
