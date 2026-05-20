import 'package:injectable/injectable.dart';
import '../entities/telemetry_entity.dart';
import '../interfaces/i_telemetry_repository.dart';

@injectable
class GetTelemetryUseCase {
  const GetTelemetryUseCase(this._repository);
  final ITelemetryRepository _repository;

  Stream<TelemetryEntity> call() => _repository.liveStream;
}
