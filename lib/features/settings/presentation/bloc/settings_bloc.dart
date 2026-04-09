import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;

  static const _languageKey = 'language_code';
  static const _unitKey = 'is_celsius';

  SettingsBloc(this._prefs) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeUnit>(_onChangeUnit);
  }

  void _onLoadSettings(
      LoadSettings event,
      Emitter<SettingsState> emit,
      ) {
    final languageCode = _prefs.getString(_languageKey) ?? 'en';
    final isCelsius = _prefs.getBool(_unitKey) ?? true;

    emit(SettingsState(
      languageCode: languageCode,
      isCelsius: isCelsius,
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
}