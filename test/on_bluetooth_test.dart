import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_bluetooth/on_bluetooth.dart';

void main() {
  const MethodChannel channel = MethodChannel('on_bluetooth');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OnBluetooth.platformVersion, '42');
  });
}
