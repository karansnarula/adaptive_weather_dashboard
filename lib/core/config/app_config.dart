enum Environment { dev, stg, prod }

class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final String apiKey;
  final String mapsApiKey;

  const AppConfig._({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.mapsApiKey,
  });

  static late final AppConfig instance;

  static void initialize() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    const appName = String.fromEnvironment('APP_NAME', defaultValue: 'Weather Dashboard');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const apiKey = String.fromEnvironment('API_KEY');
    const mapsApiKey = String.fromEnvironment('MAPS_API_KEY');

    instance = AppConfig._(
      environment: Environment.values.byName(env),
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      apiKey: apiKey,
      mapsApiKey: mapsApiKey,
    );
  }

  bool get isDev => environment == Environment.dev;
  bool get isStg => environment == Environment.stg;
  bool get isProd => environment == Environment.prod;
  bool get isDebugMode => !isProd;
}