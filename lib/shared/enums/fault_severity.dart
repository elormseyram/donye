enum FaultSeverity {
  minor,
  major,
  critical;

  String get label {
    switch (this) {
      case FaultSeverity.minor:
        return 'Minor';
      case FaultSeverity.major:
        return 'Major';
      case FaultSeverity.critical:
        return 'Critical';
    }
  }
}
