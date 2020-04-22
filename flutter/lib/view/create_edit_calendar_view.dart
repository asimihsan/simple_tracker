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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/calendar_summary_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/view/calendar_list.dart';

Widget getCreateEditCalendar(BuildContext context,
    {@required bool isCreate, CalendarSummaryModel existingCalendarSummaryModel}) {
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
                isCreate: isCreate, existingCalendarSummaryModel: existingCalendarSummaryModel),
            minimum: const EdgeInsets.symmetric(horizontal: 16.0),
          )));
}

class CreateEditCalendarForm extends StatefulWidget {
  final bool isCreate;
  CalendarSummaryModel existingCalendarSummaryModel;

  CreateEditCalendarForm({@required this.isCreate, this.existingCalendarSummaryModel});

  @override
  State<StatefulWidget> createState() {
    return CreateEditCalendarFormState(isCreate, existingCalendarSummaryModel);
  }
}

class CreateEditCalendarFormState extends State<CreateEditCalendarForm> {
  final bool isCreate;
  final CalendarSummaryModel existingCalendarSummaryModel;
  final TextEditingController _name;
  Color currentColor = Colors.lightGreen;

  CreateEditCalendarFormState(bool isCreate, CalendarSummaryModel existingCalendarSummaryModel)
      : this.isCreate = isCreate,
        this.existingCalendarSummaryModel = existingCalendarSummaryModel,
        this._name = isCreate
            ? new TextEditingController()
            : new TextEditingController(text: existingCalendarSummaryModel.name) {
    if (existingCalendarSummaryModel != null) {
      currentColor = existingCalendarSummaryModel.color;
    }
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

    return Form(
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
                          contentPadding: const EdgeInsets.all(0.0),
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: currentColor,
                              onColorChanged: (color) {
                                changeColor(color, context);
                              },
                              enableLabel: false,
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
