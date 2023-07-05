import 'package:app_cost/app.dart';
import 'package:flutter/material.dart';

onOptionSelection(
    String alias,
    bool multiselection,
    Map localOptions,
    ValueNotifier selected,
    ValueNotifier previouslySelected,
    BuildContext context) {
  List currentPageOptions = App.model.currentProject["optionSelection"][alias];
  var title = localOptions["title"];

  Map estimate =
      localOptions.containsKey("estimate") ? localOptions["estimate"] : Map();

  var previousEstimateOptions =
      App.model.currentProject["estimateOptions"]["previousEstimate"];
  previousEstimateOptions.putIfAbsent(alias, () => null);

  if (selected.value == true) {
    selected.value = false;
    currentPageOptions.remove(title);

    if (currentPageOptions.length == 0 && !currentPageOptions.contains("None"))
      currentPageOptions.add("None");

    if (estimate.length > 0) {
      decreaseEstimate(estimate);
      previousEstimateOptions[alias] = null;
    }
  } else if (multiselection == true) {
    selected.value = true;

    currentPageOptions.remove("None");
    currentPageOptions.add(title);

    if (estimate.length > 0) {
      increaseEstimate(estimate);
    }
  } else if (multiselection == false &&
      App.model.isOptionSelected.value == false) {
    selected.value = true;
    previouslySelected.value = selected;

    currentPageOptions.remove("None");
    currentPageOptions.add(title);

    if (estimate.length > 0) {
      increaseEstimate(estimate);
      previousEstimateOptions[alias] = estimate;
    }
  } else if (multiselection == false &&
      App.model.isOptionSelected.value == true) {
    previouslySelected.value.value = false;
    previouslySelected.value = selected;

    currentPageOptions.clear();

    selected.value = true;
    currentPageOptions.add(title);

    if (estimate.length > 0) {
      decreaseEstimate(previousEstimateOptions[alias]);
      increaseEstimate(estimate);
      previousEstimateOptions[alias] = estimate;
    }
  }

  App.model.isOptionSelectedUpdate();
  App.model.estimate.value = calculateEstimate(App.model.currentProject);
}

increaseEstimate(Map estimate, {var estimateOptions}) {
  estimateOptions ??= App.model.currentProject["estimateOptions"];
  if (estimateOptions.length == 1)
    estimateOptions["constHours"] += double.parse(estimate["hours"]);
  else {
    estimate["multiplier"] ??= "0";
    estimateOptions["multiplier"] += double.parse(estimate["multiplier"]);
    estimateOptions["multHours"] += double.parse(estimate["hours"]);
  }
}

decreaseEstimate(Map estimate, {var estimateOptions}) {
  estimateOptions ??= App.model.currentProject["estimateOptions"];
  if (estimateOptions.length == 1)
    estimateOptions["constHours"] -= double.parse(estimate["hours"]);
  else {
    estimate["multiplier"] ??= "0";
    estimateOptions["multiplier"] -= double.parse(estimate["multiplier"]);
    estimateOptions["multHours"] -= double.parse(estimate["hours"]);
  }
}

calculateEstimate(Map project) {
  var estimateOptions = project["estimateOptions"] ?? project;
  return estimateOptions["multiplier"] * estimateOptions["multHours"] +
      estimateOptions["constHours"];
}
