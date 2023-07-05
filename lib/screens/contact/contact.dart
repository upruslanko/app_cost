import 'package:app_cost/app.dart';
import 'package:app_cost/screens/projects/projects.dart';
import 'package:app_cost/widgets/text.dart';
import 'package:flutter/material.dart';

import 'widgets/contact_form.dart';
import 'widgets/button.dart';

const String contactText = "How can we contact you?";

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 25),
              TitleText(contactText),
              SizedBox(height: 35),
              ContactForm(),
              ValueListenableBuilder(
                valueListenable: App.model.keyboardVisibility,
                builder: (context, value, child) {
                  return Visibility(
                    visible: !value,
                    child: ContactButton(
                      formKey,
                      newContent: Projects(),
                      text: "SUBMIT",
                      disabled: false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
