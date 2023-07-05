import 'package:app_cost/app.dart';
import 'package:flutter/material.dart';

import 'package:app_cost/logic/projects.dart';
import 'package:app_cost/widgets/button.dart';

import 'contact_form.dart';

class ContactButton extends CustomButton {
  final GlobalKey<FormState> formKey;

  ContactButton(
    this.formKey, {
    Widget newContent,
    String text,
    bool disabled,
  }) : super(
          newContent: newContent,
          text: text,
          disabled: disabled,
        );

  @override
  onPressed(newContent, BuildContext context) {
    if (formKey.currentState.validate()) {
      Map contact = {
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "notes": notesController.text
      };

      writeMisc({"contact": contact});
      App.model.firestoreUser.updateData({"contact": contact});
      App.model.updateProjectsList();
      return super.onPressed(newContent, context);
    }
  }
}
