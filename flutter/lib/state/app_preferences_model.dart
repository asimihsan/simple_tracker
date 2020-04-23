// ============================================================================
//  Copyright 2020 Asim Ihsan. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License in the LICENSE file and at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// ============================================================================

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:local_storage/local_storage.dart';
import 'package:simple_tracker/proto/app_preferences.pb.dart';

class AppPreferencesModel {
  static String appId = "com.asimihsan.simpletracker";
  static String preferencesKey = "_preferences";

  AppPreferences _appPreferencesProto;

  bool get isPreferencesInitialized => _appPreferencesProto != null;

  String get username => _appPreferencesProto?.username;
  String get password => _appPreferencesProto?.password;
  Future<void> setUsernameAndPassword(String username, String password) async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto.username = username;
    _appPreferencesProto.password = password;
    await persist();
    return;
  }

  Future<void> clearUsernameAndPassword() async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto.username = "";
    _appPreferencesProto.password = "";
    await persist();
    return;
  }

  bool get isNotFirstLaunch => _appPreferencesProto?.isNotFirstLaunch;
  Future<void> setIsNotFirstLaunch(bool isNotFirstLaunch) async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto.isNotFirstLaunch = isNotFirstLaunch;
    await persist();
    return;
  }

  Future<void> reload() async {
    try {
      final String preferencesSerialized = await LocalStorage.getKeyValue(appId, preferencesKey);
      final Uint8List preferencesSerializedBytes = utf8.encode(preferencesSerialized);
      _appPreferencesProto = AppPreferences.fromBuffer(preferencesSerializedBytes);
    } on PlatformException catch (e) {
      switch (e.code) {
        case "KEY_NOT_FOUND":
          developer.log("No existing preferences found, initialize from scratch.");
          _appPreferencesProto = new AppPreferences();
          await persist();
          break;
        default:
          developer.log("Unexpected exception during reload, will blow away preferences.",
              error: e);
          _appPreferencesProto = new AppPreferences();
          await persist();
          break;
      }
    }
    return;
  }

  Future<void> persist() async {
    Uint8List preferencesSerializedBytes = _appPreferencesProto.writeToBuffer();
    String preferencesSerialized = String.fromCharCodes(preferencesSerializedBytes);
    await LocalStorage.storeKeyValue(appId, preferencesKey, preferencesSerialized);
    return;
  }
}
