// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/alerts/data/datasources/alerts_local_datasource.dart'
    as _i62;
import '../../features/alerts/data/datasources/alerts_remote_datasource.dart'
    as _i1019;
import '../../features/alerts/data/repositories/alerts_repository_impl.dart'
    as _i56;
import '../../features/alerts/domain/interfaces/i_alerts_repository.dart'
    as _i1065;
import '../../features/alerts/domain/usecases/mark_alert_read_usecase.dart'
    as _i712;
import '../../features/alerts/domain/usecases/stream_active_alerts_usecase.dart'
    as _i182;
import '../../features/analytics/data/datasources/analytics_remote_datasource.dart'
    as _i465;
import '../../features/analytics/data/repositories/analytics_repository_impl.dart'
    as _i425;
import '../../features/analytics/domain/interfaces/i_analytics_repository.dart'
    as _i158;
import '../../features/analytics/domain/usecases/get_ride_sessions_usecase.dart'
    as _i296;
import '../../features/analytics/domain/usecases/get_weekly_stats_usecase.dart'
    as _i1059;
import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/interfaces/i_auth_repository.dart' as _i682;
import '../../features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i560;
import '../../features/auth/domain/usecases/get_current_rider_usecase.dart'
    as _i56;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/signup_usecase.dart' as _i57;
import '../../features/bike_control/data/datasources/bike_control_datasource.dart'
    as _i149;
import '../../features/bike_control/data/repositories/bike_control_repository_impl.dart'
    as _i114;
import '../../features/bike_control/domain/interfaces/i_bike_control_repository.dart'
    as _i207;
import '../../features/bike_control/domain/usecases/lock_bike_usecase.dart'
    as _i858;
import '../../features/bike_control/domain/usecases/send_command_usecase.dart'
    as _i101;
import '../../features/bike_control/domain/usecases/unlock_bike_usecase.dart'
    as _i414;
import '../../features/diagnostics/data/datasources/diagnostics_local_datasource.dart'
    as _i640;
import '../../features/diagnostics/data/datasources/diagnostics_remote_datasource.dart'
    as _i213;
import '../../features/diagnostics/data/repositories/diagnostics_repository_impl.dart'
    as _i901;
import '../../features/diagnostics/domain/interfaces/i_diagnostics_repository.dart'
    as _i1006;
import '../../features/diagnostics/domain/usecases/get_diagnostics_usecase.dart'
    as _i950;
import '../../features/diagnostics/domain/usecases/get_maintenance_logs_usecase.dart'
    as _i130;
import '../../features/rider_profile/data/datasources/profile_remote_datasource.dart'
    as _i325;
import '../../features/rider_profile/data/repositories/profile_repository_impl.dart'
    as _i542;
import '../../features/rider_profile/domain/interfaces/i_profile_repository.dart'
    as _i195;
import '../../features/rider_profile/domain/usecases/get_assigned_bike_usecase.dart'
    as _i28;
import '../../features/rider_profile/domain/usecases/update_rider_profile_usecase.dart'
    as _i520;
import '../../features/settings/data/datasources/settings_local_datasource.dart'
    as _i723;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/interfaces/i_settings_repository.dart'
    as _i487;
import '../../features/settings/domain/usecases/get_settings_usecase.dart'
    as _i1029;
import '../../features/settings/domain/usecases/update_settings_usecase.dart'
    as _i474;
import '../../features/telemetry/data/datasources/telemetry_local_datasource.dart'
    as _i648;
import '../../features/telemetry/data/datasources/telemetry_remote_datasource.dart'
    as _i425;
import '../../features/telemetry/data/repositories/telemetry_repository_impl.dart'
    as _i841;
import '../../features/telemetry/domain/interfaces/i_telemetry_repository.dart'
    as _i566;
import '../../features/telemetry/domain/usecases/get_telemetry_history_usecase.dart'
    as _i238;
import '../../features/telemetry/domain/usecases/get_telemetry_usecase.dart'
    as _i656;
import '../../features/tracking/data/datasources/tracking_remote_datasource.dart'
    as _i724;
import '../../features/tracking/data/repositories/tracking_repository_impl.dart'
    as _i279;
import '../../features/tracking/domain/interfaces/i_tracking_repository.dart'
    as _i1065;
import '../../features/tracking/domain/usecases/get_ride_route_usecase.dart'
    as _i323;
import '../../features/tracking/domain/usecases/stream_live_location_usecase.dart'
    as _i753;
