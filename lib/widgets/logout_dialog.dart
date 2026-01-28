import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget logoutDialog({context, onpressed}) {
  return Dialog(
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "logout".tr.text.bold.color(errorColor).size(20).make(),
          5.heightBox,
          "are_sure_logout".tr.text.size(16).make(),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ourButton(
                    color: whiteColor,
                    onPress: () {
                      Navigator.pop(context);
                    },
                    textColor: blackColor,
                    title: "cancel".tr),
              ),
              5.widthBox,
              Container(
                color: Colors.grey,
                width: 0.6,
                height: 40,
              ),
              5.widthBox,
              Expanded(
                child: ourButton(
                    textColor: whiteColor,
                    color: primaryColor,
                    onPress: onpressed,
                    title: "ok".tr),
              )
            ],
          )
        ],
      ),
    ),
  );
}
