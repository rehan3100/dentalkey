import 'package:flutter/services.dart';

class SecureOverlay {
  static const MethodChannel _channel = MethodChannel('com.dentalkeybyrehan.secure');

  static Future<void> enableSecureScreen() async {
    await _channel.invokeMethod('enableSecureScreen');
  }

  static Future<void> disableSecureScreen() async {
    await _channel.invokeMethod('disableSecureScreen');
  }
}
