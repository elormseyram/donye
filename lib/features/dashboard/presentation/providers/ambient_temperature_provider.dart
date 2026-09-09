import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/weather_service.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

final ambientTemperatureProvider = FutureProvider<double?>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  final weather = await service.getAmbientTemperature();
  return weather?.temperatureCelsius;
});
