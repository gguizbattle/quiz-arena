import '../constants/api_constants.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => ApiConstants.baseUrl;
  static String get socketUrl => ApiConstants.socketUrl;

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  static const String profile = '/users/me';
  static const String leaderboard = '/leaderboard';
  static const String questions = '/questions';
}
