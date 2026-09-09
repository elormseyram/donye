import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

class AmbientWeather {
  const AmbientWeather({
    required this.temperatureCelsius,
    required this.fetchedAt,
  });

  final double temperatureCelsius;
  final DateTime fetchedAt;
}

@singleton
class WeatherService {
  final _log = Logger();

  AmbientWeather? _cached;

  Future<AmbientWeather?> getAmbientTemperature({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cached != null) {
      final age = DateTime.now().difference(_cached!.fetchedAt);
      if (age.inMinutes < 5) return _cached;
    }

    try {
      final position = await _getCurrentPosition();
      if (position == null) return _cached;

      final temp = await _fetchTemperature(
        position.latitude,
        position.longitude,
      );
      if (temp == null) return _cached;

      _cached = AmbientWeather(
        temperatureCelsius: temp,
        fetchedAt: DateTime.now(),
      );
      return _cached;
    } catch (e) {
      _log.e('WeatherService error: $e');
      return _cached;
    }
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _log.w('Location services are disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _log.w('Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _log.w('Location permission permanently denied');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      _log.e('Failed to get position: $e');
      return null;
    }
  }

  Future<double?> _fetchTemperature(double lat, double lng) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lng&current=temperature_2m',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        _log.w('Open-Meteo returned ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>?;
      final temp = current?['temperature_2m'];
      if (temp == null) return null;

      return (temp as num).toDouble();
    } catch (e) {
      _log.e('Failed to fetch weather: $e');
      return null;
    }
  }
}