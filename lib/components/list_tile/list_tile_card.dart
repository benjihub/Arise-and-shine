import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

Widget listTileCard(icon, String title, press) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      leading: Icon(icon, color: primaryColor),
      title: title.text.bold.make(),
      onTap: press,
    ),
  ).p4();
}
