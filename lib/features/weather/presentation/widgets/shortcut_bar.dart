import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../discussion/presentation/bloc/unread/discussion_unread_bloc.dart';
import '../../../discussion/presentation/bloc/unread/discussion_unread_state.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';

class ShortcutBar extends StatelessWidget {
  const ShortcutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final loadedState = state is WeatherLoaded ? state : null;
        final isSearched = loadedState != null;
        final cityName = loadedState?.weather.cityName ?? '';
        final lat = loadedState?.weather.latitude ?? 0;
        final lon = loadedState?.weather.longitude ?? 0;

        final shortcuts = <Widget>[
          _ShortcutItem(
            icon: Icons.smart_toy_outlined,
            label: context.l10n.chatbot,
            enabled: true,
            onTap: () => context.push(
              AppRoutes.chatbotFor(city: isSearched ? cityName : null),
            ),
          ),
          _ShortcutItem(
            icon: Icons.newspaper_outlined,
            label: context.l10n.weatherNews,
            enabled: isSearched,
            onTap: () {
              if (kIsWeb) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(context.l10n.newsNotAvailableOnWeb),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ));
                return;
              }
              context.push(AppRoutes.news(cityName));
            },
          ),
          _ShortcutItem(
            icon: Icons.air,
            label: context.l10n.airQuality,
            enabled: isSearched,
            onTap: () => context.push(
              AppRoutes.airQuality(city: cityName, lat: lat, lon: lon),
            ),
          ),
          BlocSelector<DiscussionUnreadBloc, DiscussionUnreadState, int>(
            selector: (state) => state.count,
            builder: (context, unreadCount) {
              return _ShortcutItem(
                icon: Icons.forum_outlined,
                label: context.l10n.weatherDiscussion,
                enabled: isSearched,
                badgeCount: unreadCount,
                onTap: () =>
                    context.push(AppRoutes.discussionFor(city: cityName)),
              );
            },
          ),
          _ShortcutItem(
            icon: Icons.grass_outlined,
            label: context.l10n.pollenAllergy,
            enabled: isSearched,
            onTap: () => _showComingSoon(context),
          ),
        ];

        return ResponsiveBuilder(
          mobile: (_) => _ScrollableRow(items: shortcuts),
          tablet: (_) => _SpreadRow(items: shortcuts),
          desktop: (_) => _SpreadRow(items: shortcuts),
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    CustomDialog.show(
      context,
      icon: Icons.rocket_launch,
      iconColor: Colors.orange,
      title: context.l10n.comingSoon,
      message: context.l10n.comingSoonMessage,
      buttonText: context.l10n.ok,
    );
  }
}

class _ScrollableRow extends StatelessWidget {
  final List<Widget> items;

  const _ScrollableRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimens.spaceLg),
            items[i],
          ],
        ],
      ),
    );
  }
}

class _SpreadRow extends StatelessWidget {
  final List<Widget> items;

  const _SpreadRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space2xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final int badgeCount;

  const _ShortcutItem({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.badgeCount = 0,
  });

  Widget _wrapWithBadge(Widget child) {
    if (badgeCount <= 0 || !enabled) return child;
    final label = badgeCount > 9 ? '9+' : '$badgeCount';
    return Badge(
      label: Text(label),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Column(
          children: [
            _wrapWithBadge(
              Container(
                width: AppDimens.iconButtonSize,
                height: AppDimens.iconButtonSize,
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
            ),
            const SizedBox(height: AppDimens.spaceXs),
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
