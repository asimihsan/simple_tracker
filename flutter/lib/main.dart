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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_storage/local_storage.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/localizations.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/state/calendar_list_model.dart';
import 'package:simple_tracker/state/calendar_repository.dart';
import 'package:simple_tracker/state/user_model.dart';
import 'package:simple_tracker/state/user_repository.dart';
import 'package:simple_tracker/view/user_login.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
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
          )
        ],
        child: MaterialApp(
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
          home: FutureProvider<AppPreferencesModel>(
            create: (_) async {
              final AppPreferencesModel appPreferencesModel = new AppPreferencesModel();
              await appPreferencesModel.reload();
              return appPreferencesModel;
            },
            child: MyAppWithLocalizations(),
          ),
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

          final UserRepository userRepository = Provider.of<UserRepository>(context, listen: false);
          final UserModel userModel = Provider.of<UserModel>(context, listen: false);
          userRepository
              .loginUser(
                  username: appPreferencesModel.username,
                  password: appPreferencesModel.password,
                  providedUserModel: userModel)
              .then((_) async {
            developer.log("MyAppWithLocalizationsState user repository login finished success");
            switchToCalendarListView(context);
          }).catchError((err) async {
            developer.log("MyAppWithLocalizationsState user repository login finished error",
                error: err);
            await appPreferencesModel.clearUsernameAndPassword();
            switchToUserLogin(appPreferencesModel, context);
            return;
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

switchToUserLogin(AppPreferencesModel appPreferencesModel, BuildContext context) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Provider(
              create: (_) => appPreferencesModel,
              child: getUserLogin(context, appPreferencesModel, isSignupForm: false))));
}
