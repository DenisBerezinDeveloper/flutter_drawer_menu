import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drawer_menu/src/drawer_menu.dart';

/// Manager for creating a scroll listener
/// that intercept [OverscrollNotification] events within the body
/// and set the required menu offset.
class ScrollNotificationManager {
  final ScrollController _scrollController;
  final DrawerMenuState _state;
  ScrollDragController? _dragScroller;
  DragStartDetails? _dragStartDetails;

  ScrollNotificationManager(
      {required ScrollController scrollController,
      required DrawerMenuState state})
      : _state = state,
        _scrollController = scrollController;

  Widget buildListener({required Widget child}) =>
      NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: child,
      );

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _dragStartDetails = notification.dragDetails;
    }

    if (notification is OverscrollNotification) {
      final isHorizontalDrag =
          (notification.dragDetails?.delta.dx ?? 0.0).abs() > 0;
      if (isHorizontalDrag) {
        if (_dragScroller == null && _dragStartDetails != null) {
          final scrollPosition =
              _scrollController.position as ScrollPositionWithSingleContext;
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
      if (_dragScroller != null) {
        _dragStartDetails = null;
        _dragScroller?.cancel();
        _state.close();
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
