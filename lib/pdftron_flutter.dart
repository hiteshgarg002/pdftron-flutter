library pdftron;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

part 'options.dart';

class PdftronFlutter {
  static const MethodChannel _channel = const MethodChannel('pdftron_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get version async {
    final String version = await _channel.invokeMethod('getVersion');
    return version;
  }

  static Future<void> initialize(String licenseKey) {
    _channel.invokeMethod(
        'initialize', <String, dynamic>{'licenseKey': licenseKey});
  }

  static Future<void> openDocument(String document,
      {String password, Config config}) {
    _channel.invokeMethod('openDocument', <String, dynamic>{
      'document': document,
      'password': password,
      'config': jsonEncode(config)
    });
  }
}
