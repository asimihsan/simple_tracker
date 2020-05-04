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
import 'package:simple_tracker/state/calendar_summary_model.dart';

class CalendarListModel extends ChangeNotifier {
  static const maximumCombinedViewCalendars = 4;

  bool _loading = true;
  Map<String, CalendarSummaryModel> _calendarSummaries = new HashMap();
  bool _isCombinedView = false;
  Set<CalendarSummaryModel> _combinedViewCalendars = new Set();

  bool get loading => _loading;

  bool get isCombinedView => _isCombinedView;

  set loading(bool value) {
    _loading = value;
    if (value == true) {
      _calendarSummaries.clear();
    }
    notifyListeners();
  }

  void toggleIsCombinedView() {
    _isCombinedView = !_isCombinedView;
    _combinedViewCalendars.clear();
    notifyListeners();
  }

  set isCombinedView(final bool isCombinedView) {
    _isCombinedView = isCombinedView;
    _combinedViewCalendars.clear();
    notifyListeners();
  }

  void selectCalendarForCombinedView(final CalendarSummaryModel calendarSummaryModel) {
    if (_combinedViewCalendars.length < maximumCombinedViewCalendars) {
      _combinedViewCalendars.add(calendarSummaryModel);
      notifyListeners();
    }
  }

  void deselectCalendarForCombinedView(final CalendarSummaryModel calendarSummaryModel) {
    _combinedViewCalendars.remove(calendarSummaryModel);
    notifyListeners();
  }

  bool isCalendarSelectedInCombinedView(final CalendarSummaryModel calendarSummaryModel) {
    return _combinedViewCalendars.contains(calendarSummaryModel);
  }

  List<CalendarSummaryModel> getCombinedViewCalendarsAsList() {
    var returnValue = _combinedViewCalendars.toList();
    returnValue.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return List.unmodifiable(returnValue);
  }

  void setCalendarSummaries(List<CalendarSummaryModel> newCalendarSummaries) {
    _calendarSummaries = Map.fromIterable(newCalendarSummaries, key: (e) => e.id, value: (e) => e);
    notifyListeners();
  }

  List<CalendarSummaryModel> getCalendarSummariesInNameOrder() {
    var result = _calendarSummaries.values.toList();
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return result;
  }
}
