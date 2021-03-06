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
import 'package:simple_tracker/state/calendar_detail_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/view/detail_view.dart';

Widget getCalendarDetail(List<CalendarSummaryModel> calendarSummaryModels,
    {required bool readOnly}) {
  return CalendarDetailWidget(
      calendarSummaryModels: calendarSummaryModels, readOnly: readOnly);
}

class CalendarDetailWidget extends StatefulWidget {
  final List<CalendarSummaryModel> calendarSummaryModels;
  final bool readOnly;

  const CalendarDetailWidget(
      {required this.calendarSummaryModels, required this.readOnly});

  @override
  State<StatefulWidget> createState() {
    return _CalendarDetailWidgetState(calendarSummaryModels, readOnly);
  }
}

class _CalendarDetailWidgetState extends State<CalendarDetailWidget> {
  final List<CalendarSummaryModel> calendarSummaryModels;
  final bool readOnly;

  _CalendarDetailWidgetState(this.calendarSummaryModels, this.readOnly);

  Widget _buildHomePage(Widget child) {
    String title;
    if (calendarSummaryModels.length == 1) {
      title = calendarSummaryModels[0].name;
    } else {
      title = "Multiple calendars";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CalendarDetailModel>(
        future: _downloadCalendars(context),
        builder: (BuildContext context,
            AsyncSnapshot<CalendarDetailModel> snapshot) {
          if (snapshot.hasError) {
            final Exception error = snapshot.error! as Exception;
            return _buildHomePage(
                Text("Error loading calendars! " + error.toString()));
          }
          final CalendarDetailModel? calendarDetailModel = snapshot.data;
          if (calendarDetailModel == null) {
            return _buildHomePage(new CircularProgressIndicator());
          }
          calendarDetailModel.isReadOnly = this.readOnly;
          return MultiProvider(
            providers: [ListenableProvider(create: (_) => calendarDetailModel)],
            child: _buildHomePage(DetailView()),
          );
        });
  }

  Future<CalendarDetailModel> _downloadCalendars(BuildContext context) async {
    final CalendarRepository calendarRepository =
        Provider.of<CalendarRepository>(context, listen: false);
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return await calendarRepository.getCalendars(
      userModel.userId!,
      userModel.sessionId!,
      this.calendarSummaryModels
          .map((calendarSummaryModel) => calendarSummaryModel.id)
          .toList(),
    );
  }
}
