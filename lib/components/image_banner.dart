import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({
    super.key,
    required this.image,
    required this.press,
  });
  final dynamic image;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
