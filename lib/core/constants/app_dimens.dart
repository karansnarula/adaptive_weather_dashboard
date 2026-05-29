/// Design tokens for the app: spacing, font sizes, radii, and component
/// dimensions. Reference these instead of hardcoding numeric values in UI.
abstract final class AppDimens {
  // Font sizes
  static const double fontXs = 10;
  static const double fontXs2 = 11;
  static const double fontSm = 12;
  static const double fontMd = 14;
  static const double fontLg = 16;
  static const double fontXl = 18;
  static const double fontXxl = 20;
  static const double fontDisplaySm = 24;
  static const double fontDisplayMd = 32;

  // Spacing scale — also used for padding values
  static const double spaceXxs = 4;
  static const double spaceXs = 6;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double space2xl = 24;
  static const double space3xl = 32;
  static const double space4xl = 40;
  static const double space5xl = 48;
  static const double space6xl = 64;
  static const double space7xl = 100;

  // Padding-only values that don't fit the spacing scale
  static const double paddingInputVertical = 14;

  // Border radius
  static const double radiusXs = 6;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  // Border / stroke widths
  static const double borderThin = 1;
  static const double strokeMd = 2;
  static const double borderThick = 4;

  // Icon sizes
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLogo = 80;

  // Avatar / circle sizes
  static const double avatarSm = 36;
  static const double avatarMd = 40;
  static const double avatarLg = 44;
  static const double avatarXl = 72;
  static const double circleAvatarRadius = 22;
  static const double iconButtonSize = 48;

  // Component heights
  static const double appBarHeight = 56;
  static const double buttonHeight = 48;

  // Image / card heights
  static const double imageHeightSm = 100;
  static const double imageHeightMd = 200;
  static const double imageHeightLg = 250;

  // Chart-specific dimensions
  static const double chartAxisReservedSize = 50;
  static const double chartBarWidth = 24;

  // Layout constraints
  static const double formMaxWidth = 400;
  static const double dialogMaxWidth = 340;
  static const double contentMaxWidthSm = 600;
  static const double contentMaxWidthMd = 1000;
  static const double desktopMaxWidth = 1200;
}
