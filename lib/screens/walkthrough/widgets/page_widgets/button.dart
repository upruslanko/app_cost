import 'package:app_cost/screens/contact/contact.dart';
import 'package:app_cost/widgets/text.dart';
import 'package:flutter/material.dart';

import 'package:app_cost/app.dart';
import 'package:app_cost/widgets/button.dart';

import 'package:app_cost/logic/pdf.dart';
import 'package:app_cost/logic/projects.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';

class ContinueButton extends CustomButton {
  final String text;
  final bool disabled;

  ContinueButton({this.text, this.disabled = false});

  @override
  onPressed(content, BuildContext context) {
    // debug(
    //     "Page ${App.model.walkProgress.value} options: ${App.model.currentlySelected(text: true)}");

    App.model.currentProject["timestamp"] =
        DateTime.now().millisecondsSinceEpoch;
    writeProjects(App.model.currentProject);

    if (App.model.walkProgress.value == App.model.pages.length) {
      if (App.model.currentProject["optionSelection"]
              [App.model.pages[App.model.walkProgress.value - 1]["alias"]][0] ==
          App.model.pages[App.model.walkProgress.value - 1]["options"][2]
              ["title"])
        savePdf(App.model.currentProject, App.model.pages).then((path) =>
            showDialog(
                context: context,
                builder: (_) => pdfDialog(path, context),
                barrierDismissible: true));
      else if (App.model.currentProject["optionSelection"]
              [App.model.pages[App.model.walkProgress.value - 1]["alias"]][0] ==
          App.model.pages[App.model.walkProgress.value - 1]["options"][1]
              ["title"]) {
        savePdf(App.model.currentProject, App.model.pages, export: true);
        App.model.newContent(Contact());
      }
    } else {
      if (App.model.currentlySelected().length == 0 &&
          !App.model.currentPageOptions().contains("None"))
        App.model.currentPageOptions().add("None");

      App.model.walkProgress.value++;
      App.model.isOptionSelectedUpdate();
      App.model.newPage();
    }
  }
}

Widget pdfDialog(String path, BuildContext context) {
  return AlertDialog(
    title: TitleText("Preview ${path.split("/").last}"),
    elevation: 10,
    contentPadding: EdgeInsets.only(top: 20, right: 10, left: 10),
    content: Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: PDFView(
        filePath: path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageSnap: false,
        pageFling: false,
      ),
    ),
    actions: [
      FlatButton(
        child: Text("CLOSE"),
        textColor: Colors.red,
        onPressed: () => Navigator.of(context).pop(),
      ),
      FlatButton(
        child: Text("OPEN PDF"),
        textColor: Colors.red,
        onPressed: () => OpenFile.open(path),
      ),
      FlatButton(
        child: Text("CONTINUE"),
        textColor: Colors.red,
        onPressed: () {
          Navigator.of(context).pop();
          App.model.newContent(Contact());
        },
      ),
    ],
  );
}
