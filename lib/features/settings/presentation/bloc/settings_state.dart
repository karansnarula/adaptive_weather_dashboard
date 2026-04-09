import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String languageCode;
  final bool isCelsius;

  const SettingsState({
    this.languageCode = 'en',
    this.isCelsius = true,
  });

  SettingsState copyWith({
    String? languageCode,
    bool? isCelsius,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      isCelsius: isCelsius ?? this.isCelsius,
    );
  }

  @override
  List<Object> get props => [languageCode, isCelsius];
}