import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class TelemetryGauge extends StatelessWidget {
  const TelemetryGauge({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.unit,
    this.color = AppColors.primary,
    this.size = 140,
  });

  final double value;
  final double min;
  final double max;
  final String label;
  final String unit;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(min, max);
    final fraction = (clamped - min) / (max - min);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GaugePainter(fraction: fraction, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                clamped.toStringAsFixed(clamped < 10 ? 1 : 0),
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: size * 0.1,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: size * 0.09,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.fraction, required this.color});
  final double fraction;
  final Color color;

  static const _startAngle = math.pi * 0.75;
  static const _sweepTotal = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final strokeWidth = size.width * 0.08;

    final trackPaint = Paint()
      ..color = AppColors.outline
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      _sweepTotal,
      false,
      trackPaint,
    );

    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _startAngle,
        _sweepTotal * fraction,
        false,
        valuePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.fraction != fraction;
}
