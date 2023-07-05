import 'package:app_cost/app.dart';
import 'package:app_cost/screens/create_new/create_new.dart';
import 'package:app_cost/widgets/button.dart';
import 'package:app_cost/widgets/text.dart';

import 'package:flutter/material.dart';

import 'widgets/projects_list.dart';

const String projectsText =
    "Hey, you can select drafts, finished projects or create a new project to estimate!";

class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(projectsText),
              SizedBox(height: 35),
              StreamBuilder(
                  initialData: ProjectsList(),
                  stream: App.model.projectsUpdate,
                  builder: (context, content) {
                    return ProjectsList();
                  }),
              SizedBox(height: 25),
              CustomButton(
                newContent: CreateNew(firstProject: false),
                text: "CREATE NEW",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
