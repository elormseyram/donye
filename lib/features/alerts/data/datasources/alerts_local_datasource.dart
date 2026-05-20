import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../models/alert_model.dart';

abstract class IAlertsLocalDataSource {
  List<AlertModel> getCachedAlerts();
  Future<void> cacheAlerts(List<AlertModel> alerts);
}

@LazySingleton(as: IAlertsLocalDataSource)
class AlertsLocalDataSource implements IAlertsLocalDataSource {
  AlertsLocalDataSource(@Named('alertsBox') this._box);
  final Box _box;

  @override
  List<AlertModel> getCachedAlerts() {
    return _box.values
        .whereType<Map>()
        .map((m) => AlertModel.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> cacheAlerts(List<AlertModel> alerts) async {
    await _box.clear();
    for (final a in alerts) {
      await _box.put(a.id, a.toJson());
    }
  }
}
