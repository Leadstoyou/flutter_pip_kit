package com.leadstoyou.pip_kit

import android.app.Activity
import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PipKitPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "flutter_pip")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }
  override fun onDetachedFromActivityForConfigChanges() { activity = null }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activity = binding.activity }
  override fun onDetachedFromActivity() { activity = null }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "isSupported" -> {
        val ok = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && activity != null
        result.success(ok)
      }
      "enter" -> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || activity == null) {
          result.error("UNSUPPORTED", "PiP requires API 26+", null); return
        }
        val x = (call.argument<Int>("x") ?: 16).coerceAtLeast(1)
        val y = (call.argument<Int>("y") ?: 9).coerceAtLeast(1)
        val params = PictureInPictureParams.Builder()
          .setAspectRatio(Rational(x, y))
          .build()
        activity!!.enterPictureInPictureMode(params)
        result.success(null)
      }
      "exit" -> {
        // Không có API exit trực tiếp; user chạm cửa sổ để trở lại app.
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }
}
