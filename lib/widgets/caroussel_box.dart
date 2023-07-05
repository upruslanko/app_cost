import 'package:flutter/material.dart';

class CarousselBox extends StatelessWidget {
  final child;

  CarousselBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Color(0xffeeeeee),
        border: Border.all(width: 3, color: Color(0xFFFFFFFFFF)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 4,
            blurRadius: 2,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
