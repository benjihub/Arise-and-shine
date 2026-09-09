import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';

class SocialSignInForm extends StatelessWidget {
  const SocialSignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    var profileController = Get.put(ProfileController());

    return Obx(
      () => Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          // Phone/Email Toggle Button
          Container(
            decoration: const BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
            ),
            child: authController.isPhoneSignin.value
                ? IconButton(
                    onPressed: () {
                      authController.isPhoneSignin(false);
                    },
                    icon: const Icon(
                      Icons.email,
                      size: 30,
                      color: blackColor,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      authController.isPhoneSignin(true);
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/phone.svg",
                      height: 30,
                      width: 30,
                      colorFilter: const ColorFilter.mode(
                        blackColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
          ),

          // Google Sign-In Button
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: authController.isSocialloading.value
                  ? null
                  : () => _completeSocialSignIn(
                        context,
                        authController,
                        profileController,
                        authController.googleSignIn,
                      ),
              icon: SvgPicture.asset(
                "assets/icons/google.svg",
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeSocialSignIn(
    BuildContext context,
    AuthController authController,
    ProfileController profileController,
    Future<dynamic> Function() signIn,
  ) async {
    try {
      final credential = await signIn();
      if (credential == null) return;

      final fetched = await profileController.fetchUserDetails();
      final profile = fetched == false
          ? null
          : await profileController.getUserDetails();
      if (profile == null) {
        Get.snackbar('Sign-in failed', 'Unable to load your profile.',
            colorText: whiteColor, backgroundColor: errorColor);
        return;
      }

      await authController.clearGuestStatus();
      authController.clearAuthData();
      Get.offAll(() => const EntryPoint());
      if (context.mounted) {
        VxToast.show(context, msg: 'Signed in successfully');
      }
    } catch (error, stackTrace) {
      debugPrint('Completing social sign-in failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      Get.snackbar('Sign-in failed',
          'Unable to complete sign-in. Please try again.',
          colorText: whiteColor, backgroundColor: errorColor);
    } finally {
      authController.isSocialloading(false);
    }
  }
}
