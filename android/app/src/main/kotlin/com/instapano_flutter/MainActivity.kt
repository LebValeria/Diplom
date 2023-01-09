package com.instapano_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Intent
import android.net.Uri

import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "instapano/image"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            val arguments = call.arguments<Map<String, String>>()
            if (call.method == "scanImage") {
                val imgFile = File(arguments["fullFilePath"])
                val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(imgFile))
                this@MainActivity.sendBroadcast(intent)
            }
        }
    }
}
