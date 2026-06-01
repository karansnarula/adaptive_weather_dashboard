abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const weather = '/weather';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const chatbot = '/chatbot';
  static const discussion = '/discussion';

  static const airQualityTemplate = '/air-quality/:city';
  static const newsTemplate = '/news/:city';
  static const discussionDetailSegment = ':postId';

  static String news(String city) => '/news/${Uri.encodeComponent(city)}';

  static String discussionDetail(String postId) =>
      '/discussion/${Uri.encodeComponent(postId)}';

  static String airQuality({
    required String city,
    required double lat,
    required double lon,
  }) =>
      '/air-quality/${Uri.encodeComponent(city)}?lat=$lat&lon=$lon';

  static String chatbotFor({String? city}) {
    if (city == null || city.trim().isEmpty) return chatbot;
    return '$chatbot?city=${Uri.encodeQueryComponent(city)}';
  }

  static String discussionFor({String? city}) {
    if (city == null || city.trim().isEmpty) return discussion;
    return '$discussion?city=${Uri.encodeQueryComponent(city)}';
  }
}
