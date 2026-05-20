import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ride_session_entity.dart';
import '../entities/weekly_stats_entity.dart';

abstract class IAnalyticsRepository {
  Future<Either<Failure, List<RideSessionEntity>>> getRideSessions(String riderId);
  Future<Either<Failure, WeeklyStatsEntity>> getWeeklyStats(String riderId);
}
