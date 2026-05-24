import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';

class ShortcutBar extends StatelessWidget {
  const ShortcutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final isSearched = state is WeatherLoaded;
        final cityName = isSearched ? state.weather.cityName : '';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ShortcutItem(
              icon: Icons.smart_toy_outlined,
              label: context.l10n.chatbot,
              enabled: true,
              onTap: () => context.push('/chatbot'),
            ),
            _ShortcutItem(
              icon: Icons.newspaper_outlined,
              label: context.l10n.weatherNews,
              enabled: isSearched,
              onTap: () => context.push('/news/$cityName'),
            ),
            _ShortcutItem(
              icon: Icons.air,
              label: context.l10n.airQuality,
              enabled: isSearched,
              onTap: () => context.push('/air-quality/$cityName'),
            ),
            _ShortcutItem(
              icon: Icons.grass_outlined,
              label: context.l10n.pollenAllergy,
              enabled: isSearched,
              onTap: () => _showComingSoon(context),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.comingSoon),
        content: Text(context.l10n.comingSoonMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: enabled
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: enabled
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}