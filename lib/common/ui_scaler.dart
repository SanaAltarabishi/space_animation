import 'dart:math';

import 'package:flutter/material.dart';

class UiScaler extends StatelessWidget {
  const UiScaler({
    super.key,
    required this.child,
    required this.alignment,
    this.referenceHeight = 1080,
  });

  final int referenceHeight;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double scale = min(screenSize.height / referenceHeight, 1.0);
    //The scale variable is calculated as the minimum value between the ratio of screenSize.height and referenceHeight and 1.0. This ensures that the scale factor is never greater than 1.0.

    return Transform.scale(
      scale: scale,
      alignment: alignment,
      child: child,
    );
  }
}
