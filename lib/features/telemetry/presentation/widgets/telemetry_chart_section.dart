import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/sr_card.dart';
import '../../../../../core/widgets/sr_skeleton.dart';
import '../../../../../shared/components/chart_header.dart';
import '../../domain/entities/telemetry_entity.dart';
import '../providers/telemetry_provider.dart';

class TelemetryChartSection extends ConsumerStatefulWidget {
  const TelemetryChartSection({super.key});

  @override
  ConsumerState<TelemetryChartSection> createState() =>
      _TelemetryChartSectionState();
}

class _TelemetryChartSectionState extends ConsumerState<TelemetryChartSection> {
  ChartRange _range = ChartRange.day;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(telemetryHistoryProvider);

    return SrCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartHeader(
            title: 'Battery History',
            selectedRange: _range,
            onRangeChanged: (r) => setState(() => _range = r),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 180,
            child: historyAsync.when(
              loading: () => const SkeletonPulse(
                child: SkeletonBox(height: 200, radius: 12),
              ),
              error: (_, __) => const Center(child: Text('No data available')),
              data: (history) => history.isEmpty
                  ? const Center(child: Text('No history yet'))
                  : _BatteryChart(history: _filtered(history)),
            ),
          ),
        ],
      ),
    );
  }

  List<TelemetryEntity> _filtered(List<TelemetryEntity> all) {
    final now = DateTime.now();
    final cutoff = switch (_range) {
      ChartRange.day => now.subtract(const Duration(hours: 24)),
      ChartRange.week => now.subtract(const Duration(days: 7)),
      ChartRange.month => now.subtract(const Duration(days: 30)),
    };
    return all.where((t) => t.timestamp.isAfter(cutoff)).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

class _BatteryChart extends StatelessWidget {
  const _BatteryChart({required this.history});
  final List<TelemetryEntity> history;

  @override
  Widget build(BuildContext context) {
    final spots = history.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.batteryPercentage);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppColors.outline, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 25,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}%',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
