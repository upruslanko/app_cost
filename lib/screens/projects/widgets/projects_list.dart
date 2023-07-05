import 'package:flutter/material.dart';
import 'package:app_cost/app.dart';
import 'package:app_cost/logic/option_selection.dart';

import 'button.dart';
import 'progress_bar.dart';

class ProjectsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: App.model.projects.length,
        itemBuilder: (context, index) {
          return ProjectElement(App.model.projects[index]);
        },
      ),
    );
  }
}

class ProjectElement extends StatelessWidget {
  final Map<String, dynamic> project;

  ProjectElement(this.project);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.75),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(project['name'],
                    style: Theme.of(context).textTheme.headline3),
                DeleteProject(project),
              ],
            ),
            SizedBox(height: 5),
            ProgressBar(project),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.subtitle2,
                    children: <TextSpan>[
                      TextSpan(text: 'Estimate: '),
                      TextSpan(
                          text: '${calculateEstimate(project).toInt()}h',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ContinueButton(project),
              ],
            )
          ],
        ),
      ),
    );
  }
}
