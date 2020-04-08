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

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CalendarModel extends ChangeNotifier {
  bool _isLoaded;
  String _id;
  String _name;
  List<String> _highlightedDays;
  Set<DateTime> _highlightedDateTimes;

  static final _formatter = new DateFormat('yyyy-MM-dd');

  CalendarModel.notLoaded() {
    this._isLoaded = false;
    this._id = null;
    this._name = null;
    this._highlightedDays = null;
    this._highlightedDateTimes = null;
  }

  CalendarModel.withContent(String id, String name, List<String> highlightedDays) {
    this._isLoaded = true;
    this._id = id;
    this._name = name;
    this._highlightedDays = highlightedDays;
    this._highlightedDateTimes =
        _highlightedDays.map((dayString) => DateTime.parse(dayString)).toSet();
  }

  bool get isLoaded => _isLoaded;

  String get id => _id;

  String get name => _name;

  void setContent(CalendarModel other) {
    this._id = other._id;
    this._name = other._name;
    this._highlightedDays = other._highlightedDays;
    notifyListeners();
  }

  void _setHighlightedDays(Set<DateTime> newHighlightedDateTimes) {
    _highlightedDateTimes = newHighlightedDateTimes;
    _highlightedDays = newHighlightedDateTimes
        .map((dateTime) => _formatter.format(dateTime))
        .toList(growable: false);
    _highlightedDays.sort();
  }

  bool isDateTimeHighlighted(DateTime dateTime) {
    return _highlightedDateTimes.contains(dateTime);
  }

  void addHighlightedDay(DateTime dateTime) {
    Set<DateTime> currentHighlightedDays = _highlightedDateTimes;
    currentHighlightedDays.add(dateTime);
    _setHighlightedDays(currentHighlightedDays);
    notifyListeners();
  }

  void removeHighlightedDay(DateTime dateTime) {
    Set<DateTime> currentHighlightedDays = _highlightedDateTimes;
    currentHighlightedDays.remove(dateTime);
    _setHighlightedDays(currentHighlightedDays);
    notifyListeners();
  }
}
