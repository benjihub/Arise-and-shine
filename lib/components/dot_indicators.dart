import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor = primaryColor,
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: defaultDuration,
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : inActiveColor ?? primaryMaterialColor.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (activeColor ?? primaryColor).withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
