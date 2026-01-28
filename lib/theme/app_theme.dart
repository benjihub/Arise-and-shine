import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/theme/button_theme.dart';
import 'package:flutter/material.dart';
import 'theme_data.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightGreyColor,
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: blackColor),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      appBarTheme: appBarLightTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: whiteColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: greyColor,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkCharcoalColor,
      iconTheme: const IconThemeData(color: whiteColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: whiteColor),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      appBarTheme: appBarDarkTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkGreyColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: greyColor,
      ),
    );
  }
}
