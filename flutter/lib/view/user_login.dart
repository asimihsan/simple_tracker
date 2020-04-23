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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';
import 'package:simple_tracker/exception/UserMissingOrPasswordIncorrectException.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/state/user_repository.dart';
import 'package:simple_tracker/view/calendar_list.dart';

Widget getUserLogin(BuildContext context, {bool isSignupForm}) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations);
  final String title =
      isSignupForm ? localizations.userLoginSignupTitle : localizations.userLoginLoginTitle;
  Widget child = UserLoginForm(isSignupForm);
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: SafeArea(
      child: child,
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

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  final bool isSignupForm;

  UserLoginFormState(this.isSignupForm);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
    final AppPreferencesModel appPreferencesModel =
        Provider.of<AppPreferencesModel>(context, listen: false);

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
            controller: _username,
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
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(localizations.userLoginProcessingData)));
                  final providedUserModel = Provider.of<UserModel>(context, listen: false);
                  if (isSignupForm) {
                    userRepository
                        .createUser(
                            username: _username.text,
                            password: _password.text,
                            providedUserModel: providedUserModel)
                        .then((_) async {
                      developer.log("UserLoginFormState user repository create finished success");
                      await appPreferencesModel.setUsernameAndPassword(
                          _username.text, _password.text);
                      Scaffold.of(context).removeCurrentSnackBar();
                      switchToCalendarListView(context);
                    }).catchError((err) {
                      developer.log("UserLoginFormState user repository create finished error",
                          error: err);
                    });
                  } else {
                    userRepository
                        .loginUser(
                            username: _username.text,
                            password: _password.text,
                            providedUserModel: providedUserModel)
                        .then((_) async {
                      developer.log("UserLoginFormState user repository login finished success");
                      await appPreferencesModel.setUsernameAndPassword(
                          _username.text, _password.text);
                      Scaffold.of(context).removeCurrentSnackBar();
                      switchToCalendarListView(context);
                    }).catchError((err) {
                      developer.log("UserLoginFormState user repository login finished error",
                          error: err);
                      Scaffold.of(context).removeCurrentSnackBar();
                      if (err is UserMissingOrPasswordIncorrectException) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text(
                                localizations.userLoginUserMissingOrPasswordIncorrectException)));
                      } else if (err is InternalServerErrorException) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text(localizations.internalServerErrorException)));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text("Unknown error occurred!!")));
                      }
                    });
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

void switchToCalendarListView(BuildContext context) {
  developer.log("switching to calendar list view");
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => getCalendarList(context)));
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
  return validatePassword(input, appLocalizations);
}
