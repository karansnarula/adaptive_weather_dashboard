sealed class SettingsEvent {
  const SettingsEvent();
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ChangeLanguage extends SettingsEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);
}

class ChangeUnit extends SettingsEvent {
  final bool isCelsius;

  const ChangeUnit(this.isCelsius);
}