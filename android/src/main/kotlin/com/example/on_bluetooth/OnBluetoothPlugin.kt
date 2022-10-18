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
import android.content.Intent

import android.content.BroadcastReceiver




/** OnBluetoothPlugin */
class OnBluetoothPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  val REQUEST_CODE_PERMISSION: Int = 1201

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "on_bluetooth")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "turnOnBluetooth" -> {
        if (havePermission()) {
          var mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
          if (mBluetoothAdapter.isEnabled) {
            result.success(true)
          } else {
            result.success(mBluetoothAdapter.enable())
          }
        } else {
          result.success(false)
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
              Manifest.permission.ACCESS_COARSE_LOCATION), REQUEST_CODE_PERMISSION)
        } else {
          Log.e("Xdebug", "null activity")
        }
      }
      "listenStateChange" -> {
        if (activity != null){
          try {
            val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
            activity.registerReceiver(mReceiver, filter)
          } catch (e: Exception) {
            // register duplicate
          }
        }
      }
      "cancelListenStateChange" -> {
        if (activity != null) {
          try {
            activity.unregisterReceiver(mReceiver)
          } catch (e: Exception) {
          // unregister duplicate
          }
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private val mReceiver: BroadcastReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
      val action = intent.action
      if (action == BluetoothAdapter.ACTION_STATE_CHANGED) {
        val state = intent.getIntExtra(
          BluetoothAdapter.EXTRA_STATE,
          BluetoothAdapter.ERROR
        )
        activity.runOnUiThread {
          when (state) {
            BluetoothAdapter.STATE_OFF -> channel.invokeMethod("blueStateChange", "off")
            BluetoothAdapter.STATE_TURNING_OFF -> channel.invokeMethod("blueStateChange", "off")
            BluetoothAdapter.STATE_ON -> channel.invokeMethod("blueStateChange", "on")
            BluetoothAdapter.STATE_TURNING_ON -> channel.invokeMethod("blueStateChange", "off")
            else -> channel.invokeMethod("blueStateChange", "off")
          }
        }
      }
    }
  }

  fun havePermission(): Boolean {
    return ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(context, android.Manifest.permission.BLUETOOTH_ADMIN) == PackageManager.PERMISSION_GRANTED
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//    Log.e("Xdebug","onDetachedFromEngine")
    channel.setMethodCallHandler(null)
    if (activity != null) {
      try {
        activity.unregisterReceiver(mReceiver)
      } catch (e: Exception) {
        // unregister duplicate
      }
    }
  }

  /*
  * Activity aware
  * */
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
      if (requestCode == REQUEST_CODE_PERMISSION) {
        if (grantResults != null && grantResults.isNotEmpty()) {
          val result = grantResults[0] == PackageManager.PERMISSION_GRANTED &&
                  (grantResults.size >=2 && grantResults[1] == PackageManager.PERMISSION_GRANTED) &&
                  (grantResults.size >=3 && grantResults[2] == PackageManager.PERMISSION_GRANTED)
          channel.invokeMethod("permissionResult", result)
          result
        }
      }
      false
    }
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
