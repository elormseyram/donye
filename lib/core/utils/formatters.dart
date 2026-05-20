import 'package:intl/intl.dart';

abstract class AppFormatters {
  static String battery(double percentage) =>
      '${percentage.toStringAsFixed(0)}%';

  static String voltage(double v) => '${v.toStringAsFixed(1)}V';

  static String current(double a) => '${a.toStringAsFixed(1)}A';

  static String speed(double kmh) => '${kmh.toStringAsFixed(1)} km/h';

  static String distance(double km) {
    if (km < 1) return '${(km * 1000).toStringAsFixed(0)} m';
    return '${km.toStringAsFixed(2)} km';
  }

  static String temperature(double celsius) =>
      '${celsius.toStringAsFixed(1)}°C';

  static String rpm(int r) => '$r RPM';

  static String healthScore(int score) => '$score / 100';

  static String dateTime(DateTime dt) =>
      DateFormat('dd MMM yyyy, HH:mm').format(dt);

  static String date(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  static String time(DateTime dt) => DateFormat('HH:mm').format(dt);

  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  static String energy(double kwh) => '${kwh.toStringAsFixed(2)} kWh';
}
