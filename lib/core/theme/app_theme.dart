import 'package:flutter/material.dart';

abstract class AppTheme {
  /// Material defaults left-align AppBar titles on Android while Cupertino
  /// centres them on iOS. We force centred on every platform so the app
  /// looks identical regardless of the device.
  static const AppBarTheme _appBarTheme = AppBarTheme(centerTitle: true);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: _appBarTheme,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
    appBarTheme: _appBarTheme,
  );
}
