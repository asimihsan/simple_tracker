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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/view/detail_view.dart';
import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'dart:developer' as developer;

import 'package:simple_tracker/state/user_model.dart';

Widget getCalendarDetail() {
  return MultiProvider(
    providers: [
      Provider(create: (_) => new CalendarRepository("https://preprod-simple-tracker.ihsan.io/")),
    ],
    child: CalendarDetailWidget(),
  );
}

class CalendarDetailWidget extends StatelessWidget {
  CalendarDetailWidget({Key key}) : super(key: key);

  Widget _buildHomePage(Widget child) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Tracker"),
      ),
      body: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CalendarModel>(
        future: downloadCalendar(context),
        builder: (context, snapshot) {
          final CalendarModel calendarModel = snapshot?.data;
          if (calendarModel == null) {
            developer.log("MyHomePage calendar is null...");
            return _buildHomePage(new CircularProgressIndicator());
          }
          developer.log("MyHomePage calendar is non-null...");
          return MultiProvider(
              providers: [ChangeNotifierProvider(create: (_) => calendarModel)],
              child: _buildHomePage(DetailView()));
        });
  }

  Future<CalendarModel> downloadCalendar(BuildContext context) async {
    // TODO put this somewhere else, for now also login.
    Provider.of<UserModel>(context).login("userId", "userAuthenticationToken");

    final CalendarRepository repository = Provider.of<CalendarRepository>(context, listen: false);
    return repository.getCalendar(userId: "userId", calendarId: "calendarId");
  }
}
