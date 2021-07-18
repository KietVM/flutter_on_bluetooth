import 'package:flutter/foundation.dart';

/// bluetooth status
enum BluetoothStatus {
  ///
  unknown,

  /// will handle when see
  unavailable,

  /// check permission
  unauthorized,

  ///
  on,

  ///
  off
}

/// extension stringify
extension BluetoothStatusEx on BluetoothStatus {
  /// return name enum with string type
  String get stringify => describeEnum(this);
}

/// convert string to status enum
BluetoothStatus enumBluetoothStatusFromString(String? value) =>
    BluetoothStatus.values.firstWhere((element) => element.stringify == value,
        orElse: () => BluetoothStatus.unknown);
