import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/screens/onbording/components/phone_signin_form.dart';
import 'package:arise_and_shine/screens/onbording/components/sign_up_form.dart';
import 'package:arise_and_shine/screens/onbording/components/social_signin_form.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    var profileController = Get.put(ProfileController());
    var homeController = Get.put(HomeController());

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
                      20.heightBox,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "signup".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                              fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "welcome".tr,
                          style: const TextStyle(color: whiteColor),
                        ),
                      ),
                      20.heightBox,
                      authController.isPhoneSignin.value
                          ? const PhoneSigninForm()
                          : SignUpForm(formKey: _formKey),
                      const SizedBox(height: defaultPadding),
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
                        children: [
                          Checkbox(
                              activeColor: whiteColor,
                              checkColor: primaryColor,
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue;
                                });
                              }),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                text: "I agree with the",
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url = Uri.parse(
                                            "https://ariseandshinetanzania.org/index.php/privacy-policy/");
                                        if (!await launchUrl(url)) {
                                          throw Exception(
                                              'Could not launch ${"https://ariseandshinetanzania.org/index.php/privacy-policy/"}');
                                        }
                                      },
                                    text: " Terms of service ",
                                    style: const TextStyle(
                                      color: goldenColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "& privacy policy.",
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      authController.isPhoneSignin.value
                          ? authController.isRequestingOTPLoading.value == true
                              ? loadingIndicator(color: goldenColor)
                              : ourButton(
                                  onPress: isChecked == true
                                      ? () async {
                                          if (authController
                                              .isNumberValid.isTrue) {
                                            homeController.hideKeyboard();

                                            authController.signInWithPhone(
                                                authController
                                                    .phoneController.text);
                                          } else {
                                            Get.snackbar("Error",
                                                "Phone number is not valid",
                                                colorText: whiteColor,
                                                backgroundColor: errorColor);
                                          }
                                        }
                                      : null,
                                  title: isChecked == true
                                      ? "Continue"
                                      : "Check T&C",
                                  color: isChecked == true
                                      ? goldenColor
                                      : primaryColor,
                                  textColor: isChecked == true
                                      ? primaryColor
                                      : whiteColor,
                                )
                          : authController.isloading.value
                              ? loadingIndicator(color: goldenColor)
                              : ourButton(
                                  color: isChecked == true
                                      ? goldenColor
                                      : primaryColor,
                                  title: isChecked == true
                                      ? "Sign Up"
                                      : "Check T&C",
                                  textColor: isChecked == true
                                      ? primaryColor
                                      : whiteColor,
                                  onPress: isChecked == true
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (isChecked == true) {
                                              if (authController
                                                  .isNumberValid.isTrue) {
                                                authController.isloading(true);

                                                homeController.hideKeyboard();

                                                try {
                                                  final credential =
                                                      await authController
                                                          .signupMethod(
                                                              context: context);
                                                  if (credential == null) return;

                                                  final fetched =
                                                      await profileController
                                                          .fetchUserDetails();
                                                  final profile = fetched == false
                                                      ? null
                                                      : await profileController
                                                          .getUserDetails();
                                                  if (profile == null) {
                                                    Get.snackbar(
                                                        'Sign-up failed',
                                                        'Unable to load your profile.',
                                                        colorText: whiteColor,
                                                        backgroundColor:
                                                            errorColor);
                                                    return;
                                                  }

                                                  await authController
                                                      .clearGuestStatus();
                                                  authController.clearAuthData();
                                                  Get.offAll(
                                                    () => const EntryPoint(),
                                                    transition:
                                                        Transition.fadeIn,
                                                  );
                                                  if (context.mounted) {
                                                    VxToast.show(context,
                                                        msg:
                                                            'Signed up successfully');
                                                  }
                                                } catch (error, stackTrace) {
                                                  debugPrint(
                                                      'Email sign-up completion failed: $error');
                                                  debugPrintStack(
                                                      stackTrace: stackTrace);
                                                  Get.snackbar('Sign-up failed',
                                                      'Unable to complete sign-up. Please try again.',
                                                      colorText: whiteColor,
                                                      backgroundColor:
                                                          errorColor);
                                                } finally {
                                                  authController.isloading(false);
                                                }
                                              } else {
                                                Get.snackbar("Error",
                                                    "Phone number is not valid",
                                                    colorText: whiteColor,
                                                    backgroundColor:
                                                        errorColor);
                                              }
                                            }
                                          }
                                        }
                                      : null,
                                ).box.width(context.screenWidth - 50).make(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: whiteColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
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
