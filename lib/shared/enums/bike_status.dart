enum BikeStatus {
  active,
  maintenance,
  inactive;

  String get label {
    switch (this) {
      case BikeStatus.active:
        return 'Active';
      case BikeStatus.maintenance:
        return 'Maintenance';
      case BikeStatus.inactive:
        return 'Inactive';
    }
  }
}
