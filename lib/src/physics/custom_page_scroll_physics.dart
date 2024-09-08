import 'package:flutter/material.dart';

/// Custom physics for [PageView] that change the speed of the animation
class CustomPageScrollPhysics extends PageScrollPhysics {
  const CustomPageScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      CustomPageScrollPhysics(parent: buildParent(ancestor));

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 150,
        stiffness: 100,
        damping: 0.4,
      );
}
