import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

Widget topHomeButton({
  BuildContext? context,
  onPress,
  icon,
  title,
  color,
  textColor,
  double? buttonWidth,
}) {
  return SizedBox(
    width: buttonWidth ??
        (MediaQuery.of(context!).orientation == Orientation.landscape
            ? 0.4 * context.screenWidth
            : 0.43 * context.screenWidth),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
            color: color ?? const Color.fromARGB(255, 3, 103, 252), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPress,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor ?? const Color.fromARGB(255, 3, 103, 252),
              // Theme.of(context).iconTheme.color,
              size: MediaQuery.of(context!).orientation == Orientation.landscape
                  ? 0.03 * context.screenWidth
                  : 0.04 * context.screenWidth,
            ),
            3.widthBox,
            Text(
              textScaler: const TextScaler.linear(1),
              title,
              style: TextStyle(
                color: textColor ?? const Color.fromARGB(255, 3, 103, 252),
                // color: textColor ?? Theme.of(context).iconTheme.color,
                fontSize:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 0.02 * context.screenWidth
                        : 0.033 * context.screenWidth,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
