import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'screen_type_resolver.dart';

/// Returns a responsive value of type [T] based on the current screen size.
///
/// Same fallback logic as [ResponsiveBuilder] — if a value isn't provided
/// for the current screen type, it falls back to the next smaller one.
///
/// Usage:
/// ```dart
/// final padding = ResponsiveValue<double>(
///   context,
///   mobile: 16,
///   tablet: 24,
///   desktop: 32,
/// ).value;
/// ```

class ResponsiveValue<T> {
  final BuildContext context;
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue(
      this.context, {
        required this.mobile,
        this.tablet,
        this.desktop,
      });

  T get value {
    final width = MediaQuery.sizeOf(context).width;
    final screenType = ScreenTypeResolver.resolve(width);

    return switch (screenType) {
      ScreenType.desktop => desktop ?? tablet ?? mobile,
      ScreenType.tablet => tablet ?? mobile,
      ScreenType.mobile => mobile,
    };
  }
}