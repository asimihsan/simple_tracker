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

import 'package:color/color.dart' as color3p;

import 'package:flutter/material.dart';
import 'package:flutter_color_analyzer/big_color.dart';

class CalendarSummaryModel {
  final int _formatVersion;
  final String _id;
  final String _name;
  final String _color;
  final int _version;

  CalendarSummaryModel(this._formatVersion, this._id, this._name, this._color, this._version);

  int get version => _version;

  BigColor get color {
    color3p.RgbColor rgbColor = color3p.Color.hex(_color).toRgbColor();
    return BigColor.fromColor(Color.fromARGB(255, rgbColor.r.toInt(), rgbColor.g.toInt(), rgbColor.b.toInt()));
  }

  String get name => _name;

  String get id => _id;

  int get formatVersion => _formatVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSummaryModel &&
          runtimeType == other.runtimeType &&
          _formatVersion == other._formatVersion &&
          _id == other._id &&
          _name == other._name &&
          _color == other._color &&
          _version == other._version;

  @override
  int get hashCode =>
      _formatVersion.hashCode ^ _id.hashCode ^ _name.hashCode ^ _color.hashCode ^ _version.hashCode;
}
