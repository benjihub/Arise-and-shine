import 'dart:io';

import 'package:arise_and_shine/components/app_drawer_profile_card.dart';
import 'package:arise_and_shine/components/profile_menu_item_list_tile.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/constants/firebase_consts.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/screens/giving/giving_screen.dart';
import 'package:arise_and_shine/screens/home/join_ministry/join_ministry.dart';
import 'package:arise_and_shine/screens/home/more_info/more_info_screen.dart';
import 'package:arise_and_shine/screens/home/prayer_request_mailer/prayer_request.dart';
import 'package:arise_and_shine/screens/onbording/login_screen.dart';
import 'package:arise_and_shine/screens/profile/bookstore/bookstore.dart';
import 'package:arise_and_shine/screens/profile/customer_support/contact_us.dart';
import 'package:arise_and_shine/screens/profile/edit_profile.dart';
import 'package:arise_and_shine/screens/profile/privacy_policy.dart';
import 'package:arise_and_shine/widgets/delete_user.dart';
import 'package:arise_and_shine/widgets/logout_dialog.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var profileController = Get.find<ProfileController>();
    var authController = Get.find<AuthController>();
    var homeController = Get.find<HomeController>();

    return Drawer(
      width: 0.85 * context.screenWidth,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        ),
        child: ListView(
          children: [
            15.heightBox,
            profileController.userDetails['name'] == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ourButton(
                        title: "Signup_login".tr,
                        textColor: whiteColor,
                        color: primaryColor,
                        onPress: () {
                          Get.to(() => const LoginScreen());
                        }),
                  )
                : AppDrawerProfileCard(
                    name: profileController.userDetails['name']
                        .toString()
                        .toUpperCase(),
                    email: profileController.userDetails['email'],
                    imageSrc: profileController
                                .userDetails['profile_image_url'] ==
                            ""
                        ? "https://firebasestorage.googleapis.com/v0/b/agricare-01.appspot.com/o/images%2Fno-profile-pic.jpg?alt=media&token=ba34381a-9263-4690-965b-da67d0215707"
                        : profileController.userDetails['profile_image_url'],
                  ),
            const SizedBox(height: defaultPadding),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                "general".tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            const SizedBox(height: defaultPadding / 2),

            Obx(
              () => SwitchListTile.adaptive(
                value: homeController.isDarkMode.value,
                onChanged: (_) => homeController.toggleTheme(),
                title: Text(
                  "dark_mode".tr,
                  style: const TextStyle(fontSize: 14, height: 1),
                ),
                secondary: Icon(
                  homeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).iconTheme.color,
                ),
                activeColor: primaryColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
              ),
            ),
            const Divider(height: 1),

            ProfileMenuListTile(
              text: "give".tr,
              svgSrc: "assets/icons/give.svg",
              press: () {
                if (Platform.isIOS) {
                  launchUrl(
                    Uri.parse(
                        'https://ariseandshinetanzania.org/index.php/donations/'),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  Get.to(
                    () => const GivingScreen(),
                    transition: Transition.fadeIn,
                  );
                }
              },
            ),

            ProfileMenuListTile(
              text: "payer_request".tr,
              svgSrc: "assets/icons/pray.svg",
              press: () {
                Get.to(
                  () => const PrayerRequestScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),

            ProfileMenuListTile(
              text: "join_ministry".tr,
              svgSrc: "assets/icons/Profile.svg",
              press: () {
                Get.to(
                  () => const JoinMinistryScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),

            ProfileMenuListTile(
              text: "bookstore".tr,
              svgSrc: "assets/icons/Stores.svg",
              press: () {
                Get.to(
                  () => const BookstoreScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),

            ProfileMenuListTile(
              text: "customer_support".tr,
              svgSrc: "assets/icons/Help.svg",
              press: () {
                Get.to(
                  () => const ContactUsScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),

            ProfileMenuListTile(
              text: "about".tr,
              svgSrc: "assets/icons/info.svg",
              press: () {
                Get.to(
                  () => const MoreInfoScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),

            const SizedBox(height: defaultPadding),

            Visibility(
              visible: profileController.userDetails['name'] != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Text(
                  "profile_settings".tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            Visibility(
              visible: profileController.userDetails['name'] != null,
              child: ProfileMenuListTile(
                text: "edit_profile".tr,
                svgSrc: "assets/icons/Edit Square.svg",
                press: () {
                  Get.to(
                    () => const EditProfileScreen(),
                    transition: Transition.fadeIn,
                  );
                },
              ),
            ),

            Visibility(
              visible: profileController.userDetails['name'] != null,
              child: ProfileMenuListTile(
                text: "delete_profile".tr,
                svgSrc: "assets/icons/Delete.svg",
                press: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;

                  // Confirm if the user signed in with Google
                  bool isGoogleUser = false;
                  for (var provider in user!.providerData) {
                    if (provider.providerId == "google.com") {
                      isGoogleUser = true;
                      break;
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (context) => DeleteUserPopup(
                      isGoogleUser: isGoogleUser,
                      onConfirm: () {
                        homeController.hideKeyboard();

                        profileController
                            .deleteUser(profileController.userDetails['id'],
                                profileController.userDetails['email'])
                            .then((_) {
                          profileController.clearSharedPreferences();

                          profileController.passwordController.clear();

                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              profileController.userDetails.clear();
                            },
                          );

                          Get.offAll(() => const LoginScreen());
                        }).catchError((error) {
                          Get.snackbar(
                            'Error',
                            'Account Deletion Failed, $error',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: errorColor,
                            colorText: whiteColor,
                            duration: const Duration(seconds: 4),
                          );
                        });
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                        profileController.passwordController.clear();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "terms".tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            ProfileMenuListTile(
              text: "privacy_policy".tr,
              svgSrc: "assets/icons/Lock.svg",
              press: () async {
                Get.to(
                  () => const PrivacyPolicyScreen(),
                  transition: Transition.fadeIn,
                );
              },
            ),
            const SizedBox(height: defaultPadding),

            // Log Out
            Visibility(
              visible: profileController.userDetails['name'] != null,
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => logoutDialog(
                      context: context,
                      onpressed: () async {
                        if (profileController.isConnected.value == true) {
                          profileController.isloading(true);

                          profileController.timeoutChecker();

                          authController.logoutMethod(context).then(
                            (_) {
                              profileController.clearSharedPreferences();

                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  profileController.userDetails.clear();
                                },
                              );

                              final currentUser = auth.currentUser;
                              if (currentUser == null) {
                                Get.offAll(() => const LoginScreen());

                                authController.nameController.clear();

                                authController.emailController.clear();

                                profileController.isloading(false);
                              } else {
                                Get.snackbar(
                                  'Failed',
                                  'user still signed in: ${currentUser.uid}',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: errorColor,
                                  colorText: whiteColor,
                                  duration: const Duration(seconds: 4),
                                );
                              }
                            },
                          );
                        } else {
                          Get.snackbar(
                            'Failed',
                            'No internet connection',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: errorColor,
                            colorText: whiteColor,
                            duration: const Duration(seconds: 4),
                          );
                        }
                      },
                    ),
                  );
                },
                minLeadingWidth: 24,
                leading: SvgPicture.asset(
                  "assets/icons/Logout.svg",
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    errorColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text(
                  "logout".tr,
                  style: const TextStyle(
                      color: errorColor, fontSize: 14, height: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
