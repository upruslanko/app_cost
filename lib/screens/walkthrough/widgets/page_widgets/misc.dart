import 'package:app_cost/app.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        App.model.description.value = true,
        App.model.newPage(),
      },
      child: Text(
        "details",
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

class MultiselectionNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Text(
        "(you can select all fields or do not choose anything if you do not need)",
        style: Theme.of(context).textTheme.subtitle2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
