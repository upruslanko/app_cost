import 'package:app_cost/app.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Map project;

  ProgressBar(this.project);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          width: 120,
          height: 14,
          child: LinearProgressIndicator(
            value: App.model.howManyOptionsSet(project) /
                project["optionSelection"].length,
            valueColor: AlwaysStoppedAnimation<Color>(
                App.model.howManyOptionsSet(project) ==
                        project["optionSelection"].length
                    ? Colors.green
                    : Colors.red),
            backgroundColor: Colors.grey,
          ),
        ),
        Text(
            "${App.model.howManyOptionsSet(project)}/${project["optionSelection"].length} steps",
            style: Theme.of(context).textTheme.subtitle2)
      ],
    );
  }
}
