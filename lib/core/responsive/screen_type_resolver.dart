import 'app_breakpoints.dart';

class ScreenTypeResolver {
  static ScreenType resolve(double width) {
    if (width >= AppBreakpoints.desktop) return ScreenType.desktop;
    if (width >= AppBreakpoints.tablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }
}