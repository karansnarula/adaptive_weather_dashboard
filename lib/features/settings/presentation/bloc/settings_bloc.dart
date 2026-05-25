import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;

  static const _languageKey = 'language_code';
  static const _unitKey = 'is_celsius';
  static const _themeKey = 'theme_mode';

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeUnit>(_onChangeUnit);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadSettings(
      LoadSettings event,
      Emitter<SettingsState> emit,
      ) async {
    final languageCode = _prefs.getString(_languageKey) ?? 'en';
    final isCelsius = _prefs.getBool(_unitKey) ?? true;
    final themeMode = _prefs.getString(_themeKey) ?? 'system';
    final packageInfo = await PackageInfo.fromPlatform();

    emit(SettingsState(
      languageCode: languageCode,
      isCelsius: isCelsius,
      themeMode: themeMode,
      appVersion: packageInfo.version,
    ));
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event,
      Emitter<SettingsState> emit,
      ) async {
    await _prefs.setString(_languageKey, event.languageCode);
    emit(state.copyWith(languageCode: event.languageCode));
  }

  Future<void> _onChangeUnit(
      ChangeUnit event,
      Emitter<SettingsState> emit,
      ) async {
    await _prefs.setBool(_unitKey, event.isCelsius);
    emit(state.copyWith(isCelsius: event.isCelsius));
  }

  Future<void> _onChangeTheme(
      ChangeTheme event,
      Emitter<SettingsState> emit,
      ) async {
    await _prefs.setString(_themeKey, event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }
}