import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:app_cost/app.dart';
import 'package:app_cost/logic/option_selection.dart';
import 'package:app_cost/widgets/icon.dart';

class OptionSelector extends StatelessWidget {
  final String alias;
  final List options;
  final bool multiselection;

  OptionSelector({this.alias, this.options, this.multiselection = false});

  @override
  Widget build(BuildContext context) {
    List<int> order = [];
    List<Widget> children = [];
    List<Widget> defaultChildren = [];
    ValueNotifier previouslySelected = ValueNotifier(ValueNotifier(false));

    var optionPage = App.model.currentProject["optionSelection"][alias];

    for (int i = 0; i < options.length; i++) {
      var newNotifier = ValueNotifier(optionPage.contains(options[i]["title"]));
      if (newNotifier.value == true) previouslySelected.value = newNotifier;

      defaultChildren.insert(
          defaultChildren.length,
          iconWithText(
            options[i],
            newNotifier,
            previouslySelected,
            context,
          ));
    }

    switch (defaultChildren.length) {
      case 2:
        order = [1, 0];
        break;
      case 3:
        order = [0, 2, 1];
        break;
      case 4:
        order = [1, 0, 3, 2];
        break;
      default:
        order = [0];
    }

    order.forEach((index) => children.insert(0, defaultChildren[index]));

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: MediaQuery.of(context).size.width * 0.05,
        runSpacing: 15,
        alignment: WrapAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget iconWithText(Map localOptions, ValueNotifier selected,
      ValueNotifier previouslySelected, BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([selected, previouslySelected.value]),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 5,
                      color: selected.value ? Colors.red : Color(0x00000000)),
                  shape: BoxShape.circle,
                ),
                child: IconBlock(
                  assetPath: localOptions["assetPath"],
                ),
              ),
              onTap: () => onOptionSelection(alias, multiselection,
                  localOptions, selected, previouslySelected, context),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                localOptions["title"],
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    );
  }
}
