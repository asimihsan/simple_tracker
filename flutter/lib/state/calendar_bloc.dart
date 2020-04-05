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

import 'dart:async';

import 'package:simple_tracker/state/bloc.dart';
import 'package:simple_tracker/state/calendar_model.dart';

class CalendarBloc implements Bloc {
  CalendarModel _calendarModel;
  CalendarModel get selectedCalendar => _calendarModel;

  final _calendarController = StreamController<CalendarModel>();

  Stream<CalendarModel> get calendarStream => _calendarController.stream;

  void selectCalendar(CalendarModel calendarModel) {
    _calendarModel = calendarModel;
    _calendarController.sink.add(calendarModel);
  }

  @override
  void dispose() {
    _calendarController.close();
  }
}
