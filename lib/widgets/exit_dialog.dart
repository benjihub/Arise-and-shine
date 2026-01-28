import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget exitDialog(context) {
  return Dialog(
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "exit_app".tr.text.bold.color(primaryColor).size(20).make(),
          10.heightBox,
          "are_you_sure_exit".tr.text.size(16).make(),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ourButton(
                    color: Colors.white,
                    onPress: () {
                      Navigator.pop(context);
                    },
                    textColor: blackColor,
                    title: "no".tr),
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
                    color: primaryColor,
                    onPress: () {
                      SystemNavigator.pop();
                    },
                    textColor: whiteColor,
                    title: "yes".tr),
              )
            ],
          )
        ],
      ),
    ),
  );
}
