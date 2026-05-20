import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/diagnostics_provider.dart';

class DiagnosticsController extends Notifier<void> {
  @override
  void build() {}

  Future<void> refresh() async {
    ref.invalidate(diagnosticsProvider);
    ref.invalidate(maintenanceLogsProvider);
  }
}

final diagnosticsControllerProvider = NotifierProvider<DiagnosticsController, void>(
  DiagnosticsController.new,
);
