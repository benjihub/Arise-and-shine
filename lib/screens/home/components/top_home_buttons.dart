import 'package:arise_and_shine/screens/live_tv/live_tv.dart';
import 'package:arise_and_shine/screens/live_tv/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopHomeButtons extends StatelessWidget {
  const TopHomeButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => const LiveServiceScreen(),
                transition: Transition.fadeIn,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live',
                  textScaler: TextScaler.linear(1),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.asset(
                    "assets/images/IMG-20251220-WA0013.png",
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint(
                        'Failed to load asset IMG-20251220-WA0013.png: $error',
                      );
                      return Container(
                        width: 110,
                        height: 110,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              Get.to(
                () => const LiveServiceScreen(),
                transition: Transition.fadeIn,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  "assets/images/upaku1.png",
                  height: 110,
                  width: 110,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Failed to load asset upaku1.png: $error');
                    return Container(
                      width: 110,
                      height: 110,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
