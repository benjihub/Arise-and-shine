import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneSigninForm extends StatelessWidget {
  const PhoneSigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();

    return IntlPhoneField(
      style: const TextStyle(color: whiteColor),
      dropdownTextStyle: const TextStyle(color: Colors.white),
      dropdownIcon: const Icon(
        Icons.arrow_drop_down,
        color: whiteColor,
      ),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '723456789',
        labelStyle: const TextStyle(color: whiteColor),
        fillColor: Colors.transparent,
        hintStyle: const TextStyle(
          color: Color.fromARGB(125, 255, 255, 255),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: whiteColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: goldenColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ),
        ),
      ),
      initialCountryCode: 'TZ',
      onChanged: (phone) {
        authController.phoneController.text = phone.completeNumber;

        try {
          if (phone.isValidNumber()) {
            authController.isNumberValid(true);
          }
        } catch (e) {
          authController.isNumberValid(false);
        }
      },
    );
  }
}
