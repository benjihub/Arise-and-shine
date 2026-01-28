import 'dart:io';
import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();
  PhoneNumber initialPhoneNumber = PhoneNumber(isoCode: 'US');

  @override
  void initState() {
    controller.nameController.text = controller.userDetails['name'] ?? "";
    controller.emailController.text = controller.userDetails['email'] ?? "";
    controller.phoneController.text = controller.userDetails['phone'] ?? "";
    controller.fullPhoneNumber.value = controller.userDetails['phone'] ?? "";

    setInitialPhoneNumber(controller.fullPhoneNumber.value);

    super.initState();
  }

  Future<void> setInitialPhoneNumber(String fullPhoneNumber) async {
    try {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        fullPhoneNumber,
      );
      setState(() {
        initialPhoneNumber = number;
        controller.phoneController.text = number.phoneNumber ?? '';
      });
    } catch (e) {
      debugPrint("Error parsing phone number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    var homeController = Get.find<HomeController>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        controller.profileImgPath.value = "";

        authController.oldPassController.clear();

        authController.newPassController.clear();

        authController.confirmNewPasswordController.clear();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
              controller.profileImgPath.value = "";
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: "edit_profile".tr.text.make(),
          centerTitle: true,
        ),
        body: Obx(
          () => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          controller.userDetails['profile_image_url'] == "" &&
                                  controller.profileImgPath.isEmpty
                              ? const NetworkImageWithLoader(
                                  "https://firebasestorage.googleapis.com/v0/b/agricare-01.appspot.com/o/images%2Fno-profile-pic.jpg?alt=media&token=ba34381a-9263-4690-965b-da67d0215707",
                                  radius: 100,
                                )
                                  .box
                                  .roundedFull
                                  .size(80, 80)
                                  .clip(Clip.antiAlias)
                                  .make()
                                  .onTap(
                                  () {
                                    controller.changeImage(context);
                                  },
                                )
                              : controller.userDetails['profile_image_url'] !=
                                          "" &&
                                      controller.profileImgPath.isEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: controller
                                          .userDetails['profile_image_url'],
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .size(80, 80)
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                      .onTap(
                                      () {
                                        controller.changeImage(context);
                                      },
                                    )
                                  : Image.file(
                                      File(controller.profileImgPath.value),
                                      fit: BoxFit.cover,
                                    )
                                      .box
                                      .roundedFull
                                      .size(80, 80)
                                      .clip(Clip.antiAlias)
                                      .make()
                                      .onTap(
                                      () {
                                        controller.changeImage(context);
                                      },
                                    ),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.userDetails['name']
                                    .toString()
                                    .text
                                    .uppercase
                                    .make(),
                                controller.userDetails['email']
                                    .toString()
                                    .text
                                    .color(
                                      Theme.of(context)
                                          .bottomNavigationBarTheme
                                          .unselectedItemColor,
                                    )
                                    .make()
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.profileImgPath.value.isNotEmpty,
                            child: controller.photoisUploading.value
                                ? loadingIndicator()
                                : Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.upload,
                                        color: whiteColor,
                                      ),
                                      onPressed: () {
                                        if (controller.isConnected.value ==
                                            true) {
                                          controller.photoisUploading(true);

                                          controller.uploadProfileImage().then(
                                            (value) {
                                              if (value == true) {
                                                controller
                                                    .updateImageInFirestore(
                                                        imgUrl: controller
                                                            .profileImageLink)
                                                    .then(
                                                  (value) {
                                                    if (value == true) {
                                                      controller
                                                          .fetchUserDetails()
                                                          .then(
                                                        (value) {
                                                          if (value != false) {
                                                            controller
                                                                .getUserDetails();
                                                            controller
                                                                .photoisUploading(
                                                                    false);

                                                            controller
                                                                .profileImgPath
                                                                .value = "";
                                                          } else {
                                                            controller
                                                                .photoisUploading(
                                                                    false);
                                                          }
                                                        },
                                                      );
                                                    } else {
                                                      controller
                                                          .photoisUploading(
                                                              false);
                                                    }
                                                  },
                                                );
                                              } else {
                                                controller
                                                    .photoisUploading(false);
                                              }
                                            },
                                          );
                                        } else {
                                          Get.snackbar(
                                              "Error", "No internet connection",
                                              snackPosition: SnackPosition.TOP,
                                              icon: const Icon(
                                                Icons
                                                    .signal_wifi_connected_no_internet_4,
                                                color: whiteColor,
                                              ),
                                              colorText: whiteColor,
                                              backgroundColor: Colors.red);
                                        }
                                      },
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  20.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: InternationalPhoneNumberInput(
                              cursorColor: primaryColor,
                              inputDecoration: InputDecoration(
                                fillColor: whiteColor,
                                isDense: true,
                                floatingLabelStyle:
                                    const TextStyle(color: primaryColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .red, // Focused error border color
                                    width: 2,
                                  ),
                                ),
                              ),
                              onInputChanged: (PhoneNumber number) {
                                controller.fullPhoneNumber.value =
                                    number.phoneNumber!;

                              },
                              onInputValidated: (bool value) {
                                if (value == false) {
                                  controller.fullPhoneNumber.value = "";
                                }
                              },
                              maxLength: 10,
                              spaceBetweenSelectorAndTextField: 0,
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                useBottomSheetSafeArea: true,
                              ),
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              initialValue: initialPhoneNumber,
                              textFieldController: controller.phoneController,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                            ),
                          ),
                          10.heightBox,
                          Column(
                            children: [
                              10.heightBox,
                              const Divider(),
                            ],
                          ),
                          10.heightBox,
                          Align(
                            alignment: Alignment.center,
                            child:
                                "change_username_password".tr.text.bold.make(),
                          ),
                          10.heightBox,
                          customTextField(
                            context: context,
                            label: "full_name".tr,
                            hint: "eg. Kyagulanyi Deo",
                            controller: controller.nameController,
                          ),
                          10.heightBox,
                          customTextField(
                            context: context,
                            label: "old_password".tr,
                            hint: "******",
                            controller: authController.oldPassController,
                            isPass: true,
                          ),
                          10.heightBox,
                          customTextField(
                            context: context,
                            label: "new_password".tr,
                            hint: "******",
                            controller: authController.newPassController,
                            isPass: true,
                          ),
                          10.heightBox,
                          customTextField(
                            context: context,
                            label: "confirm_password".tr,
                            hint: "******",
                            controller:
                                authController.confirmNewPasswordController,
                            isPass: true,
                          ),
                          20.heightBox,
                        ],
                      ),
                    ),
                  ),
                  25.heightBox,
                  Obx(
                    () => controller.isLoading.value
                        ? loadingIndicator()
                        : ourButton(
                            onPress: () async {
                              homeController.hideKeyboard();

                              // details updates
                              if (controller.isConnected.value == true) {
                                controller.isLoading(true);

                                controller.updateUserDetails().then(
                                  (value) {
                                    if (value == true) {
                                      controller.fetchUserDetails().then(
                                        (value) {
                                          if (value != false) {
                                            controller.getUserDetails();
                                            controller.isLoading(false);
                                          } else {
                                            controller.isLoading(false);
                                          }
                                        },
                                      );
                                      Get.snackbar(
                                        'Success',
                                        'Updated Successfully',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: primaryColor,
                                        colorText: whiteColor,
                                        duration: const Duration(seconds: 4),
                                      );
                                    } else {
                                      controller.isLoading(false);
                                    }
                                  },
                                );

                                //if old password matches databases'
                                if (authController.oldPassController.text.isNotEmpty &&
                                    authController
                                        .newPassController.text.isNotEmpty &&
                                    authController.newPassController.text ==
                                        authController
                                            .confirmNewPasswordController
                                            .text) {
                                  controller.isLoading(true);

                                  controller
                                      .changeAuthPassword(
                                          context: context,
                                          email:
                                              controller.emailController.text,
                                          oldPassword: authController
                                              .oldPassController.text,
                                          newPassword: authController
                                              .newPassController.text)
                                      .then(
                                    (value) {
                                      if (value == true) {
                                        controller.isLoading(false);

                                        authController.oldPassController
                                            .clear();

                                        authController.newPassController
                                            .clear();

                                        authController
                                            .confirmNewPasswordController
                                            .clear();

                                        Get.snackbar(
                                          'Success',
                                          'Password Changed',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor,
                                          colorText: whiteColor,
                                          duration: const Duration(seconds: 4),
                                        );
                                      }
                                    },
                                  );
                                }
                              } else {
                                Get.snackbar("Error", "No internet connection",
                                    snackPosition: SnackPosition.TOP,
                                    icon: const Icon(
                                      Icons.signal_wifi_connected_no_internet_4,
                                      color: whiteColor,
                                    ),
                                    colorText: whiteColor,
                                    backgroundColor: errorColor);
                              }
                            },
                            color: primaryColor,
                            title: "update".tr,
                          ),
                  ),
                  25.heightBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
