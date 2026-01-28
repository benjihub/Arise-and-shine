import 'package:arise_and_shine/components/image_banner.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutApostleScreen extends StatelessWidget {
  const AboutApostleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("about_pastor".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageBanner(
                        image: "assets/images/IMG-20241205-WA0052.jpg",
                        press: () {}),
                    20.heightBox,
                    "about_pastor".tr.text.bold.size(20).make(),
                    const Divider(),
                    "about_pastor..."
                        .tr
                        .text
                        .color(
                          Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                        )
                        .make(),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
