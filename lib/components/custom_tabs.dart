import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

Widget buildAnimatedTab(String text, int index, tabController, context) {
  final bool isSelected = tabController.index == index;
  var screenWidth = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: () {
      tabController.animateTo(index);
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSelected ? 0.6 * screenWidth : 0.3 * screenWidth,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : goldenColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: isSelected
            ? [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
