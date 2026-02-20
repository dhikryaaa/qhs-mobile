import 'package:flutter/foundation.dart';

String baseUrl() {
  if (kIsWeb) {
    return 'http://localhost:8000';
  } else {
    return 'https://pervertible-unvolubly-theressa.ngrok-free.dev';
  }
}
