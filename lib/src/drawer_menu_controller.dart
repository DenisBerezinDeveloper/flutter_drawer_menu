import 'package:flutter/foundation.dart';
import 'package:flutter_drawer_menu/src/drawer_menu.dart';

/// Control tool for DrawerMenu behavior.
/// It also allows subscribing to events for DrawerMenu state changes.
class DrawerMenuController {
  /// private [ValueNotifier] objects
  final ValueNotifier<bool> _isOpenNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<double> _scrollPositionNotifier =
      ValueNotifier<double>(0);
  final ValueNotifier<bool> _isTabletModeNotifier = ValueNotifier<bool>(false);

  /// public [ValueListenable] objects

  /// A [ValueListenable] that holds open|closed state.
  /// Always open is tablet mode.
  ValueListenable<bool> get isOpenNotifier => _isOpenNotifier;

  /// A [ValueListenable] that holds scroll position of menu (0-1).
  /// 0 - menu closed.
  /// >0 - menu open.
  /// Always 1 in tablet mode.
  ValueListenable<double> get scrollPositionNotifier => _scrollPositionNotifier;

  /// A [ValueListenable] that holds current menu mode (tablet|phone).
  ValueListenable<bool> get isTabletModeNotifier => _isTabletModeNotifier;

  /// Managed state of the [DrawerMenu].
  DrawerMenuState? _state;

  /// Create new [DrawerMenu] controller
  DrawerMenuController();

  /// Register [DrawerMenuState]
  /// ignore: use_setters_to_change_properties
  void registerState(DrawerMenuState state) {
    _state = state;
  }

  /// Unregister [DrawerMenuState]
  void unregisterState(DrawerMenuState state) {
    _state = null;
  }

  /// Update controller fields
  void refresh({
    required bool isOpen,
    required double position,
    required bool isTablet,
  }) {
    _isOpenNotifier.value = isOpen;
    _scrollPositionNotifier.value = position;
    _isTabletModeNotifier.value = isTablet;
  }

  /// Open the menu.
  /// [animated] - do it with animation.
  Future open({bool animated = true}) =>
      _state?.open(animated: animated) ?? Future.value();

  /// Close the menu.
  /// [animated] - do it with animation.
  Future close({bool animated = true}) =>
      _state?.close(animated: animated) ?? Future.value();

  /// Open or close the menu.
  /// [animated] - do it with animation.
  Future toggle({bool animated = true}) =>
      _state?.toggle(animated: animated) ?? Future.value();
}
