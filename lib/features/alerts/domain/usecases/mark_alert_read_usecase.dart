import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/interfaces/i_alerts_repository.dart';

@injectable
class MarkAlertReadUseCase {
  const MarkAlertReadUseCase(this._repository);
  final IAlertsRepository _repository;

  Future<Either<Failure, void>> call(String alertId) =>
      _repository.markAlertRead(alertId);
}
