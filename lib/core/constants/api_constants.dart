import 'package:flutter/foundation.dart';

/// API endpoints and configuration for CareerPulse Backend
class ApiConstants {
  ApiConstants._();

  // Environment variable override if passed during build:
  // flutter run --dart-define=BACKEND_URL=http://...
  static const String _envUrl = String.fromEnvironment('BACKEND_URL');

  // Dynamic default resolution based on platform
  static String get defaultBaseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;

    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android Emulator accesses host loopback via 10.0.2.2
        return 'http://10.0.2.2:8000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  // Active base URL (customizable in app settings if needed)
  static String baseUrl = defaultBaseUrl;

  // Endpoint paths
  static const String healthEndpoint = '/api/v1/health';
  static const String analyzeResumeEndpoint = '/api/v1/analyze-resume';
}
