import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/screens/profile/update_profile.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VerificationAuthPage extends StatefulWidget {
  const VerificationAuthPage({super.key});

  @override
  State<VerificationAuthPage> createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<VerificationAuthPage> {
  var authController = Get.find<AuthController>();
  var profileController = Get.put(ProfileController());
  var homeController = Get.find<HomeController>();

  final List<TextEditingController> codeNumberControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    for (var controller in codeNumberControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // authController.phoneController.clear();
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Text("OTP Verification".tr),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/otp.svg",
                      height: 200,
                    ),
                    Text(
                      "Enter Verification Code",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A 6-digit code was sent to your phone via SMS',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: context.screenWidth / 7.5,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Center(
                            child: TextFormField(
                              controller: codeNumberControllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, color: blackColor),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index != 5) {
                                    // Move to the next field
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes[index + 1]);
                                  }
                                } else if (value.isEmpty && index != 0) {
                                  // If the current field is empty, move back to the previous field
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index - 1]);
                                }
                              },
                              onTap: () {
                                codeNumberControllers[index].selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: codeNumberControllers[index]
                                          .text
                                          .length),
                                );
                              },
                              onFieldSubmitted: (_) {
                                if (index != 5) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index + 1]);
                                }
                              },
                              onEditingComplete: () {
                                // Handling deletion across fields
                                if (codeNumberControllers[index].text.isEmpty &&
                                    index != 0) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index - 1]);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: authController.resendTimeout.value == 0
                          ? () => authController
                              .resendCode(authController.phoneController.text)
                          : null,
                      child: authController.isRequestingOTPLoading.value == true
                          ? loadingIndicator()
                          : Text(
                              authController.resendTimeout.value == 0
                                  ? 'Resend Code'
                                  : 'Resend Code in ${authController.resendTimeout.value} seconds',
                              style: TextStyle(
                                color: authController.resendTimeout.value == 0
                                    ? primaryColor
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    authController.isVerifyingOTPLoading.value == true
                        ? loadingIndicator()
                        : ourButton(
                            onPress: codeNumberControllers.every(
                                    (controller) => controller.text.isNotEmpty)
                                ? () {
                                    homeController.hideKeyboard();

                                    String otpCode = codeNumberControllers
                                        .map((controller) => controller.text)
                                        .join();

                                    authController.verifyOTP(otpCode).then(
                                      (value) {
                                        if (value == true) {
                                          profileController
                                              .fetchUserDetails()
                                              .then(
                                            (value) {
                                              if (value != false) {
                                                profileController
                                                    .getUserDetails()
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      VxToast.show(context,
                                                          msg:
                                                              "Logged in Successfully");

                                                      Get.offAll(
                                                        () =>
                                                            const EntryPoint(),
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                Get.to(
                                                  () =>
                                                      const UpdateProfileScreen(),
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                : null,
                            color: primaryColor,
                            title: 'Submit',
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
