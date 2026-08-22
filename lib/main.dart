import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants/app_config.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/services/google_maps_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.supabaseUrl.isEmpty ||
      AppConfig.supabasePublishableKey.isEmpty ||
      AppConfig.dornyePortalUrl.isEmpty ||
      AppConfig.dornyePortalPublishableKey.isEmpty) {
    throw StateError(
      'Missing Supabase build configuration. Use --dart-define-from-file.',
    );
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabasePublishableKey,
  );

  await ensureGoogleMapsLoaded(AppConfig.googleMapsApiKey);

  await Hive.initFlutter();
  await _openHiveBoxes();

  await configureDependencies();

  runApp(const ProviderScope(child: App()));
}

Future<void> _openHiveBoxes() async {
  await Future.wait([
    Hive.openBox('rider'),
    Hive.openBox('telemetry'),
    Hive.openBox('alerts'),
    Hive.openBox('diagnostics'),
    Hive.openBox('settings'),
  ]);
}
