import 'package:flutter/material.dart';
import 'package:flutter_drawer_menu/src/drawer_menu.dart';

/// [ScrollBehavior] for [DrawerMenu].
/// It is necessary to hide the indicators and scrollbars
/// for [CustomScrollView].
class DrawerMenuScrollBehavior extends ScrollBehavior {
  const DrawerMenuScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}
