import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/profile/customer_support/chat.dart';
import 'package:arise_and_shine/screens/profile/customer_support/contact_us.dart';
import 'package:arise_and_shine/screens/profile/customer_support/faq.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('customer_support'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'how_can_we_help'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
                  children: [
                    ourButton(
                        title: 'chat'.tr,
                        onPress: () {
                          Get.to(
                            () => const ChatScreen(),
                            transition: Transition.fadeIn,
                          );
                        },
                        color: primaryColor,
                        textColor: whiteColor),
                    const SizedBox(height: 16),
                    ourButton(
                        title: 'FAQ',
                        onPress: () {
                          Get.to(
                            () => const FAQScreen(),
                            transition: Transition.fadeIn,
                          );
                        },
                        color: primaryColor,
                        textColor: whiteColor),
                    const SizedBox(height: 16),
                    ourButton(
                        title: 'contact_us'.tr,
                        onPress: () {
                          Get.to(
                            () => const ContactUsScreen(),
                            transition: Transition.fadeIn,
                          );
                        },
                        color: primaryColor,
                        textColor: whiteColor),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '© 2025 Arise & Shine',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
