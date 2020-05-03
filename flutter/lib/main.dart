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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/exception/NoExistingSessionToReuseException.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/state/user_repository.dart';
import 'package:simple_tracker/view/user_login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          FutureProvider<AppPreferencesModel>(
            create: (_) async {
              final AppPreferencesModel appPreferencesModel = new AppPreferencesModel();
              await appPreferencesModel.reload();
              return appPreferencesModel;
            },
          ),
          Provider(
            create: (_) => new UserModel.notLoggedIn(),
          ),
          ListenableProvider(
            create: (_) => new CalendarListModel(),
          ),
          Provider(
            create: (_) => new CalendarRepository("https://preprod-simple-tracker.ihsan.io/"),
          ),
          Provider(
            create: (_) => new UserRepository("https://preprod-simple-tracker.ihsan.io/"),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale.fromSubtags(languageCode: 'en'),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyAppWithLocalizations(),
        ));
  }
}

class MyAppWithLocalizations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppWithLocalizationsState();
}

class MyAppWithLocalizationsState extends State<MyAppWithLocalizations> {
  bool movingToNextView = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppPreferencesModel>(builder: (context, appPreferencesModel, child) {
      if (appPreferencesModel != null && movingToNextView == false) {
        // TODO racey! Surely there is an easier and less racey way of injecting Future-provided
        // preferences.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            movingToNextView = true;
          });
          if (appPreferencesModel.username == "") {
            switchToUserLogin(appPreferencesModel, context);
            return;
          }

          // We might have a valid session ID to re-use, so try that first before logging in from
          // scratch. Logging in is slow because the server hashes the password using Argon2id.
          final CalendarRepository calendarRepository =
              Provider.of<CalendarRepository>(context, listen: false);
          final CalendarListModel calendarListModel =
              Provider.of<CalendarListModel>(context, listen: false);
          final UserModel userModel = Provider.of<UserModel>(context, listen: false);

          Future future;
          if (appPreferencesModel.sessionId != "") {
            future = calendarRepository.listCalendars(
                userId: appPreferencesModel.userId,
                sessionId: appPreferencesModel.sessionId,
                maxResults: 1,
                calendarListModel: calendarListModel);
          } else {
            future = Future.error(new NoExistingSessionToReuseException());
          }
          future.then((_) async {
            developer.log("MyAppWithLocalizationsState user repository list calendars success");
            userModel.login(appPreferencesModel.userId, appPreferencesModel.sessionId);
            await switchToCalendarListView(context);
          }).catchError((listCalendarErr) async {
            await appPreferencesModel.clearUserIdAndSessionId();
            developer.log("MyAppWithLocalizationsState user repository list calendars failed",
                error: listCalendarErr);
            final UserRepository userRepository =
                Provider.of<UserRepository>(context, listen: false);
            userRepository
                .loginUser(
                    username: appPreferencesModel.username,
                    password: appPreferencesModel.password,
                    providedUserModel: userModel)
                .then((_) async {
              developer.log("MyAppWithLocalizationsState user repository login finished success");
              await appPreferencesModel.setUserIdAndSessionId(
                  userModel.userId, userModel.sessionId);
              await switchToCalendarListView(context);
            }).catchError((userLoginErr) async {
              developer.log("MyAppWithLocalizationsState user repository login finished error",
                  error: userLoginErr);
              await appPreferencesModel.clearCredentials();
              await switchToUserLogin(appPreferencesModel, context);
              return;
            });
          });
        });
      }
      return Scaffold(
          appBar: AppBar(
            title: Text('Loading...'),
          ),
          body: SafeArea(
            child: new CircularProgressIndicator(),
            minimum: const EdgeInsets.symmetric(horizontal: 16.0),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
  }
}

Future<void> switchToUserLogin(
    AppPreferencesModel appPreferencesModel, BuildContext context) async {
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Provider(
              create: (_) => appPreferencesModel,
              child: getUserLogin(context, appPreferencesModel, isSignupForm: false))));
}
