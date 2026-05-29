import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../di/injection.dart';
import '../../data/air_quality_service.dart';
import '../../domain/entities/air_quality.dart';

class AirQualityPage extends StatefulWidget {
  final String cityName;
  final double latitude;
  final double longitude;

  const AirQualityPage({
    super.key,
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<AirQualityPage> createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  late Future<AirQuality> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<AirQualityService>().getAirQuality(
      widget.latitude,
      widget.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cityName} ${context.l10n.airQuality}'),
      ),
      body: FutureBuilder<AirQuality>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                context.l10n.errorGeneric,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          final airQuality = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              children: [
                _AqiIndicator(airQuality: airQuality),
                const SizedBox(height: AppDimens.space2xl),
                _PollutantChart(airQuality: airQuality),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AqiIndicator extends StatelessWidget {
  final AirQuality airQuality;

  const _AqiIndicator({required this.airQuality});

  Color get _aqiColor => switch (airQuality.aqi) {
    1 => Colors.green,
    2 => Colors.lightGreen,
    3 => Colors.orange,
    4 => Colors.deepOrange,
    5 => Colors.red,
    _ => Colors.grey,
  };

  String _aqiLabel(BuildContext context) => switch (airQuality.aqi) {
    1 => context.l10n.aqiGood,
    2 => context.l10n.aqiFair,
    3 => context.l10n.aqiModerate,
    4 => context.l10n.aqiPoor,
    5 => context.l10n.aqiVeryPoor,
    _ => context.l10n.aqiUnknown,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space2xl),
        child: Column(
          children: [
            Text(
              context.l10n.airQualityIndex,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Container(
              width: AppDimens.imageHeightSm,
              height: AppDimens.imageHeightSm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _aqiColor.withValues(alpha: 0.15),
                border: Border.all(color: _aqiColor, width: AppDimens.borderThick),
              ),
              child: Center(
                child: Text(
                  '${airQuality.aqi}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _aqiColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              _aqiLabel(context),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _aqiColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PollutantChart extends StatelessWidget {
  final AirQuality airQuality;

  const _PollutantChart({required this.airQuality});

  @override
  Widget build(BuildContext context) {
    final pollutants = [
      _PollutantData('CO', airQuality.co),
      _PollutantData('NO₂', airQuality.no2),
      _PollutantData('O₃', airQuality.o3),
      _PollutantData('SO₂', airQuality.so2),
      _PollutantData('PM2.5', airQuality.pm25),
      _PollutantData('PM10', airQuality.pm10),
    ];

    final maxValue = pollutants
        .map((p) => p.value)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space2xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.pollutantLevels,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.space2xl),
            SizedBox(
              height: AppDimens.imageHeightLg,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${pollutants[groupIndex].name}\n${rod.toY.toStringAsFixed(1)} μg/m³',
                          TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: AppDimens.chartAxisReservedSize,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= pollutants.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                            child: Text(
                              pollutants[index].name,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxValue / 4,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        strokeWidth: AppDimens.borderThin,
                      );
                    },
                  ),
                  barGroups: List.generate(pollutants.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: pollutants[index].value,
                          color: _getBarColor(pollutants[index].value, maxValue),
                          width: AppDimens.chartBarWidth,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppDimens.radiusXs),
                            topRight: Radius.circular(AppDimens.radiusXs),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBarColor(double value, double maxValue) {
    final ratio = value / maxValue;
    if (ratio < 0.25) return Colors.green;
    if (ratio < 0.5) return Colors.lightGreen;
    if (ratio < 0.75) return Colors.orange;
    return Colors.red;
  }
}

class _PollutantData {
  final String name;
  final double value;

  const _PollutantData(this.name, this.value);
}