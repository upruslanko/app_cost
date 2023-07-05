import 'package:app_cost/app.dart';
import 'package:flutter/material.dart';

class Estimate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: App.model.estimate,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: <TextSpan>[
                TextSpan(text: 'Estimate: '),
                TextSpan(
                    text: '${value.toInt()}h',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
