class ApiConstants {
  ApiConstants._();

  /// Backend serverin LAN IP-si.
  /// Eyni Wi-Fi şəbəkəsindəki cihazlar bu ünvana qoşulur.
  /// Emulator localhost üçün 10.0.2.2 istifadə edir.
  static const String serverHost = '192.168.31.177';
  static const int serverPort = 3000;

  static const String baseUrl = 'http://$serverHost:$serverPort/api/v1';
  static const String socketUrl = 'http://$serverHost:$serverPort/game';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
