import 'package:app_cost/app.dart';
import 'package:app_cost/logic/projects.dart';
import 'package:app_cost/screens/create_new/create_new.dart';
import 'package:app_cost/screens/walkthrough/walkthrough.dart';
import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final Map project;

  ContinueButton(this.project);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isProjectDone() ? Colors.green : Colors.red,
      ),
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: IconButton(
          icon: Icon(
            Icons.arrow_right,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () => continueProject()),
    );
  }

  bool isProjectDone() {
    return App.model.howManyOptionsSet(project) ==
        project["optionSelection"].length;
  }

  continueProject() {
    project["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    writeProjects(project);

    App.model.currentProject = project;
    App.model.newContent(Walkthrough());
  }
}

class DeleteProject extends StatelessWidget {
  final Map project;

  DeleteProject(this.project);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      width: 30,
      height: 30,
      alignment: Alignment.center,
      child: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 15,
          ),
          onPressed: () {
            bool lastProject = App.model.projects.length == 1;
            final deleteSnackBar = SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                content: Container(
                  height: 20,
                  margin: EdgeInsets.only(left: 20, right: 10),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    lastProject ? "Are you sure?" : 'Project deleted.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                duration: Duration(seconds: 7),
                action: SnackBarAction(
                    label: lastProject ? "YES" : "UNDO",
                    textColor: Colors.red,
                    onPressed: () {
                      if (lastProject) {
                        deleteProject(project)
                            .then((value) => App.model.updateProjectsList());
                        App.model.newContent(CreateNew(firstProject: true));
                      } else
                        writeProjects(project, newProject: true)
                            .then((value) => App.model.updateProjectsList());
                    }));

            if (App.model.projects.length > 1)
              deleteProject(project)
                  .then((value) => App.model.updateProjectsList());

            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(deleteSnackBar);
          }),
    );
  }
}

class DeleteProjectNotification extends Notification {
  final Map project;
  final bool undo;

  DeleteProjectNotification(this.project, {this.undo = false});
}
