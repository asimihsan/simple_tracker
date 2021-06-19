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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_analyzer/big_color.dart';
import 'package:flutter_color_analyzer/flutter_color_analyzer.dart';
import 'package:flutter_color_analyzer/palettes.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/view/calendar_list.dart';

Widget getCreateEditCalendar(BuildContext context, CalendarListModel calendarListModel,
    {required bool isCreate, CalendarSummaryModel existingCalendarSummaryModel}) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  final String title =
      isCreate ? localizations.createCalendarTitle : localizations.editCalendarTitle;

  return new WillPopScope(
      onWillPop: () {
        refreshListCalendars(context);
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SafeArea(
            child: new CreateEditCalendarForm(
                isCreate: isCreate,
                calendarListModel: calendarListModel,
                existingCalendarSummaryModel: existingCalendarSummaryModel),
            minimum: const EdgeInsets.symmetric(horizontal: 16.0),
          )));
}

class CreateEditCalendarForm extends StatefulWidget {
  final bool isCreate;
  final CalendarListModel calendarListModel;
  final CalendarSummaryModel existingCalendarSummaryModel;

  CreateEditCalendarForm(
      {required this.isCreate, this.calendarListModel, this.existingCalendarSummaryModel});

  @override
  State<StatefulWidget> createState() {
    return CreateEditCalendarFormState(calendarListModel, isCreate, existingCalendarSummaryModel);
  }
}

Widget createSimilarColorsWarning(
    final BigColor proposedColor,
    final CalendarListModel calendarListModel,
    CalendarSummaryModel existingCalendarSummaryModel,
    AppLocalizations localizations) {
  if (proposedColor == null) {
    return null;
  }
  final List<CalendarSummaryModel> existingCalendars =
      calendarListModel.getCalendarSummariesInNameOrder();
  final List<CalendarSummaryModel> conflictingCalendars = existingCalendars
      .where((calendar) => calendar != existingCalendarSummaryModel)
      .where((calendar) => !ColorAnalyzer.noticeablyDifferent(calendar.color, proposedColor))
      .toList();
  if (conflictingCalendars.isEmpty) {
    return null;
  }
  final List<Widget> listTiles = conflictingCalendars
      .map((calendar) => Card(
            child: ListTile(
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(color: calendar.color),
                ),
                title: Text(calendar.name)),
          ))
      .toList();
  return Container(
      child: Column(
    children: <Widget>[
      Padding(padding: const EdgeInsets.fromLTRB(0, 32.0, 0, 0)),
      Text(localizations.createEditCalendarSimilarColorsWarning),
      Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0)),
      ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: listTiles,
      ),
    ],
  ));
}

class CreateEditCalendarFormState extends State<CreateEditCalendarForm> {
  final bool isCreate;
  List<BigColor> recommendedColors;
  final CalendarListModel calendarListModel;
  final List<BigColor> existingCalendarColors;
  List<BigColor> colorsToOffer;
  final CalendarSummaryModel existingCalendarSummaryModel;
  final TextEditingController _name;
  BigColor currentColor;
  BigColor currentRecommendedColor;

  CreateEditCalendarFormState(final CalendarListModel calendarListModel, bool isCreate,
      CalendarSummaryModel existingCalendarSummaryModel)
      : this.isCreate = isCreate,
        this.calendarListModel = calendarListModel,
        this.existingCalendarColors = calendarListModel.getCalendarColors(),
        this.existingCalendarSummaryModel = existingCalendarSummaryModel,
        this._name = isCreate
            ? new TextEditingController()
            : new TextEditingController(text: existingCalendarSummaryModel.name) {
    if (existingCalendarSummaryModel != null) {
      currentColor = existingCalendarSummaryModel.color;
    }
    colorsToOffer = Palettes.getMaterialColorsInHueOrder([500, 800, 200]);
  }

  // Global key that uniquely identifies Form widget allows validation.
  final _formKey = GlobalKey<FormState>();

