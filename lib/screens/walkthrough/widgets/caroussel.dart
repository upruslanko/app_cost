import 'package:flutter/material.dart';

import 'package:app_cost/widgets/caroussel_box.dart';
import 'package:app_cost/widgets/view_page.dart';
import 'package:app_cost/widgets/icon.dart';

class CarousselWithAssets extends StatelessWidget {
  final PageController carousselController = PageController();
  final ValueNotifier activePage = ValueNotifier(0);

  final List options;

  CarousselWithAssets(this.options);

  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: activePage,
        builder: (context, value, child) {
          return Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            height: MediaQuery.of(context).size.width * 0.85 +
                MediaQuery.of(context).size.width / 3,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CarousselBox(
                    child: PageView(
                      controller: carousselController,
                      onPageChanged: (page) => value = page,
                      children: List.generate(
                        options.length,
                        (index) => page(options[index], context),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: IconBlock(assetPath: options[value]["assetPath"]),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.05),
                  alignment: Alignment.bottomCenter,
                  child: ViewPage(options.length, value),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget page(Map option, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 4.5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Text(
              "Choose ${option['title']} when:",
              style: Theme.of(context).textTheme.headline3,
            ),
            Container(
              margin: EdgeInsets.only(top: 7.5),
              child: Text(
                option['description'],
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
