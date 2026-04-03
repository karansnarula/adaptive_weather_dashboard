import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'screen_type_resolver.dart';

/// A layout builder that renders the appropriate widget based on screen size.
///
/// [mobile] is required. [tablet] and [desktop] are optional and fall back
/// to the next smaller layout if not provided.
///
/// Only the active layout is built — the others are never constructed.
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context) => MobileWeatherLayout(),
///   tablet: (context) => TabletWeatherLayout(),
///   desktop: (context) => DesktopWeatherLayout(),
/// )
/// ```

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final screenType = ScreenTypeResolver.resolve(width);

    return switch (screenType) {
      ScreenType.desktop => (desktop ?? tablet ?? mobile)(context),
      ScreenType.tablet => (tablet ?? mobile)(context),
      ScreenType.mobile => mobile(context),
    };
  }
}