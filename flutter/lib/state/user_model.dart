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

import 'package:flutter/material.dart';

class UserModel {
  bool _loggedIn;
  String _userId;
  String _sessionId;

  UserModel.notLoggedIn() {
    this._loggedIn = false;
    this._userId = null;
    this._sessionId = null;
  }

  void login(String userId, String sessionId) {
    this._loggedIn = true;
    this._userId = userId;
    this._sessionId = sessionId;
  }

  bool get loggedIn => _loggedIn;

  String get sessionId => _sessionId;

  String get userId => _userId;
}
