import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class AppDrawerProfileCard extends StatelessWidget {
  const AppDrawerProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
  });

  final String name, email, imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
            width: 0.3 * context.screenWidth,
            height: 0.3 * context.screenWidth,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(
                  color: primaryColor,
                  width: 1,
                ),
                padding: const EdgeInsets.all(10),
              ),
              child: CircleAvatar(
                radius: 0.2 * context.screenWidth,
                child: NetworkImageWithLoader(
                  imageSrc,
                  radius: 100,
                ),
              ),
            ),
          ),
          10.widthBox,
          SizedBox(
            width: 0.4 * context.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name.text.bold.ellipsis.make(),
                email.text
                    .color(
                      Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                    )
                    .ellipsis
                    .make(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
