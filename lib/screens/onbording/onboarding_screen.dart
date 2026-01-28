import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/screens/onbording/login_screen.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = context.screenHeight;
    var screenWidth = context.screenWidth;
    var authController = Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/IMG-20241205-WA0020.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        primaryColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: primaryColor,
                value: Get.locale?.languageCode ?? 'en',
                icon: const Icon(Icons.language, color: Colors.white),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: "Eng".text.white.make(),
                  ),
                  DropdownMenuItem(
                    value: 'sw',
                    child: "Swa".text.white.make(),
                  ),
                  // Add more languages here
                ],
                onChanged: (value) {
                  if (value != null) {
                    Get.updateLocale(Locale(value));

                    authController.currentLanguage.value = value;
                  }
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: 0.3 * screenHeight,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: "best_way_to_connect"
                          .tr
                          .text
                          .size(24)
                          .center
                          .bold
                          .white
                          .make(),
                    ),
                    ourButton(
                      title: "get_started".tr,
                      textColor: blackColor,
                      color: whiteColor,
                      onPress: () {
                        Get.to(
                          () => const LoginScreen(),
                          transition: Transition.fadeIn,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
