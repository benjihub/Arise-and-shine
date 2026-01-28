import 'package:arise_and_shine/components/image_banner.dart';
import 'package:arise_and_shine/components/launcher.dart';
import 'package:arise_and_shine/components/list_tile/divider_list_tile.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/home/more_info/about_apostle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("more_info".tr),
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
                        image: "assets/images/IMG-20241205-WA0045.jpg",
                        press: () {}),
                    20.heightBox,
                    "about_ministry".tr.text.bold.size(20).make(),
                    const Divider(),
                    "about_ministry..."
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
            SliverToBoxAdapter(
              child: 10.heightBox,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          "more_info".tr.text.bold.size(20).make(),
                          DividerListTile(
                            leading: const Icon(Icons.person),
                            title: "about_pastor".tr.text.make(),
                            press: () {
                              Get.to(
                                () => const AboutApostleScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),
                          DividerListTile(
                            leading: const Icon(Icons.facebook),
                            title: "Facebook".text.make(),
                            press: () {
                              const facebookUrl =
                                  'https://www.facebook.com/ariseandshinetanzania';
                              launchURL(facebookUrl);
                            },
                          ),
                          DividerListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: "Instagram".text.make(),
                            press: () {
                              const instagramUrl =
                                  'https://www.instagram.com/ariseandshinetanzania';
                              launchURL(instagramUrl);
                            },
                          ),
                          DividerListTile(
                            leading: const Icon(Icons.play_circle_fill),
                            title: "Youtube".text.make(),
                            press: () {
                              const youtubeUrl =
                                  'https://www.youtube.com/@ariseandshinetanzania6592';
                              launchURL(youtubeUrl);
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
