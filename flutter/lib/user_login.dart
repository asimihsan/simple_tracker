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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_tracker/localizations.dart';
import 'dart:developer' as developer;

Widget getUserLogin(BuildContext context) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  return Scaffold(
    appBar: AppBar(
      //title: Text(localizations.userLoginTitle),
      title: Text('Login'),
    ),
    body: SafeArea(
      child: UserLoginForm(),
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  );
}

class UserLoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserLoginFormState();
  }
}

class UserLoginFormState extends State<UserLoginForm> {
  // Global key that uniquely identifies Form widget allows validation.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            validator: (input) => validateUsername(input, localizations),
            decoration: InputDecoration(
              labelText: localizations.userLoginUsername,
            ),
          ),
          TextFormField(
            validator: (input) => validatePassword(input, localizations),
            decoration: InputDecoration(
              labelText: localizations.userLoginPassword,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.userLoginProcessingData)));
                  }
                },
                child: Text("Submit"),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: new Center(
                child: new RichText(
                    text: new TextSpan(
              children: [
                new TextSpan(
                    text: "Sign up as a new user",
                    style: new TextStyle(color: Colors.blue),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        developer.log("Sign up click");
                      }),
              ],
            ))),
          ),
        ]));
  }
}

String validateUsername(String input, AppLocalizations appLocalizations) {
  if (input.isEmpty) {
    return appLocalizations.userLoginErrorUsernameEmpty;
  }
  if (input.length < 4) {
    return appLocalizations.userLoginErrorUsernameTooShort;
  }
  if (input.length > 40) {
    return appLocalizations.userLoginErrorUsernameTooLong;
  }
  var validUsernameRe = new RegExp(r"^[A-Za-z0-9_\-\.]+$",
      multiLine: false, caseSensitive: true, unicode: false, dotAll: false);
  if (!validUsernameRe.hasMatch(input)) {
    return appLocalizations.userLoginErrorUsernameInvalidChars;
  }
  return null;
}

String validatePassword(String input, AppLocalizations appLocalizations) {
  if (input.isEmpty) {
    return appLocalizations.userLoginErrorPasswordEmpty;
  }
  if (input.length > 128) {
    return appLocalizations.userLoginErrorPasswordTooLong;
  }
  return null;
}
