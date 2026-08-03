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
          : 0.35 * context.screenWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height:
                  (MediaQuery.of(context).orientation == Orientation.landscape
                          ? 0.06 * screenWidth
                          : 0.09 * screenWidth) *
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
                        ? 0.025 * screenWidth
                        : 0.035 * screenWidth,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    ).onTap(press);
  }
}
