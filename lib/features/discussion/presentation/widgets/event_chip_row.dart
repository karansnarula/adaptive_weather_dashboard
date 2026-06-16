import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/weather_event_type.dart';

/// Horizontal-scrolling row of weather-event-type chips. Tapping one
/// fires [onTap] which the parent uses to populate the title and stamp
/// the structured eventType on the post.
class EventChipRow extends StatelessWidget {
  final WeatherEventType? selected;
  final ValueChanged<WeatherEventType> onTap;

  const EventChipRow({
    super.key,
    required this.selected,
    required this.onTap,
  });

  String _labelFor(BuildContext context, WeatherEventType type) {
    final l10n = context.l10n;
    return switch (type) {
      WeatherEventType.storm => l10n.eventStorm,
      WeatherEventType.flood => l10n.eventFlood,
      WeatherEventType.heatwave => l10n.eventHeatwave,
      WeatherEventType.drought => l10n.eventDrought,
      WeatherEventType.wildfire => l10n.eventWildfire,
      WeatherEventType.tornado => l10n.eventTornado,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      child: Row(
        children: [
          for (final t in WeatherEventType.values) ...[
            ChoiceChip(
              label: Text(_labelFor(context, t)),
              selected: selected == t,
              onSelected: (_) => onTap(t),
            ),
            const SizedBox(width: AppDimens.spaceSm),
          ],
        ],
      ),
    );
  }
}
