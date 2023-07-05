import 'package:flutter/material.dart';

import 'package:app_cost/logic/projects.dart';
import 'package:app_cost/widgets/button.dart';

class WelcomeButton extends CustomButton {
  final Widget newContent;
  final String text;
  final bool disabled;

  WelcomeButton({this.newContent, this.text, this.disabled});

  @override
  onPressed(newContent, BuildContext context) {
    writeMisc({"showWelcome": false});
    return super.onPressed(newContent, context);
  }
}
