import 'package:arise_and_shine/components/media_card.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/screens/live_tv/live_tv.dart';
import 'package:arise_and_shine/screens/home/radio/radio_screen.dart';
import 'package:arise_and_shine/screens/live_tv/live_service.dart';
import 'package:arise_and_shine/screens/media/gallery_screen.dart';
import 'package:arise_and_shine/widgets/social_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaListScreen extends StatelessWidget {
  const MediaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var ministryController = Get.find<MinistryController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: mediaCard(
                  Icons.live_tv,
                  "Arise & Shine TV",
                  () => Get.to(
                    () => const TVScreen(),
                    transition: Transition.fadeIn,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: mediaCard(
                      Icons.tv,
                      "live_service".tr,
                      () => Get.to(
                            () => const LiveServiceScreen(),
                            transition: Transition.fadeIn,
                          ))),
              SliverToBoxAdapter(
                  child: mediaCard(Icons.radio, "radios".tr,
                      () => Get.to(() => const RadiosScreen()))),
              SliverToBoxAdapter(
                  child: mediaCard(Icons.photo, "gallery".tr,
                      () => Get.to(() => const GalleryScreen()))),
              SliverToBoxAdapter(
                  child: mediaCard(Icons.play_circle_fill, "YouTube", () {
                showSocialDialog(context,
                    icon: Icons.play_circle_fill,
                    iconColor: Colors.red,
                    title: "Follow Us on Social Media",
                    socialLinks: ministryController.socialsList['youtube']);
              }, iconColor: Colors.red)),
              SliverToBoxAdapter(
                  child: mediaCard(Icons.facebook, "Facebook", () {
                showSocialDialog(context,
                    icon: Icons.facebook,
                    iconColor: Colors.blue,
                    title: "Follow Us on Social Media",
                    socialLinks: ministryController.socialsList['facebook']);
              }, iconColor: Colors.blue)),
              SliverToBoxAdapter(
                child: mediaCard(Icons.camera_alt, "Instagram", () {
                  showSocialDialog(context,
                      icon: Icons.camera_alt,
                      iconColor: Colors.blue,
                      title: "Follow Us on Social Media",
                      socialLinks: ministryController.socialsList['instagram']);
                }, iconColor: Colors.blue),
              ),
              SliverToBoxAdapter(
                  child: mediaCard(Icons.tiktok, "TikTok", () {
                showSocialDialog(context,
                    icon: Icons.tiktok,
                    iconColor: blackColor,
                    title: "Follow Us on Social Media",
                    socialLinks: ministryController.socialsList['tiktok']);
              }, iconColor: blackColor)),
            ],
          ),
        ),
      ),
    );
  }
}
