enum TelemetryStatus {
  normal,
  warning,
  critical;

  String get label {
    switch (this) {
      case TelemetryStatus.normal:
        return 'Normal';
      case TelemetryStatus.warning:
        return 'Warning';
      case TelemetryStatus.critical:
        return 'Critical';
    }
  }
}
