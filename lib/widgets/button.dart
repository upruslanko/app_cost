import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:app_cost/app.dart';

class CustomButton extends StatelessWidget {
  final Widget newContent;
  final String text;
  final bool disabled;

  CustomButton({@required this.newContent, this.text, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.only(bottom: 40.0),
      child: FlatButton(
        onPressed: () => disabled ? null : onPressed(newContent, context),
        color: disabled ? Colors.grey : Colors.red,
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  onPressed(newContent, BuildContext context) {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
      Future.delayed(const Duration(milliseconds: 250),
          () => App.model.newContent(newContent));
    } else
      App.model.newContent(newContent);
  }

  /*_nextImage(PageController carousselController) {
    debug("Pushed scroll button");
    carousselController.nextPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }*/
}
