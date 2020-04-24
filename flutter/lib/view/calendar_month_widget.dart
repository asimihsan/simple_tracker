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

import 'dart:developer' as developer;

import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/state/calendar_detail_model.dart';
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
    return Consumer<CalendarDetailModel>(builder: (context, calendarDetailModel, child) {
      final CalendarRepository calendarRepository =
          Provider.of<CalendarRepository>(context, listen: false);
      final UserModel userModel = Provider.of<UserModel>(context, listen: false);
      final ThemeData themeData = Theme.of(context);

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
          currentRow.add(dayWidget(context, currentCalendar.day, true /*blank*/,
              calendarDetailModel, currentDateTime, calendarRepository, userModel));
        } else {
          currentRow.add(dayWidget(context, currentCalendar.day, false /*blank*/,
              calendarDetailModel, currentDateTime, calendarRepository, userModel));
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

      List<Widget> children = new List();
      children.add(Text(title, style: themeData.textTheme.headline4));

      final List<CalendarModelAndMonthSum> calendarModelAndMonthSum =
          calendarDetailModel.calculateMonthSum(this.year, this.month);
      calendarModelAndMonthSum.forEach(
          (elem) => children.add(Text(elem.summaryText, style: TextStyle(color: elem.color))));
      children.add(Column(children: rows));

      return Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    });
  }

  Widget dayWidget(
      final BuildContext context,
      final int index,
      final bool isBlank,
      final CalendarDetailModel calendarDetailModel,
      final DateTime currentDateTime,
      final CalendarRepository calendarRepository,
      final UserModel userModel) {
    final List<CalendarModel> calendarModels =
        calendarDetailModel != null ? calendarDetailModel.calendarModels : new List();
    final List<Color> colors = calendarDetailModel != null
        ? calendarDetailModel.getColorsForDateTime(currentDateTime)
        : new List();

    Widget child;
    Color backgroundColor;
    Function onTapHandler;
    if (isBlank) {
      child = Text(
        isBlank ? "" : "$index",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      );
      backgroundColor = Colors.white;
      onTapHandler = () {};
    } else {
      final bool highlighted = colors.length > 0;
      final bool refreshing = calendarDetailModel.isRefreshingDateTime(currentDateTime);

      // TODO let us see more than one background color.
      backgroundColor = highlighted ? colors[0] : Colors.white;
      child = refreshing
          ? new CircularProgressIndicator()
          : Text(
              isBlank ? "" : "$index",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            );

      onTapHandler = () {
        if (calendarDetailModel.isReadOnly) {
          return;
        }
        developer.log("Pressed index $index");
        if (highlighted) {
          calendarRepository.removeHighlightedDay(
              userModel: userModel,
              calendarDetailModel: calendarDetailModel,
              calendarModel: calendarModels[0],
              dateTime: currentDateTime);
        } else {
          calendarRepository.addHighlightedDay(
              userModel: userModel,
              calendarDetailModel: calendarDetailModel,
              calendarModel: calendarModels[0],
              dateTime: currentDateTime);
        }
      };
    }

    List<Color> bgColors = calendarDetailModel != null && currentDateTime != null
        ? calendarDetailModel.getColorsForDateTimeWithDefaultColor(currentDateTime, Colors.white)
        : new List();
    final Color bgColor1 = bgColors.length >= 1 ? bgColors[0] : Colors.white;
    final Color bgColor2 = bgColors.length >= 2 ? bgColors[1] : Colors.white;
    final Color bgColor3 = bgColors.length >= 3 ? bgColors[2] : Colors.white;
    final Color bgColor4 = bgColors.length >= 4 ? bgColors[3] : Colors.white;

    const double squareSize = 50;
    const double width = squareSize / 2 - 1;
    const double height = squareSize / 2 - 1;
    if (calendarDetailModel != null && calendarDetailModel.isReadOnly) {
      return Stack(
        children: <Widget>[
          // Top-left
          if (!isBlank)
            Positioned(
              top: 1,
              left: 1,
              height: height,
              width: width,
              child: SizedBox(
                  height: height,
                  width: width,
                  child: Container(
                    decoration: new BoxDecoration(color: bgColor1),
                  )),
            ),

          // Top-right
          if (!isBlank)
            Positioned(
              top: 1,
              right: 1,
              height: height,
              width: width,
              child: SizedBox(
                  height: height,
                  width: width,
                  child: Container(
                    decoration: new BoxDecoration(color: bgColor2),
                  )),
            ),

          // Bottom-left
          if (!isBlank)
            Positioned(
              bottom: 1,
              left: 1,
              height: height,
              width: width,
              child: SizedBox(
                  height: height,
                  width: width,
                  child: Container(
                    decoration: new BoxDecoration(color: bgColor3),
                  )),
            ),

          // Bottom-right
          if (!isBlank)
            Positioned(
              bottom: 1,
              right: 1,
              height: height,
              width: width,
              child: SizedBox(
                  height: height,
                  width: width,
                  child: Container(
                    decoration: new BoxDecoration(color: bgColor4),
                  )),
            ),

          // This is the date number with a transparent background (no decoration).
          SizedBox(
              height: squareSize,
              width: squareSize,
              child: InkWell(
                child: Ink(
                    width: squareSize,
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(border: Border.all()),
                    child: child),
              )),
        ],
      );
    } else {
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
  }

  Widget headerWidget(final BuildContext context, String day) {
    return Container(
        width: 50,
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "$day",
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ));
  }
}
