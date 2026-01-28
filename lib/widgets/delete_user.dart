import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/widgets/custom_textfield.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:arise_and_shine/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteUserPopup extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isGoogleUser;

  const DeleteUserPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.isGoogleUser,
  });

  @override
  State<DeleteUserPopup> createState() => _DeleteUserPopupState();
}

class _DeleteUserPopupState extends State<DeleteUserPopup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var profileController = Get.find<ProfileController>();

    return AlertDialog(
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      scrollable: true,
      contentPadding: const EdgeInsets.all(8),
      title: Text(
        "delete_profile".tr,
        style: const TextStyle(fontWeight: FontWeight.bold, color: errorColor),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "delete_account...".tr,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              widget.isGoogleUser
                  ? const SizedBox()
                  : customTextField(
                      context: context,
                      label: "enter_password".tr,
                      controller: profileController.passwordController,
                      isPass: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            "cancel".tr,
          ),
        ),
        Obx(
          () => profileController.isDeleting.value
              ? loadingIndicator(color: errorColor)
              : Center(
                  child: SizedBox(
                    width: 0.7 * context.screenWidth,
                    child: ourButton(
                      color: Colors.red,
                      textColor: whiteColor,
                      onPress: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          widget.onConfirm();
                        }
                      },
                      title: "delete".tr,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
