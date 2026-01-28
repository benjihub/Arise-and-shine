import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contact_us'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'we_would_love'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Container(
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
                          child: Column(
                            children: [
                              customTextField(
                                context: context,
                                controller: ministryController.nameController,
                                label: 'full_name'.tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              customTextField(
                                context: context,
                                controller: ministryController.emailController,
                                label: 'email'.tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                email: true,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        customTextField(
                          context: context,
                          controller: ministryController.commentController,
                          label: 'message'.tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                          isDesc: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => ministryController.isloading.value
                                ? loadingIndicator()
                                : ourButton(
                                    onPress: () {
                                      if (_formKey.currentState!.validate()) {
                                        homeController.hideKeyboard();

                                        ministryController
                                            .submitMessageToContactForm(
                                          name: ministryController
                                              .nameController.text,
                                          email: ministryController
                                              .emailController.text,
                                          message: ministryController
                                              .commentController.text,
                                        );
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
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 10),
              Text(
                'contact_details'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
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
                      ListTile(
                        leading: Image.asset(
                          "assets/images/whatsapp.png",
                          height: 20,
                        ),
                        title: Text(ministryController
                            .settings['contact details']['whatsapp']),
                        onTap: () => openWhatsApp(ministryController
                            .settings['contact details']['whatsapp']),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.phone, color: Colors.blueAccent),
                        title: Text(ministryController
                            .settings['contact details']['phone']),
                        onTap: () => makePhoneCall(ministryController
                            .settings['contact details']['phone']),
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.email, color: Colors.blueAccent),
                        title: Text(ministryController
                            .settings['contact details']['email']),
                        onTap: () => sendEmail(ministryController
                            .settings['contact details']['email']),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on,
                            color: Colors.blueAccent),
                        title: Text(ministryController
                            .settings['contact details']['location']),
                        onTap: openLocation,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openWhatsApp(String phoneNumber) async {
    final url = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) {
        print("Could not open WhatsApp");
      }
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) {
        print("Could not make a call");
      }
    }
  }

  void sendEmail(String email) async {
    final url = "mailto:$email";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) {
        print("Could not send an email");
      }
    }
  }

  void openLocation() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${ministryController.settings['contact details']['location']}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) {
        print("Could not open Google Maps");
      }
    }
  }
}
