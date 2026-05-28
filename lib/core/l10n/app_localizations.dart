import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather Dashboard'**
  String get appTitle;

  /// No description provided for @navWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get navWeather;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get searchCity;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}°'**
  String feelsLike(String temp);

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'5-Day Forecast'**
  String get forecast;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite Cities'**
  String get favorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite cities yet'**
  String get noFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNoInternet;

  /// No description provided for @errorCityNotFound.
  ///
  /// In en, this message translates to:
  /// **'City not found. Please try another search.'**
  String get errorCityNotFound;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for a city to see the weather'**
  String get searchPrompt;

  /// No description provided for @feelsLikeLabel.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLikeLabel;

  /// No description provided for @fiveDayForecast.
  ///
  /// In en, this message translates to:
  /// **'5-Day Forecast'**
  String get fiveDayForecast;

  /// No description provided for @tapToViewWeather.
  ///
  /// In en, this message translates to:
  /// **'Tap to view weather'**
  String get tapToViewWeather;

  /// No description provided for @noFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for a city and tap the heart to save it'**
  String get noFavoritesSubtitle;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @switchToFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Switch to Fahrenheit'**
  String get switchToFahrenheit;

  /// No description provided for @switchToCelsius.
  ///
  /// In en, this message translates to:
  /// **'Switch to Celsius'**
  String get switchToCelsius;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authErrorGeneric;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemMode;

  /// No description provided for @dailyWeatherNotification.
  ///
  /// In en, this message translates to:
  /// **'Daily Weather Notification'**
  String get dailyWeatherNotification;

  /// No description provided for @dailyWeatherUpdates.
  ///
  /// In en, this message translates to:
  /// **'You will receive daily weather updates'**
  String get dailyWeatherUpdates;

  /// No description provided for @noNotificationCity.
  ///
  /// In en, this message translates to:
  /// **'No notification city set'**
  String get noNotificationCity;

  /// No description provided for @notificationHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the bell icon on a weather card to enable'**
  String get notificationHint;

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Map unavailable'**
  String get mapUnavailable;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbot;

  /// No description provided for @weatherNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get weatherNews;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// No description provided for @pollenAllergy.
  ///
  /// In en, this message translates to:
  /// **'Pollen'**
  String get pollenAllergy;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available in a future update.'**
  String get comingSoonMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// No description provided for @aqiGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get aqiGood;

  /// No description provided for @aqiFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get aqiFair;

  /// No description provided for @aqiModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get aqiModerate;

  /// No description provided for @aqiPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get aqiPoor;

  /// No description provided for @aqiVeryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get aqiVeryPoor;

  /// No description provided for @aqiUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get aqiUnknown;

  /// No description provided for @airQualityIndex.
  ///
  /// In en, this message translates to:
  /// **'Air Quality Index'**
  String get airQualityIndex;

  /// No description provided for @pollutantLevels.
  ///
  /// In en, this message translates to:
  /// **'Pollutant Levels (μg/m³)'**
  String get pollutantLevels;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version: {version}'**
  String appVersion(String version);

  /// No description provided for @chatbotPageTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Weather Assistant'**
  String get chatbotPageTitle;

  /// No description provided for @chatbotInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about the weather…'**
  String get chatbotInputHint;

  /// No description provided for @chatbotEmptyStateGeneric.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m your weather assistant. Ask me about the climate, forecasts, or any weather curiosity.'**
  String get chatbotEmptyStateGeneric;

  /// No description provided for @chatbotEmptyStateWithCity.
  ///
  /// In en, this message translates to:
  /// **'Hi! Ask me anything about the weather in {city}, or any other place.'**
  String chatbotEmptyStateWithCity(String city);

  /// No description provided for @chatbotQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached. Try again tomorrow.'**
  String get chatbotQuotaExceeded;

  /// No description provided for @chatbotQuotaExceededDetail.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used your {limit} free messages for today. Come back tomorrow — paid tier coming soon.'**
  String chatbotQuotaExceededDetail(int limit);

  /// No description provided for @chatbotQuotaResetAt.
  ///
  /// In en, this message translates to:
  /// **'Resets at {time}'**
  String chatbotQuotaResetAt(String time);

  /// No description provided for @chatbotError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the assistant. Tap send to retry.'**
  String get chatbotError;

  /// No description provided for @weatherDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get weatherDiscussion;

  /// No description provided for @discussionFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather Discussion'**
  String get discussionFeedTitle;

  /// No description provided for @discussionPostTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get discussionPostTitle;

  /// No description provided for @discussionAddPost.
  ///
  /// In en, this message translates to:
  /// **'Add post'**
  String get discussionAddPost;

  /// No description provided for @discussionSearchCityFirst.
  ///
  /// In en, this message translates to:
  /// **'Search a city first to post'**
  String get discussionSearchCityFirst;

  /// No description provided for @discussionNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Be the first to share!'**
  String get discussionNoPostsYet;

  /// No description provided for @discussionNoCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Start the conversation.'**
  String get discussionNoCommentsYet;

  /// No description provided for @discussionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get discussionRetry;

  /// No description provided for @discussionPostedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted:'**
  String get discussionPostedOn;

  /// No description provided for @discussionByAuthor.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String discussionByAuthor(String name);

  /// No description provided for @discussionCreatePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Share an update'**
  String get discussionCreatePostTitle;

  /// No description provided for @discussionCreatePostUnder.
  ///
  /// In en, this message translates to:
  /// **'Posting under {city}'**
  String discussionCreatePostUnder(String city);

  /// No description provided for @discussionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get discussionTitleLabel;

  /// No description provided for @discussionImageUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL (optional)'**
  String get discussionImageUrlLabel;

  /// No description provided for @discussionDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get discussionDescriptionLabel;

  /// No description provided for @discussionSubmitPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get discussionSubmitPost;

  /// No description provided for @discussionAddComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment'**
  String get discussionAddComment;

  /// No description provided for @discussionDeletePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete post?'**
  String get discussionDeletePostTitle;

  /// No description provided for @discussionDeletePostBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the post and all its comments.'**
  String get discussionDeletePostBody;

  /// No description provided for @discussionDeleteCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete comment?'**
  String get discussionDeleteCommentTitle;

  /// No description provided for @discussionDeleteCommentBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the comment.'**
  String get discussionDeleteCommentBody;

  /// No description provided for @discussionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get discussionCancel;

  /// No description provided for @discussionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get discussionDelete;

  /// No description provided for @eventStorm.
  ///
  /// In en, this message translates to:
  /// **'Storm'**
  String get eventStorm;

  /// No description provided for @eventFlood.
  ///
  /// In en, this message translates to:
  /// **'Flood'**
  String get eventFlood;

  /// No description provided for @eventHeatwave.
  ///
  /// In en, this message translates to:
  /// **'Heatwave'**
  String get eventHeatwave;

  /// No description provided for @eventDrought.
  ///
  /// In en, this message translates to:
  /// **'Drought'**
  String get eventDrought;

  /// No description provided for @eventWildfire.
  ///
  /// In en, this message translates to:
  /// **'Wildfire'**
  String get eventWildfire;

  /// No description provided for @eventTornado.
  ///
  /// In en, this message translates to:
  /// **'Tornado'**
  String get eventTornado;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
