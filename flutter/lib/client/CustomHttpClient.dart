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

import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart' as pb;
import 'package:simple_tracker/exception/CouldNotDeserializeResponseException.dart';
import 'dart:developer' as developer;

import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/proto/calendar.pb.dart';

class RpcClient {
  final String _baseUrl;
  final CustomHttpClient _client = new CustomHttpClient();

  RpcClient(this._baseUrl);

  Future<GetCalendarsResponse> getCalendars(final GetCalendarsRequest request) {
    _client.post(_baseUrl + "get_calendars", body: request.writeToBuffer()).then((response) {
      GetCalendarsResponse responseProto;
      try {
        responseProto = GetCalendarsResponse.fromBuffer(response.bodyBytes);
      } catch (e) {
        throw new CouldNotDeserializeResponseException();
      }
      return responseProto;
    });
  }
}

class CustomHttpClient extends http.BaseClient {
  static final Map<String, String> defaultHeaders = {
    "Accept": "application/protobuf",
    "Content-Type": "application/protobuf",
  };
  static final Duration defaultTimeout = Duration(seconds: 5);

  http.Client _client;

  CustomHttpClient() {
    _client = new http.Client();
  }

  @override
  Future<http.StreamedResponse> send(final http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _client.send(request).timeout(defaultTimeout).then((response) {
      if (response.headers.containsKey("x-amzn-trace-id")) {
        developer.log("URL: " +
            request.url.toString() +
            ", X-Ray trace ID: " +
            response.headers["x-amzn-trace-id"]);
      }
      if (response.headers.containsKey("x-amzn-requestid")) {
        developer.log("URL: " +
            request.url.toString() +
            ", Request ID: " +
            response.headers["x-amzn-requestid"]);
      }
      if (response.statusCode != 200) {
        throw new InternalServerErrorException();
      }
      return response;
    });
  }
}
