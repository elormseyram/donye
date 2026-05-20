import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/alert_model.dart';

abstract class IAlertsRemoteDataSource {
  Stream<List<AlertModel>> streamActiveAlerts(String bikeId);
  Future<void> markAlertRead(String alertId);
}

@LazySingleton(as: IAlertsRemoteDataSource)
class AlertsRemoteDataSource implements IAlertsRemoteDataSource {
  const AlertsRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Stream<List<AlertModel>> streamActiveAlerts(String bikeId) {
    return _client
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('bike_id', bikeId)
        .order('created_at', ascending: false)
        .map((rows) => rows
            .map((r) => AlertModel.fromJson(Map<String, dynamic>.from(r)))
            .where((a) => !a.isResolved)
            .toList());
  }

  @override
  Future<void> markAlertRead(String alertId) async {
    try {
      await _client
          .from('alerts')
          .update({'is_read': true}).eq('id', alertId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
