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

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'dart:developer' as developer;

import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/view/create_calendar_view.dart';

Widget getCalendarList(BuildContext context) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);
  return Scaffold(
    appBar: AppBar(
      title: Text(localizations.calendarListTitle),
    ),
    body: SafeArea(
      child: new CalendarList(),
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        developer.log("Create new calendar click");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => getCreateCalendar(context)),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}

class CalendarList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CalendarListState();
  }
}

Future<List<CalendarSummaryModel>> refreshListCalendars(BuildContext context) {
  final CalendarRepository calendarRepository =
      Provider.of<CalendarRepository>(context, listen: false);
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  final CalendarListModel calendarListModel =
      Provider.of<CalendarListModel>(context, listen: false);
  return calendarRepository.listCalendars(
      userId: userModel.userId,
      sessionId: userModel.sessionId,
      calendarListModel: calendarListModel);
}

class CalendarListState extends State<CalendarList> with AfterLayoutMixin<CalendarList> {
  @override
  void afterFirstLayout(BuildContext context) {
    developer.log("CalendarList afterFirstLayout");
    refreshListCalendars(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarListModel>(builder: (context, calendarList, child) {
      if (calendarList.loading == true) {
        return emptyList(context, "Loading...");
      }
      List<Widget> calendarSummaries = calendarList
          .getCalendarSummariesInNameOrder()
          .map((calendarSummary) => calendarSummaryModelToListViewWidget(calendarSummary))
          .toList();
      if (calendarSummaries.length == 0) {
        return emptyList(context, "You don't have any calendars!");
      }
      return new RefreshIndicator(
          onRefresh: () {
            developer.log("refresh for non-empty!");
            return refreshListCalendars(context);
          },
          child: Container(
              padding: EdgeInsets.all(32.0),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: calendarSummaries
                    .map((calendarSummary) => Container(
                          height: 50,
                          child: calendarSummary,
                        ))
                    .toList(),
              )));
    });
  }

  Widget emptyList(BuildContext context, String text) {
    return new RefreshIndicator(
        onRefresh: () {
          developer.log("refresh for empty!");
          return refreshListCalendars(context);
        },
        child: Container(
            padding: EdgeInsets.all(32.0),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[new Text(text)],
            )));
  }

  Widget calendarSummaryModelToListViewWidget(CalendarSummaryModel calendarSummaryModel) {
    return Text(calendarSummaryModel.name);
  }
}
