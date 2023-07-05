import 'package:flutter/material.dart';

import 'package:app_cost/app.dart';
import 'package:app_cost/logic/projects.dart';
import 'package:app_cost/widgets/button.dart';

class CreateButton extends CustomButton {
  final String projectTitle;
  final Widget newContent;
  final String text;
  final bool disabled;

  CreateButton({this.projectTitle, this.newContent, this.text, this.disabled});

  @override
  onPressed(newContent, BuildContext context) {
    App.model.currentProject = {
      "name": projectTitle,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "optionSelection": {
        for (var page in App.model.pages) page["alias"]: List<String>()
      },
      "estimateOptions": {
        "multiplier": 1.0,
        "multHours": 0.0,
        "constHours": 0.0,
        "previousEstimate": Map(),
      },
    };

    writeProjects(App.model.currentProject, newProject: true);
    return super.onPressed(newContent, context);
  }
}
