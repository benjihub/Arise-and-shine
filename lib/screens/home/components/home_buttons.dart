import 'package:arise_and_shine/components/card_button_with_title.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/charity/charity_screen.dart';
import 'package:arise_and_shine/screens/home/events/events.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? 0.22 * MediaQuery.of(context).size.height
              : 0.14 * MediaQuery.of(context).size.height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: defaultPadding),
              CardButtonWithTitle(
                iconWidget: Image.asset("assets/images/healing_service.jpg",
                    fit: BoxFit.cover),
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
              const SizedBox(width: defaultPadding),
              CardButtonWithTitle(
                iconWidget:
                    Image.asset("assets/images/charity.jpg", fit: BoxFit.cover),
                subtitle: "charity_subtitle".tr,
                title: "charity".tr,
                press: () {
                  Get.to(
                    () => const CharityScreen(),
                    transition: Transition.fadeIn,
                  );
                },
              ),
              const SizedBox(width: defaultPadding),
              CardButtonWithTitle(
                iconWidget: Image.asset("assets/images/bookstore.jpg",
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
              const SizedBox(width: defaultPadding),
              CardButtonWithTitle(
                iconWidget: Image.asset("assets/images/upcoming_events.jpg",
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
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}
