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

  @override
  String get aqiGood => 'Good';

  @override
  String get aqiFair => 'Fair';

  @override
  String get aqiModerate => 'Moderate';

  @override
  String get aqiPoor => 'Poor';

  @override
  String get aqiVeryPoor => 'Very Poor';

  @override
  String get aqiUnknown => 'Unknown';

  @override
  String get airQualityIndex => 'Air Quality Index';

  @override
  String get pollutantLevels => 'Pollutant Levels (μg/m³)';

  @override
  String appVersion(String version) {
    return 'App Version: $version';
  }

  @override
  String get chatbotPageTitle => 'AI Weather Assistant';

  @override
  String get chatbotInputHint => 'Ask about the weather…';

  @override
  String get chatbotEmptyStateGeneric =>
      'Hi! I\'m your weather assistant. Ask me about the climate, forecasts, or any weather curiosity.';

  @override
  String chatbotEmptyStateWithCity(String city) {
    return 'Hi! Ask me anything about the weather in $city, or any other place.';
  }

  @override
  String get chatbotQuotaExceeded => 'Daily limit reached. Try again tomorrow.';

  @override
  String chatbotQuotaExceededDetail(int limit) {
    return 'You\'ve used your $limit free messages for today. Come back tomorrow — paid tier coming soon.';
  }

  @override
  String chatbotQuotaResetAt(String time) {
    return 'Resets at $time';
  }

  @override
  String get chatbotError =>
      'Couldn\'t reach the assistant. Tap send to retry.';

  @override
  String get weatherDiscussion => 'Discussion';

  @override
  String get discussionFeedTitle => 'Weather Discussion';

  @override
  String get discussionPostTitle => 'Post';

  @override
  String get discussionAddPost => 'Add post';

  @override
  String get discussionSearchCityFirst => 'Search a city first to post';

  @override
  String get discussionNoPostsYet => 'No posts yet. Be the first to share!';

  @override
  String get discussionNoCommentsYet =>
      'No comments yet. Start the conversation.';

  @override
  String get discussionRetry => 'Retry';

  @override
  String get discussionPostedOn => 'Posted:';

  @override
  String discussionByAuthor(String name) {
    return 'By $name';
  }

  @override
  String get discussionCreatePostTitle => 'Share an update';

  @override
  String discussionCreatePostUnder(String city) {
    return 'Posting under $city';
  }

  @override
  String get discussionTitleLabel => 'Title';

  @override
  String get discussionImageUrlLabel => 'Image URL (optional)';

  @override
  String get discussionDescriptionLabel => 'Description';

  @override
  String get discussionSubmitPost => 'Post';

  @override
  String get discussionAddComment => 'Add a comment';

  @override
  String get discussionDeletePostTitle => 'Delete post?';

  @override
  String get discussionDeletePostBody =>
      'This will permanently remove the post and all its comments.';

  @override
  String get discussionDeleteCommentTitle => 'Delete comment?';

  @override
  String get discussionDeleteCommentBody =>
      'This will permanently remove the comment.';

  @override
  String get discussionCancel => 'Cancel';

  @override
  String get discussionDelete => 'Delete';

  @override
  String get eventStorm => 'Storm';

  @override
  String get eventFlood => 'Flood';

  @override
  String get eventHeatwave => 'Heatwave';

  @override
  String get eventDrought => 'Drought';

  @override
  String get eventWildfire => 'Wildfire';

  @override
  String get eventTornado => 'Tornado';

  @override
  String get newsPageTitle => 'News';

  @override
  String get newsTabWeather => 'Weather';

  @override
  String get newsTabGeneral => 'General';

  @override
  String get newsTabTravel => 'Travel';

  @override
  String get newsNoArticles => 'No articles found.';

  @override
  String get newsError => 'Couldn\'t load news. Pull down to retry.';

  @override
  String get newsRetry => 'Retry';

  @override
  String get newsErrorOpening => 'Couldn\'t open the article.';
}
