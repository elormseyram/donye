import 'package:injectable/injectable.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/interfaces/i_alerts_repository.dart';

@injectable
class StreamActiveAlertsUseCase {
  const StreamActiveAlertsUseCase(this._repository);
  final IAlertsRepository _repository;

  Stream<List<AlertEntity>> call(String bikeId) =>
      _repository.streamActiveAlerts(bikeId);
}
