import 'package:app_cost/logic/projects.dart';
import 'package:flutter/material.dart';

import 'package:app_cost/app.dart';
import 'package:app_cost/screens/walkthrough/walkthrough.dart';

import 'button.dart';

const int maxLength = 20;

class InputForm extends StatefulWidget {
  final String hintText;

  InputForm({this.hintText});

  @override
  _InputFormState createState() => _InputFormState(hintText);
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController inputFieldController = TextEditingController();
  final ValueNotifier validated = ValueNotifier(false);
  List projects = List();
  final String hintText;

  _InputFormState(this.hintText);

  @override
  void initState() {
    readProjects().then((value) => setState(() {
          projects = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: inputFieldController,
              maxLength: maxLength,
              enableInteractiveSelection: false,
              textCapitalization: TextCapitalization.words,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => _formKey.currentState.validate(),
              onFieldSubmitted: (value) => _submit(),
              validator: (value) => _validate(value),
            ),
          ),
          AnimatedBuilder(
            animation:
                Listenable.merge([App.model.keyboardVisibility, validated]),
            builder: (context, child) {
              return Visibility(
                visible: !App.model.keyboardVisibility.value,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: CreateButton(
                    projectTitle: inputFieldController.text,
                    newContent: Walkthrough(),
                    text: "CREATE NEW",
                    disabled: !validated.value,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _validate(String value) {
    bool isProjectAlreadyCreated() {
      for (int i = 0; i < projects.length; i++) {
        if (projects[i]["name"] == value) return true;
      }
      return false;
    }

    RegExp def = RegExp(r'^[a-zA-Z0-9_\-=@,\.; ]+');
    if (0 < value.length && value.length <= maxLength) {
      if (!def.hasMatch(value)) return "please dont use any special symbols";

      if (isProjectAlreadyCreated()) return "This project already exists";

      validated.value = true;
      return null;
    } else {
      validated.value = false;
      return "please enter some text";
    }
  }

  _submit() {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
