import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Future<String> loadPrivacyPolicyText(BuildContext context) async {
  final String text = await DefaultAssetBundle.of(context)
      .loadString('assets/PRIVACY_POLICY.md');
  developer.log(text);
  return text;
}

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyWidgetState createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  Future<String>? privacyPolicyTextFuture;

  @override
  void initState() {
    super.initState();
    privacyPolicyTextFuture = loadPrivacyPolicyText(context);
  }

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
            title: Text("Privacy Policy"),
            leading: IconButton(
              icon: backIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder(
              future: privacyPolicyTextFuture!,
              builder: (context, snapshot) {
                final Brightness brightnessValue =
                    MediaQuery.of(context).platformBrightness;
                bool isDark = brightnessValue == Brightness.dark;
                final String data;
                if (snapshot.data == null) {
                  data = "";
                } else {
                  data = snapshot.data as String;
                }
                return MarkdownBody(
                    data: data,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      blockquoteDecoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue.withOpacity(0.4)
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ));
              },
            ),
          ),
        ));
  }
}
