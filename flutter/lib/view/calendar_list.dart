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
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/calendar_repository.dart';

Widget getCalendarList(BuildContext context) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);
  final String title = localizations.calendarListTitle;

  Widget child = MultiProvider(
    providers: [
      Provider(
        create: (_) => new CalendarRepository("https://preprod-simple-tracker.ihsan.io/"),
      )
    ],
    child: new CalendarList(),
  );

  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: SafeArea(
      child: child,
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  );
}

class CalendarList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Calendar list view");
  }
}
