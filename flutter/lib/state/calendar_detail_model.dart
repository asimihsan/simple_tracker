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

  CalendarDetailModel() {
    _loading = true;
  }

  setupFromCalendarModels(List<CalendarModel> calendarModels) {
    _calendarModels.clear();
    _highlightedDateTimes.clear();
    _refreshingDateTimes.clear();
    calendarModels.forEach((calendarModel) {
      _calendarModels[calendarModel.id] = calendarModel;
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
    _loading = false;
    notifyListeners();
  }

  List<Color> getColorsForDateTime(DateTime dateTime) {
    List<Color> result;
    if (!_highlightedDateTimes.containsKey(dateTime)) {
      result = List();
    } else {
      result = _highlightedDateTimes[dateTime].map((calendarModel) => calendarModel.color);
    }
    return List.unmodifiable(result);
  }

  bool isRefreshingDateTime(DateTime dateTime) {
    return this._refreshingDateTimes.contains(dateTime);
  }

  void addHighlightedDay(CalendarModel calendarModel, DateTime dateTime) {
    addRefreshingDateTime(dateTime);
    notifyListeners();

    // TODO call with CalendarRepository

    // TODO done with call, first refresh entire model

    // Remove the refreshing indicator
    removeRefreshingDateTime(dateTime);

    // Notify at the end
    notifyListeners();

    List<CalendarModel> existing = new List();
    if (_highlightedDateTimes.containsKey(dateTime)) {
      existing = _highlightedDateTimes[dateTime].toList();
    }
    if (!existing.contains(calendarModel)) {
      existing.add(calendarModel);
    }
    existing.sort((a, b) => a.id.compareTo(b.id));
    _highlightedDateTimes[dateTime] = List.unmodifiable(existing);
  }

  void removeHighlightedDay(CalendarModel calendarModel, DateTime dateTime) {
    addRefreshingDateTime(dateTime);
    notifyListeners();

    // TODO call with CalendarRepository

    // TODO done with call, first refresh entire model

    // Remove the refreshing indicator
    removeRefreshingDateTime(dateTime);

    // Notify at the en
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
