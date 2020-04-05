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

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CalendarModel {
  final String _id;
  final String _name;
  final List<String> _highlightedDays;

  CalendarModel(this._id, this._name, this._highlightedDays);

  Set<DateTime> get highlightedDays =>
      _highlightedDays.map((dayString) => DateTime.parse(dayString)).toSet();

  String get name => _name;

  String get id => _id;
}
