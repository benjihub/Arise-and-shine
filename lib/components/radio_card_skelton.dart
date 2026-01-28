import 'package:arise_and_shine/components/skleton/skelton.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class RadioCardSkelton extends StatelessWidget {
  const RadioCardSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(
              width: 0.4 * 0.7 * context.screenWidth,
            ),
            const SizedBox(width: 10),
            const Column(
              children: [
                Spacer(),
                Skeleton(height: 12, width: 64),
                Spacer(),
                Skeleton(height: 12, width: 64),
                Spacer(),
                Skeleton(height: 12, width: 64),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
