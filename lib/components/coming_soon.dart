import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComingSoon extends StatelessWidget {
  final String title;
  const ComingSoon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
