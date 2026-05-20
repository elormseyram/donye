import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/telemetry_entity.dart';
import '../providers/telemetry_provider.dart';

class TelemetryController extends AutoDisposeNotifier<TelemetryEntity?> {
  @override
  TelemetryEntity? build() {
    ref.listen<AsyncValue<TelemetryEntity>>(
      telemetryStreamProvider,
      (_, next) {
        next.whenData((data) => state = data);
      },
    );
    return ref.read(latestTelemetryProvider);
  }
}

final telemetryControllerProvider =
    AutoDisposeNotifierProvider<TelemetryController, TelemetryEntity?>(
  TelemetryController.new,
);
