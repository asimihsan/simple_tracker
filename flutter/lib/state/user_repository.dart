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

import 'package:meta/meta.dart';
import 'package:simple_tracker/proto/user.pb.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class UserRepository {
  final String baseUrl;

  UserRepository(this.baseUrl);

  Future<UserModel> createUser({@required String username, @required String password}) async {
    var requestProto = CreateUserRequest();
    requestProto.username = username;
    requestProto.password = password;
    var createUserRequestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "create_user";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };

    var userModel = UserModel.notLoggedIn();
    var response = await http.post(url, headers: headers, body: createUserRequestSerialized);
    developer.log("CreateUser response " + response.statusCode.toString());
    if (response.statusCode == 200) {
      developer.log("CreateUser response success");
      var responseProto = CreateUserResponse.fromBuffer(response.bodyBytes);
      developer.log("response proto", error: responseProto.toDebugString());
      userModel.login("userId", "authenticationToken");
    } else {
      developer.log("CreateUser response failure", error: response.body);
    }
    return userModel;
  }
}
