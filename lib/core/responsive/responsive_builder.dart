import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'screen_type_resolver.dart';

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