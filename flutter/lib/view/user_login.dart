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
import 'package:simple_tracker/exception/UserAlreadyExistsException.dart';
import 'package:simple_tracker/exception/UserMissingOrPasswordIncorrectException.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/state/user_repository.dart';
import 'package:simple_tracker/view/calendar_list.dart';
import 'package:simple_tracker/view/settings_widget.dart';

Widget getUserLogin(
    BuildContext context, AppPreferencesModel appPreferencesModel,
    {required bool isSignupForm}) {
  final AppLocalizations localizations =
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  final String title = isSignupForm
      ? localizations.userLoginSignupTitle
      : localizations.userLoginLoginTitle;
  final Widget child = Provider(
      create: (_) => appPreferencesModel, child: UserLoginForm(isSignupForm));
  final Widget settingsWidget = Provider(
      create: (_) => appPreferencesModel, child: SettingsWidget(),
  );
  return Scaffold(
    appBar: AppBar(title: Text(title), actions: <Widget>[
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_context) => settingsWidget),
            );
          }),
    ]),
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

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final bool isSignupForm;

  UserLoginFormState(this.isSignupForm);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    final AppPreferencesModel appPreferencesModel =
        Provider.of<AppPreferencesModel>(context, listen: false);

    final TextSpan switchLink = isSignupForm
        ? TextSpan(
            text: localizations.userLoginLoginAsExistingUser,
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                switchToUserLoginHandler(appPreferencesModel, context);
              })
        : TextSpan(
            text: localizations.userLoginSignUpAsANewUser,
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                switchToUserSignupHandler(appPreferencesModel, context);
              });

    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            controller: _username,
            validator: (input) => validateUsername(input!, localizations),
            decoration: InputDecoration(
              labelText: localizations.userLoginUsername,
            ),
          ),
          TextFormField(
            controller: _password,
            validator: (input) => validatePassword(input!, localizations),
            decoration: InputDecoration(
              labelText: localizations.userLoginPassword,
            ),
          ),
          if (isSignupForm)
            TextFormField(
              validator: (input) => validateConfirmPassword(
                  input!, _password.text, localizations),
              decoration: InputDecoration(
                labelText: localizations.userLoginConfirmPassword,
              ),
            ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(localizations.userLoginProcessingData)));
                  final providedUserModel =
                      Provider.of<UserModel>(context, listen: false);
                  if (isSignupForm) {
                    userRepository
                        .createUser(
                            username: _username.text,
                            password: _password.text,
                            providedUserModel: providedUserModel)
                        .then((_) async {
                      developer.log(
                          "UserLoginFormState user repository create finished success");
                      await appPreferencesModel.setCredentials(
                          providedUserModel.userId!,
                          providedUserModel.sessionId!);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      switchToCalendarListView(context);
                    }).catchError((err) async {
                      developer.log(
                          "UserLoginFormState user repository create finished error",
                          error: err);
                      await appPreferencesModel.clearCredentials();
                      if (err is UserAlreadyExistsException) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text("User already exists!")));
                      } else if (err is InternalServerErrorException) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text(
                                localizations.internalServerErrorException)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text("Unknown error occurred!!")));
                      }
                    });
                  } else {
                    userRepository
                        .loginUser(
                            username: _username.text,
                            password: _password.text,
                            providedUserModel: providedUserModel)
                        .then((_) async {
                      developer.log(
                          "UserLoginFormState user repository login finished success");
                      await appPreferencesModel.setCredentials(
                          providedUserModel.userId!,
                          providedUserModel.sessionId!);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      switchToCalendarListView(context);
                    }).catchError((err) async {
                      developer.log(
                          "UserLoginFormState user repository login finished error",
                          error: err);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      await appPreferencesModel.clearCredentials();
                      if (err is UserMissingOrPasswordIncorrectException) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text(localizations
                                .userLoginUserMissingOrPasswordIncorrectException)));
                      } else if (err is InternalServerErrorException) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.deepOrange,
                            content: Text(
                                localizations.internalServerErrorException)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            child: Center(
                child: RichText(
                    text: TextSpan(
              children: [switchLink],
            ))),
          ),
        ]));
  }
}

void switchToUserSignupHandler(
    AppPreferencesModel appPreferencesModel, BuildContext context) {
  developer.log("Sign up click");
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              getUserLogin(context, appPreferencesModel, isSignupForm: true)));
}

void switchToUserLoginHandler(
    AppPreferencesModel appPreferencesModel, BuildContext context) {
  developer.log("Log in click");
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              getUserLogin(context, appPreferencesModel, isSignupForm: false)));
}

Future<void> switchToCalendarListView(BuildContext context,
    {Exception? error}) async {
  developer.log("switching to calendar list view");
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => getCalendarList(context, error: error)));
}

String? validateUsername(String input, AppLocalizations appLocalizations) {
  if (input.isEmpty) {
    return appLocalizations.userLoginErrorUsernameEmpty;
  }
  if (input.length < 4) {
    return appLocalizations.userLoginErrorUsernameTooShort;
  }
  if (input.length > 40) {
    return appLocalizations.userLoginErrorUsernameTooLong;
  }
  var validUsernameRe = RegExp(r"^[A-Za-z0-9_\-\.]+$",
      multiLine: false, caseSensitive: true, unicode: false, dotAll: false);
  if (!validUsernameRe.hasMatch(input)) {
    return appLocalizations.userLoginErrorUsernameInvalidChars;
  }
  return null;
}

String? validatePassword(String input, AppLocalizations appLocalizations) {
  if (input.isEmpty) {
    return appLocalizations.userLoginErrorPasswordEmpty;
  }
  if (input.length > 128) {
    return appLocalizations.userLoginErrorPasswordTooLong;
  }
  return null;
}

String? validateConfirmPassword(
    String input, String firstPassword, AppLocalizations appLocalizations) {
  if (input != firstPassword) {
    return appLocalizations.userLoginConfirmPasswordDoesNotMatch;
  }
  return validatePassword(input, appLocalizations);
}
