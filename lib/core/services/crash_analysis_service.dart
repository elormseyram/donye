import 'dart:math' as math;

class CrashEventAnalysis {
  const CrashEventAnalysis({
    required this.id,
    required this.detectedAt,
    required this.peakImpactG,
    required this.peakRotationDps,
    required this.hadFreeFall,
    required this.sampleCount,
  });

  final String id;
  final DateTime detectedAt;
  final double peakImpactG;
  final double peakRotationDps;
  final bool hadFreeFall;
  final int sampleCount;

  bool get isCritical =>
      peakImpactG >= 4 ||
      peakRotationDps >= 350 ||
      (peakImpactG >= 2.5 && peakRotationDps >= 220);

  String get phaseSummary {
    final phases = <String>[];
    if (hadFreeFall) phases.add('free-fall');
    if (peakRotationDps >= 220) phases.add('violent rotation');
    if (peakImpactG >= 2.5) phases.add('impact');
    phases.add('settling');
    return phases.join(' → ');
  }
}

class CrashAnalysisService {
  const CrashAnalysisService._();

  static const double freeFallThresholdG = 0.45;
  static const double impactThresholdG = 2.5;
  static const double rotationThresholdDps = 220;
  static const Duration phaseWindow = Duration(seconds: 12);
  static const Duration eventCooldown = Duration(seconds: 30);

  static List<CrashEventAnalysis> analyze(List<Map<String, dynamic>> rows) {
    final samples =
        rows.map(_CrashSample.fromJson).whereType<_CrashSample>().toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    if (samples.isEmpty) return const [];

    final events = <CrashEventAnalysis>[];
    var cluster = <_CrashSample>[];

    void finishCluster() {
      if (cluster.isEmpty) return;
      final peakImpact = cluster.map((s) => s.impactG).reduce(math.max);
      final peakRotation = cluster.map((s) => s.rotationDps).reduce(math.max);
      final hadFreeFall = cluster.any((s) => s.impactG <= freeFallThresholdG);
      final hasImpact = peakImpact >= impactThresholdG;
      final hasRotation = peakRotation >= rotationThresholdDps;
      // A confirmed event needs multiple crash phases, or an exceptionally
      // violent rotation. This catches real falls without treating every
      // pothole or sensor vibration as a crash.
      final confirmed =
          (hasImpact && (hasRotation || hadFreeFall)) || peakRotation >= 300;
      if (confirmed) {
        final strongest = cluster.reduce((a, b) {
          final aScore = a.impactG + a.rotationDps / 100;
          final bScore = b.impactG + b.rotationDps / 100;
          return aScore >= bScore ? a : b;
        });
        final event = CrashEventAnalysis(
          id: 'crash-${strongest.id}',
          detectedAt: strongest.recordedAt,
          peakImpactG: peakImpact,
          peakRotationDps: peakRotation,
          hadFreeFall: hadFreeFall,
          sampleCount: cluster.length,
        );
        if (events.isEmpty ||
            event.detectedAt.difference(events.last.detectedAt).abs() >=
                eventCooldown) {
          events.add(event);
        }
      }
      cluster = <_CrashSample>[];
    }

    for (final sample in samples) {
      final isPhase =
          sample.impactG <= freeFallThresholdG ||
          sample.impactG >= impactThresholdG ||
          sample.rotationDps >= 120;
      if (!isPhase) continue;
      if (cluster.isNotEmpty &&
          sample.recordedAt.difference(cluster.last.recordedAt) > phaseWindow) {
        finishCluster();
      }
      cluster.add(sample);
    }
    finishCluster();
    return events.reversed.toList();
  }
}

class _CrashSample {
  const _CrashSample({
    required this.id,
    required this.recordedAt,
    required this.impactG,
    required this.rotationDps,
  });

  final Object id;
  final DateTime recordedAt;
  final double impactG;
  final double rotationDps;

  static _CrashSample? fromJson(Map<String, dynamic> row) {
    final recordedAt = DateTime.tryParse('${row['recorded_at']}');
    if (recordedAt == null) return null;
    double number(String key) => row[key] is num
        ? (row[key] as num).toDouble()
        : double.tryParse('${row[key]}') ?? 0;
    final x = number('accel_x');
    final y = number('accel_y');
    final z = number('accel_z');
    final gx = number('gyro_x');
    final gy = number('gyro_y');
    final gz = number('gyro_z');
    return _CrashSample(
      id: row['id'] ?? recordedAt.microsecondsSinceEpoch,
      recordedAt: recordedAt,
      impactG: math.sqrt(x * x + y * y + z * z),
      rotationDps: math.sqrt(gx * gx + gy * gy + gz * gz),
    );
  }
}
