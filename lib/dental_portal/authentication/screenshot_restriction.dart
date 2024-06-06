import 'package:flutter/services.dart';

class ScreenshotRestriction {
  static const MethodChannel _channel = MethodChannel('com.dentalkeybyrehan/screenshot');

  static Future<void> enableScreenshotRestriction() async {
    await _channel.invokeMethod('enableScreenshotRestriction');
  }

  static Future<void> disableScreenshotRestriction() async {
    await _channel.invokeMethod('disableScreenshotRestriction');
  }
}
