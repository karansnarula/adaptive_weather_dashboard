import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive_builder.dart';
import '../constants/app_dimens.dart';

/// The app shell that adapts its navigation pattern based on screen size:
/// - Mobile: Bottom navigation bar
/// - Tablet: Navigation rail (slim side bar)
/// - Desktop: Full side navigation drawer
///
/// Feature screens plug into the [body] — they don't manage navigation.
class AdaptiveScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;

  const AdaptiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      // ── MOBILE: Bottom navigation ──
      mobile: (context) => Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      ),

      // ── TABLET: Navigation rail ──
      tablet: (context) => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: destinations
                  .map((d) => NavigationRailDestination(
                icon: d.icon,
                selectedIcon: d.selectedIcon,
                label: Text(d.label),
              ))
                  .toList(),
            ),
            const VerticalDivider(width: AppDimens.borderThin, thickness: AppDimens.borderThin),
            Expanded(child: body),
          ],
        ),
      ),

      // ── DESKTOP: Persistent side drawer ──
      desktop: (context) => Scaffold(
        body: Row(
          children: [
            NavigationDrawer(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              children: [
                const SizedBox(height: AppDimens.spaceLg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceLg,
                    vertical: AppDimens.spaceSm,
                  ),
                  child: Text(
                    context.l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSm),
                ...destinations.map((d) => NavigationDrawerDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon ?? d.icon,
                  label: Text(d.label),
                )),
              ],
            ),
            const VerticalDivider(width: AppDimens.borderThin, thickness: AppDimens.borderThin),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}