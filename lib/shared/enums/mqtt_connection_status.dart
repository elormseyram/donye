enum MqttConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting;

  bool get isConnected => this == MqttConnectionStatus.connected;
  bool get isActive =>
      this == MqttConnectionStatus.connected ||
      this == MqttConnectionStatus.reconnecting;

  String get label {
    switch (this) {
      case MqttConnectionStatus.disconnected:
        return 'Disconnected';
      case MqttConnectionStatus.connecting:
        return 'Connecting…';
      case MqttConnectionStatus.connected:
        return 'Connected';
      case MqttConnectionStatus.reconnecting:
        return 'Reconnecting…';
    }
  }
}
