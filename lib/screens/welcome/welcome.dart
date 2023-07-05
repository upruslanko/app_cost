import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:app_cost/widgets/text.dart';
import 'package:app_cost/screens/create_new/create_new.dart';

import 'widgets/caroussel.dart';
import 'widgets/button.dart';

const welcomeOptions = [
  {
    'title': 'Welcome to HW Cost mobile app!',
    'assetPath': 'lib/assets/welcome/1.png'
  },
  {
    'title': 'You can estimate any mobile app here for free!',
    'assetPath': 'lib/assets/welcome/2.png'
  },
  {
    'title': 'Share your estimate to investors or HW professionals!',
    'assetPath': 'lib/assets/welcome/3.png'
  },
];

class Welcome extends StatelessWidget {
  final ValueNotifier<int> activePage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: activePage,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  height: 75,
                  child: TitleText(welcomeOptions[activePage.value]["title"])),
              WelcomeCaroussel(welcomeOptions, activePage),
              WelcomeButton(
                newContent: CreateNew(firstProject: true),
                text: "START",
                disabled: activePage.value != welcomeOptions.length - 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
