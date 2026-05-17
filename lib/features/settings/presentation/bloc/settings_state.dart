import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String languageCode;
  final bool isCelsius;
  final String themeMode;

  const SettingsState({
    this.languageCode = 'en',
    this.isCelsius = true,
    this.themeMode = 'system',
  });

  SettingsState copyWith({
    String? languageCode,
    bool? isCelsius,
    String? themeMode,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      isCelsius: isCelsius ?? this.isCelsius,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [languageCode, isCelsius, themeMode];
}