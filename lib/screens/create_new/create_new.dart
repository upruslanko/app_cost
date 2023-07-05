import 'package:app_cost/screens/walkthrough/widgets/appbar.dart';
import 'package:flutter/material.dart';

import 'package:app_cost/widgets/icon.dart';
import 'package:app_cost/widgets/text.dart';

import 'widgets/input_form.dart';

const assetPath = "lib/assets/walkthrough/chemistry.png";

const String createFirstText =
    "Hey, you have no projects to estimate. Tap the button and let’s go!";

const String createNewText = "Create a new project";

class CreateNew extends StatelessWidget {
  final bool firstProject;

  CreateNew({@required this.firstProject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !firstProject ? WalkthroughAppbar(backToProjects: true) : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: firstProject
                      ? MediaQuery.of(context).size.height * 0.1
                      : MediaQuery.of(context).size.height * 0.02),
              child: TitleText(firstProject ? createFirstText : createNewText),
            ),
            IconBlock(assetPath: assetPath),
            InputForm(hintText: "Project name..."),
          ],
        ),
      ),
    );
  }
}
