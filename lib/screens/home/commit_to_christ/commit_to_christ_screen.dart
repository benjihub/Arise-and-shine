import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommitToChristScreen extends StatefulWidget {
  const CommitToChristScreen({super.key});

  @override
  State<CommitToChristScreen> createState() => _CommitToChristScreenState();
}

class _CommitToChristScreenState extends State<CommitToChristScreen> {
  final _formKey = GlobalKey<FormState>();

  final ministryController = Get.find<MinistryController>();
  final profileController = Get.find<ProfileController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    ministryController.nameController.text =
        profileController.userDetails['name'] ?? "";
    ministryController.emailController.text =
        profileController.userDetails['email'] ?? "";
    ministryController.contactController.text =
        profileController.userDetails['phone'] ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("commit_to_christ".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: 10.heightBox,
            ),
            SliverToBoxAdapter(
                child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "im_commiting".tr.text.bold.size(20).make(),
                    const Divider(),
                    "im_commiting..."
                        .tr
                        .text
                        .color(
                          Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                        )
                        .make(),
                  ],
                ),
              ),
            )),
            SliverToBoxAdapter(
              child: 10.heightBox,
            ),
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  profileController.userDetails['name'] == null,
                              child: Column(
                                children: [
                                  customTextField(
                                    context: context,
                                    controller:
                                        ministryController.nameController,
                                    label: "name".tr,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your name";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  customTextField(
                                    context: context,
                                    controller:
                                        ministryController.emailController,
                                    label: "email".tr,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            customTextField(
                              context: context,
                              controller: ministryController.contactController,
                              label: "phone_number".tr,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your contact";
                                }
                                if (value.length < 10) {
                                  return "Please enter a valid contact number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            customTextField(
                              context: context,
                              controller: ministryController.locationController,
                              label: "location".tr,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your location";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.commentController,
                                label: "comment".tr,
                                isDesc: true),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ministryController.isloading.value
                            ? loadingIndicator()
                            : ourButton(
                                onPress: () {
                                  if (_formKey.currentState!.validate()) {
                                    homeController.hideKeyboard();

                                    ministryController.submitJoinMinistryForm(
                                      name: ministryController
                                          .nameController.text,
                                      email: ministryController
                                          .emailController.text,
                                      contact: ministryController
                                          .contactController.text,
                                      location: ministryController
                                          .locationController.text,
                                      comment: ministryController
                                          .commentController.text,
                                    );
                                  }
                                },
                                title: "share_decision".tr,
                                color: primaryColor,
                                textColor: whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
