import 'dart:async';

import 'package:flutter/services.dart';
import 'package:on_bluetooth/src/bluetooth_status.dart';
import 'package:on_bluetooth/src/method.dart';

export 'package:on_bluetooth/src/bluetooth_status.dart';

class OnBluetooth {
  static const MethodChannel _channel = const MethodChannel(kPackageName);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> turnOnBluetooth() async {
    final bool? success = await _channel.invokeMethod(kTurnOnBluetooth);
    if (success is bool) {
      return success;
    }
    return false;
  }

  /// get status bluetooth
  static Future<BluetoothStatus> bluetoothStatus() async {
    final statusString = await _channel.invokeMethod(kStatusBluetooth);
    if (statusString is String) {
      final bluetoothStatus = enumBluetoothStatusFromString(statusString);
      return bluetoothStatus;
    }
    return BluetoothStatus.unknown;
  }

  /// request permission
  static void requestPermission() {
    _channel.invokeMethod('requestPermission');
  }
}
