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

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';

class CalendarModel {
  final CalendarSummaryModel calendarSummaryModel;
  final List<String> _highlightedDays;

  // This is a derived field calculated once.
  Set<DateTime> _highlightedDaysAsDateTimes = Set();

  CalendarModel(this.calendarSummaryModel, this._highlightedDays) {
    this._highlightedDaysAsDateTimes = _highlightedDays
        .map((highlightedDayString) => DateTime.parse(highlightedDayString))
        .toSet();
  }

  String get id => calendarSummaryModel.id;

  Color get color => calendarSummaryModel.color;

  int get version => calendarSummaryModel.version;

  Set<DateTime> get highlightedDaysAsDateTimes => this._highlightedDaysAsDateTimes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is CalendarModel)) {
      return false;
    }
    if (!(other.runtimeType == runtimeType)) {
      return false;
    }
    final CalendarModel otherObject = other;
    return id == otherObject.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
