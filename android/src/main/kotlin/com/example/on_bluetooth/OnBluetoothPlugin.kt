package com.example.on_bluetooth

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.Service
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.service.ServiceAware
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** OnBluetoothPlugin */
class OnBluetoothPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "on_bluetooth")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  @SuppressLint("MissingPermission")
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "turnOnBluetooth" -> {
        var mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (mBluetoothAdapter.isEnabled) {
          result.success(true)
        } else {
          result.success(mBluetoothAdapter.enable())
        }
      }
      "statusBluetooth" -> {
        if (havePermission()) {
          var mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
          var state = mBluetoothAdapter.state
          if (state == BluetoothAdapter.STATE_TURNING_OFF ||
            state == BluetoothAdapter.STATE_TURNING_ON) {
            state = BluetoothAdapter.STATE_OFF
          }
          when (state) {
            BluetoothAdapter.STATE_ON -> {
              result.success("on")
            }
            BluetoothAdapter.STATE_OFF -> {
              result.success("off")
            }
            else -> {
              if (mBluetoothAdapter.isEnabled) {
                result.success("on")
              } else {
                result.success("off")
              }
            }
          }
        } else {
          result.success("unauthorized")
        }
      }
      "requestPermission" -> {
        if (activity != null ) {
          ActivityCompat.requestPermissions(activity,
            arrayOf(Manifest.permission.BLUETOOTH,
              Manifest.permission.BLUETOOTH_ADMIN,
              Manifest.permission.ACCESS_COARSE_LOCATION), 1201)
        } else {
          Log.e("Xdebug", "null activity")
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  fun havePermission(): Boolean {
    return ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(context, android.Manifest.permission.BLUETOOTH_ADMIN) == PackageManager.PERMISSION_GRANTED
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  /*
  * Activity aware
  * */
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.e("Xdebug", "Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.e("Xdebug", "Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    Log.e("Xdebug", "Not yet implemented")
  }
}
