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

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_tracker/state/calendar_model.dart';

class CalendarDetailModel extends ChangeNotifier {
  bool _loading;

  Map<String, CalendarModel> _calendarModels = new HashMap();

  // This is a derived calculated field.
  Map<DateTime, List<CalendarModel>> _highlightedDateTimes = new HashMap();

  // This is a Flutter-UI-only field to indicate DateTimes that are currently refreshing.
  Set<DateTime> _refreshingDateTimes = new Set();

  bool get loading => _loading;

  List<CalendarModel> get calendarModels {
    List<CalendarModel> result = _calendarModels.values.toList();
    result.sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  CalendarDetailModel() {
    _loading = true;
  }

  setupUpdatedCalendarModels(List<CalendarModel> updatedCalendarModels) {
    _setupUpdatedCalendarModels(updatedCalendarModels);
    _setupHighlightedDateTimes();
    _loading = false;
    notifyListeners();
  }

  setupCalendarModelsFromScratch(List<CalendarModel> calendarModels) {
    _setupCalendarModelsFromScratch(calendarModels);
    _setupHighlightedDateTimes();
    _loading = false;
    notifyListeners();
  }

  void _setupUpdatedCalendarModels(List<CalendarModel> updatedCalendarModels) {
    updatedCalendarModels.forEach((calendarModel) {
      _calendarModels[calendarModel.id] = calendarModel;
    });
  }

  void _setupCalendarModelsFromScratch(List<CalendarModel> calendarModels) {
    _calendarModels.clear();
    calendarModels.forEach((calendarModel) {
      _calendarModels[calendarModel.id] = calendarModel;
    });
  }

  void _setupHighlightedDateTimes() {
    _highlightedDateTimes.clear();
    _calendarModels.values.forEach((calendarModel) {
      calendarModel.highlightedDaysAsDateTimes.forEach((dateTime) {
        if (!_highlightedDateTimes.containsKey(dateTime)) {
          _highlightedDateTimes[dateTime] = new List();
        }
        if (!_highlightedDateTimes[dateTime].contains(calendarModel)) {
          _highlightedDateTimes[dateTime].add(calendarModel);
          _highlightedDateTimes[dateTime].sort((a, b) => a.id.compareTo(b.id));
        }
      });
    });
  }

  List<CalendarModel> getHighlightedCalendarModelsForDateTime(DateTime dateTime) {
    if (!_highlightedDateTimes.containsKey(dateTime)) {
      return List.unmodifiable(List());
    }
    return List.unmodifiable(_highlightedDateTimes[dateTime]);
  }

  List<Color> getColorsForDateTime(DateTime dateTime) {
    return getHighlightedCalendarModelsForDateTime(dateTime)
        .map((calendarModel) => calendarModel.color)
        .toList();
  }

  bool isRefreshingDateTime(DateTime dateTime) {
    return this._refreshingDateTimes.contains(dateTime);
  }

  void addRefreshingDateTime(DateTime dateTime) {
    this._refreshingDateTimes.add(dateTime);
    notifyListeners();
  }

  void removeRefreshingDateTime(DateTime dateTime) {
    this._refreshingDateTimes.remove(dateTime);
    notifyListeners();
  }
}
