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
import 'package:date_calendar/date_calendar.dart';

class CalendarModelAndMonthSum {
  final CalendarModel _calendarModel;
  final int _monthSum;

  CalendarModelAndMonthSum(this._calendarModel, this._monthSum);

  CalendarModel get calendarModel => _calendarModel;

  int get monthSum => _monthSum;

  String get summaryText => '${_calendarModel.name}: $monthSum';

  Color get color => _calendarModel.color;
}

class CalendarDetailModel extends ChangeNotifier {
  static final List<CalendarModel> emptyCalendarModelList = List.unmodifiable(List());

  bool _loading;
  bool _isReadOnly;

  Map<String, CalendarModel> _calendarModels = new HashMap();

  // This is a derived calculated field.
  Map<DateTime, List<CalendarModel>> _highlightedDateTimes = new HashMap();

  // This is a Flutter-UI-only field to indicate DateTimes that are currently refreshing.
  Set<DateTime> _refreshingDateTimes = new Set();

  bool get loading => _loading;

  bool get isReadOnly => _isReadOnly;

  set isReadOnly(bool value) {
    _isReadOnly = value;
  }

  List<CalendarModel> get calendarModels {
    List<CalendarModel> result = _calendarModels.values.toList();
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return result;
  }

  CalendarDetailModel() {
    _loading = true;
  }

  List<CalendarModelAndMonthSum> calculateMonthSum(final int year, final int month) {
    final Map<CalendarModel, int> monthSum = new HashMap();
    calendarModels.forEach((calendarModel) => monthSum[calendarModel] = 0);

    GregorianCalendar currentCalendar = new GregorianCalendar(year, month, 1);
    while (currentCalendar.month == month) {
      getHighlightedCalendarModelsForDateTime(currentCalendar.toDateTimeLocal())
          .forEach((calendarModel) => monthSum[calendarModel] = monthSum[calendarModel] + 1);
      currentCalendar = currentCalendar.addDays(1);
    }

    return List.unmodifiable(calendarModels
        .map(
            (calendarModel) => new CalendarModelAndMonthSum(calendarModel, monthSum[calendarModel]))
        .toList());
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
          _highlightedDateTimes[dateTime]
              .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        }
      });
    });
  }

  List<CalendarModel> getHighlightedCalendarModelsForDateTime(DateTime dateTime) {
    if (!_highlightedDateTimes.containsKey(dateTime)) {
      return emptyCalendarModelList;
    }
    return List.unmodifiable(_highlightedDateTimes[dateTime]);
  }

  List<Color> getColorsForDateTime(DateTime dateTime) {
    return getHighlightedCalendarModelsForDateTime(dateTime)
        .map((calendarModel) => calendarModel.color)
        .toList();
  }

  List<Color> getColorsForDateTimeWithDefaultColor(DateTime dateTime, Color defaultColor) {
    var highlightedCalendarModels = getHighlightedCalendarModelsForDateTime(dateTime).toSet();
    return calendarModels.map((calendarModel) {
      if (highlightedCalendarModels.contains(calendarModel)) {
        return calendarModel.color;
      }
      return defaultColor;
    }).toList();
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
