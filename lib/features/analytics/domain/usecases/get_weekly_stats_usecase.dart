import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weekly_stats_entity.dart';
import '../interfaces/i_analytics_repository.dart';

@injectable
class GetWeeklyStatsUseCase {
  const GetWeeklyStatsUseCase(this._repository);
  final IAnalyticsRepository _repository;

  Future<Either<Failure, WeeklyStatsEntity>> call(String riderId) =>
      _repository.getWeeklyStats(riderId);
}
