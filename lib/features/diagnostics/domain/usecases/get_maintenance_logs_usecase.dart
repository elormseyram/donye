import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/maintenance_log_model.dart';
import '../interfaces/i_diagnostics_repository.dart';

@injectable
class GetMaintenanceLogsUseCase {
  const GetMaintenanceLogsUseCase(this._repository);
  final IDiagnosticsRepository _repository;

  Future<Either<Failure, List<MaintenanceLogModel>>> call(String bikeId) =>
      _repository.getMaintenanceLogs(bikeId);
}
