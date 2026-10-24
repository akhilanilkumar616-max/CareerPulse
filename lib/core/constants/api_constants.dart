import 'package:flutter/foundation.dart';

/// API endpoints and configuration for CareerPulse Backend
class ApiConstants {
  ApiConstants._();

  /// Default production Render cloud webservice URL
  static const String productionUrl = 'https://careerpulse-backend-lhp0.onrender.com';

  // Environment variable override if passed during build:
  // flutter run --dart-define=BACKEND_URL=https://...
  static const String _envUrl = String.fromEnvironment('BACKEND_URL');

  // Dynamic base URL resolution
  static String get defaultBaseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    return productionUrl;
  }

  // Active base URL (customizable in app settings if needed)
  static String baseUrl = defaultBaseUrl;

  // Endpoint paths
  static const String healthEndpoint = '/api/v1/health';
  static const String analyzeResumeEndpoint = '/api/v1/analyze-resume';
  static const String historyEndpoint = '/api/v1/history';
  static const String profileEndpoint = '/api/v1/profile';
}
