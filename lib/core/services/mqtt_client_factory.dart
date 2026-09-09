import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_client_factory_native.dart'
    if (dart.library.js_interop) 'mqtt_client_factory_web.dart' as platform;

MqttClient createMqttClient({
  required String host,
  required String clientId,
  required int tcpPort,
  required int webSocketPort,
}) =>
    platform.createMqttClient(
      host: host,
      clientId: clientId,
      tcpPort: tcpPort,
      webSocketPort: webSocketPort,
    );
