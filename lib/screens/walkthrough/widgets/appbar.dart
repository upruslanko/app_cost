import 'package:app_cost/app.dart';
import 'package:app_cost/screens/projects/projects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WalkthroughAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool backToProjects;

  WalkthroughAppbar({Key key, this.backToProjects = false})
      : preferredSize = Size.fromHeight(75),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([App.model.walkProgress, App.model.description]),
      builder: (context, child) {
        return Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: CustomIconButton(
                      type: "previousPage", backToProjects: backToProjects),
                  visible: (App.model.walkProgress.value > 1 &&
                          !App.model.description.value) ||
                      backToProjects,
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Text(
                    App.model.walkProgress.value.toString() +
                        "/" +
                        App.model.pages.length.toString(),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  visible: !App.model.description.value && !backToProjects,
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: CustomIconButton(
                      type: "close", backToProjects: backToProjects),
                  visible: !backToProjects,
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Color(0x00ffffff),
          ),
        );
      },
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String type;
  final bool backToProjects;

  CustomIconButton({@required this.type, this.backToProjects});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.all(0.0),
          icon: Icon(
            type == "close" ? Icons.close : Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => type == "previousPage" ? _previousPage() : _close(),
        ),
      ),
    );
  }

  void _close() {
    if (App.model.description.value) {
      App.model.description.value = false;
      App.model.newPage();
    } else {
      App.model.updateProjectsList();
      App.model.newContent(Projects());
    }
  }

  void _previousPage() {
    if (!backToProjects) {
      App.model.walkProgress.value--;

      App.model.isOptionSelectedUpdate();
      App.model.newPage();
    } else {
      App.model.updateProjectsList();
      App.model.newContent(Projects());
    }
  }
}
