import 'package:flutter/material.dart';

/// Custom physics for [PageView] that allows only fling
class FlingScrollPhysics extends ClampingScrollPhysics {
  const FlingScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  FlingScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      FlingScrollPhysics(parent: buildParent(ancestor));

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (position.pixels == 0) {
      return 0;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  double? get dragStartDistanceMotionThreshold => 16;

  @override
  double get minFlingDistance => 50;
}
