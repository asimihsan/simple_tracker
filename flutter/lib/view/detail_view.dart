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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:simple_tracker/date_calendar/date_calendar.dart';
import 'package:simple_tracker/view/calendar_month_widget.dart';
import 'package:simple_tracker/view/custom_scroll_physics.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GregorianCalendar today = GregorianCalendar.now();
    final InfiniteScrollController _infiniteScrollController = InfiniteScrollController(
      initialScrollOffset: 0.0,
    );

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
  }
}
