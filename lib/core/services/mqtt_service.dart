import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/app_config.dart';
import '../../shared/enums/mqtt_connection_status.dart';
import 'mqtt_client_factory.dart';

typedef JsonMap = Map<String, dynamic>;

@singleton
class MqttService {
  MqttService();

  final _log = Logger();

  MqttClient? _client;
  String? _bikeId;
  String? _lastToken;
  int _reconnectDelay = 1;
  Timer? _reconnectTimer;
  bool _disconnectRequested = false;

  final _connectionStatus = BehaviorSubject<MqttConnectionStatus>.seeded(
    MqttConnectionStatus.disconnected,
  );
  final _telemetry = BehaviorSubject<JsonMap>();
  final _location = BehaviorSubject<JsonMap>();
  final _bikeStatus = BehaviorSubject<JsonMap>();
  final _alerts = ReplaySubject<JsonMap>(maxSize: 20);

  Stream<MqttConnectionStatus> get connectionStatus => _connectionStatus.stream;
  Stream<JsonMap> get telemetryStream => _telemetry.stream;
  Stream<JsonMap> get locationStream => _location.stream;
  Stream<JsonMap> get bikeStatusStream => _bikeStatus.stream;
  Stream<JsonMap> get alertStream => _alerts.stream;

  Future<void> connect(String bikeId, String jwtToken) async {
    final mqttBikeId = AppConfig.mqttBikeId.isEmpty
        ? bikeId
        : AppConfig.mqttBikeId;
    if (_bikeId == mqttBikeId &&
        !_disconnectRequested &&
        _connectionStatus.value != MqttConnectionStatus.disconnected) {
      return;
    }
    _reconnectTimer?.cancel();
    _disconnectRequested = false;
    _bikeId = mqttBikeId;
    _lastToken = jwtToken;
    _reconnectDelay = 1;
    await _doConnect();
  }

  Future<void> _doConnect() async {
    if (_bikeId == null || _lastToken == null) return;
    _connectionStatus.add(MqttConnectionStatus.connecting);

    final clientId = 'sherides_${DateTime.now().millisecondsSinceEpoch}';

    _client = createMqttClient(
      host: AppConfig.mqttBrokerHost,
      clientId: clientId,
      tcpPort: AppConfig.mqttBrokerTlsPort,
       webSocketPort: AppConfig.mqttBrokerWebSocketTlsPort,
    )
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
    if (!_disconnectRequested) {
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

  Future<bool> publishCommand(JsonMap payload) async {
    if (_bikeId == null) return false;
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      return false;
    }
    final topic = '${AppConfig.mqttTopicPrefix}/$_bikeId/commands';
    final builder = MqttClientPayloadBuilder()..addString(jsonEncode(payload));
    final bytes = builder.payload;
    if (bytes == null) return false;
    _client!.publishMessage(topic, MqttQos.atLeastOnce, bytes);
    return true;
  }

  void _scheduleReconnect() {
    if (_disconnectRequested ||
        _bikeId == null ||
        _reconnectTimer?.isActive == true) {
      return;
    }
    _connectionStatus.add(MqttConnectionStatus.reconnecting);
    _reconnectTimer = Timer(Duration(seconds: _reconnectDelay), () {
      _reconnectTimer = null;
      _reconnectDelay = (_reconnectDelay * 2).clamp(
        1,
        AppConfig.mqttReconnectMaxDelaySeconds,
      );
      _doConnect();
    });
  }

  Future<void> disconnect() async {
    _disconnectRequested = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _connectionStatus.add(MqttConnectionStatus.disconnected);
    _bikeId = null;
    _lastToken = null;
    _client?.disconnect();
    _client = null;
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _connectionStatus.close();
    _telemetry.close();
    _location.close();
    _bikeStatus.close();
    _alerts.close();
  }
}