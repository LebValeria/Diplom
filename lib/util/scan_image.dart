import 'dart:async';
import 'package:flutter/services.dart';

class ScanImage {
  static const MethodChannel _channel = const MethodChannel('instapano/image');

  static Future<bool> scanImage(String fullFilePath) async {
    bool success = false;
    var sendMap = <String, String> {
      "fullFilePath": fullFilePath
    };
    try {
      success = await _channel.invokeMethod("scanImage", sendMap);
    } on PlatformException {
      rethrow;
    }
    return success;
  }
}
