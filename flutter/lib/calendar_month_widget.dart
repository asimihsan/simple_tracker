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
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/user_model.dart';

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
  const CalenderMonth({Key key, this.year, this.month}) : super(key: key);

  final int year;
  final int month;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarModel>(builder: (context, calendar, child) {
      final CalendarRepository calendarRepository =
          Provider.of<CalendarRepository>(context, listen: false);
      final UserModel userModel = Provider.of<UserModel>(context, listen: false);

      final String title = "${MONTH_LABELS_EN[this.month - 1]} ${this.year}";
      developer.log('CalenderMonth build entry for title $title');

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
        final DateTime currentDateTime = currentCalendar.toDateTimeLocal();
        if (i + 1 < startingWeekday) {
          currentRow.add(dayWidget(context, currentCalendar.day, true /*blank*/, calendar,
              currentDateTime, calendarRepository, userModel));
        } else {
          currentRow.add(dayWidget(context, currentCalendar.day, false /*blank*/, calendar,
              currentDateTime, calendarRepository, userModel));
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
        currentRow.add(dayWidget(context, currentCalendar.day, true /*blank*/, null, null,
            calendarRepository, userModel));
        currentRow.add(Spacer());
      }
      rows.add(Row(children: currentRow));
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
    });
  }

  Widget dayWidget(
      final BuildContext context,
      final int index,
      final bool isBlank,
      final CalendarModel calendarModel,
      final DateTime currentDateTime,
      final CalendarRepository calendarRepository,
      final UserModel userModel) {
    Widget child;
    Color backgroundColor;
    Function onTapHandler;
    if (isBlank) {
      child = Text(
        isBlank ? "" : "$index",
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.center,
      );
      backgroundColor = Colors.white;
      onTapHandler = () {};
    } else {
      final bool highlighted = calendarModel.isDateTimeHighlighted(currentDateTime);
      final bool refreshing = calendarModel.isRefreshingDateTime(currentDateTime);
      backgroundColor = highlighted ? Colors.orangeAccent : Colors.white;
      child = refreshing
          ? new CircularProgressIndicator()
          : Text(
              isBlank ? "" : "$index",
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            );
      onTapHandler = () {
        developer.log("Pressed index $index");
        if (highlighted) {
          calendarRepository.removeHighlightedDay(userModel, calendarModel, currentDateTime);
        } else {
          calendarRepository.addHighlightedDay(userModel, calendarModel, currentDateTime);
        }
      };
    }

    return SizedBox(
        height: 50,
        width: 50,
        child: InkWell(
          onTap: onTapHandler,
          child: Ink(
              width: 50,
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(border: Border.all(), color: backgroundColor),
              child: child),
        ));
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
