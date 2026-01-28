import 'package:arise_and_shine/components/skleton/skelton.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class ProductCardSkelton extends StatelessWidget {
  const ProductCardSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.6 * context.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(
              height: 0.14 * context.screenHeight,
            ),
            const Spacer(flex: 2),
            const Skeleton(height: 12, width: 64),
            const Spacer(flex: 2),
            const Skeleton(),
            const Spacer(),
            const Skeleton(),
            const Spacer(flex: 2),
            const Skeleton(height: 12, width: 80),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
