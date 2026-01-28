import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextField({
  required BuildContext context,
  label,
  hint,
  controller,
  bool isDesc = false,
  bool phone = false,
  bool date = false,
  bool email = false,
  bool number = false,
  bool isPass = false,
  String? Function(String?)? validator,
}) {
  TextInputType textInputType = TextInputType.text;
  List<TextInputFormatter> inputFormatters = <TextInputFormatter>[];

  if (date) {
    textInputType = TextInputType.datetime;
    inputFormatters = <TextInputFormatter>[];
  } else if (email) {
    textInputType = TextInputType.emailAddress;
  } else if (number) {
    textInputType = TextInputType.number;
  }

  return TextFormField(
    obscureText: isPass,
    validator: validator,
    inputFormatters: inputFormatters,
    keyboardType: textInputType,
    controller: controller,
    cursorColor: Theme.of(context).primaryColor,
    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      isDense: true,
      labelText: label,
      floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            isDesc ? BorderRadius.circular(12) : BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            isDesc ? BorderRadius.circular(12) : BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
            isDesc ? BorderRadius.circular(12) : BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius:
            isDesc ? BorderRadius.circular(12) : BorderRadius.circular(50),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).hintColor),
    ),
  );
}
