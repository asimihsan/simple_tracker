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

Widget getUserLogin(BuildContext context, {bool isSignupForm}) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);
  final String title =
      isSignupForm ? localizations.userLoginSignupTitle : localizations.userLoginLoginTitle;

  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: SafeArea(
      child: UserLoginForm(isSignupForm),
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  );
}

class UserLoginForm extends StatefulWidget {
  final bool isSignupForm;

  UserLoginForm(this.isSignupForm);

  @override
  State<StatefulWidget> createState() {
    return UserLoginFormState(isSignupForm);
  }
}

class UserLoginFormState extends State<UserLoginForm> {
  // Global key that uniquely identifies Form widget allows validation.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _password = new TextEditingController();

  final bool isSignupForm;

  UserLoginFormState(this.isSignupForm);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    final TextSpan switchLink = isSignupForm
        ? new TextSpan(
            text: localizations.userLoginLoginAsExistingUser,
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                switchToUserLoginHandler(context);
              })
        : new TextSpan(
            text: localizations.userLoginSignUpAsANewUser,
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                switchToUserSignupHandler(context);
              });

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
            controller: _password,
            validator: (input) => validatePassword(input, localizations),
            decoration: InputDecoration(
              labelText: localizations.userLoginPassword,
            ),
          ),
          if (isSignupForm)
            TextFormField(
              validator: (input) => validateConfirmPassword(input, _password.text, localizations),
              decoration: InputDecoration(
                labelText: localizations.userLoginConfirmPassword,
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
                child: Text(localizations.userLoginSubmitButton),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: new Center(
                child: new RichText(
                    text: new TextSpan(
              children: [switchLink],
            ))),
          ),
        ]));
  }
}

void switchToUserSignupHandler(BuildContext context) {
  developer.log("Sign up click");
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => getUserLogin(context, isSignupForm: true)));
}

void switchToUserLoginHandler(BuildContext context) {
  developer.log("Log in click");
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => getUserLogin(context, isSignupForm: false)));
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

String validateConfirmPassword(
    String input, String firstPassword, AppLocalizations appLocalizations) {
  if (input != firstPassword) {
    return appLocalizations.userLoginConfirmPasswordDoesNotMatch;
  }
  String basicPasswordValidation = validatePassword(input, appLocalizations);
  if (basicPasswordValidation != null) {
    return basicPasswordValidation;
  }
  return null;
}
