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

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:simple_tracker/calendar_month_widget.dart';
import 'package:simple_tracker/custom_scroll_physics.dart';
import 'package:simple_tracker/state/calendar_model.dart';

class DetailView extends StatefulWidget {
  final CalendarModel _calendarModel;

  const DetailView(
    this._calendarModel, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailViewState(_calendarModel);
  }
}

class DetailViewState extends State<DetailView> {
  final GregorianCalendar today = GregorianCalendar.now();
  final InfiniteScrollController _infiniteScrollController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );
  final CalendarModel _calendarModel;

  DetailViewState(this._calendarModel);

  @override
  Widget build(BuildContext context) {
    developer.log("DetailViewState calendarModel highlightedDays",
        error: _calendarModel.highlightedDays);

    developer.log("foo", error: DateTime.parse("2020-04-02"));

    return InfiniteListView.separated(
      controller: _infiniteScrollController,
      itemBuilder: (BuildContext context, int index) {
        final GregorianCalendar newCalendar = today.addMonths(index);
        final int newMonth = newCalendar.month;
        final int newYear = newCalendar.year;
        developer.log('building row',
            error: jsonEncode({"index": index, "newMonth": newMonth, "newYear": newYear}));
        return CalenderMonth(
            year: newCalendar.year,
            month: newCalendar.month,
            highlightedDays: _calendarModel.highlightedDays);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 2.0),
      physics: new CustomScrollPhysics(),
    );
  }

  Widget listViewEntry(final int index) {
    return Center(child: Text('Entry a'));
  }
}
