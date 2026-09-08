import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/mqtt_service.dart';
import '../../../../shared/enums/command_type.dart';
import '../../../../shared/enums/command_status.dart';
import '../models/bike_command_model.dart';

abstract interface class IBikeControlDataSource {
  Future<BikeCommandModel> sendCommand(
    String bikeId,
    CommandType type, {
    String? payload,
  });
}

@LazySingleton(as: IBikeControlDataSource)
class BikeControlDataSource implements IBikeControlDataSource {
  const BikeControlDataSource(this._client, this._mqttService);
  final SupabaseClient _client;
  final MqttService _mqttService;

  @override
  Future<BikeCommandModel> sendCommand(
    String bikeId,
    CommandType type, {
    String? payload,
  }) async {
    final issuedAt = DateTime.now().toUtc().toIso8601String();
    final model = BikeCommandModel(
      bikeId: bikeId,
      type: type.name,
      payload: payload,
      issuedAt: issuedAt,
      status: CommandStatus.sent.name,
    );

    try {
      // Publish over MQTT (primary channel)
      final published = await _mqttService.publishCommand(
        model.toMqttPayload(),
      );
      if (!published) {
        throw ServerException(message: 'Bike is not connected to MQTT');
      }

      // The command has already reached MQTT. An unavailable optional audit
      // table must not make a successful hardware command look like a failure.
      try {
        await _client.from('bike_commands').insert({
          'bike_id': bikeId,
          'type': type.name,
          if (payload != null) 'payload': payload,
          'issued_at': issuedAt,
          'status': CommandStatus.sent.name,
        });
      } catch (_) {}

      return model;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
