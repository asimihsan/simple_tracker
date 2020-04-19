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

import 'package:color/color.dart';
import 'package:meta/meta.dart';
import 'package:simple_tracker/exception/CouldNotDeserializeResponseException.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/proto/calendar.pb.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class CalendarRepository {
  final String baseUrl;

  CalendarRepository(this.baseUrl);

  Future<void> createCalendar(
      {@required String userId,
      @required String sessionId,
      @required String name,
      @required String color}) async {
    var requestProto = CreateCalendarRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    requestProto.name = name;
    requestProto.color = color;
    var createCalendarRequestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "create_calendar";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };
    var response = await http.post(url, headers: headers, body: createCalendarRequestSerialized);
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode != 200) {
      throw new InternalServerErrorException();
    }

    CreateCalendarResponse responseProto;
    try {
      responseProto = CreateCalendarResponse.fromBuffer(response.bodyBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw new CouldNotDeserializeResponseException();
    }
    developer.log("CreateCalendarResponse", error: responseProto);
    return;
  }

  Future<List<CalendarSummaryModel>> listCalendars(
      {@required String userId,
      @required String sessionId,
      @required CalendarListModel calendarListModel}) async {
    calendarListModel.loading = true;

    var requestProto = ListCalendarsRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    var listCalendarsRequestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "list_calendars";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };
    var response = await http.post(url, headers: headers, body: listCalendarsRequestSerialized);

    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode != 200) {
      calendarListModel.loading = false;
      throw new InternalServerErrorException();
    }

    ListCalendarsResponse responseProto;
    try {
      responseProto = ListCalendarsResponse.fromBuffer(response.bodyBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarListModel.loading = false;
      throw new CouldNotDeserializeResponseException();
    }
    developer.log("ListCalendarsResponse", error: responseProto);

    List<CalendarSummaryModel> result =
        responseProto.calendarSummaries.map((externalCalendarSummary) {
      return new CalendarSummaryModel(
          externalCalendarSummary.formatVersion.toInt(),
          externalCalendarSummary.id,
          externalCalendarSummary.name,
          externalCalendarSummary.color,
          externalCalendarSummary.version.toInt());
    }).toList(growable: false);
    calendarListModel.setCalendarSummaries(result);
    calendarListModel.loading = false;
    return result;
  }

  Future<CalendarModel> getCalendar({@required String userId, @required String calendarId}) async {
    // TODO this would actually call a server, here just pretend data.
    await Future.delayed(Duration(seconds: 3));

    List<String> highlightedDays = new List();
    highlightedDays.add("2020-03-05");
    highlightedDays.add("2020-04-01");
    highlightedDays.add("2020-04-03");

    return new CalendarModel.withContent("calendarId", "Migraines", highlightedDays);
  }

  Future<void> addHighlightedDay(@required UserModel userModel,
      @required CalendarModel calendarModel, @required DateTime dateTime) async {
    calendarModel.addRefreshingDateTime(dateTime);

    // TODO this would actually call a server, here just pretend data.
    await Future.delayed(Duration(seconds: 1));

    calendarModel.addHighlightedDay(dateTime);
    calendarModel.removeRefreshingDateTime(dateTime);
  }

  Future<void> removeHighlightedDay(@required UserModel userModel,
      @required CalendarModel calendarModel, @required DateTime dateTime) async {
    calendarModel.addRefreshingDateTime(dateTime);

    // TODO this would actually call a server, here just pretend data.
    await Future.delayed(Duration(seconds: 1));

    calendarModel.removeHighlightedDay(dateTime);
    calendarModel.removeRefreshingDateTime(dateTime);
  }
}
