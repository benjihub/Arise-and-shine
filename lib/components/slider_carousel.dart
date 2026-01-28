import 'package:arise_and_shine/components/dot_indicators.dart';
import 'package:arise_and_shine/components/skleton/others/offers_skelton.dart';
import 'package:arise_and_shine/components/skleton/skelton.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderCarousel extends StatefulWidget {
  const SliderCarousel({super.key});

  @override
  State<SliderCarousel> createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final MinistryController ministryController = Get.find<MinistryController>();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : context.screenWidth;
        final double desiredHeight = availableWidth * (720 / 1280);
        final double carouselHeight =
            desiredHeight.clamp(260.0, 520.0).toDouble();

        return Obx(() {
          if (ministryController.imageUrls.isEmpty) {
            return const OffersSkelton();
          }

          return SizedBox(
            height: carouselHeight,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CarouselSlider(
                    items: ministryController.imageUrls.map((imageUrl) {
                      return ClipRRect(
                        // borderRadius:
                        //     const BorderRadius.all(Radius.circular(16)),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const Skeleton(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    }).toList(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 6),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          ministryController.imageUrls.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: defaultPadding / 4,
                              ),
                              child: DotIndicator(
                                isActive: index == _selectedIndex,
                                activeColor: Colors.white70,
                                inActiveColor: Colors.white54,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // .box
                  // .withGradient(const LinearGradient(
                  //   colors: [
                  //     Colors.transparent,
                  //     Color.fromARGB(178, 3, 32, 252),
                  //   ],
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  // ))
                  // .make(),
                ),
                // Container(
                //   decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(16),
                //     ),
                //     gradient: LinearGradient(
                //       colors: [
                //         Colors.transparent,
                //         Color.fromARGB(199, 3, 32, 252),
                //       ],
                //       stops: [
                //         0.6,
                //         1.0
                //       ], // Adjust gradient stops for smoother blending
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //     ),
                //   ),
                // ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(defaultPadding),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: "invite_friend"
                //               .tr
                //               .text
                //               .size(16)
                //               .center
                //               .bold
                //               .white
                //               .make(),
                //         ),
                //         OutlinedButton(
                //           onPressed: () {
                //             Share.share(
                //               'Check out Arise & Shine App using: https://play.google.com/store/apps/details?id=com.indexhosting.arise_and_shine',
                //             );
                //           },
                //           style: OutlinedButton.styleFrom(
                //             side: const BorderSide(color: Colors.white),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(50),
                //             ),
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 16, vertical: 12),
                //           ),
                //           child: Text(
                //             "send_invite".tr,
                //             style: const TextStyle(
                //               color: Colors.white,
                //               fontSize: 12,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        });
      },
    );
  }
}
