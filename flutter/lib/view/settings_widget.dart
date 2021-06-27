import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:simple_tracker/main.dart';
import 'package:simple_tracker/state/app_preferences_model.dart';
import 'package:simple_tracker/view/static_text_widget.dart';

class SettingsWidget extends StatelessWidget {
  final AppPreferencesModel appPreferencesModel;

  SettingsWidget(this.appPreferencesModel);

  @override
  Widget build(BuildContext context) {
    Icon backIcon;
    if (Platform.isIOS) {
      backIcon = Icon(CupertinoIcons.back);
    } else {
      backIcon = Icon(Icons.arrow_back);
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("Settings"),
            leading: IconButton(
              icon: backIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SettingsListView(appPreferencesModel));
  }
}

String createAboutText(final String appVersion, final String appBuild) {
  return """## About Simple Calendar Tracker

**Version**: $appVersion build $appBuild
**Author**: Kitten Cat LLC

Please send comments, questions, and feedback to:

### **admin@kittencat.art**
""";
}

class SettingsListView extends StatelessWidget {
  final AppPreferencesModel appPreferencesModel;

  SettingsListView(this.appPreferencesModel);

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    final bool isDark = brightnessValue == Brightness.dark;
    final String aboutText = createAboutText(
        appPreferencesModel.appVersion!, appPreferencesModel.appBuildNumber!);

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
                  MaterialPageRoute(
                      builder: (context) => StaticTextWidget(
                          assetPath: 'assets/privacy_policy.md',
                          title: 'Privacy Policy')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Terms of Use'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StaticTextWidget(
                          assetPath: 'assets/terms_of_use.md',
                          title: 'Terms of Use')),
                );
              },
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: MarkdownBody(
                  data: aboutText,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    blockquoteDecoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue.withOpacity(0.4)
                          : Colors.blue.shade50,
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
