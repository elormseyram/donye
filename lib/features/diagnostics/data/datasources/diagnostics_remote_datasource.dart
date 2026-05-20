import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/diagnostic_model.dart';
import '../models/maintenance_log_model.dart';

abstract interface class IDiagnosticsRemoteDataSource {
  Future<DiagnosticModel> getDiagnostics(String bikeId);
  Future<List<MaintenanceLogModel>> getMaintenanceLogs(String bikeId);
}

@LazySingleton(as: IDiagnosticsRemoteDataSource)
class DiagnosticsRemoteDataSource implements IDiagnosticsRemoteDataSource {
  const DiagnosticsRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<DiagnosticModel> getDiagnostics(String bikeId) async {
    try {
      final rows = await _client
          .from('diagnostics')
          .select('*, fault_codes(*)')
          .eq('bike_id', bikeId)
          .order('last_diagnostic_at', ascending: false)
          .limit(1);
      if ((rows as List).isEmpty) {
        throw ServerException(message: 'No diagnostics found');
      }
      return DiagnosticModel.fromJson(
          Map<String, dynamic>.from(rows.first as Map));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MaintenanceLogModel>> getMaintenanceLogs(String bikeId) async {
    try {
      final rows = await _client
          .from('maintenance_logs')
          .select()
          .eq('bike_id', bikeId)
          .order('performed_at', ascending: false)
          .limit(50);
      return (rows as List)
          .map((r) =>
              MaintenanceLogModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
