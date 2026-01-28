import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class CardButtonWithTitle extends StatelessWidget {
  const CardButtonWithTitle({
    super.key,
    required this.press,
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    this.color = primaryColor,
  });
  final String title, subtitle;
  final Widget iconWidget;
  final VoidCallback press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var screenWidth = context.screenWidth;

    return Container(
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 0.25 * context.screenWidth
          : 0.28 * context.screenWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width:
                  (MediaQuery.of(context).orientation == Orientation.landscape
                          ? 0.05 * screenWidth
                          : 0.07 * screenWidth) *
                      2,
              height:
                  (MediaQuery.of(context).orientation == Orientation.landscape
                          ? 0.05 * screenWidth
                          : 0.07 * screenWidth) *
                      2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: iconWidget,
              ),
            ),
            5.heightBox,
            Text(
              textScaler: const TextScaler.linear(1),
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 0.02 * screenWidth
                        : 0.025 * screenWidth,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    ).onTap(press);
  }
}
