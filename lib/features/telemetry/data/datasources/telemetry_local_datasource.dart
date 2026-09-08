import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/telemetry_payload_model.dart';

abstract interface class ITelemetryLocalDataSource {
  Future<List<TelemetryPayloadModel>> getCached(String bikeId);
  Future<void> cacheEntries(List<TelemetryPayloadModel> entries);
}

@LazySingleton(as: ITelemetryLocalDataSource)
class TelemetryLocalDataSource implements ITelemetryLocalDataSource {
  TelemetryLocalDataSource(@Named('telemetryBox') this._box);
  final Box _box;

  static const _cacheLimit = 100;

  @override
  Future<List<TelemetryPayloadModel>> getCached(String bikeId) async {
    try {
      final raw = _box.values
          .whereType<String>()
          .map(
            (s) => TelemetryPayloadModel.fromJson(
              jsonDecode(s) as Map<String, dynamic>,
            ),
          )
          .where((m) => m.bikeId == bikeId)
          .toList();
      raw.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return raw;
    } catch (_) {
      throw CacheException(message: 'Failed to read telemetry cache');
    }
  }

  @override
  Future<void> cacheEntries(List<TelemetryPayloadModel> entries) async {
    await _box.clear();
    final limited = entries.take(_cacheLimit);
    for (final e in limited) {
      await _box.add(jsonEncode(e.toJson()));
    }
  }
}
