import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/datasources/portal_session_cache.dart';
import '../models/ride_session_model.dart';

abstract class IAnalyticsRemoteDataSource {
  Future<List<RideSessionModel>> getRideSessions(String riderId);
}

@LazySingleton(as: IAnalyticsRemoteDataSource)
class AnalyticsRemoteDataSource implements IAnalyticsRemoteDataSource {
  const AnalyticsRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<List<RideSessionModel>> getRideSessions(String riderId) async {
    try {
      final firmwareSessions = await _getFirmwareRideSessions(riderId);
      if (firmwareSessions.isNotEmpty) return firmwareSessions;

      // Legacy fallback for deployments that still write completed sessions.
      final rows = await _client
          .from('ride_sessions')
          .select()
          .eq('rider_id', riderId)
          .order('start_time', ascending: false)
          .limit(50);

      final sessions = (rows as List)
          .map(
            (r) =>
                RideSessionModel.fromJson(Map<String, dynamic>.from(r as Map)),
          )
          .toList();
      return sessions;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<RideSessionModel>> _getFirmwareRideSessions(
    String riderId,
  ) async {
    final deviceId = AppConfig.mqttBikeId;
    if (deviceId.isEmpty) return [];

    final since = DateTime.now().subtract(const Duration(days: 7));
    // The most recent page always contains the current/last ride. Pulling the
    // entire high-frequency seven-day feed made this screen slow and could
    // time out before returning any result.
    final rows = await _client
        .from('ebike_telemetry')
        .select('device_id,latitude,longitude,gps_speed,recorded_at')
        .eq('device_id', deviceId)
        .gte('recorded_at', since.toUtc().toIso8601String())
        .order('recorded_at', ascending: false)
        .limit(1000);

    final samples =
        (rows as List)
            .map(
              (row) => _FirmwareSample.fromJson(
                Map<String, dynamic>.from(row as Map),
              ),
            )
            .where((sample) => sample != null)
            .cast<_FirmwareSample>()
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));
    return _sessionsFromSamples(samples, riderId, deviceId);
  }

  List<RideSessionModel> _sessionsFromSamples(
    List<_FirmwareSample> samples,
    String riderId,
    String deviceId,
  ) {
    if (samples.isEmpty) return [];

    const maxSampleGap = Duration(seconds: 30);
    final sessions = <RideSessionModel>[];
    final bike = PortalSessionCache.bike;
    final capacityKwh =
        double.tryParse(
          '${bike?['battery_capacity_kwh'] ?? bike?['batteryCapacityKwh'] ?? 0}',
        ) ??
        0.0;
    var current = <_FirmwareSample>[];

    void finishRide() {
      if (current.isEmpty) return;
      var distanceKm = 0.0;
      for (var i = 1; i < current.length; i++) {
        final segment = _haversineKm(current[i - 1], current[i]);
        // Reject impossible GPS jumps rather than inflating total distance.
        if (segment <= 1.0) distanceKm += segment;
      }
      final moving = current.where((s) => s.speedKmh > 0).toList();
      if (moving.isNotEmpty) {
        final avgSpeed =
            moving.fold(0.0, (sum, s) => sum + s.speedKmh) / moving.length;
        final maxSpeed = moving
            .map((s) => s.speedKmh)
            .reduce((a, b) => math.max(a, b));
        // Until voltage/current telemetry is available, estimate consumption
        // from the configured full-charge capacity and a 60 km nominal range.
        final energyKwh = capacityKwh > 0
            ? capacityKwh * distanceKm / 60.0
            : 0.0;
        final batteryDrain = capacityKwh > 0
            ? (energyKwh / capacityKwh * 100).clamp(0.0, 100.0).toDouble()
            : 0.0;
        sessions.add(
          RideSessionModel(
            id: 'firmware-${current.first.time.millisecondsSinceEpoch}',
            riderId: riderId,
            bikeId: deviceId,
            startTime: current.first.time.toIso8601String(),
            endTime: current.last.time.toIso8601String(),
            distanceKm: distanceKm,
            avgSpeedKmh: avgSpeed,
            maxSpeedKmh: maxSpeed,
            energyConsumedKwh: energyKwh,
            avgBatteryDrain: batteryDrain,
          ),
        );
      }
      current = <_FirmwareSample>[];
    }

    for (final sample in samples) {
      if (current.isNotEmpty &&
          sample.time.difference(current.last.time) > maxSampleGap) {
        finishRide();
      }
      if (sample.speedKmh > 0) {
        current.add(sample);
      } else if (current.isNotEmpty) {
        // A zero/null reading means the bike is off and closes the ride.
        finishRide();
      }
    }
    finishRide();
    return sessions.reversed.toList();
  }

  double _haversineKm(_FirmwareSample a, _FirmwareSample b) {
    const earthRadiusKm = 6371.0;
    double radians(double degrees) => degrees * math.pi / 180.0;
    final dLat = radians(b.latitude - a.latitude);
    final dLon = radians(b.longitude - a.longitude);
    final value =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(radians(a.latitude)) *
            math.cos(radians(b.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final safeValue = value.clamp(0.0, 1.0).toDouble();
    return earthRadiusKm *
        2 *
        math.atan2(math.sqrt(safeValue), math.sqrt(1 - safeValue));
  }
}

class _FirmwareSample {
  const _FirmwareSample({
    required this.latitude,
    required this.longitude,
    required this.speedKmh,
    required this.time,
  });

  final double latitude;
  final double longitude;
  final double speedKmh;
  final DateTime time;

  static _FirmwareSample? fromJson(Map<String, dynamic> json) {
    final latitude = double.tryParse('${json['latitude']}');
    final longitude = double.tryParse('${json['longitude']}');
    final speed = double.tryParse('${json['gps_speed']}') ?? 0.0;
    final time = DateTime.tryParse('${json['recorded_at']}');
    if (latitude == null || longitude == null || time == null) {
      return null;
    }
    return _FirmwareSample(
      latitude: latitude,
      longitude: longitude,
      speedKmh: speed,
      time: time,
    );
  }
}
