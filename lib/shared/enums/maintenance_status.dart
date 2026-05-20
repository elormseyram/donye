enum MaintenanceStatus {
  ok,
  dueSoon,
  overdue;

  String get label {
    switch (this) {
      case MaintenanceStatus.ok:
        return 'OK';
      case MaintenanceStatus.dueSoon:
        return 'Due Soon';
      case MaintenanceStatus.overdue:
        return 'Overdue';
    }
  }
}
