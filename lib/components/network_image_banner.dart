import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class NetworkImageBanner extends StatelessWidget {
  const NetworkImageBanner({
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: NetworkImageWithLoader(image),
      ),
    ).onTap(press);
  }
}