import '../network/dio_client.dart' as _i667;
import '../services/connectivity_service.dart' as _i47;
import '../services/hive_service.dart' as _i1047;
import '../services/mqtt_service.dart' as _i936;
import '../services/notification_service.dart' as _i941;
import 'modules/connectivity_module.dart' as _i855;
import 'modules/hive_module.dart' as _i31;
import 'modules/network_module.dart' as _i851;
import 'modules/notifications_module.dart' as _i308;
import 'modules/supabase_module.dart' as _i388;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final connectivityModule = _$ConnectivityModule();
    final networkModule = _$NetworkModule();
    final supabaseModule = _$SupabaseModule();
    final notificationsModule = _$NotificationsModule();
    final hiveModule = _$HiveModule();
    gh.singleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.singleton<_i361.Dio>(() => networkModule.dio());
    gh.singleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.singleton<_i936.MqttService>(() => _i936.MqttService());
    gh.singleton<_i163.FlutterLocalNotificationsPlugin>(
      () => notificationsModule.localNotifications,
    );
    gh.singleton<_i1047.HiveService>(() => _i1047.HiveService());
    gh.singleton<_i986.Box<dynamic>>(
      () => hiveModule.settingsBox,
      instanceName: 'settingsBox',
    );
    gh.singleton<_i986.Box<dynamic>>(
      () => hiveModule.telemetryBox,
      instanceName: 'telemetryBox',
    );
    gh.singleton<_i986.Box<dynamic>>(
      () => hiveModule.diagnosticsBox,
      instanceName: 'diagnosticsBox',
    );
    gh.lazySingleton<_i648.ITelemetryLocalDataSource>(
      () => _i648.TelemetryLocalDataSource(
        gh<_i986.Box<dynamic>>(instanceName: 'telemetryBox'),
      ),
    );
    gh.singleton<_i986.Box<dynamic>>(
      () => hiveModule.riderBox,
      instanceName: 'riderBox',
    );
    gh.singleton<_i986.Box<dynamic>>(
      () => hiveModule.alertsBox,
      instanceName: 'alertsBox',
    );
    gh.lazySingleton<_i149.IBikeControlDataSource>(
      () => _i149.BikeControlDataSource(
        gh<_i454.SupabaseClient>(),
        gh<_i936.MqttService>(),
      ),
    );
    gh.singleton<_i667.DioClient>(
      () => networkModule.dioClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i941.NotificationService>(
      () => _i941.NotificationService(
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.lazySingleton<_i723.ISettingsLocalDataSource>(
      () => _i723.SettingsLocalDataSource(
        gh<_i986.Box<dynamic>>(instanceName: 'settingsBox'),
      ),
    );
    gh.lazySingleton<_i325.IProfileRemoteDataSource>(
      () => _i325.ProfileRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i425.ITelemetryRemoteDataSource>(
      () => _i425.TelemetryRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1019.IAlertsRemoteDataSource>(
      () => _i1019.AlertsRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i992.IAuthLocalDataSource>(
      () => _i992.AuthLocalDataSource(
        gh<_i986.Box<dynamic>>(instanceName: 'riderBox'),
      ),
    );
    gh.singleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i724.ITrackingRemoteDataSource>(
      () => _i724.TrackingRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i640.IDiagnosticsLocalDataSource>(
      () => _i640.DiagnosticsLocalDataSource(
        gh<_i986.Box<dynamic>>(instanceName: 'diagnosticsBox'),
      ),
    );
    gh.lazySingleton<_i62.IAlertsLocalDataSource>(
      () => _i62.AlertsLocalDataSource(
        gh<_i986.Box<dynamic>>(instanceName: 'alertsBox'),
      ),
    );
    gh.lazySingleton<_i1065.IAlertsRepository>(
      () => _i56.AlertsRepositoryImpl(gh<_i1019.IAlertsRemoteDataSource>()),
    );
    gh.lazySingleton<_i213.IDiagnosticsRemoteDataSource>(
      () => _i213.DiagnosticsRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i566.ITelemetryRepository>(
      () => _i841.TelemetryRepositoryImpl(
        gh<_i936.MqttService>(),
        gh<_i425.ITelemetryRemoteDataSource>(),
        gh<_i648.ITelemetryLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i161.IAuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i465.IAnalyticsRemoteDataSource>(
      () => _i465.AnalyticsRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i195.IProfileRepository>(
      () => _i542.ProfileRepositoryImpl(gh<_i325.IProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i207.IBikeControlRepository>(
      () => _i114.BikeControlRepositoryImpl(gh<_i149.IBikeControlDataSource>()),
    );
    gh.lazySingleton<_i487.ISettingsRepository>(
      () => _i955.SettingsRepositoryImpl(gh<_i723.ISettingsLocalDataSource>()),
    );
    gh.factory<_i101.SendCommandUseCase>(
      () => _i101.SendCommandUseCase(gh<_i207.IBikeControlRepository>()),
    );
    gh.lazySingleton<_i1006.IDiagnosticsRepository>(
      () => _i901.DiagnosticsRepositoryImpl(
        gh<_i213.IDiagnosticsRemoteDataSource>(),
        gh<_i640.IDiagnosticsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i1065.ITrackingRepository>(
      () => _i279.TrackingRepositoryImpl(
        gh<_i936.MqttService>(),
        gh<_i724.ITrackingRemoteDataSource>(),
      ),
    );
    gh.factory<_i656.GetTelemetryUseCase>(
      () => _i656.GetTelemetryUseCase(gh<_i566.ITelemetryRepository>()),
    );
    gh.factory<_i238.GetTelemetryHistoryUseCase>(
      () => _i238.GetTelemetryHistoryUseCase(gh<_i566.ITelemetryRepository>()),
    );
    gh.lazySingleton<_i682.IAuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.IAuthRemoteDataSource>(),
        gh<_i992.IAuthLocalDataSource>(),
      ),
    );
    gh.factory<_i323.GetRideRouteUseCase>(
      () => _i323.GetRideRouteUseCase(gh<_i1065.ITrackingRepository>()),
    );
    gh.factory<_i753.StreamLiveLocationUseCase>(
      () => _i753.StreamLiveLocationUseCase(gh<_i1065.ITrackingRepository>()),
    );
    gh.factory<_i712.MarkAlertReadUseCase>(
      () => _i712.MarkAlertReadUseCase(gh<_i1065.IAlertsRepository>()),
    );
    gh.factory<_i182.StreamActiveAlertsUseCase>(
      () => _i182.StreamActiveAlertsUseCase(gh<_i1065.IAlertsRepository>()),
    );
    gh.lazySingleton<_i158.IAnalyticsRepository>(
      () =>
          _i425.AnalyticsRepositoryImpl(gh<_i465.IAnalyticsRemoteDataSource>()),
    );
    gh.factory<_i28.GetAssignedBikeUseCase>(
      () => _i28.GetAssignedBikeUseCase(gh<_i195.IProfileRepository>()),
    );
    gh.factory<_i520.UpdateRiderProfileUseCase>(
      () => _i520.UpdateRiderProfileUseCase(gh<_i195.IProfileRepository>()),
    );
    gh.factory<_i560.ForgotPasswordUseCase>(
      () => _i560.ForgotPasswordUseCase(gh<_i682.IAuthRepository>()),
    );
    gh.factory<_i56.GetCurrentRiderUseCase>(
      () => _i56.GetCurrentRiderUseCase(gh<_i682.IAuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i682.IAuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i682.IAuthRepository>()),
    );
    gh.factory<_i57.SignupUseCase>(
      () => _i57.SignupUseCase(gh<_i682.IAuthRepository>()),
    );
    gh.factory<_i858.LockBikeUseCase>(
      () => _i858.LockBikeUseCase(gh<_i101.SendCommandUseCase>()),
    );
    gh.factory<_i414.UnlockBikeUseCase>(
      () => _i414.UnlockBikeUseCase(gh<_i101.SendCommandUseCase>()),
    );
    gh.factory<_i1029.GetSettingsUseCase>(
      () => _i1029.GetSettingsUseCase(gh<_i487.ISettingsRepository>()),
    );
    gh.factory<_i474.UpdateSettingsUseCase>(
      () => _i474.UpdateSettingsUseCase(gh<_i487.ISettingsRepository>()),
    );
    gh.factory<_i950.GetDiagnosticsUseCase>(
      () => _i950.GetDiagnosticsUseCase(gh<_i1006.IDiagnosticsRepository>()),
    );
    gh.factory<_i130.GetMaintenanceLogsUseCase>(
      () =>
          _i130.GetMaintenanceLogsUseCase(gh<_i1006.IDiagnosticsRepository>()),
    );
    gh.factory<_i296.GetRideSessionsUseCase>(
      () => _i296.GetRideSessionsUseCase(gh<_i158.IAnalyticsRepository>()),
    );
    gh.factory<_i1059.GetWeeklyStatsUseCase>(
      () => _i1059.GetWeeklyStatsUseCase(gh<_i158.IAnalyticsRepository>()),
    );
    return this;
  }
}

class _$ConnectivityModule extends _i855.ConnectivityModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$SupabaseModule extends _i388.SupabaseModule {}

class _$NotificationsModule extends _i308.NotificationsModule {}

class _$HiveModule extends _i31.HiveModule {}
