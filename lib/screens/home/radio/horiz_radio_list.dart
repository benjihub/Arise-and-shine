import 'package:arise_and_shine/components/audio_player.dart';
import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/components/radio_skelton.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizRadioList extends StatelessWidget {
  const HorizRadioList({super.key});

  @override
  Widget build(BuildContext context) {
    var ministryController = Get.find<MinistryController>();
    var homeController = Get.find<HomeController>();

    final radios = ministryController.radiosList;

    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 0.42 * context.screenHeight
            : 0.15 * context.screenHeight,
        child: ministryController.isloading.isTrue
            ? const RadioSkelton()
            : radios.isEmpty
                ? const RadioSkelton()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: radios.length,
                    itemBuilder: (context, index) {
                      final radio = radios[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: index == radios.length - 1 ? 20 : 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: homeController.isDarkMode.value
                                ? Colors.grey[900]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 0.28 * context.screenWidth,
                                child: NetworkImageWithLoader(
                                  radio['image'] ??
                                      "https://firebasestorage.googleapis.com/v0/b/arise-and-shine-tanzania.firebasestorage.app/o/radios%2Flogo.png?alt=media&token=eb189957-b228-4342-8243-eed1d16d53ad",
                                ),
                              ),
                            ],
                          ),
                        ).box.p3.transparent.make().onTap(() {
                          if (radio['radioLink'] != "") {
                            Get.to(
                              () => AudioPlayerScreen(
                                audioUrl: radio['radioLink']!,
                                audioData: radio,
                              ),
                              transition: Transition.fadeIn,
                            );
                          }
                        }),
                      );
                    },
                  ),
      ),
    );
  }
}
