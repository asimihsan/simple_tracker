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

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';
import 'package:simple_tracker/client/CustomHttpClient.dart';
import 'package:simple_tracker/exception/CouldNotDeserializeResponseException.dart';
import 'package:simple_tracker/exception/CouldNotVerifySessionException.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/proto/calendar.pb.dart';
import 'package:simple_tracker/state/calendar_detail_model.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';

class CalendarRepository {
  static final _formatter = new DateFormat('yyyy-MM-dd');

  final String baseUrl;
  BackendClient _backendClient;

  CalendarRepository(this.baseUrl) : _backendClient = BackendClient.defaultClient(baseUrl);

  Future<CalendarDetailModel> getCalendars(
      String userId,
      String sessionId,
      List<String> calendarIds) async {
    var requestProto = GetCalendarsRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    calendarIds.forEach((calendarId) => requestProto.calendarIds.add(calendarId));
    var getCalendarsRequestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("get_calendars", getCalendarsRequestSerialized);
    GetCalendarsResponse responseProto;
    try {
      responseProto = GetCalendarsResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw CouldNotDeserializeResponseException();
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

  List<String> getInternalHighlightedDays(List<int> highlightedDaysSerialized) {
    List<int> inflated = zlib.decode(highlightedDaysSerialized);
    ListOfStrings listOfStrings;
    try {
      listOfStrings = ListOfStrings.fromBuffer(inflated);
    } catch (e) {
      developer.log("could not deserialize highlightedDays as proto", error: e);
      throw e;
    }
    return listOfStrings.strings;
  }

  Future<void> createCalendar(
      {required String userId,
      required String sessionId,
      required String name,
      required String color}) async {
    var requestProto = CreateCalendarRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    requestProto.name = name;
    requestProto.color = color;
    var createCalendarRequestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("create_calendar", createCalendarRequestSerialized);
    CreateCalendarResponse responseProto;
    try {
      responseProto = CreateCalendarResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw CouldNotDeserializeResponseException();
    }
    developer.log("CreateCalendarResponse", error: responseProto);

    if (responseProto.success == false) {
      if (responseProto.errorReason ==
          CreateCalendarErrorReason.CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }
  }

  Future<List<CalendarSummaryModel>> listCalendars(
      {required String userId,
      required String sessionId,
      required CalendarListModel calendarListModel,
      int maxResults = 100}) async {
    calendarListModel.loading = true;

    var requestProto = ListCalendarsRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    requestProto.maxResults = Int64(maxResults);
    var listCalendarsRequestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("list_calendars", listCalendarsRequestSerialized);
    ListCalendarsResponse responseProto;
    try {
      responseProto = ListCalendarsResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarListModel.loading = false;
      throw CouldNotDeserializeResponseException();
    }
    developer.log("ListCalendarsResponse", error: responseProto);
    calendarListModel.loading = false;

    if (responseProto.success == false) {
      if (responseProto.errorReason ==
          ListCalendarsErrorReason.LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }

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
    return result;
  }

  Future<void> removeHighlightedDay(
      {required UserModel userModel,
      required CalendarDetailModel calendarDetailModel,
      required CalendarModel calendarModel,
      required DateTime dateTime}) async {
    calendarDetailModel.addRefreshingDateTime(dateTime);

    var requestProto = UpdateCalendarsRequest();
    requestProto.userId = userModel.userId!;
    requestProto.sessionId = userModel.sessionId!;

    var updateCalendarAction = UpdateCalendarAction();
    updateCalendarAction.calendarId = calendarModel.id;
    updateCalendarAction.existingVersion = new Int64(calendarModel.version);
    updateCalendarAction.actionType =
        UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY;
    updateCalendarAction.removeHighlightedDay = _formatter.format(dateTime);
    requestProto.actions[calendarModel.id] = updateCalendarAction;
    var requestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("update_calendars", requestSerialized);
    UpdateCalendarsResponse responseProto;
    try {
      responseProto = UpdateCalendarsResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw CouldNotDeserializeResponseException();
    }

    if (responseProto.success == false) {
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      if (responseProto.errorReason ==
          UpdateCalendarsErrorReason.UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }

    final List<CalendarModel> calendarModels = responseProto.calendarDetails
        .map((calendarDetail) => convertExternalCalendarDetailToCalendarModel(calendarDetail))
        .toList();
    calendarDetailModel.setupUpdatedCalendarModels(calendarModels);
    calendarDetailModel.removeRefreshingDateTime(dateTime);
    return;
  }

  Future<void> addHighlightedDay(
      {required UserModel userModel,
      required CalendarDetailModel calendarDetailModel,
      required CalendarModel calendarModel,
      required DateTime dateTime}) async {
    calendarDetailModel.addRefreshingDateTime(dateTime);

    var requestProto = UpdateCalendarsRequest();
    requestProto.userId = userModel.userId!;
    requestProto.sessionId = userModel.sessionId!;

    var updateCalendarAction = UpdateCalendarAction();
    updateCalendarAction.calendarId = calendarModel.id;
    updateCalendarAction.existingVersion = new Int64(calendarModel.version);
    updateCalendarAction.actionType =
        UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY;
    updateCalendarAction.addHighlightedDay = _formatter.format(dateTime);
    requestProto.actions[calendarModel.id] = updateCalendarAction;
    var requestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("update_calendars", requestSerialized);
    UpdateCalendarsResponse responseProto;
    try {
      responseProto = UpdateCalendarsResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      throw CouldNotDeserializeResponseException();
    }

    if (responseProto.success == false) {
      calendarDetailModel.removeRefreshingDateTime(dateTime);
      if (responseProto.errorReason ==
          UpdateCalendarsErrorReason.UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }

    final List<CalendarModel> calendarModels = responseProto.calendarDetails
        .map((calendarDetail) => convertExternalCalendarDetailToCalendarModel(calendarDetail))
        .toList();
    calendarDetailModel.setupUpdatedCalendarModels(calendarModels);
    calendarDetailModel.removeRefreshingDateTime(dateTime);
    return;
  }

  Future<void> updateCalendarNameColor(
      {required UserModel userModel,
      required CalendarSummaryModel calendarSummaryModel,
      required String name,
      required String color}) async {
    var requestProto = UpdateCalendarsRequest();
    requestProto.userId = userModel.userId!;
    requestProto.sessionId = userModel.sessionId!;

    var updateCalendarAction = UpdateCalendarAction();
    updateCalendarAction.calendarId = calendarSummaryModel.id;
    updateCalendarAction.existingVersion = new Int64(calendarSummaryModel.version);
    updateCalendarAction.actionType =
        UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR;
    updateCalendarAction.newName = name;
    updateCalendarAction.newColor = color;
    requestProto.actions[calendarSummaryModel.id] = updateCalendarAction;
    var requestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes =
        await _backendClient.send("update_calendars", requestSerialized);

    UpdateCalendarsResponse responseProto;
    try {
      responseProto = UpdateCalendarsResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw CouldNotDeserializeResponseException();
    }

    if (responseProto.success == false) {
      if (responseProto.errorReason ==
          UpdateCalendarsErrorReason.UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }

    return;
  }

  Future<void> deleteCalendar(
      {required String userId, required String sessionId, required String calendarId}) async {
    var requestProto = DeleteCalendarRequest();
    requestProto.userId = userId;
    requestProto.sessionId = sessionId;
    requestProto.calendarId = calendarId;
    var requestSerialized = requestProto.writeToBuffer();

    final List<int> responseBytes = await _backendClient.send("delete_calendar", requestSerialized);

    DeleteCalendarResponse responseProto;
    try {
      responseProto = DeleteCalendarResponse.fromBuffer(responseBytes);
    } catch (e) {
      developer.log("could not deserialize response as proto", error: e);
      throw CouldNotDeserializeResponseException();
    }
    developer.log("DeleteCalendarResponse", error: responseProto);

    if (responseProto.success == false) {
      if (responseProto.errorReason ==
          DeleteCalendarErrorReason.DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR) {
        throw CouldNotVerifySessionException();
      } else {
        throw InternalServerErrorException();
      }
    }

    return;
  }
}
