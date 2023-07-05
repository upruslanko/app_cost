import 'dart:io' as io;
import 'package:flutter/material.dart';

class IconBlock extends StatelessWidget {
  final String assetPath;

  IconBlock({@required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 4,
            blurRadius: 2,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Center(
          child: !io.File(assetPath).existsSync()
              ? Image(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                )
              : SizedBox.shrink()),
    );
  }
}
