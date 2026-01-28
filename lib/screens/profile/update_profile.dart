import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var profileController = Get.put(ProfileController());
    var authController = Get.put(AuthController());
    final homeController = Get.find<HomeController>();

    final formKey = GlobalKey<FormState>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: "Update Personal Details".text.make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    "assets/images/update.png",
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedItemColor,
                  ),
                ),
                20.heightBox,
                customTextField(
                  context: context,
                  controller: authController.nameController,
                  label: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                10.heightBox,
                customTextField(
                  context: context,
                  controller: authController.emailController,
                  label: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                50.heightBox,
                authController.isloading.value == true
                    ? loadingIndicator()
                    : ourButton(
                        title: "Done",
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            authController.isloading(true);
                            homeController.hideKeyboard();
                            authController
                                .updateUserDetailsForthefirsttime()
                                .then(
                              (value) {
                                if (value = true) {
                                  profileController.fetchUserDetails().then(
                                    (value) {
                                      if (value != false) {
                                        profileController.getUserDetails().then(
                                          (value) {
                                            if (value != null) {
                                              authController.isloading(false);

                                              Get.snackbar("Success",
                                                  "Details Updated Successfully");

                                              Get.offAll(
                                                  () => const EntryPoint());
                                            }
                                          },
                                        );
                                      } else {
                                        authController.isloading(false);
                                      }
                                    },
                                  );
                                } else {
                                  authController.isloading(false);
                                }
                              },
                            );
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
