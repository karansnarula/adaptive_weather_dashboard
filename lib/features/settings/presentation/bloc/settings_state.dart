import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String languageCode;
  final bool isCelsius;
  final String themeMode;
  final String appVersion;

  const SettingsState({
    this.languageCode = 'en',
    this.isCelsius = true,
    this.themeMode = 'system',
    this.appVersion = '',
  });

  SettingsState copyWith({
    String? languageCode,
    bool? isCelsius,
    String? themeMode,
    String? appVersion,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      isCelsius: isCelsius ?? this.isCelsius,
      themeMode: themeMode ?? this.themeMode,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object> get props => [languageCode, isCelsius, themeMode, appVersion];
}