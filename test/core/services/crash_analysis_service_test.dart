import 'package:flutter_test/flutter_test.dart';
import 'package:donye/core/services/crash_analysis_service.dart';

void main() {
  test('detects a historical violent-rotation crash candidate', () {
    final events = CrashAnalysisService.analyze([
      {
        'id': 1,
        'recorded_at': '2026-09-06T15:07:49.913556Z',
        'accel_x': 0.1,
        'accel_y': 0.2,
        'accel_z': 1.0,
        'gyro_x': 433.26,
        'gyro_y': 0,
        'gyro_z': 0,
      },
    ]);

    expect(events, hasLength(1));
    expect(events.single.isCritical, isTrue);
    expect(events.single.peakRotationDps, closeTo(433.26, 0.01));
  });

  test('does not classify ordinary riding telemetry as a crash', () {
    final events = CrashAnalysisService.analyze([
      {
        'id': 2,
        'recorded_at': '2026-09-06T15:08:00Z',
        'accel_x': 0.1,
        'accel_y': 0.1,
        'accel_z': 1.0,
        'gyro_x': 5,
        'gyro_y': 7,
        'gyro_z': 3,
      },
    ]);

    expect(events, isEmpty);
  });
}
