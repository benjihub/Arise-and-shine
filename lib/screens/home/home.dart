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
import 'package:share_plus/share_plus.dart';

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
          await ministryController.fetchTvLink();
          await ministryController.fetchRadios();
          await ministryController.fetchsocialsList();
          await ministryController.fetchSettings();
          await ministryController.fetchEvents();
        },
        color: primaryColor,
        child: Stack(
          children: [
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: SliderCarousel(),
                  ),
                  const SliverToBoxAdapter(child: TopHomeButtons()),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -36),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textScaler: const TextScaler.linear(1),
                              "recent_sermons".tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const SermonsScreen(
                                      isAppBarVisible: true,
                                    ));
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    textScaler: const TextScaler.linear(1),
                                    "view_all".tr,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: const RecentSermons(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textScaler: const TextScaler.linear(1),
                              "radios".tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const RadiosScreen());
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    textScaler: const TextScaler.linear(1),
                                    "view_all".tr,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: const HorizRadioList(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textScaler: const TextScaler.linear(1),
                              "recent_testimonies".tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const TestmoniesScreen());
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    textScaler: const TextScaler.linear(1),
                                    "view_all".tr,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: const RecentTestimonies(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -48),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: HomeButtons(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
            // Translucent floating top bar
            _buildFloatingTopBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).padding.top + 56,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {
                Share.share(
                  'Check out Arise & Shine App using: https://play.google.com/store/apps/details?id=com.indexhosting.arise_and_shine',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
