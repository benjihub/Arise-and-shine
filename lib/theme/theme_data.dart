import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: lightGreyColor,
  elevation: 0,
  iconTheme: IconThemeData(color: blackColor),
  actionsIconTheme: IconThemeData(color: blackColor),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: blackColor,
  ),
);

const AppBarTheme appBarDarkTheme = AppBarTheme(
  backgroundColor: darkCharcoalColor,
  elevation: 0,
  iconTheme: IconThemeData(color: whiteColor),
  actionsIconTheme: IconThemeData(color: whiteColor),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
);
