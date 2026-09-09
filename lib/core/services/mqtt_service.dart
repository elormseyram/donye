import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/app_config.dart';
import '../../shared/enums/mqtt_connection_status.dart';

typedef JsonMap = Map<String, dynamic>;

@singleton
class MqttService {
  MqttService();

  final _log = Logger();

  MqttClient? _client;
  String? _bikeId;
  String? _lastToken;
  int _reconnectDelay = 1;

  final _connectionStatus =
      BehaviorSubject<MqttConnectionStatus>.seeded(MqttConnectionStatus.disconnected);
  final _telemetry = BehaviorSubject<JsonMap>();
  final _location = BehaviorSubject<JsonMap>();
  final _bikeStatus = BehaviorSubject<JsonMap>();
  final _alerts = PublishSubject<JsonMap>();

  Stream<MqttConnectionStatus> get connectionStatus => _connectionStatus.stream;
  Stream<JsonMap> get telemetryStream => _telemetry.stream;
  Stream<JsonMap> get locationStream => _location.stream;
  Stream<JsonMap> get bikeStatusStream => _bikeStatus.stream;
  Stream<JsonMap> get alertStream => _alerts.stream;

  Future<void> connect(String bikeId, String jwtToken) async {
    _bikeId = bikeId;
    _lastToken = jwtToken;
    _reconnectDelay = 1;
    await _doConnect();
  }

  Future<void> _doConnect() async {
  if (_bikeId == null || _lastToken == null) return;
  _connectionStatus.add(MqttConnectionStatus.connecting);

  final clientId = 'sherides_${DateTime.now().millisecondsSinceEpoch}';

  if (kIsWeb) {
    final scheme = AppConfig.mqttUseTls ? 'wss' : 'ws';
    final wsPort = AppConfig.mqttUseTls ? 8884 : 8000;
    final url = '$scheme://${AppConfig.mqttBrokerHost}:$wsPort/mqtt';

    _client = MqttBrowserClient(url, clientId)
      ..keepAlivePeriod = 30
      ..autoReconnect = false
      ..connectTimeoutPeriod = 10000
      ..logging(on: false)
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..onSubscribed = (_) {}
      ..connectionMessage = MqttConnectMessage()
          .authenticateAs(AppConfig.mqttUsername, AppConfig.mqttPassword)
          .withClientIdentifier(clientId)
          .startClean();
  } else {
    final port = AppConfig.mqttUseTls
        ? AppConfig.mqttBrokerTlsPort
        : AppConfig.mqttBrokerPort;

    _client = MqttServerClient(AppConfig.mqttBrokerHost, clientId)
      ..port = port
      ..secure = AppConfig.mqttUseTls
      ..keepAlivePeriod = 30
      ..autoReconnect = false
      ..connectTimeoutPeriod = 10000
      ..logging(on: false)
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..onSubscribed = (_) {}
      ..onBadCertificate = ((Object _) => true)
      ..connectionMessage = MqttConnectMessage()
          .authenticateAs(AppConfig.mqttUsername, AppConfig.mqttPassword)
          .withClientIdentifier(clientId)
          .startClean();
  }

  try {
    await _client!.connect();
  } catch (e) {
    _log.e('MQTT connect error: $e');
    _scheduleReconnect();
  }
}

  void _onConnected() {
    _log.i('MQTT connected');
    _reconnectDelay = 1;
    _connectionStatus.add(MqttConnectionStatus.connected);
    _subscribeAll();
    _client!.updates!.listen(_onMessage);
  }

  void _onDisconnected() {
    _log.w('MQTT disconnected');
    if (_connectionStatus.value != MqttConnectionStatus.disconnected) {
      _scheduleReconnect();
    }
  }

  void _subscribeAll() {
    final id = _bikeId!;
    final prefix = AppConfig.mqttTopicPrefix;
    for (final suffix in ['telemetry', 'location', 'status', 'alerts']) {
      _client!.subscribe('$prefix/$id/$suffix', MqttQos.atLeastOnce);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    if (messages == null) return;
    for (final msg in messages) {
      final payload = MqttPublishPayload.bytesToStringAsString(
        (msg.payload as MqttPublishMessage).payload.message,
      );
      try {
        final data = jsonDecode(payload) as JsonMap;
        final topic = msg.topic;
        if (topic.endsWith('/telemetry')) {
          _telemetry.add(data);
        } else if (topic.endsWith('/location')) {
          _location.add(data);
        } else if (topic.endsWith('/status')) {
          _bikeStatus.add(data);
        } else if (topic.endsWith('/alerts')) {
          _alerts.add(data);
        }
      } catch (e) {
        _log.e('MQTT parse error on ${msg.topic}: $e');
      }
    }
  }

  Future<void> publishCommand(JsonMap payload) async {
    if (_bikeId == null) return;
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }
    final topic = '${AppConfig.mqttTopicPrefix}/$_bikeId/commands';
    final builder = MqttClientPayloadBuilder()
      ..addString(jsonEncode(payload));
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void _scheduleReconnect() {
    _connectionStatus.add(MqttConnectionStatus.reconnecting);
    Future.delayed(Duration(seconds: _reconnectDelay), () async {
      _reconnectDelay = (_reconnectDelay * 2).clamp(1, 30);
      await _doConnect();
    });
  }

  Future<void> disconnect() async {
    _connectionStatus.add(MqttConnectionStatus.disconnected);
    _bikeId = null;
    _lastToken = null;
    _client?.disconnect();
    _client = null;
  }

  void dispose() {
    _connectionStatus.close();
    _telemetry.close();
    _location.close();
    _bikeStatus.close();
    _alerts.close();
  }
}
