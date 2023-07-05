import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:app_cost/widgets/caroussel_box.dart';
import 'package:app_cost/widgets/view_page.dart';

class WelcomeCaroussel extends StatelessWidget {
  final PageController carousselController = PageController();
  final ValueNotifier<int> activePage;
  final List welcomeOptions;

  WelcomeCaroussel(this.welcomeOptions, this.activePage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarousselBox(
          child: PageView(
            controller: carousselController,
            onPageChanged: (page) => activePage.value = page,
            children: List.generate(
              welcomeOptions.length,
              (index) => page(welcomeOptions[index]["assetPath"], context),
            ),
          ),
        ),
        ViewPage(welcomeOptions.length, activePage.value),
      ],
    );
  }

  Widget page(assetPath, BuildContext context) {
    return io.File(assetPath).existsSync()
        ? Image(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          )
        : Center(
            child: Text(
              "Image",
              style: Theme.of(context).textTheme.headline1,
            ),
          );
  }
}
