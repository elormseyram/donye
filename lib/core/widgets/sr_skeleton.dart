import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

// ---------------------------------------------------------------------------
// Shimmer pulse wrapper — one animation, all children share it
// ---------------------------------------------------------------------------

class SkeletonPulse extends StatefulWidget {
  const SkeletonPulse({super.key, required this.child});
  final Widget child;

  @override
  State<SkeletonPulse> createState() => SkeletonPulseState();
}

class SkeletonPulseState extends State<SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Opacity(opacity: 0.35 + 0.65 * _ctrl.value, child: child),
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// Primitive skeleton box — plain grey rectangle
// ---------------------------------------------------------------------------

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Alerts skeleton  — mimics list of alert tiles
// ---------------------------------------------------------------------------

class AlertsListSkeleton extends StatelessWidget {
  const AlertsListSkeleton({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, i) => _AlertTileSkeleton(wide: i.isEven),
      ),
    );
  }
}

class _AlertTileSkeleton extends StatelessWidget {
  const _AlertTileSkeleton({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const SkeletonCircle(size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: wide ? 140 : 100, height: 14),
                const SizedBox(height: 8),
                const SkeletonBox(height: 12),
                const SizedBox(height: 6),
                SkeletonBox(width: wide ? 180 : 140, height: 12),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const SkeletonBox(width: 48, height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Analytics skeleton  — stats grid + chart placeholder
// ---------------------------------------------------------------------------

class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SkeletonBox(width: 80, height: 18),
            const SizedBox(height: AppSpacing.sm),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
              children: const [
                _StatCardSkeleton(),
                _StatCardSkeleton(),
                _StatCardSkeleton(),
                _StatCardSkeleton(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ChartCardSkeleton(height: 180),
            const SizedBox(height: AppSpacing.md),
            const SkeletonBox(width: 100, height: 18),
            const SizedBox(height: AppSpacing.sm),
            ...[1, 2, 3].map(
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: _RideTileSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SkeletonBox(width: 32, height: 32, radius: 8),
          SizedBox(height: 8),
          SkeletonBox(width: 60, height: 20),
          SizedBox(height: 4),
          SkeletonBox(width: 80, height: 12),
        ],
      ),
    );
  }
}

class _ChartCardSkeleton extends StatelessWidget {
  const _ChartCardSkeleton({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 120, height: 16),
          const SizedBox(height: AppSpacing.md),
          SkeletonBox(height: height, radius: 12),
        ],
      ),
    );
  }
}

class _RideTileSkeleton extends StatelessWidget {
  const _RideTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 40, height: 40, radius: 8),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 130, height: 14),
                SizedBox(height: 6),
                SkeletonBox(width: 160, height: 12),
              ],
            ),
          ),
          const SkeletonBox(width: 50, height: 14),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Diagnostics skeleton  — health ring + fault list
// ---------------------------------------------------------------------------

class DiagnosticsSkeleton extends StatelessWidget {
  const DiagnosticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Health ring placeholder
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ChartCardSkeleton(height: 60),
          const SizedBox(height: AppSpacing.md),
          ...[1, 2, 3].map(
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: _FaultChipSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaultChipSkeleton extends StatelessWidget {
  const _FaultChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: const [
          SkeletonCircle(size: 12),
          SizedBox(width: AppSpacing.sm),
          SkeletonBox(width: 60, height: 12),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: SkeletonBox(height: 12)),
          SizedBox(width: AppSpacing.sm),
          SkeletonBox(width: 40, height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile skeleton — avatar + form fields
// ---------------------------------------------------------------------------

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: const [
                SkeletonCircle(size: 72),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 140, height: 18),
                      SizedBox(height: 8),
                      SkeletonBox(width: 180, height: 14),
                      SizedBox(height: 6),
                      SkeletonBox(width: 100, height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...[1, 2, 3].map(
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _FieldSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldSkeleton extends StatelessWidget {
  const _FieldSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SkeletonBox(width: 80, height: 12),
        SizedBox(height: 8),
        SkeletonBox(height: 52, radius: 10),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Telemetry skeleton — gauge placeholder + metric tiles
// ---------------------------------------------------------------------------

class TelemetrySkeleton extends StatelessWidget {
  const TelemetrySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Gauge
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Metrics row
          Row(
            children: const [
              Expanded(child: _MetricTileSkeleton()),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricTileSkeleton()),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: const [
              Expanded(child: _MetricTileSkeleton()),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricTileSkeleton()),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ChartCardSkeleton(height: 160),
        ],
      ),
    );
  }
}

class _MetricTileSkeleton extends StatelessWidget {
  const _MetricTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(width: 80, height: 12),
          SizedBox(height: 6),
          SkeletonBox(width: 60, height: 22),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Generic list skeleton — maintenance logs, ride routes, etc.
// ---------------------------------------------------------------------------

class GenericListSkeleton extends StatelessWidget {
  const GenericListSkeleton({super.key, this.count = 8});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, i) => _GenericTileSkeleton(short: i % 3 == 0),
      ),
    );
  }
}

class _GenericTileSkeleton extends StatelessWidget {
  const _GenericTileSkeleton({required this.short});
  final bool short;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 40, height: 40, radius: 8),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: short ? 100 : 150, height: 14),
                const SizedBox(height: 6),
                SkeletonBox(width: short ? 160 : 200, height: 12),
              ],
            ),
          ),
          const SkeletonBox(width: 48, height: 24, radius: 6),
        ],
      ),
    );
  }
}
