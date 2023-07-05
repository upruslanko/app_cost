import 'package:app_cost/app.dart';
import 'package:app_cost/screens/walkthrough/widgets/page_widgets/additional.dart';
import 'package:flutter/material.dart';

import 'package:app_cost/widgets/text.dart';

import 'page_widgets/button.dart';
import 'page_widgets/misc.dart';
import 'page_widgets/estimate.dart';
import 'page_widgets/option_selector.dart';

class CustomPage extends StatelessWidget {
  final String type;
  final String alias;
  final String title;
  final List options;

  CustomPage({this.type, this.alias, this.title, this.options});

  factory CustomPage.fromJson(Map<String, dynamic> json) {
    return CustomPage(
      type: json['type'] as String ?? "option_selector",
      alias: json['alias'] as String ?? "",
      title: json['title'] as String,
      options: json['options'] as List ?? List(),
    );
  }

  int descriptionCounter() {
    int count = 0;
    options.forEach((element) {
      if (element["description"] != null) count++;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              TitleText(title),
              descriptionCounter() > 0 ? Description() : SizedBox.shrink(),
              type.contains("multiselection") && !type.contains("noinfo")
                  ? MultiselectionNote()
                  : SizedBox.shrink(),
            ],
          ),
        ),
        type.contains("additional")
            ? AdditionalOptions()
            : OptionSelector(
                alias: alias,
                options: options,
                multiselection: type.contains("multiselection"),
              ),
        ValueListenableBuilder(
          valueListenable: App.model.keyboardVisibility,
          builder: (context, keyboardVisibility, child) {
            return Visibility(
              visible: !keyboardVisibility,
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Estimate(),
                    visible: App.model.walkProgress.value > 1,
                  ),
                  ValueListenableBuilder(
                    valueListenable: App.model.isOptionSelected,
                    builder: (context, isOptionSelected, child) {
                      var text = type.contains("skip") && !isOptionSelected
                          ? "SKIP"
                          : "CONTINUE";
                      if (App.model.walkProgress.value ==
                          App.model.pages.length) text = "FINISH";
                      return ContinueButton(
                        text: text,
                        disabled: !isOptionSelected && !type.contains("skip"),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
