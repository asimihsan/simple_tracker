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
import 'package:provider/provider.dart';
import 'package:simple_tracker/calendar_month_widget.dart';
import 'package:simple_tracker/custom_scroll_physics.dart';
import 'package:simple_tracker/state/calendar_model.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GregorianCalendar today = GregorianCalendar.now();
    final InfiniteScrollController _infiniteScrollController = InfiniteScrollController(
      initialScrollOffset: 0.0,
    );

    return Consumer<CalendarModel>(builder: (context, calender, child) {
      return InfiniteListView.separated(
        controller: _infiniteScrollController,
        itemBuilder: (BuildContext context, int index) {
          final GregorianCalendar newCalendar = today.addMonths(index);
          final int newMonth = newCalendar.month;
          final int newYear = newCalendar.year;
          developer.log('building row',
              error: jsonEncode({"index": index, "newMonth": newMonth, "newYear": newYear}));
          return CalenderMonth(year: newCalendar.year, month: newCalendar.month);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(height: 2.0),
        physics: new CustomScrollPhysics(),
      );
    });

//    return Consumer<CalendarModel>(builder: (context, calendar, child) {
//      if (calendar.isLoaded == false) {
//        developer.log("DetailView calendar is null...");
//        return CircularProgressIndicator();
//      }
//      developer.log("DetailView calendar is non-null...");
//      return InfiniteListView.separated(
//        controller: _infiniteScrollController,
//        itemBuilder: (BuildContext context, int index) {
//          developer.log("DetailViewState calendarModel highlightedDays",
//              error: calendar.highlightedDays);
//          developer.log("foo", error: DateTime.parse("2020-04-02"));
//
//          final GregorianCalendar newCalendar = today.addMonths(index);
//          final int newMonth = newCalendar.month;
//          final int newYear = newCalendar.year;
//          developer.log('building row',
//              error: jsonEncode({"index": index, "newMonth": newMonth, "newYear": newYear}));
//          return CalenderMonth(
//              year: newCalendar.year,
//              month: newCalendar.month,
//              highlightedDays: calendar.highlightedDays);
//        },
//        separatorBuilder: (BuildContext context, int index) => const Divider(height: 2.0),
//        physics: new CustomScrollPhysics(),
//      );
//    });
  }
}
