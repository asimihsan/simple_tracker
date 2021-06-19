import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:simple_tracker/main.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/view/privacy_policy_widget.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Icon backIcon;
    if (Platform.isIOS) {
      backIcon = new Icon(CupertinoIcons.back);
    } else {
      backIcon = new Icon(Icons.arrow_back);
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("Settings"),
            leading: new IconButton(
              icon: backIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SettingsListView());
  }
}

String createAboutText(final String appVersion, final String appBuild) {
  return """## About Simple Calendar Tracker

**Version**: $appVersion build $appBuild
**Author**: Asim Ihsan

Please send comments, questions, and feedback to:

### **simple-calendar-tracker@gmail.com**
""";
}

class SettingsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightnessValue == Brightness.dark;
    final AppPreferencesModel appPreferencesModel =
        Provider.of<AppPreferencesModel>(context, listen: false);
    final String aboutText =
        createAboutText(appPreferencesModel.appVersion!, appPreferencesModel.appBuildNumber!);

    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Log out'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                final BuildContext contextCopy = context;
                await appPreferencesModel.clear();
                await switchToUserLogin(appPreferencesModel, contextCopy);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Privacy policy'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyWidget()),
                );
              },
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: MarkdownBody(
                  data: aboutText,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    blockquoteDecoration: BoxDecoration(
                      color: isDark ? Colors.blue.withOpacity(0.4) : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  )),
            ),
          ),
        ],
      ),
    ));
  }
}
