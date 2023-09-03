import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawer_menu/drawer_menu.dart';

/// Manager for creating a scroll listener
/// that intercept [OverscrollNotification] events within the body
/// and set the required menu offset.
class ScrollNotificationManager {

  final ScrollController scrollController;
  final DrawerMenuState state;
  ScrollDragController? _dragScroller;
  DragStartDetails? _dragStartDetails;

  ScrollNotificationManager({
    required this.scrollController,
    required this.state
  });

  Widget buildListener({required Widget child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: child,
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _dragStartDetails = notification.dragDetails;
    }

    if (notification is OverscrollNotification) {
      var isHorizontalDrag = (notification.dragDetails?.delta.dx ?? 0.0).abs() > 0;
      if(isHorizontalDrag) {
        if (_dragScroller == null && _dragStartDetails != null) {
          final scrollPosition = scrollController.position as ScrollPositionWithSingleContext;
          _dragScroller = scrollPosition.drag(_dragStartDetails!, () {
            _dragScroller = null;
          }) as ScrollDragController;
        }

        if (notification.dragDetails != null) {
          _dragScroller?.update(notification.dragDetails!);
        }
      }
    }

    if (notification is ScrollUpdateNotification) {
      if(_dragScroller != null) {
        _dragStartDetails = null;
        _dragScroller?.cancel();
        state.close();
      }
      return false;
    }

    if (notification is ScrollEndNotification) {
      _dragStartDetails = null;
      if (notification.dragDetails != null) {
        _dragScroller?.end(notification.dragDetails!);
      }
    }

    if (notification is UserScrollNotification) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          break;
        case ScrollDirection.idle:
          _dragScroller?.cancel();
          break;
        case ScrollDirection.reverse:
          break;
      }
    }
    return false;
  }
}