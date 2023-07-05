import 'package:app_cost/logic/projects.dart';
import 'package:flutter/material.dart';

final formKey = GlobalKey<FormState>();

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController notesController = TextEditingController();

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final ValueNotifier validated = ValueNotifier(false);

  @override
  void initState() {
    readMisc().then((value) {
      Map contact = value["contact"] ?? Map();
      if (contact.length > 0) {
        nameController.text = contact["name"];
        emailController.text = contact["email"];
        phoneController.text = contact["phone"];
        notesController.text = contact["notes"];
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Flexible(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            InputField(
              controller: nameController,
              validateType: "name",
              hintText: "Your Name",
            ),
            InputField(
              controller: emailController,
              validateType: "email",
              hintText: "E-mail",
            ),
            InputField(
              controller: phoneController,
              validateType: "phone",
              hintText: "Telephone",
            ),
            InputField(
              controller: notesController,
              validateType: "notes",
              hintText: "Notes (not required)",
              maxLength: 200,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String validateType;
  final String hintText;
  final int maxLength;
  final int maxLines;

  InputField(
      {this.controller,
      this.validateType,
      this.hintText,
      this.maxLength,
      this.maxLines = 1});

  TextInputType getInputType() {
    switch (validateType) {
      case "phone":
        return TextInputType.number;
      case "email":
        return TextInputType.emailAddress;
      case "notes":
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextCapitalization getTextCapitalization() {
    switch (validateType) {
      case "name":
        return TextCapitalization.words;
      case "notes":
        return TextCapitalization.words;
      default:
        return TextCapitalization.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(bottom: 30, right: 5, left: 5),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        maxLength: maxLength,
        enableInteractiveSelection: false,
        textCapitalization: getTextCapitalization(),
        keyboardType: getInputType(),
        style: Theme.of(context).textTheme.headline3,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hoverColor: Colors.white,
          hintText: hintText,
          contentPadding: EdgeInsets.all(14),
          errorStyle: TextStyle(fontSize: 14, height: 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              style: BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey,
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
        validator: (value) => validate(value),
        onEditingComplete: () => formKey.currentState.validate()
            ? FocusManager.instance.primaryFocus.unfocus()
            : null,
      ),
    );
  }

  validate(value) {
    RegExp name = RegExp(r'^[A-Za-z ]+$');
    RegExp email = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    RegExp phone = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    RegExp def = RegExp(r'^[a-zA-Z0-9_\-=@,\.; ]+');

    switch (validateType) {
      case "name":
        return name.hasMatch(value) ? null : "incorrect name";
      case "email":
        return email.hasMatch(value) ? null : "incorrect email";
      case "phone":
        return phone.hasMatch(value) ? null : "incorrect phone number";
      case "notes":
        if (value != "")
          return def.hasMatch(value) ? null : "please correct your notes";
        return null;
      default:
        return def.hasMatch(value) ? null : "please write correct text";
    }
  }
}
