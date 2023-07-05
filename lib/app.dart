//app.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:app_cost/logic/models.dart';
import 'package:app_cost/logic/projects.dart';

import 'screens/create_new/create_new.dart';
import 'screens/projects/projects.dart';
import 'screens/welcome/welcome.dart';
import 'style.dart';

class App extends StatelessWidget {
  static AppModel model = AppModel();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return true;
      },
      child: MaterialApp(
        theme: _theme(),
        home: AppContent(),
      ),
    );
  }

  ThemeData _theme() {
    return ThemeData(
      scaffoldBackgroundColor: Color(0xffebeff2),
      textTheme: TextTheme(
        headline1: Headline1TextStyle,
        headline2: Headline2TextStyle,
        headline3: Headline3TextStyle,
        headline6: ClickableTextTextStyle,
        subtitle1: EstimateTextStyle,
        subtitle2: DescriptionTextTextStyle,
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  @override
  _AppContentState createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    KeyboardVisibility.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      App.model.keyboardVisibility.value = visible;
    });

    parsePages().then((value) => App.model.pages = value);

    readProjects().then((value) => App.model.projects = value);

    writeMisc({}).then((misc) {
      App.model.firestoreUser =
          Firestore.instance.collection("users").document(misc["id"]);
      App.model.firestoreUser.get().then((value) =>
          value.data ??
          App.model.firestoreUser.setData(Map.fromIterable(
              ["projects", "contact"],
              key: (e) => e, value: (e) => null)));

      misc["showWelcome"]
          ? App.model.newContent(Welcome())
          : readProjects().then((projects) {
              App.model.projects = projects;
              App.model.newContent(projects.length == 0
                  ? CreateNew(firstProject: true)
                  : Projects());
            });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: Projects(),
      stream: App.model.contentUpdates,
      builder: (context, content) {
        return content.data;
      },
    );
  }
}