  void changeColor(Color color, BuildContext context) {
    setState(() {
      currentColor = color;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    final CalendarRepository calendarRepository =
        Provider.of<CalendarRepository>(context, listen: false);

    recommendedColors = Palettes.tableau10.where((paletteColor) {
      for (final BigColor existingCalendarColor in existingCalendarColors) {
        if (!ColorAnalyzer.noticeablyDifferent(existingCalendarColor, paletteColor)) {
          return false;
        }
      }
      if (currentColor != null && paletteColor == currentColor) {
        currentRecommendedColor = paletteColor;
        return true;
      }
      if (currentColor != null) {
        return ColorAnalyzer.noticeablyDifferent(currentColor, paletteColor);
      }
      return true;
    }).toList();
    if (currentRecommendedColor == null) {
      currentRecommendedColor = recommendedColors[0];
    }

    if (currentColor == null && existingCalendarSummaryModel == null) {
      Color proposedCurrentColor;
      if (recommendedColors.isNotEmpty) {
        proposedCurrentColor = recommendedColors[0];
      } else {
        proposedCurrentColor = colorsToOffer[0];
      }
      setState(() {
        currentColor = proposedCurrentColor;
      });
    }

    final Widget similarColorsWarning = createSimilarColorsWarning(
        currentColor, calendarListModel, existingCalendarSummaryModel, localizations);

    final Widget form = Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            controller: _name,
            validator: (input) => validateName(input, localizations),
            decoration: InputDecoration(
              labelText: localizations.createCalendarName,
            ),
          ),
          Row(
            children: <Widget>[
              Text(localizations.createCalendarColor),
              IconButton(
                icon: Icon(Icons.color_lens, color: currentColor),
                tooltip: localizations.createCalendarColor,
                iconSize: 48.0,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0.0),
                          contentPadding: const EdgeInsets.all(32.0),
                          content: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text("Recommended colors"),
                                BlockPicker(
                                  availableColors: recommendedColors,
                                  pickerColor: currentRecommendedColor,
                                  onColorChanged: (color) {
                                    changeColor(color, context);
                                  },
                                ),
                                Text("More colors"),
                                BlockPicker(
                                  availableColors: colorsToOffer,
                                  pickerColor:
                                      currentColor != null ? currentColor : colorsToOffer[0],
                                  onColorChanged: (color) {
                                    changeColor(color, context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
                child: Text(isCreate
                    ? localizations.createCalendarSubmitButton
                    : localizations.editCalendarSubmitButton),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.createCalendarCreatingCalendar)));
                  final userModel = Provider.of<UserModel>(context, listen: false);

                  final Future<void> future = isCreate
                      ? calendarRepository.createCalendar(
                          userId: userModel.userId,
                          sessionId: userModel.sessionId,
                          name: _name.text,
                          color: color3p.Color.rgb(
                                  currentColor.red, currentColor.green, currentColor.blue)
                              .toHexColor()
                              .toCssString(),
                        )
                      : calendarRepository.updateCalendarNameColor(
                          userModel: userModel,
                          calendarSummaryModel: existingCalendarSummaryModel,
                          name: _name.text,
                          color: color3p.Color.rgb(
                                  currentColor.red, currentColor.green, currentColor.blue)
                              .toHexColor()
                              .toCssString(),
                        );

                  future.then((_) {
                    Scaffold.of(context).removeCurrentSnackBar();
                    Navigator.maybePop(context);
                  }).catchError((err) {
                    Scaffold.of(context).removeCurrentSnackBar();
                    if (err is InternalServerErrorException) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.deepOrange,
                          content: Text(localizations.internalServerErrorException)));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.deepOrange,
                          content: Text("Unknown error occurred!!")));
                    }
                  });
                }),
          )
        ]));

    return Column(
      children: <Widget>[
        form,
        if (similarColorsWarning != null) similarColorsWarning,
      ],
    );
  }

  String validateName(String input, AppLocalizations appLocalizations) {
    if (input.isEmpty || input.trim().isEmpty) {
      return appLocalizations.createCalendarErrorNameEmpty;
    }
    if (input.length > 40) {
      return appLocalizations.createCalendarErrorNameTooLong;
    }
    return null;
  }
}
