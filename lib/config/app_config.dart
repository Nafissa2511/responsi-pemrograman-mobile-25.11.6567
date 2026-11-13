import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file .env.
class AppConfig {
  /// Base URL API dari .env.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// API key dummy dari .env.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
