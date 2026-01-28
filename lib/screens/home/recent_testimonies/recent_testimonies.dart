import 'package:arise_and_shine/components/home_sermon_skelton.dart';
import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/components/video_sermon_details.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentTestimonies extends StatelessWidget {
  const RecentTestimonies({super.key});

  @override
  Widget build(BuildContext context) {
    var sermonsController = Get.find<SermonsController>();
    var screenWidth = context.screenWidth;

    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 0.6 * context.screenHeight
            : 0.25 * context.screenHeight,
        child: sermonsController.isLoading.isTrue
            ? const ProductsSkelton()
            : sermonsController.videoTestimonies.isEmpty
                ? const ProductsSkelton()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sermonsController.videoTestimonies.length >= 10
                        ? 10
                        : sermonsController.videoTestimonies.length,
                    itemBuilder: (context, index) {
                      String formattedDate = '';
                      final video = sermonsController.videoTestimonies[index];

                      if (video['publishedAt'] is Timestamp) {
                        DateTime date =
                            (video['publishedAt'] as Timestamp).toDate();
                        formattedDate = DateFormat('MMMM d, yyyy').format(date);
                      } else if (video['publishedAt'] is String) {
                        DateTime date = DateTime.parse(video['publishedAt']);
                        formattedDate = DateFormat('MMMM d, yyyy').format(date);
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: index ==
                                  sermonsController.videoTestimonies.length - 1
                              ? 20
                              : 0,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 0.5 * context.screenWidth
                              : 0.7 * context.screenWidth,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .bottomNavigationBarTheme
                                .backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 0.35 * context.screenHeight
                                    : 0.15 * context.screenHeight,
                                child: NetworkImageWithLoader(
                                  video['thumbnail'] ??
                                      "https://firebasestorage.googleapis.com/v0/b/arise-and-shine-tanzania.firebasestorage.app/o/IMG-20241205-WA0020.jpg?alt=media&token=fa8c38c8-574d-4ef5-b4e2-0865100c74d0",
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                textScaler: const TextScaler.linear(1),
                                video['title'],
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 0.015 * screenWidth
                                          : 0.03 * screenWidth,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                textScaler: const TextScaler.linear(1),
                                formattedDate,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .bottomNavigationBarTheme
                                      .unselectedItemColor,
                                  fontSize:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 0.015 * screenWidth
                                          : 0.025 * screenWidth,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ).box.p3.transparent.make().onTap(() {
                          Get.to(
                            () => VideoSermonDetails(
                              videoData: video,
                              videos: sermonsController.videoTestimonies,
                            ),
                            transition: Transition.fadeIn,
                          );
                        }),
                      );
                    },
                  ),
      ),
    );
  }
}
