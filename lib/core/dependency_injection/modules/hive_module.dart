import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HiveModule {
  @Named('riderBox')
  @singleton
  Box get riderBox => Hive.box('rider');

  @Named('telemetryBox')
  @singleton
  Box get telemetryBox => Hive.box('telemetry');

  @Named('alertsBox')
  @singleton
  Box get alertsBox => Hive.box('alerts');

  @Named('diagnosticsBox')
  @singleton
  Box get diagnosticsBox => Hive.box('diagnostics');

  @Named('settingsBox')
  @singleton
  Box get settingsBox => Hive.box('settings');
}
