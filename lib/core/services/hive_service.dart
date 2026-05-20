import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveService {
  static const _telemetryBox = 'telemetry';
  static const _alertsBox = 'alerts';
  static const _diagnosticsBox = 'diagnostics';
  static const _riderBox = 'rider';
  static const _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(_riderBox),
      Hive.openBox(_telemetryBox),
      Hive.openBox(_alertsBox),
      Hive.openBox(_diagnosticsBox),
      Hive.openBox(_settingsBox),
    ]);
  }

  Box get riderBox => Hive.box(_riderBox);
  Box get telemetryBox => Hive.box(_telemetryBox);
  Box get alertsBox => Hive.box(_alertsBox);
  Box get diagnosticsBox => Hive.box(_diagnosticsBox);
  Box get settingsBox => Hive.box(_settingsBox);

  Future<void> clearAll() async {
    await Future.wait([
      riderBox.clear(),
      telemetryBox.clear(),
      alertsBox.clear(),
      diagnosticsBox.clear(),
    ]);
  }
}
