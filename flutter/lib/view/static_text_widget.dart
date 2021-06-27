import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

Future<String> loadText(BuildContext context, String path) async {
  final String text = await DefaultAssetBundle.of(context)
      .loadString(path);
  return text;
}

class StaticTextWidget extends StatefulWidget {
  final String assetPath;
  final String title;

  const StaticTextWidget({
    Key? key,
    required String this.assetPath,
    required String this.title
  }) : super(key: key);

  @override
  _StaticTextWidgetState createState() => _StaticTextWidgetState(assetPath, title);
}

class _StaticTextWidgetState extends State<StaticTextWidget> {
  late Future<String> _loadTextFuture;

  final String assetPath;
  final String title;

  _StaticTextWidgetState(String this.assetPath, String this.title);

  @override
  void initState() {
    super.initState();
    _loadTextFuture = loadText(context, this.assetPath);
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
            title: Text(this.title),
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
            child: FutureBuilder<String>(
              future: _loadTextFuture,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
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
