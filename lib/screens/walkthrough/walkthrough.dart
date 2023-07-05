import 'package:app_cost/app.dart';
import 'package:app_cost/logic/option_selection.dart';
import 'package:flutter/material.dart';

import 'widgets/appbar.dart';
import 'widgets/page.dart';

class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    App.model.walkProgress.value =
        App.model.howManyOptionsSet(App.model.currentProject);
    if (App.model.walkProgress.value < App.model.pages.length)
      App.model.walkProgress.value++;

    App.model.estimate.value = calculateEstimate(App.model.currentProject);
    App.model.isOptionSelectedUpdate();

    return StreamBuilder(
      initialData: CustomPage.fromJson(
          App.model.pages[App.model.walkProgress.value - 1]),
      stream: App.model.pageUpdates,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: WalkthroughAppbar(),
          body: snapshot.data,
        );
      },
    );
  }
}

// TODO: Projects page with futurebuilder
