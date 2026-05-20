import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/diagnostic_entity.dart';
import '../interfaces/i_diagnostics_repository.dart';

@injectable
class GetDiagnosticsUseCase {
  const GetDiagnosticsUseCase(this._repository);
  final IDiagnosticsRepository _repository;

  Future<Either<Failure, DiagnosticEntity>> call(String bikeId) =>
      _repository.getDiagnostics(bikeId);
}
