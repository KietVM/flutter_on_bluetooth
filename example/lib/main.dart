import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:on_bluetooth/on_bluetooth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool bluetoothStatus = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await OnBluetooth.platformVersion ?? 'Unknown platform version';
      syncStatus();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void syncStatus() async {
    BluetoothStatus status = await OnBluetooth.bluetoothStatus();
    print('BluetoothStatus $status');
    setState(() {
      if (status == BluetoothStatus.on) {
        bluetoothStatus = true;
      } else {
        bluetoothStatus = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Text(
              'Bluetooth Status: ${bluetoothStatus ? 'on' : 'of'}',
              style: TextStyle(
                  color: bluetoothStatus ? Colors.blue : Colors.black),
            ),
            TextButton(
                onPressed: () async {
                  await OnBluetooth.turnOnBluetooth();
                  // status bluetooth still have turning_on that not realy
                  // on need 1s wait it chang ready to on
                  Future.delayed(Duration(seconds: 1), () {
                    syncStatus();
                  });
                },
                child: Text('Turn on bluetooth')),
            TextButton(
                onPressed: () {
                  OnBluetooth.requestPermission();
                },
                child: Text('Request permission'))
          ],
        ),
      ),
    );
  }
}
