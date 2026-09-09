import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/screens/onbording/components/login_form.dart';
import 'package:arise_and_shine/screens/onbording/components/phone_signin_form.dart';
import 'package:arise_and_shine/screens/onbording/components/social_signin_form.dart';
import 'package:arise_and_shine/screens/onbording/forgot_password_screen.dart';
import 'package:arise_and_shine/screens/onbording/signup_screen.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    var homeController = Get.put(HomeController());
    var profileController = Get.put(ProfileController());

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    var screenHeight = context.screenHeight;

    return Obx(
      () => Scaffold(
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
                        color: Color.fromARGB(200, 3, 32, 252)),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 200,
                          child: Image.asset("assets/images/logo.png")),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "login".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                              fontSize: 20),
                        ),
                      ),
                      20.heightBox,
                      const SizedBox(height: defaultPadding / 2),
                      authController.isPhoneSignin.value
                          ? const PhoneSigninForm()
                          : LogInForm(formKey: formKey),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      authController.isPhoneSignin.value
                          ? authController.isRequestingOTPLoading.value == true
                              ? loadingIndicator(color: goldenColor)
                              : ourButton(
                                  onPress: () {
                                    if (authController.isNumberValid.isTrue) {
                                      homeController.hideKeyboard();

                                      authController.signInWithPhone(
                                          authController.phoneController.text);
                                    } else {
                                      Get.snackbar(
                                          "Error", "Phone number is not valid",
                                          colorText: whiteColor,
                                          backgroundColor: errorColor);
                                    }
                                  },
                                  title: "Continue",
                                  color: goldenColor,
                                  textColor: primaryColor)
                          : authController.isloading.value
                              ? loadingIndicator(color: goldenColor)
                              : ourButton(
                                  color: goldenColor,
                                  title: "login".tr,
                                  textColor: primaryColor,
                                  onPress: () async {
                                    if (formKey.currentState!.validate()) {
                                      authController.isloading(true);
                                      homeController.hideKeyboard();
                                      try {
                                        final credential = await authController
                                            .loginMethod(context: context);
                                        if (credential == null) return;

                                        final fetched = await profileController
                                            .fetchUserDetails();
                                        final profile = fetched == false
                                            ? null
                                            : await profileController
                                                .getUserDetails();
                                        if (profile == null) {
                                          Get.snackbar(
                                              'Sign-in failed',
                                              'Unable to load your profile.',
                                              colorText: whiteColor,
                                              backgroundColor: errorColor);
                                          return;
                                        }

                                        await authController.clearGuestStatus();
                                        authController.clearAuthData();
                                        Get.offAll(
                                          () => const EntryPoint(),
                                          transition: Transition.fadeIn,
                                        );
                                        if (context.mounted) {
                                          VxToast.show(context,
                                              msg: 'Logged in successfully');
                                        }
                                      } catch (error, stackTrace) {
                                        debugPrint('Email login completion failed: $error');
                                        debugPrintStack(stackTrace: stackTrace);
                                        Get.snackbar('Sign-in failed',
                                            'Unable to complete sign-in. Please try again.',
                                            colorText: whiteColor,
                                            backgroundColor: errorColor);
                                      } finally {
                                        authController.isloading(false);
                                      }
                                    }
                                  },
                                ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            "forgot_password".tr,
                            style: const TextStyle(color: whiteColor),
                          ),
                          onPressed: () {
                            Get.to(
                              () => const ForgotPasswordScreen(),
                              transition: Transition.fadeIn,
                            );
                          },
                        ),
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          SizedBox(
                              width: 0.4 * context.screenWidth,
                              child: const Divider()),
                          10.widthBox,
                          "OR".text.white.make(),
                          10.widthBox,
                          SizedBox(
                              width: 0.4 * context.screenWidth,
                              child: const Divider()),
                        ],
                      ),
                      20.heightBox,
                      const SocialSignInForm(),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "dont_have_account".tr,
                            style: const TextStyle(color: whiteColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(
                                () => const SignUpScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                            child: Text(
                              "signup".tr,
                              style: const TextStyle(
                                  color: goldenColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "continue_as".tr.text.white.make(),
                          "guest".tr.text.color(goldenColor).bold.make()
                        ],
                      ).box.make().onTap(() {
                        authController.setGuestUser();

                        Get.offAll(
                          () => const EntryPoint(),
                          transition: Transition.fadeIn,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
            authController.isSocialloading.value
                ? SafeArea(
                    child: Container(
                    color: const Color.fromARGB(162, 0, 0, 0),
                    child: Center(
                      child: loadingIndicator(color: goldenColor),
                    ),
                  ))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
