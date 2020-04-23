/*
 * ============================================================================
 *  Copyright 2020 Asim Ihsan. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License in the LICENSE file and at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * ============================================================================
 */

// Refererences
// - https://api.flutter.dev/flutter/services/MethodChannel/invokeMethod.html

import 'dart:async';

import 'package:flutter/services.dart';

class LocalStorage {
  static const MethodChannel _channel = const MethodChannel('com.asimihsan.local_storage');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('initialize');
    return version;
  }

  static Future<String> getKeyValue(String appId, String key) async {
    try {
      return _channel.invokeMethod('getKeyValue', <String, dynamic>{'appId': appId, 'key': key});
    } on PlatformException catch (e) {
      throw 'Unable to get key ${key}';
    }
  }

  static Future<void> storeKeyValue(String appId, String key, String value) async {
    try {
      return _channel.invokeMethod(
          'storeKeyValue', <String, dynamic>{'appId': appId, 'key': key, 'value': value});
    } on PlatformException catch (e) {
      throw 'Unable to store key ${key}';
    }
  }
}
