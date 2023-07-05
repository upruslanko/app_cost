import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:app_cost/app.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String pagesPath = "lib/assets/pages.json";
const String projectsPath = "projects.json";
const String miscPath = "misc.json";

Future<void> writeProjects(Map content, {bool newProject = false}) async {
  updateExistingProject(List currentProjects) {
    for (int i = 0; i < currentProjects.length; i++) {
      if (currentProjects[i]["name"] == content["name"]) {
        currentProjects[i] = content;
        break;
      }
    }
  }

  final List currentProjects = await readProjects();

  newProject
      ? currentProjects.insert(currentProjects.length, content)
      : updateExistingProject(currentProjects);

  final file = File(join(await localPath, projectsPath));
  await file.writeAsString(json.encode(currentProjects));

  await App.model.firestoreUser.updateData({"projects": currentProjects});
}

Future<List> readProjects() async {
  try {
    List projects = await readJson(projectsPath) ?? List();
    projects.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));
    return projects;
  } catch (e) {
    print(e.toString());
  }
  return List();
}

Future<Map> readMisc() async {
  try {
    return await readJson(miscPath) ??
        {"id": AutoIdGenerator.autoId(), "showWelcome": true};
  } catch (e) {
    print(e.toString());
  }
  return {"id": AutoIdGenerator.autoId(), "showWelcome": true};
}

Future<dynamic> readJson(String path) async {
  final file = await File(
    join(await localPath, path),
  ).create(recursive: true);

  String content = await file.readAsString();
  if (content.isNotEmpty) return await json.decode(content);
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<List> parsePages() async {
  String _loadString = await rootBundle.loadString(pagesPath);
  return await json.decode(_loadString);
}

Future<void> deleteProject(Map project) async {
  Map getProject(projects) {
    for (var p in projects) {
      if (p["name"] == project["name"]) return p;
    }
    return Map();
  }

  List projects = await readProjects();

  projects.remove(getProject(projects));

  final file = File(join(await localPath, projectsPath));
  await file.writeAsString(json.encode(projects));

  await App.model.firestoreUser.updateData({"projects": projects});
}

Future<Map> writeMisc(Map options) async {
  final Map miscOptions = await readMisc();

  for (var optionName in options.keys) {
    miscOptions[optionName] = options[optionName];
  }

  final file = File(join(await localPath, miscPath));
  await file.writeAsString(json.encode(miscOptions));
  return miscOptions;
}

class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    final int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}
