enum Environment { dev, stg, prod }

class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final String apiKey;
  final String mapsApiKey;
  final String geminiApiUrl;
  final String geminiApiKey;
  final String newsApiUrl;
  final String newsApiKey;

  const AppConfig._({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.mapsApiKey,
    required this.geminiApiUrl,
    required this.geminiApiKey,
    required this.newsApiUrl,
    required this.newsApiKey,
  });

  static late final AppConfig instance;

  static void initialize() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    const appName = String.fromEnvironment('APP_NAME', defaultValue: 'Weather Dashboard');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const apiKey = String.fromEnvironment('API_KEY');
    const mapsApiKey = String.fromEnvironment('MAPS_API_KEY');
    const geminiApiUrl = String.fromEnvironment(
      'GEMINI_API_URL',
      defaultValue: 'https://generativelanguage.googleapis.com/v1beta/',
    );
    const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
    const newsApiUrl = String.fromEnvironment(
      'NEWS_API_URL',
      defaultValue: 'https://newsapi.org/v2/',
    );
    const newsApiKey = String.fromEnvironment('NEWS_API_KEY');

    instance = AppConfig._(
      environment: Environment.values.byName(env),
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      apiKey: apiKey,
      mapsApiKey: mapsApiKey,
      geminiApiUrl: geminiApiUrl,
      geminiApiKey: geminiApiKey,
      newsApiUrl: newsApiUrl,
      newsApiKey: newsApiKey,
    );
  }

  bool get isDev => environment == Environment.dev;
  bool get isStg => environment == Environment.stg;
  bool get isProd => environment == Environment.prod;
  bool get isDebugMode => !isProd;
}
