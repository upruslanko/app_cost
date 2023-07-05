import 'package:flutter/material.dart';

const GiantTextSize = 40.0;
const AboveLargeTextSize = 24.0;
const LargeTextSize = 20.0;
const MediumTextSize = 16.0;
const SmallTextSize = 12.0;

const String FontNameDefault = 'Roboto';

const Color TextColorDark = Colors.black;
const Color TextColorLight = Colors.white;
const Color TextColorAccent = Colors.red;
const Color TextColorFaint = Color.fromRGBO(125, 125, 125, 1.0);

const DefaultPaddingHorizontal = 12.0;

const Headline1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w900,
  fontSize: GiantTextSize,
  color: TextColorDark,
);

const Headline2TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w600,
  fontSize: AboveLargeTextSize,
  color: TextColorLight,
);

const Headline3TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w700,
  fontSize: LargeTextSize,
  color: TextColorDark,
);

const ClickableTextTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w600,
  fontSize: LargeTextSize,
  color: TextColorAccent,
  decoration: TextDecoration.underline,
);

const EstimateTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w400,
  fontSize: AboveLargeTextSize,
  color: TextColorDark,
);

const DescriptionTextTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w400,
  fontSize: MediumTextSize,
  color: TextColorDark,
);
