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
  const CalenderMonth({
    Key key,
    this.year,
    this.month,
  }) : super(key: key);

  final int year;
  final int month;

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

    var currentDayInMonth = 1;
    for (var i = 0; i <= 40; i++) {
      if (i + 1 < startingWeekday) {
        currentRow.add(dayWidget(context, currentDayInMonth, true /*blank*/));
      } else {
        currentRow.add(dayWidget(context, currentDayInMonth, false /*blank*/));
        currentDayInMonth++;
      }
      currentRow.add(Spacer());
      if (currentRow.length >= 14) {
        rows.add(Row(children: currentRow));
        currentRow = new List<Widget>();
      }
      if (currentCalendar.addDays(currentDayInMonth).month != this.month) {
        break;
      }
    }
    while (currentRow.length < 14) {
      currentRow.add(dayWidget(context, currentDayInMonth, true /*blank*/));
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

  Widget dayWidget(final BuildContext context, final int index, final bool isBlank) {
    return InkWell(
        onTap: () => developer.log("Pressed index $index"),
        child: Container(
            width: 50,
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(15.0),
            decoration: new BoxDecoration(border: Border.all()),
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
