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

import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

const MONTH_LABELS_EN = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
const DAY_LABELS_EN = [
  null,
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

class CalenderMonth extends StatelessWidget {
  const CalenderMonth({Key key, this.year, this.month, this.highlightedDays}) : super(key: key);

  final int year;
  final int month;
  final Set<DateTime> highlightedDays;

  @override
  Widget build(BuildContext context) {
    final String title = "${MONTH_LABELS_EN[this.month - 1]} ${this.year}";
    GregorianCalendar currentCalendar = new GregorianCalendar(this.year, this.month, 1);
    final int startingWeekday = currentCalendar.weekday;

    final List<Row> rows = new List<Row>();
    List<Widget> currentRow = new List<Widget>();

    for (var i = 1; i < DAY_LABELS_EN.length; i++) {
      currentRow.add(headerWidget(context, DAY_LABELS_EN[i]));
      currentRow.add(Spacer());
    }
    rows.add(Row(children: currentRow));
    currentRow = new List<Widget>();

    for (var i = 0; i <= 40; i++) {
      final bool highlighted = highlightedDays.contains(currentCalendar.toDateTimeLocal());
      if (i + 1 < startingWeekday) {
        currentRow
            .add(dayWidget(context, currentCalendar.day, true /*blank*/, false /*highlighted*/));
      } else {
        currentRow.add(dayWidget(context, currentCalendar.day, false /*blank*/, highlighted));
        currentCalendar = currentCalendar.addDays(1);
      }
      currentRow.add(Spacer());
      if (currentRow.length >= 14) {
        rows.add(Row(children: currentRow));
        currentRow = new List<Widget>();
      }
      if (currentCalendar.month != this.month) {
        break;
      }
    }
    while (currentRow.length < 14) {
      currentRow
          .add(dayWidget(context, currentCalendar.day, true /*blank*/, false /*highlighted*/));
      currentRow.add(Spacer());
    }
    rows.add(Row(children: currentRow));

    // TODO: implement build
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.display1),
          Column(children: rows),
        ],
      ),
    );
  }

  Widget dayWidget(
      final BuildContext context, final int index, final bool isBlank, final bool highlighted) {
    final Color backgroundColor = highlighted ? Colors.orangeAccent : Colors.white;
    return InkWell(
        onTap: () => developer.log("Pressed index $index"),
        child: Container(
            width: 50,
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(15.0),
            decoration: new BoxDecoration(border: Border.all(), color: backgroundColor),
            child: Text(
              isBlank ? "" : "$index",
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            )));
  }

  Widget headerWidget(final BuildContext context, String day) {
    return Container(
        width: 50,
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "$day",
          style: Theme.of(context).textTheme.body1,
          textAlign: TextAlign.center,
        ));
  }
}
