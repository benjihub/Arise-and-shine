import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

Widget mediaCard(icon, String title, press, {iconColor = primaryColor}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: Icon(icon, color: iconColor),
      title: title.text.bold.make(),
      onTap: press,
    ),
  ).p4();
}
