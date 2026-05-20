import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/diagnostic_model.dart';

abstract interface class IDiagnosticsLocalDataSource {
  Future<DiagnosticModel?> getCached(String bikeId);
  Future<void> cache(DiagnosticModel model);
}

@LazySingleton(as: IDiagnosticsLocalDataSource)
class DiagnosticsLocalDataSource implements IDiagnosticsLocalDataSource {
  DiagnosticsLocalDataSource(@Named('diagnosticsBox') this._box);
  final Box _box;

  @override
  Future<DiagnosticModel?> getCached(String bikeId) async {
    try {
      final raw = _box.get(bikeId);
      if (raw == null) return null;
      return DiagnosticModel.fromJson(
          jsonDecode(raw as String) as Map<String, dynamic>);
    } catch (_) {
      throw CacheException(message: 'Failed to read diagnostics cache');
    }
  }

  @override
  Future<void> cache(DiagnosticModel model) async {
    await _box.put(model.bikeId, jsonEncode(model.toJson()));
  }
}
