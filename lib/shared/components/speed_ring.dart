import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SpeedRing extends StatelessWidget {
  const SpeedRing({
    super.key,
    required this.speedKmh,
    this.maxSpeed = 60.0,
    this.size = 200,
  });

  final double speedKmh;
  final double maxSpeed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fraction = (speedKmh / maxSpeed).clamp(0.0, 1.0);
    final color = fraction >= 0.85
        ? AppColors.error
        : fraction >= 0.6
            ? AppColors.warning
            : AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _SpeedPainter(fraction: fraction, color: color),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                speedKmh.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -2,
                ),
              ),
              Text(
                'km/h',
                style: TextStyle(
                  fontSize: size * 0.1,
                  fontWeight: FontWeight.w500,
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

class _SpeedPainter extends CustomPainter {
  const _SpeedPainter({required this.fraction, required this.color});
  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.46;
    final innerRadius = size.width * 0.36;

    // Tick marks
    const totalTicks = 30;
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i <= totalTicks; i++) {
      final tickFraction = i / totalTicks;
      final angle = math.pi * 0.75 + tickFraction * math.pi * 1.5;
      final isActive = tickFraction <= fraction;
      tickPaint
        ..color = isActive ? color : AppColors.outline
        ..strokeWidth = i % 5 == 0 ? 3 : 1.5;

      final r1 = i % 5 == 0 ? innerRadius - 4 : innerRadius;
      final start = Offset(
        center.dx + r1 * math.cos(angle),
        center.dy + r1 * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Needle dot
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(center, size.width * 0.04, dotPaint);
  }

  @override
  bool shouldRepaint(_SpeedPainter old) => old.fraction != fraction;
}
