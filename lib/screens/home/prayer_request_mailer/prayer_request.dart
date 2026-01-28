import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayerRequestScreen extends StatefulWidget {
  const PrayerRequestScreen({super.key});

  @override
  State<PrayerRequestScreen> createState() => _PrayerRequestScreenState();
}

class _PrayerRequestScreenState extends State<PrayerRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final ministryController = Get.find<MinistryController>();
  final profileController = Get.find<ProfileController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    ministryController.nameController.text =
        profileController.userDetails['name'] ?? "";

    ministryController.contactController.text =
        profileController.userDetails['phone'] ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("payer_request".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "payer_request".tr.text.size(20).make(),
                    const Divider(),
                    "payer_request..."
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
                          Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  profileController.userDetails['name'] == null,
                              child: customTextField(
                                context: context,
                                controller: ministryController.nameController,
                                label: "full_name".tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest1Controller,
                                label: "Prayer Request 1",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest2Controller,
                                label: "Prayer Request 2",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest3Controller,
                                label: "Prayer Request 3",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest4Controller,
                                label: "Prayer Request 4",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest5Controller,
                                label: "Prayer Request 5",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest6Controller,
                                label: "Prayer Request 6",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest7Controller,
                                label: "Prayer Request 7",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest8Controller,
                                label: "Prayer Request 8",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller:
                                    ministryController.prayerRequest9Controller,
                                label: "Prayer Request 9",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller: ministryController
                                    .prayerRequest10Controller,
                                label: "Prayer Request 10",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller: ministryController
                                    .prayerRequest11Controller,
                                label: "Prayer Request 11",
                                isDesc: true),
                            const SizedBox(height: 10),
                            customTextField(
                                context: context,
                                controller: ministryController
                                    .prayerRequest12Controller,
                                label: "Prayer Request 12",
                                isDesc: true),
                            const SizedBox(height: 10),
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

                                    ministryController.submitPrayerRequestForm(
                                        name: ministryController
                                            .nameController.text,
                                        contact: ministryController
                                            .contactController.text,
                                        location: ministryController
                                            .locationController.text,
                                        prayerRequest: [
                                          ministryController
                                              .prayerRequest1Controller.text,
                                          ministryController
                                              .prayerRequest2Controller.text,
                                          ministryController
                                              .prayerRequest3Controller.text,
                                          ministryController
                                              .prayerRequest4Controller.text,
                                          ministryController
                                              .prayerRequest5Controller.text,
                                          ministryController
                                              .prayerRequest6Controller.text,
                                          ministryController
                                              .prayerRequest7Controller.text,
                                          ministryController
                                              .prayerRequest8Controller.text,
                                          ministryController
                                              .prayerRequest9Controller.text,
                                          ministryController
                                              .prayerRequest10Controller.text,
                                          ministryController
                                              .prayerRequest11Controller.text,
                                          ministryController
                                              .prayerRequest12Controller.text,
                                        ]);
                                  }
                                },
                                title: "submit".tr,
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
