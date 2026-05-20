enum CommandStatus {
  pending,
  sent,
  acknowledged,
  failed;

  String get label {
    switch (this) {
      case CommandStatus.pending:
        return 'Pending';
      case CommandStatus.sent:
        return 'Sent';
      case CommandStatus.acknowledged:
        return 'Acknowledged';
      case CommandStatus.failed:
        return 'Failed';
    }
  }
}
