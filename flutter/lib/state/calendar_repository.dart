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

import 'package:meta/meta.dart';
import 'package:simple_tracker/state/calendar_model.dart';

class CalendarRepository {
  Future<CalendarModel> getCalendar({@required String userId, @required String calendarId}) async {
    // TODO this would actually call a server, here just pretend data.
    await Future.delayed(Duration(seconds: 1));

    List<String> highlightedDays = new List();
    highlightedDays.add("2020-03-05");
    highlightedDays.add("2020-04-01");
    highlightedDays.add("2020-04-03");

    return new CalendarModel("calendarId", "Migraines", highlightedDays);
  }
}
