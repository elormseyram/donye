import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient createMqttClient({
  required String host,
  required String clientId,
  required int tcpPort,
  required int webSocketPort,
}) {
  return MqttBrowserClient.withPort(
    'wss://$host/mqtt',
    clientId,
    webSocketPort,
  )..websocketProtocols = MqttClientConstants.protocolsSingleDefault;
}
