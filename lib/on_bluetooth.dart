import 'dart:async';

import 'package:flutter/services.dart';

class OnBluetooth {
  static const MethodChannel _channel = const MethodChannel('on_bluetooth');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> turnOnBluetooth() async {
    final bool? success = await _channel.invokeMethod('turnOnBluetooth');
    if (success is bool) {
      return success;
    }
    return false;
  }
}
