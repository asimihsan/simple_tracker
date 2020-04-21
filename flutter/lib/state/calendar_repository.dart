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

import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:simple_tracker/exception/CouldNotDeserializeResponseException.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/proto/calendar.pb.dart';
import 'package:simple_tracker/state/calendar_detail_model.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:intl/intl.dart';

class CalendarRepository {
  static final _formatter = new DateFormat('yyyy-MM-dd');

  final String baseUrl;

  CalendarRepository(this.baseUrl);

  Future<CalendarDetailModel> getCalendars(
      {@required String userId,
      @required String sessionId,
      @required List<String> calendarIds}) async {
    var requestProto = GetCalendarsRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    calendarIds.forEach((calendarId) => requestProto.calendarIds.add(calendarId));
    var getCalendarsRequestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "get_calendars";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };
    var response = await http.post(url, headers: headers, body: getCalendarsRequestSerialized);
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode != 200) {
      throw new InternalServerErrorException();
    }

    GetCalendarsResponse responseProto;
    try {
      responseProto = GetCalendarsResponse.fromBuffer(response.bodyBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw new CouldNotDeserializeResponseException();
    }
    developer.log("GetCalendarsResponse", error: responseProto);

    final List<CalendarModel> calendarModels = responseProto.calendarDetails
        .map((calendarDetail) => convertExternalCalendarDetailToCalendarModel(calendarDetail))
        .toList();
    final CalendarDetailModel calendarDetailModel = CalendarDetailModel();
    calendarDetailModel.setupCalendarModelsFromScratch(calendarModels);
    return calendarDetailModel;
  }

  CalendarModel convertExternalCalendarDetailToCalendarModel(CalendarDetail calendarDetail) {
    return CalendarModel(
      convertExternalCalendarDetailToCalendarSummaryModel(calendarDetail),
      getInternalHighlightedDays(calendarDetail.highlightedDays),
    );
  }

  CalendarSummaryModel convertExternalCalendarDetailToCalendarSummaryModel(
      CalendarDetail calendarDetail) {
    return CalendarSummaryModel(
      calendarDetail.summary.formatVersion.toInt(),
      calendarDetail.summary.id,
      calendarDetail.summary.name,
      calendarDetail.summary.color,
      calendarDetail.summary.version.toInt(),
    );
  }

  List<String> getInternalHighlightedDays(Uint8List highlightedDaysSerialized) {
    Uint8List inflated = zlib.decode(highlightedDaysSerialized);
    ListOfStrings listOfStrings;
    try {
      listOfStrings = ListOfStrings.fromBuffer(inflated);
    } catch (e) {
      developer.log("could not deserialize highlightedDays as proto", error: e);
      return null;
    }
    return listOfStrings.strings;
  }

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

  Future<void> removeHighlightedDay(
      {@required UserModel userModel,
      @required CalendarDetailModel calendarDetailModel,
      @required CalendarModel calendarModel,
      @required DateTime dateTime}) async {
    calendarDetailModel.addRefreshingDateTime(dateTime);

    var requestProto = UpdateCalendarsRequest();
    requestProto.userId = userModel.userId;
    requestProto.sessionId = userModel.sessionId;

    var updateCalendarAction = UpdateCalendarAction();
    updateCalendarAction.calendarId = calendarModel.id;
    updateCalendarAction.existingVersion = new Int64(calendarModel.version);
    updateCalendarAction.actionType =
        UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY;
    updateCalendarAction.removeHighlightedDay = _formatter.format(dateTime);
    requestProto.actions[calendarModel.id] = updateCalendarAction;
    var requestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "update_calendars";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };
    var response = await http.post(url, headers: headers, body: requestSerialized);
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode != 200) {
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw new InternalServerErrorException();
    }

    UpdateCalendarsResponse responseProto;
    try {
      responseProto = UpdateCalendarsResponse.fromBuffer(response.bodyBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw new CouldNotDeserializeResponseException();
    }

    final List<CalendarModel> calendarModels = responseProto.calendarDetails
        .map((calendarDetail) => convertExternalCalendarDetailToCalendarModel(calendarDetail))
        .toList();
    calendarDetailModel.setupUpdatedCalendarModels(calendarModels);
    calendarDetailModel.removeRefreshingDateTime(dateTime);
    return calendarDetailModel;
  }

  Future<void> addHighlightedDay(
      {@required UserModel userModel,
      @required CalendarDetailModel calendarDetailModel,
      @required CalendarModel calendarModel,
      @required DateTime dateTime}) async {
    calendarDetailModel.addRefreshingDateTime(dateTime);

    var requestProto = UpdateCalendarsRequest();
    requestProto.userId = userModel.userId;
    requestProto.sessionId = userModel.sessionId;

    var updateCalendarAction = UpdateCalendarAction();
    updateCalendarAction.calendarId = calendarModel.id;
    updateCalendarAction.existingVersion = new Int64(calendarModel.version);
    updateCalendarAction.actionType =
        UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY;
    updateCalendarAction.addHighlightedDay = _formatter.format(dateTime);
    requestProto.actions[calendarModel.id] = updateCalendarAction;
    var requestSerialized = requestProto.writeToBuffer();

    var url = baseUrl + "update_calendars";
    Map<String, String> headers = {
      "Accept": "application/protobuf",
      "Content-Type": "application/protobuf",
    };
    var response = await http.post(url, headers: headers, body: requestSerialized);
    if (response.headers.containsKey("x-amzn-trace-id")) {
      developer.log("X-Ray trace ID: " + response.headers["x-amzn-trace-id"]);
    }
    if (response.headers.containsKey("x-amzn-requestid")) {
      developer.log("Request ID: " + response.headers["x-amzn-requestid"]);
    }

    if (response.statusCode != 200) {
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw new InternalServerErrorException();
    }

    UpdateCalendarsResponse responseProto;
    try {
      responseProto = UpdateCalendarsResponse.fromBuffer(response.bodyBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw new CouldNotDeserializeResponseException();
    }

    final List<CalendarModel> calendarModels = responseProto.calendarDetails
        .map((calendarDetail) => convertExternalCalendarDetailToCalendarModel(calendarDetail))
        .toList();
    calendarDetailModel.setupUpdatedCalendarModels(calendarModels);
    calendarDetailModel.removeRefreshingDateTime(dateTime);
    return calendarDetailModel;
  }
}
