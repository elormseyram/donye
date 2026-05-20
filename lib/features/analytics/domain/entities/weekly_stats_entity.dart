import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_stats_entity.freezed.dart';

@freezed
abstract class WeeklyStatsEntity with _$WeeklyStatsEntity {
  const factory WeeklyStatsEntity({
    required double totalDistanceKm,
    required double totalEnergyKwh,
    required double avgSpeedKmh,
    required double maxSpeedKmh,
    required int totalRides,
    required Duration totalRideTime,
    required List<DailyDistanceStat> dailyDistance,
  }) = _WeeklyStatsEntity;
}

@freezed
abstract class DailyDistanceStat with _$DailyDistanceStat {
  const factory DailyDistanceStat({
    required DateTime date,
    required double distanceKm,
    required double energyKwh,
  }) = _DailyDistanceStat;
}
