// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather Dashboard';

  @override
  String get navWeather => 'Weather';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navSettings => 'Settings';

  @override
  String get searchCity => 'Search city...';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String feelsLike(String temp) {
    return 'Feels like $temp°';
  }

  @override
  String get forecast => '5-Day Forecast';

  @override
  String get favorites => 'Favorite Cities';

  @override
  String get noFavorites => 'No favorite cities yet';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get units => 'Units';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNoInternet => 'No internet connection.';

  @override
  String get errorCityNotFound => 'City not found. Please try another search.';

  @override
  String get searchPrompt => 'Search for a city to see the weather';

  @override
  String get feelsLikeLabel => 'Feels like';

  @override
  String get fiveDayForecast => '5-Day Forecast';

  @override
  String get tapToViewWeather => 'Tap to view weather';

  @override
  String get noFavoritesSubtitle =>
      'Search for a city and tap the heart to save it';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get switchToFahrenheit => 'Switch to Fahrenheit';

  @override
  String get switchToCelsius => 'Switch to Celsius';

  @override
  String get authErrorEmailInUse =>
      'An account already exists with this email.';

  @override
  String get authErrorInvalidEmail => 'Invalid email address.';

  @override
  String get authErrorWeakPassword =>
      'Password is too weak. Use at least 6 characters.';

  @override
  String get authErrorUserNotFound => 'No account found with this email.';

  @override
  String get authErrorWrongPassword => 'Incorrect password.';

  @override
  String get authErrorInvalidCredential => 'Invalid email or password.';

  @override
  String get authErrorGeneric =>
      'An unexpected error occurred. Please try again.';

  @override
  String get logout => 'Logout';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemMode => 'System Default';

  @override
  String get dailyWeatherNotification => 'Daily Weather Notification';

  @override
  String get dailyWeatherUpdates => 'You will receive daily weather updates';

  @override
  String get noNotificationCity => 'No notification city set';

  @override
  String get notificationHint =>
      'Tap the bell icon on a weather card to enable';

  @override
  String get mapUnavailable => 'Map unavailable';

  @override
  String get chatbot => 'Chatbot';

  @override
  String get weatherNews => 'News';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get pollenAllergy => 'Pollen';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get comingSoonMessage =>
      'This feature will be available in a future update.';

  @override
  String get ok => 'OK';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name!';
  }
}
