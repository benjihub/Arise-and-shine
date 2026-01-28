import 'dart:io';

import 'package:arise_and_shine/components/slider_carousel.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:arise_and_shine/screens/home/components/home_buttons.dart';
import 'package:arise_and_shine/screens/home/components/top_home_buttons.dart';
import 'package:arise_and_shine/screens/home/radio/horiz_radio_list.dart';
import 'package:arise_and_shine/screens/home/radio/radio_screen.dart';
import 'package:arise_and_shine/screens/home/recent_sermons/recent_sermons.dart';
import 'package:arise_and_shine/screens/home/recent_testimonies/recent_testimonies.dart';
import 'package:arise_and_shine/screens/home/testmonies/testmonies_screen.dart';
import 'package:arise_and_shine/screens/sermons/sermons_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    var sermonsController = Get.find<SermonsController>();
    var ministryController = Get.find<MinistryController>();

    return Scaffold(
      key: scaffoldKey,
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await sermonsController.fetchAudioSermons();
          await sermonsController.fetchVideoSermons();
          await sermonsController.fetchVideoTestimonies();
          await sermonsController.fetchAudioTestimonies();
          await ministryController.fetchSliderImages();
          await ministryController.fetchTvLink();
          await ministryController.fetchRadios();
          await ministryController.fetchsocialsList();
          await ministryController.fetchSettings();
          await ministryController.fetchEvents();
        },
        color: primaryColor,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // SliverPadding(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   sliver: SliverToBoxAdapter(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         const Text(
              //           textScaler: TextScaler.linear(1),
              //           "Arise & Shine",
              //           style:
              //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //         ),
              //         IconButton(
              //           onPressed: () {
              //             Share.share(
              //               'Check out Arise & Shine App using: https://play.google.com/store/apps/details?id=com.indexhosting.arise_and_shine',
              //             );
              //           },
              //           icon: const Icon(
              //             Icons.share,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              // Remove or minimize spacing between slider and top buttons
              // No spacing at all between slider and top buttons
              const SliverToBoxAdapter(
                child: SliderCarousel(),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(left: 8, right: 6),
                sliver: SliverToBoxAdapter(child: TopHomeButtons()),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: const TextScaler.linear(1),
                        "recent_sermons".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const SermonsScreen(
                                isAppBarVisible: true,
                              ));
                        },
                        child: Text(
                          textScaler: const TextScaler.linear(1),
                          "view_all".tr,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: RecentSermons()),
              const SliverToBoxAdapter(
                child: SizedBox(height: 2),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: const TextScaler.linear(1),
                        "radios".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const RadiosScreen());
                        },
                        child: Text(
                          textScaler: const TextScaler.linear(1),
                          "view_all".tr,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: HorizRadioList()),
              const SliverToBoxAdapter(
                child: SizedBox(height: 2),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textScaler: const TextScaler.linear(1),
                        "recent_testimonies".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const TestmoniesScreen());
                        },
                        child: Text(
                          textScaler: const TextScaler.linear(1),
                          "view_all".tr,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: RecentTestimonies()),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                sliver: SliverToBoxAdapter(
                  child: HomeButtons(),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
