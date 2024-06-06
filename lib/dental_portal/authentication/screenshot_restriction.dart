import 'package:flutter/services.dart';

class ScreenshotRestriction {
  static const MethodChannel _channel = MethodChannel('com.dentalkeybyrehan/screenshot');

  static Future<void> enableScreenshotRestriction() async {
    try {
      await _channel.invokeMethod('enableScreenshotRestriction');
      print("enableScreenshotRestriction called in Flutter");
    } catch (e) {
      print("Failed to call enableScreenshotRestriction: $e");
    }
  }

  static Future<void> disableScreenshotRestriction() async {
    try {
      await _channel.invokeMethod('disableScreenshotRestriction');
      print("disableScreenshotRestriction called in Flutter");
    } catch (e) {
      print("Failed to call disableScreenshotRestriction: $e");
    }
  }
}
