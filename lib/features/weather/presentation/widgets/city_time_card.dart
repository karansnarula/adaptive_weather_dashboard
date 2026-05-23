import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive_value.dart';
import '../../domain/entities/weather.dart';

class CityTimeCard extends StatelessWidget {
  final Weather weather;

  const CityTimeCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final cityTime = DateTime.now().toUtc().add(
      Duration(seconds: weather.timezoneOffset),
    );

    final locale = Localizations.localeOf(context).languageCode;
    final timeString = DateFormat.Hm(locale).format(cityTime);
    final dateString = DateFormat.yMMMd(locale).format(cityTime);

    final monday = cityTime.subtract(Duration(days: cityTime.weekday - 1));
    final days = List.generate(7, (index) {
      final day = monday.add(Duration(days: index));
      return DateFormat.E(locale).format(day);
    });

    final currentDayIndex = cityTime.weekday - 1;

    final circleSize = ResponsiveValue<double>(
      context,
      mobile: 36,
      tablet: 40,
      desktop: 44,
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      mobile: 10,
      tablet: 11,
      desktop: 12,
    ).value;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  timeString,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  dateString,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final isCurrentDay = index == currentDayIndex;
                return Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: isCurrentDay ? Colors.teal : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      days[index],
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: isCurrentDay
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrentDay
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}