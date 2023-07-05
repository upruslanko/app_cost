import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_cost/logic/projects.dart';
import 'package:app_cost/screens/walkthrough/widgets/caroussel.dart';
import 'package:app_cost/screens/walkthrough/widgets/page.dart';

class AppModel {
  final ValueNotifier keyboardVisibility = ValueNotifier(false);
  List pages = List();
  List projects = List();
  DocumentReference firestoreUser;

  final ValueNotifier<int> walkProgress = ValueNotifier(1);
  final ValueNotifier<bool> isOptionSelected = ValueNotifier(false);
  final ValueNotifier<bool> description = ValueNotifier(false);
  final ValueNotifier<double> estimate = ValueNotifier(0);
  final ValueNotifier<ValueNotifier> previouslySelected =
      ValueNotifier(ValueNotifier(false));

  Map<String, dynamic> currentProject = Map();

  StreamController _appController = StreamController();
  StreamController _pageController = StreamController.broadcast();
  StreamController _projectsController = StreamController.broadcast();

  Stream get contentUpdates => _appController.stream;
  Stream get pageUpdates => _pageController.stream;
  Stream get projectsUpdate => _projectsController.stream;

  void newContent(content) {
    _appController.add(content);
  }

  void newPage({int pageNumber}) {
    pageNumber ??= walkProgress.value - 1;
    var options = pages[pageNumber]["options"];
    var content = description.value
        ? CarousselWithAssets(options)
        : CustomPage.fromJson(pages[pageNumber]);
    _pageController.add(content);
  }

  void customPage(content) {
    _pageController.add(content);
  }

  Future<void> updateProjectsList() async {
    projects = await readProjects();
    _projectsController.add(null);
  }

  isOptionSelectedUpdate() =>
      isOptionSelected.value = currentlySelected().length > 0;

  currentlySelected({bool text = false}) {
    var currentlySelectedList = List.from(getOptionPage(walkProgress.value));

    text ? currentlySelectedList.sort() : currentlySelectedList.remove("None");
    return text ? currentlySelectedList.join(", ") : currentlySelectedList;
  }

  List getOptionPage(int pageNumber) {
    return currentProject["optionSelection"][pages[pageNumber - 1]["alias"]];
  }

  int howManyOptionsSet(Map project) {
    int optionsSet = 0;
    project["optionSelection"].forEach((alias, optionPage) {
      if (optionPage.isNotEmpty) optionsSet++;
    });
    return optionsSet;
  }

  List currentPageOptions() {
    return currentProject["optionSelection"]
        [pages[walkProgress.value - 1]["alias"]];
  }
}
