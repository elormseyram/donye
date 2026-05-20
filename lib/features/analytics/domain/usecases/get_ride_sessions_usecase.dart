import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ride_session_entity.dart';
import '../interfaces/i_analytics_repository.dart';

@injectable
class GetRideSessionsUseCase {
  const GetRideSessionsUseCase(this._repository);
  final IAnalyticsRepository _repository;

  Future<Either<Failure, List<RideSessionEntity>>> call(String riderId) =>
      _repository.getRideSessions(riderId);
}
