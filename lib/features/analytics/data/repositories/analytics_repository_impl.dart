import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ride_session_entity.dart';
import '../../domain/entities/weekly_stats_entity.dart';
import '../../domain/interfaces/i_analytics_repository.dart';
import '../datasources/analytics_remote_datasource.dart';
import '../models/ride_session_model.dart';

@LazySingleton(as: IAnalyticsRepository)
class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  const AnalyticsRepositoryImpl(this._remote);
  final IAnalyticsRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<RideSessionEntity>>> getRideSessions(
    String riderId,
  ) async {
    try {
      final models = await _remote.getRideSessions(riderId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyStatsEntity>> getWeeklyStats(
    String riderId,
  ) async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final models = await _remote.getRideSessions(riderId);
      final recent = models
          .where((m) => DateTime.parse(m.startTime).isAfter(sevenDaysAgo))
          .toList();

      final dailyMap = <String, _DayAccumulator>{};
      for (final m in recent) {
        final day = DateTime.parse(m.startTime);
        final key = '${day.year}-${day.month}-${day.day}';
        dailyMap.putIfAbsent(key, () => _DayAccumulator(day));
        dailyMap[key]!.add(m);
      }

      final dailyStats = dailyMap.values
          .map((acc) => DailyDistanceStat(
                date: acc.date,
                distanceKm: acc.distanceKm,
                energyKwh: acc.energyKwh,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      final totalDist = recent.fold(0.0, (s, m) => s + m.distanceKm);
      final totalEnergy = recent.fold(0.0, (s, m) => s + m.energyConsumedKwh);
      final maxSpeed = recent.isEmpty
          ? 0.0
          : recent.map((m) => m.maxSpeedKmh).reduce((a, b) => a > b ? a : b);
      final avgSpeed =
          recent.isEmpty ? 0.0 : recent.fold(0.0, (s, m) => s + m.avgSpeedKmh) / recent.length;

      return Right(WeeklyStatsEntity(
        totalDistanceKm: totalDist,
        totalEnergyKwh: totalEnergy,
        avgSpeedKmh: avgSpeed,
        maxSpeedKmh: maxSpeed,
        totalRides: recent.length,
        totalRideTime: Duration.zero,
        dailyDistance: dailyStats,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

class _DayAccumulator {
  _DayAccumulator(this.date);
  final DateTime date;
  double distanceKm = 0;
  double energyKwh = 0;

  void add(RideSessionModel m) {
    distanceKm += m.distanceKm;
    energyKwh += m.energyConsumedKwh;
  }
}
