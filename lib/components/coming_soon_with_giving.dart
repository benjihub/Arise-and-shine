import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/giving/giving_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComingSoonWithGiving extends StatelessWidget {
  final String title;
  const ComingSoonWithGiving({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(
            () => const GivingScreen(),
            transition: Transition.fadeIn,
          );
        },
        child: const Icon(
          Icons.volunteer_activism,
          color: whiteColor,
        ),
      ),
      appBar: AppBar(
        title: title.text.make(),
        centerTitle: true,
      ),
      body: Center(
        child: "coming_soon".tr.text.color(primaryColor).make(),
      ),
    );
  }
}
