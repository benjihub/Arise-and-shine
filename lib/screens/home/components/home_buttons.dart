import 'package:arise_and_shine/components/card_button_with_title.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/devotional/devotional_screen.dart';
import 'package:arise_and_shine/screens/home/commit_to_christ/commit_to_christ_screen.dart';
import 'package:arise_and_shine/screens/home/events/events.dart';
import 'package:arise_and_shine/screens/live_tv/live_service.dart';
import 'package:arise_and_shine/screens/profile/bookstore/bookstore.dart';
import 'package:arise_and_shine/screens/sermons/sermons_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardButtonWithTitle(
              iconWidget: Image.asset("assets/images/IMG-20251220-WA0014.jpg",
                  fit: BoxFit.cover),
              subtitle: "events_and_updates".tr,
              title: "upcoming_events".tr,
              press: () {
                Get.to(
                  () => const EventsScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),
            CardButtonWithTitle(
              iconWidget: Image.asset("assets/images/IMG-20251220-WA0015.jpg",
                  fit: BoxFit.cover),
              subtitle: "jesus_as_my_lord".tr,
              title: "commit_to_christ".tr,
              press: () {
                Get.to(
                  () => const BookstoreScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),
            CardButtonWithTitle(
              iconWidget:
                  Image.asset("assets/images/bible.webp", fit: BoxFit.cover),
              subtitle: "watch_all_live_services".tr,
              title: "live_service".tr,
              press: () {
                Get.to(
                  () => const SermonsScreen(
                    isAppBarVisible: true,
                  ),
                  transition: Transition.fadeIn,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
