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

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:simple_tracker/proto/app_preferences.pb.dart';

class AppPreferencesModel {
  static String key = "com.asimihsan.simpletracker.preferences";

  AppPreferences? _appPreferencesProto;
  PackageInfo? _packageInfo;
  final _storage = FlutterSecureStorage();

  bool get isPreferencesInitialized => _appPreferencesProto != null;

  Future<void> clear() async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto!.userId = "";
    _appPreferencesProto!.sessionId = "";
    _appPreferencesProto!.isNotFirstLaunch = false;
    await persist();
    return;
  }

  bool credentialsPresent() => _appPreferencesProto?.sessionId != null && _appPreferencesProto?.sessionId != "";
  String? get userId => _appPreferencesProto?.userId;
  String? get sessionId => _appPreferencesProto?.sessionId;
  Future<void> setCredentials(String userId, sessionId) async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto!.userId = userId;
    _appPreferencesProto!.sessionId = sessionId;
    await persist();
    return;
  }

  Future<void> clearCredentials() async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto!.userId = "";
    _appPreferencesProto!.sessionId = "";
    await persist();
    return;
  }

  bool? get isNotFirstLaunch => _appPreferencesProto?.isNotFirstLaunch;
  Future<void> setIsNotFirstLaunch(bool isNotFirstLaunch) async {
    if (_appPreferencesProto == null) {
      await reload();
    }
    _appPreferencesProto!.isNotFirstLaunch = isNotFirstLaunch;
    await persist();
    return;
  }

  String? get appVersion => _packageInfo?.version;

  String? get appBuildNumber => _packageInfo?.buildNumber;

  Future<void> reload() async {
    final String? preferencesSerialized = await _storage.read(key: key);
    if (preferencesSerialized == null) {
      developer.log("No existing preferences found, initialize from scratch.");
      _appPreferencesProto = AppPreferences();
      await persist();
      return;
    }
    final List<int> preferencesSerializedBytes = utf8.encode(
        preferencesSerialized);
    try {
      _appPreferencesProto =
          AppPreferences.fromBuffer(preferencesSerializedBytes);
    } catch (_) {
      _appPreferencesProto = AppPreferences();
      await persist();
    }

    _packageInfo = await PackageInfo.fromPlatform();
    return;
  }

  Future<void> persist() async {
    final List<int> preferencesSerializedBytes = _appPreferencesProto!.writeToBuffer();
    final String preferencesSerialized = String.fromCharCodes(preferencesSerializedBytes);
    await _storage.write(key: key, value: preferencesSerialized);
    return;
  }
}
