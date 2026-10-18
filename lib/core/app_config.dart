import 'package:flutter/foundation.dart';

/// Konfigurasi aplikasi yang mudah diganti di satu tempat.
class AppConfig {
  AppConfig._();

  static const String authHostLabel = 'accounts.ntcfit.app';
  static const int resendCodeSeconds = 20;
  static const int getReadySeconds = 5;
  static const int restSeconds = 10;

  /// Android Emulator memakai 10.0.2.2 untuk mengakses localhost komputer.
  /// Flutter Web memakai 127.0.0.1.
  static String get apiBaseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }
}
