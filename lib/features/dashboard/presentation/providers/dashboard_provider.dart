import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/rider_entity.dart';
import '../../../telemetry/presentation/providers/telemetry_provider.dart';
import '../../../../shared/enums/mqtt_connection_status.dart';

export '../../../auth/presentation/providers/auth_provider.dart'
    show currentRiderProvider, assignedBikeIdProvider;
export '../../../telemetry/presentation/providers/telemetry_provider.dart'
    show latestTelemetryProvider;

/// Convenience alias so dashboard widgets can watch one provider.
final dashboardRiderProvider = FutureProvider<RiderEntity?>((ref) async {
  return ref.watch(currentRiderProvider.future);
});

/// Live MQTT connection status backed by the real MqttService stream.
final mqttConnectionStatusProvider =
    StreamProvider<MqttConnectionStatus>((ref) {
  return ref.watch(mqttServiceProvider).connectionStatus;
});
