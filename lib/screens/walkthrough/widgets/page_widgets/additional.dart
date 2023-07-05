import 'package:app_cost/app.dart';
import 'package:app_cost/logic/projects.dart';

import 'package:flutter/material.dart';

class AdditionalOptions extends StatefulWidget {
  @override
  _AdditionalOptionsState createState() => _AdditionalOptionsState();
}

class _AdditionalOptionsState extends State<AdditionalOptions> {
  var focusNode = FocusNode();
  FocusNode activeFocusNode;
  int activeIndex;
  List additionalOptions = App.model.currentPageOptions();

  @override
  void dispose() {
    additionalOptions.removeWhere((value) => value.isEmpty);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UpdateNotification>(
      onNotification: (notification) {
        setState(() {
          focusNode = FocusNode();
          activeIndex = notification.activeIndex;
        });

        if (App.model.currentlySelected().length == 0 &&
            !additionalOptions.contains("None")) additionalOptions.add("None");

        return true;
      },
      child: Flexible(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 15),
          itemCount: App.model.currentlySelected().length + 1,
          itemBuilder: (context, index) {
            return OptionTile(
              index,
              index == activeIndex,
              focusNode,
              key: UniqueKey(),
            );
          },
        ),
      ),
    );
  }
}

class OptionTile extends StatefulWidget {
  final int index;
  final FocusNode focusNode;
  final bool active;

  OptionTile(this.index, this.active, this.focusNode, {Key key})
      : super(key: key);

  @override
  _OptionTileState createState() => _OptionTileState(index, active, focusNode);
}

class _OptionTileState extends State<OptionTile> {
  final int index;
  final FocusNode myFocusNode;
  final bool active;

  _OptionTileState(this.index, this.active, this.myFocusNode);

  Widget showingWidget;
  List additionalOptions = App.model.currentPageOptions();

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  RegExp def = RegExp(r'^[a-zA-Z0-9_\-=@,\.; ]+');

  @override
  void initState() {
    myFocusNode.addListener(() {
      if (!myFocusNode.hasFocus &&
          _formKey.currentState != null &&
          _formKey.currentState.validate()) {
        updateWidget();
      }
    });

    additionalOptions.remove("None");
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.removeListener(() {});
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      showingWidget = active
          ? textEditingFormField()
          : index == additionalOptions.length
              ? createButton()
              : editableText();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 30, right: 10),
      child: Row(
        children: [Flexible(child: showingWidget)],
      ),
    );
  }

  Widget createButton() {
    return RawMaterialButton(
      fillColor: Colors.red,
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 25.0,
      ),
      onPressed: () {
        myFocusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          UpdateNotification(activeIndex: additionalOptions.length)
              .dispatch(context);
        });
      },
    );
  }

  Widget editableText() {
    return Row(
      children: [
        Text(
          "${index + 1}. ",
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(width: 10),
        GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9 - 75,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  additionalOptions[index],
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.75),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
            ),
            onTap: () {
              myFocusNode.unfocus();
              UpdateNotification(activeIndex: index).dispatch(context);
            })
      ],
    );
  }

  Widget textEditingFormField() {
    if (index == additionalOptions.length) additionalOptions.add("");
    _controller.text = additionalOptions[index];

    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${index + 1}. ",
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(width: 10),
          Flexible(
            child: TextFormField(
              autofocus: true,
              maxLines: null,
              maxLength: 200,
              controller: _controller,
              focusNode: myFocusNode,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                hintText: "Please write your option",
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
              validator: (value) => validateText(value),
            ),
          ),
          RawMaterialButton(
            fillColor: Colors.red,
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
            child: Icon(
              Icons.save,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                updateWidget();
                UpdateNotification().dispatch(context);
              }
            },
          )
        ],
      ),
    );
  }

  validateText(value) {
    if (_controller.text.isNotEmpty) {
      if (def.hasMatch(value)) {
        additionalOptions[index] = value;
        App.model.isOptionSelectedUpdate();

        App.model.currentProject["timestamp"] =
            DateTime.now().millisecondsSinceEpoch;
        writeProjects(App.model.currentProject);
      } else
        return "please write correct text";
    } else {
      additionalOptions.removeAt(index);
      App.model.isOptionSelectedUpdate();

      App.model.currentProject["timestamp"] =
          DateTime.now().millisecondsSinceEpoch;
      writeProjects(App.model.currentProject);
    }
  }

  updateWidget() {
    if (_controller.text.isNotEmpty)
      setState(() {
        showingWidget = editableText();
      });
  }
}

class UpdateNotification extends Notification {
  final int activeIndex;

  UpdateNotification({this.activeIndex});
}
