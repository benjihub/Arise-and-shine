import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

Widget searchField(BuildContext context, searchController, label, hint) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        height: 30,
        width: 0.7 * context.screenWidth,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 16,
            ),
          ),
        ),
      ),
      const SizedBox(width: 20, child: Icon(Icons.search)),
    ],
  );
}
