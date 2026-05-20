enum AlertType {
  batteryLow,
  overheat,
  geofence,
  tamper,
  fault;

  String get label {
    switch (this) {
      case AlertType.batteryLow:
        return 'Low Battery';
      case AlertType.overheat:
        return 'Overheat';
      case AlertType.geofence:
        return 'Geofence';
      case AlertType.tamper:
        return 'Tamper Detected';
      case AlertType.fault:
        return 'System Fault';
    }
  }
}
