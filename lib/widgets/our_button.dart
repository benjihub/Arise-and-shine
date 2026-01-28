import 'package:flutter/material.dart';
import 'package:arise_and_shine/constants/constants.dart';

Widget ourButton({onPress, color, textColor, String? title}) {
  return SizedBox(
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: color,
          padding: const EdgeInsets.all(12)),
      onPressed: onPress,
      child: title?.text.color(textColor).bold.make(),
    ),
  );
}
