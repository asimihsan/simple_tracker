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
import 'dart:math';

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
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];
const DAY_LABELS_SHORTEST_EN = [
  "Mo",
  "Tu",
  "We",
  "Th",
  "Fr",
  "Sa",
  "Su",
];

class CalenderMonth extends StatelessWidget {
  const CalenderMonth({Key key, this.year, this.month}) : super(key: key);

  final int year;
  final int month;

  final int daysInWeek = 7;
  final double minWidthPixels = 50.0;
  final double maxWidthPixels = 75.0;
  final int maximumCellsInMonth = 40;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarDetailModel>(builder: (context, calendarDetailModel, child) {
      final CalendarRepository calendarRepository =
          Provider.of<CalendarRepository>(context, listen: false);
      final UserModel userModel = Provider.of<UserModel>(context, listen: false);
      final ThemeData themeData = Theme.of(context);

      final String title = "${MONTH_LABELS_EN[this.month - 1]} ${this.year}";
      developer.log('CalenderMonth build entry for title $title');

      final GregorianCalendar today = GregorianCalendar.now();
      GregorianCalendar currentCalendar = new GregorianCalendar(this.year, this.month, 1);
      final int startingWeekday = currentCalendar.weekday;
      final List<TableRow> tableRows = new List();

      final List<Widget> headerRow = new List();
      for (var i = 0; i < daysInWeek; i++) {
        headerRow.add(headerWidget(context, DAY_LABELS_SHORTEST_EN[i]));
      }
      tableRows.add(TableRow(children: headerRow));

      var currentRow = new List<Widget>();
      for (var i = 0; i <= maximumCellsInMonth; i++) {
        final DateTime currentDateTime = currentCalendar.toDateTimeLocal();
        if (i + 1 < startingWeekday) {
          currentRow.add(dayWidget(context, currentCalendar.day, false /*isToday*/, true /*blank*/,
              calendarDetailModel, currentDateTime, calendarRepository, userModel));
        } else {
          currentRow.add(dayWidget(
              context,
              currentCalendar.day,
              today == currentCalendar /*isToday*/,
              false /*blank*/,
              calendarDetailModel,
              currentDateTime,
              calendarRepository,
              userModel));
          currentCalendar = currentCalendar.addDays(1);
        }
        if (currentRow.length >= 7) {
          tableRows.add(TableRow(children: currentRow));
          currentRow = new List<Widget>();
        }
        if (currentCalendar.month != this.month) {
          break;
        }
      }

      if (currentRow.length > 0) {
        while (currentRow.length < 7) {
          currentRow.add(dayWidget(context, currentCalendar.day, false /*isToday*/, true /*blank*/,
              null, null, calendarRepository, userModel));
        }
        tableRows.add(TableRow(children: currentRow));
      }

      List<Widget> children = new List();
      children.add(Text(title, style: themeData.textTheme.headline4));

      final List<CalendarModelAndMonthSum> calendarModelAndMonthSum =
          calendarDetailModel.calculateMonthSum(this.year, this.month);
      calendarModelAndMonthSum.forEach(
          (elem) => children.add(Text(elem.summaryText, style: TextStyle(color: elem.color))));
      children.add(Table(
        defaultColumnWidth: FractionColumnWidth(1.0 / daysInWeek),
        children: tableRows,
      ));

      final double mediaWidth = MediaQuery.of(context).size.width;
      developer.log("mediaWidth: ", error: mediaWidth);
      final Orientation orientation = MediaQuery.of(context).orientation;
      final double targetWidth = orientation == Orientation.portrait
          ? minWidthPixels * daysInWeek
          : maxWidthPixels * daysInWeek;
      final double desiredMarginWidth = (mediaWidth - targetWidth) / 2;

      return Container(
        margin: EdgeInsets.fromLTRB(desiredMarginWidth, 5.0, desiredMarginWidth, 5.0),
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
      final bool isToday,
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
      TextStyle textStyle = Theme.of(context).textTheme.bodyText2;
      if (isToday) {
        textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
      }
      child = refreshing
          ? new CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  isBlank ? "" : "$index",
                  style: textStyle,
                  textAlign: TextAlign.center,
                )
              ],
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

    final List<Color> bgColors = calendarDetailModel != null && currentDateTime != null
        ? calendarDetailModel.getColorsForDateTimeWithDefaultColor(
            currentDateTime, Colors.transparent)
        : new List();
    final Color bgColor1 = bgColors.length >= 1 ? bgColors[0] : Colors.transparent;
    final Color bgColor2 = bgColors.length >= 2 ? bgColors[1] : Colors.transparent;
    final Color bgColor3 = bgColors.length >= 3 ? bgColors[2] : Colors.transparent;
    final Color bgColor4 = bgColors.length >= 4 ? bgColors[3] : Colors.transparent;

    final Border border = isToday ? Border.all(width: 3.0) : Border.all();

    final Orientation orientation = MediaQuery.of(context).orientation;
    final double squareSize = orientation == Orientation.portrait ? minWidthPixels : maxWidthPixels;
    final double width = squareSize / 2 - 1;
    final double height = squareSize / 2 - 1;
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
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minWidthPixels,
                    minHeight: minWidthPixels,
                    maxWidth: maxWidthPixels,
                    maxHeight: maxWidthPixels,
                  ),
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
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minWidthPixels,
                    minHeight: minWidthPixels,
                    maxWidth: maxWidthPixels,
                    maxHeight: maxWidthPixels,
                  ),
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
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minWidthPixels,
                    minHeight: minWidthPixels,
                    maxWidth: maxWidthPixels,
                    maxHeight: maxWidthPixels,
                  ),
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
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: minWidthPixels,
                    minHeight: minWidthPixels,
                    maxWidth: maxWidthPixels,
                    maxHeight: maxWidthPixels,
                  ),
                  child: Container(
                    decoration: new BoxDecoration(color: bgColor4),
                  )),
            ),

          // This is the date number with a transparent background (no decoration).
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidthPixels,
              minHeight: minWidthPixels,
              maxWidth: maxWidthPixels,
              maxHeight: maxWidthPixels,
            ),
            child: InkWell(
              onTap: onTapHandler,
              child: Ink(
                  padding: EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(border: border),
                  child: child),
            ),
          ),
        ],
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidthPixels,
          minHeight: minWidthPixels,
          maxWidth: minWidthPixels,
          maxHeight: minWidthPixels,
        ),
        child: InkWell(
          onTap: onTapHandler,
          child: Ink(
              padding: EdgeInsets.all(5.0),
              decoration: new BoxDecoration(border: border, color: backgroundColor),
              child: child),
        ),
      );
    }
  }

  Widget headerWidget(final BuildContext context, String day) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidthPixels,
          maxWidth: maxWidthPixels,
        ),
        child: Container(
            margin: EdgeInsets.all(min(2.0, minWidthPixels / 25.0)),
            padding: EdgeInsets.all(min(10.0, minWidthPixels / 5.0)),
            child: Text(
              "$day",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
