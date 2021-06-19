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

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:simple_tracker/client/CustomHttpClient.dart';
import 'package:simple_tracker/exception/CouldNotDeserializeResponseException.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/exception/UserAlreadyExistsException.dart';
import 'package:simple_tracker/exception/UserMissingOrPasswordIncorrectException.dart';
import 'package:simple_tracker/proto/user.pb.dart';
import 'package:simple_tracker/state/user_model.dart';

class UserRepository {
  final String baseUrl;

  BackendClient _backendClient;

  UserRepository(this.baseUrl) {
    _backendClient = BackendClient.defaultClient(baseUrl);
  }

  Future<void> createUser(
      {required String username,
      required String password,
      required UserModel providedUserModel}) async {
    var requestProto = CreateUserRequest();
    requestProto.username = username;
    requestProto.password = password;
    var createUserRequestSerialized = requestProto.writeToBuffer();

    final Uint8List responseBytes =
        await _backendClient.send("create_user", createUserRequestSerialized);

    CreateUserResponse responseProto;
    try {
      responseProto = CreateUserResponse.fromBuffer(responseBytes);
      developer.log("response proto", error: responseProto.toDebugString());
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      developer.log(Utf8Codec().decode(responseBytes));
      throw new CouldNotDeserializeResponseException();
    }

    if (!responseProto.success) {
      if (responseProto.errorReason == CreateUserErrorReason.USER_ALREADY_EXISTS) {
        throw UserAlreadyExistsException();
      } else {
        throw InternalServerErrorException();
      }
    }
    providedUserModel.login(responseProto.userId, responseProto.sessionId);
  }

  Future<UserModel> loginUser(
      {required String username,
      required String password,
      required UserModel providedUserModel}) async {
    var requestProto = LoginUserRequest();
    requestProto.username = username;
    requestProto.password = password;
    var requestSerialized = requestProto.writeToBuffer();

    final Uint8List responseBytes = await _backendClient.send("login_user", requestSerialized);

    LoginUserResponse responseProto;
    try {
      responseProto = LoginUserResponse.fromBuffer(responseBytes);
      developer.log("response proto", error: responseProto.toDebugString());
      providedUserModel.login(responseProto.userId, responseProto.sessionId);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw new CouldNotDeserializeResponseException();
    }

    if (!responseProto.success) {
      switch (responseProto.errorReason) {
        case LoginUserErrorReason.USER_MISSING_OR_PASSWORD_INCORRECT:
          throw new UserMissingOrPasswordIncorrectException();
        case LoginUserErrorReason.LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR:
        default:
          throw new InternalServerErrorException();
      }
    }

    return providedUserModel;
  }
}
