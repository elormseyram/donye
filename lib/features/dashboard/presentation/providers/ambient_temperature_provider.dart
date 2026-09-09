import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/weather_service.dart';

final weatherServiceProvider = Provider<WeatherService>(
  (_) => WeatherService(),
);

final ambientTemperatureProvider = FutureProvider.autoDispose<double?>((
  ref,
) async {
  final weather = await ref
      .watch(weatherServiceProvider)
      .getAmbientTemperature();
  return weather?.temperatureCelsius;
});