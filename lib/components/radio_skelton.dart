import 'package:arise_and_shine/components/radio_card_skelton.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class RadioSkelton extends StatelessWidget {
  const RadioSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: index == 4 ? defaultPadding : 0,
        ),
        child: const RadioCardSkelton(),
      ),
    );
  }
}
