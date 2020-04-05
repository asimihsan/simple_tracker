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

import 'package:flutter/material.dart';
import 'package:simple_tracker/detail_view.dart';
import 'package:simple_tracker/state/bloc_provider.dart';
import 'package:simple_tracker/state/calendar_model.dart';
import 'package:simple_tracker/state/calendar_query_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarQueryBloc>(
      bloc: CalendarQueryBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalendarQueryBloc calendarQueryBloc = BlocProvider.of<CalendarQueryBloc>(context);
    if (!calendarQueryBloc.submittedOnce) {
      calendarQueryBloc.submitQuery("userId", "calendarId");
    }
    Widget child;
    return StreamBuilder<CalendarModel>(
        stream: BlocProvider.of<CalendarQueryBloc>(context).calendarStream,
        builder: (context, snapshot) {
          final CalendarModel calendar = snapshot.data;
          if (calendar == null) {
            developer.log("MyHomePage calendar is null...");
            child = CircularProgressIndicator();
          } else {
            developer.log("MyHomePage calendar is non-null...");
            child = DetailView(calendar);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Simple Tracker"),
            ),
            body: child,
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
          );
        });
  }
}
