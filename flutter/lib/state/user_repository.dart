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
import 'package:meta/meta.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/exception/UserMissingOrPasswordIncorrectException.dart';
import 'package:simple_tracker/proto/user.pb.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class UserRepository {
  final String baseUrl;

  UserRepository(this.baseUrl);

  Future<UserModel> createUser(
      {@required String username,
      @required String password,
      @required UserModel providedUserModel}) async {
    var requestProto = CreateUserRequest();
    requestProto.username = username;
    requestProto.password = password;
    var createUserRequestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "create_user";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };

    var response = await http.post(url, headers: headers, body: createUserRequestSerialized);
    developer.log("CreateUser response " + response.statusCode.toString());
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode == 200) {
      developer.log("CreateUser response success");
      var responseProto = CreateUserResponse.fromBuffer(response.bodyBytes);
      developer.log("response proto", error: responseProto.toDebugString());
      providedUserModel.login(responseProto.userId, responseProto.sessionId);
    } else {
      developer.log("CreateUser response failure", error: response.body);
      return null;
    }
    return providedUserModel;
  }

  Future<UserModel> loginUser(
      {@required String username,
      @required String password,
      @required UserModel providedUserModel}) async {
    var requestProto = LoginUserRequest();
    requestProto.username = username;
    requestProto.password = password;
    var requestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "login_user";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };

    var response = await http.post(url, headers: headers, body: requestSerialized);
    developer.log("LoginUser response " + response.statusCode.toString());
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    LoginUserResponse responseProto;
    try {
      responseProto = LoginUserResponse.fromBuffer(response.bodyBytes);
      developer.log("response proto", error: responseProto.toDebugString());
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
    }

    if (response.statusCode == 200) {
      developer.log("CreateUser response success");
      providedUserModel.login(responseProto.userId, responseProto.sessionId);
    } else {
      developer.log("LoginUser response failure", error: response.body);
      if (responseProto != null) {
        switch (responseProto.errorReason) {
          case LoginUserErrorReason.USER_MISSING_OR_PASSWORD_INCORRECT:
            throw new UserMissingOrPasswordIncorrectException();
          case LoginUserErrorReason.LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR:
          default:
            throw new InternalServerErrorException();
        }
      }
    }
    return providedUserModel;
  }
}
