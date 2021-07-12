# on_bluetooth

A new flutter plugin project.

## Getting Started

This project make a minifunction just for turn on bluetooth

**iOS**
We can not do exactly what we want on this. We just can open the popup ask user permission and give them option turn on bluetooth from setting

I using **CBCentralManagerOptionShowPowerAlertKey**

**Android**
I asking for turn on bluetooth directly from android. They accept for this thing.

## setup

**iOS**
info.plist

```
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>Need BLE permission</string>
  <key>NSBluetoothPeripheralUsageDescription</key>
  <string>Need BLE permission</string>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>Need Location permission</string>
  <key>NSLocationAlwaysUsageDescription</key>
  <string>Need Location permission</string>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>Need Location permission</string>
```

**Android**
AndroidManifest.xml

```
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## use

```
OnBluetooth.turnOnBluetooth();
```

## note

This project making for mine personal problem :D will update if have time or more problems.
