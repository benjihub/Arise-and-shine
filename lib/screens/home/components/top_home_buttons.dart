import 'package:arise_and_shine/screens/live_tv/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopHomeButtons extends StatelessWidget {
  const TopHomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Live',
              textScaler: TextScaler.linear(1),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const LiveServiceScreen(),
                        transition: Transition.fadeIn,
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        "assets/images/IMG-20251220-WA0013.png",
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                            'Failed to load asset IMG-20251220-WA0013.png: $error',
                          );
                          return Container(
                            width: 150,
                            height: 150,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const LiveServiceScreen(),
                        transition: Transition.fadeIn,
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        "assets/images/upaku1.png",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Failed to load asset upaku1.png: $error');
                          return Container(
                            width: 150,
                            height: 150,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
