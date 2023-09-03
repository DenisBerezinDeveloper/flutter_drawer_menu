import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_drawer_menu/src/scroll_notification_manager.dart';

import 'drawer_menu_controller.dart';
import 'scroll_behavior.dart';

const _alphaMultiplierForShadowCenter = 0.3;

/// Widget that displays a draggable menu in phone mode and a side menu in tablet mode.
/// {@tool snippet}
/// ```dart
/// final _menuController = DrawerMenuController();
/// DrawerMenu(
///   controller: _controller,
///   menuSystemOverlayStyle: const SystemOverlayStyle(
///     brightness: Brightness.dark,
///   ),
///   menu: _buildMenu(),
///   body: _buildBody(),
/// );
/// ```
/// {@end-tool}
class DrawerMenu extends StatefulWidget {

  /// Menu content widget
  final Widget menu;

  /// Primary content widget
  final Widget body;

  /// Duration of [open|closed] toggling animation (default 300ms)
  final Duration animationDuration;

  /// The minimum width of the DrawerMenu to activate tablet mode (show side menu).
  final double tabletModeMinScreenWidth;
  
  /// The width of the side menu in tablet mode
  final double tabletModeSideMenuWidth;

  /// Right margin for the menu.
  /// Default is 70.
  final double rightMargin;

  /// Control tool for DrawerMenu behavior.
  /// It also allows subscribing to events for DrawerMenu state changes.
  final DrawerMenuController? controller;

  /// Set a color to use for the scrim that obscures primary content while a drawer is open.
  /// Default is Color(0x44ffffff).
  final Color? scrimColor;

  /// Applies a blur effect when opening the menu.
  /// Default is False.
  final bool scrimBlurEffect;

  /// Color for the right menu shadow.
  /// Default is Color(0x22000000).
  final Color? shadowColor;

  /// Width for the right menu shadow.
  /// Default is 35.
  final double shadowWidth;

  /// Multiplier for the parallax effect applied to the body when the menu is opened.
  /// 0 - the body moves together with the menu. 1 - the body stays in place.
  /// Default is 0.5.
  final double bodyParallaxFactor;

  /// Use [RepaintBoundary] to isolate the rendering of the menu and body widgets
  /// for improve repaints performance.
  /// Default is True.
  final bool useRepaintBoundaries;

  /// Creates a widget that displays a slideable menu in phone mode and a side menu in tablet mode.
  const DrawerMenu({
    Key? key,
    required this.menu,
    required this.body,
    this.animationDuration = const Duration(milliseconds: 300),
    this.tabletModeMinScreenWidth = 600,
    this.tabletModeSideMenuWidth = 300,
    this.rightMargin = 70.0,
    this.controller,
    this.scrimColor = const Color(0x44ffffff),
    this.scrimBlurEffect = false,
    this.shadowColor = const Color(0x22000000),
    this.shadowWidth = 35.0,
    this.bodyParallaxFactor = 0.5,
    this.useRepaintBoundaries = true,
  }) : super(key: key);

  @override
  State<DrawerMenu> createState() => DrawerMenuState();

  /// Finds the [DrawerMenuState] from the closest instance of this class that
  /// encloses the given context.
  /// If there is no [DrawerMenu] in scope, then this will throw an exception.
  /// To return null if there is no [DrawerMenu], use [maybeOf] instead.
  static DrawerMenuState of(BuildContext context) {
    final DrawerMenuState? result = context.findAncestorStateOfType<DrawerMenuState>();
    if (result != null) {
      return result;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'DrawerMenu.of() called with a context that does not contain a DrawerMenuState.',
      ),
      ErrorDescription(
        'No DrawerMenu ancestor could be found starting from the context that was passed to DrawerMenu.of(). '
            'This usually happens when the context provided is from the same StatefulWidget as that '
            'whose build function actually creates the DrawerMenu widget being sought.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [DrawerMenuState] from the closest instance of this class that
  /// encloses the given context.
  static DrawerMenuState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<DrawerMenuState>();
  }
}

/// State of [DrawerMenu]
class DrawerMenuState extends State<DrawerMenu> {

  /// Is the [DrawerMenu] open or not
  /// Always true in tablet mode.
  bool get isOpen => _controller.isOpenNotifier.value;

  /// Returns the current [DrawerMenuController] for this [DrawerMenu].
  DrawerMenuController get controller => _controller;

  /// Fixed keys for menu and body.
  /// These are needed to prevent the widgets from losing
  /// their state when the layout changes (e.g., in tablet mode).
  final _globalKeyMenu = GlobalKey();
  final _globalKeyBody = GlobalKey();

  /// Computed menu width for the current widget width.
  double _calculatedDraggableMenuWidth = 0.0;

  /// [ScrollController] for [CustomScrollView] with menu and body.
  final ScrollController _scrollController = ScrollController();

  /// A [ValueNotifier] that holds menu offset.
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  /// Constants for scrollable and non-scrollable menu states.
  final ScrollPhysics _scrollablePhysics = const PageScrollPhysics(parent: ClampingScrollPhysics());
  final ScrollPhysics _neverScrollablePhysics = const NeverScrollableScrollPhysics();

  /// Physics state for [CustomScrollView]
  late ScrollPhysics _physics = _scrollablePhysics;

  /// Manager for creating a scroll listener
  /// that intercept [OverscrollNotification] events within the body
  /// and set the required menu offset.
  late final _scrollNotificationManager = ScrollNotificationManager(
    scrollController: _scrollController,
    state: this
  );

  /// Controller of [DrawerMenu]
  late DrawerMenuController _controller;

  /// Tablet mode state.
  /// true if width >= tabletModeMinScreenWidth.
  bool _isTabletMode = false;

  @override
  void initState() {
    _scrollController.addListener(_refreshNotifiers);
    _controller = widget.controller ?? DrawerMenuController();
    _controller.registerState(this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.unregisterState(this);
    super.dispose();
  }

  /// Open the menu.
  /// [animated] - do it with animation.
  Future open({bool animated = true}) async {
    if(_isTabletMode) {
      return;
    }
    if(animated) {
      await _scrollController.animateTo(-_calculatedDraggableMenuWidth,
          duration: widget.animationDuration,
          curve: Curves.fastOutSlowIn);
    } else {
      _scrollController.jumpTo(-_calculatedDraggableMenuWidth);
    }
    enableDragging();
  }

  /// Close the menu.
  /// [animated] - do it with animation.
  Future close({bool animated = true}) async {
    if(_isTabletMode || !_scrollController.hasClients) {
      return;
    }
    if(animated) {
      await _scrollController.animateTo(0.0,
          duration: widget.animationDuration,
          curve: Curves.fastOutSlowIn);
    } else {
      _scrollController.jumpTo(0.0);
    }
  }

  /// Open or close the menu.
  /// [animated] - do it with animation.
  Future toggle({bool animated = true}) {
    if(_controller.isOpenNotifier.value) {
      return close(animated: animated);
    }
    else {
      return open(animated: animated);
    }
  }

  /// Allow menu to be moved by gestures.
  void enableDragging() {
    if(_physics != _scrollablePhysics) {
      setState(() {
        _physics = _scrollablePhysics;
      });
    }
  }

  /// Disallow moving the menu by gestures.
  void disableDragging() {
    if(_physics != _neverScrollablePhysics) {
      setState(() {
        _physics = _neverScrollablePhysics;
      });
    }
  }

  @override
  void didUpdateWidget(covariant DrawerMenu oldWidget) {
    if(widget.controller != oldWidget.controller) {
      oldWidget.controller?.unregisterState(this);
      _controller = widget.controller ?? DrawerMenuController();
      _controller.registerState(this);
      _refreshNotifiers();
    }

    super.didUpdateWidget(oldWidget);
  }

  /// Refresh all notifiers
  void _refreshNotifiers() {
    final scrollOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    _refreshController(
      isOpen: _isTabletMode || scrollOffset != 0.0,
      position: _isTabletMode ? 1.0 : _calculateScrollPositionFactor(),
      isTablet: _isTabletMode,
    );
    _scrollOffsetNotifier.value = scrollOffset;
  }

  /// Refresh controller
  void _refreshController({
    required bool isOpen,
    required double position,
    required bool isTablet,
  }) {
    _controller.refresh(
        isOpen: isOpen,
        position: position,
        isTablet: isTablet
    );
  }

  /// Calculate the position of the menu [0-1].
  /// 0 - closed
  /// 1 - open
  double _calculateScrollPositionFactor() {
    return _scrollController.hasClients
        ? (-_scrollController.offset / _calculatedDraggableMenuWidth).clamp(0.0, 1.0)
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.tabletModeMinScreenWidth >= 0.0);
    assert(widget.tabletModeMinScreenWidth >= widget.tabletModeSideMenuWidth);
    assert(widget.tabletModeSideMenuWidth >= 0.0);
    assert(widget.rightMargin >= 0.0);
    assert(widget.bodyParallaxFactor >= 0.0 && widget.bodyParallaxFactor <= 1.0);
    assert(widget.shadowWidth >= 0.0 && widget.shadowWidth <= widget.rightMargin);
    return LayoutBuilder(
      builder: _buildWithConstraints,
    );
  }

  /// Build a widget with known [BoxConstraints].
  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {

    var isFirstLayout = _calculatedDraggableMenuWidth == 0.0;

    double actualDraggableMenuWidth = constraints.maxWidth - widget.rightMargin;
    bool draggableMenuWidthChanged = actualDraggableMenuWidth != _calculatedDraggableMenuWidth;
    _calculatedDraggableMenuWidth = actualDraggableMenuWidth;

    bool actualIsTabletMode = constraints.maxWidth >= widget.tabletModeMinScreenWidth;
    bool tabletModeChanged = actualIsTabletMode != _isTabletMode;
    _isTabletMode = actualIsTabletMode;

    if(isFirstLayout) {
      _refreshNotifiers();
    }
    else if(draggableMenuWidthChanged) {
      // Behavior when the widget's width changes.
      if(_isTabletMode) {
        // When switching to tablet mode, immediately reset the menu position for the phone mode.
        if(_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
        _refreshNotifiers();
      }
      else {
        void scrollAction() {
          if(_scrollController.hasClients) {
            // Scroll to actual position after width change
            _scrollController.jumpTo(!_controller.isOpenNotifier.value || tabletModeChanged
                ? 0.0
                : -_calculatedDraggableMenuWidth);
          }
          _refreshNotifiers();
        }
        if(_scrollController.hasClients) {
          scrollAction();
        }
        else {
          Future.delayed(Duration.zero, scrollAction);
        }
      }
    }

    if(_isTabletMode) {
      return _buildTabletMode(context, constraints);
    }
    else {
      return _buildDraggableMenuMode(context, constraints);
    }
  }

  // Build a widget in tablet mode.
  Widget _buildTabletMode(BuildContext context, BoxConstraints constraints) {
    return Row(
      children: [
        SizedBox(
          width: min(widget.tabletModeSideMenuWidth, constraints.maxWidth),
          child: Material(child: Container(
            key: _globalKeyMenu,
            child: widget.menu,
          )),
        ),
        Expanded(child: Container(
          key: _globalKeyBody,
          child: widget.body,
        ))
      ],
    );
  }

  // Build a widget in phone mode.
  Widget _buildDraggableMenuMode(BuildContext context, BoxConstraints constraints) {

    const centerKey = ValueKey("center");

    // create scroller with menu and body
    final customScroll = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildDraggableMenuWidget(context,  constraints),
        ),
        SliverToBoxAdapter(
          key: centerKey,
          child: _buildDraggableBodyWidget(context,  constraints),
        ),
      ],
      center: centerKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: _physics,
    );

    // apply ScrollConfiguration for delete bars and indicators
    return ScrollConfiguration(
      behavior: const DrawerMenuScrollBehavior(),
      child: customScroll,
    );
  }

  // Build a menu part of widget in phone mode.
  Widget _buildDraggableMenuWidget(BuildContext context, BoxConstraints constraints) {

    // initial menu widget
    Widget widgetMenu = Container(
      key: _globalKeyMenu,
      child: widget.menu,
    );

    //wrap with Scaffold for applying user theme
    widgetMenu = Scaffold(
      body: widgetMenu,
    );

    // setup size
    widgetMenu = SizedBox(
      width: _calculatedDraggableMenuWidth,
      height: double.maxFinite,
      child: widgetMenu,
    );

    // apply RepaintBoundary optimization
    if(widget.useRepaintBoundaries) {
      widgetMenu = RepaintBoundary(
        child: widgetMenu,
      );
    }

    return widgetMenu;
  }

  // Build a body part of widget in phone mode.
  Widget _buildDraggableBodyWidget(BuildContext context, BoxConstraints constraints) {

    // create all needed listeners
    Widget bodyChild = ValueListenableBuilder<double>(
      valueListenable: _scrollOffsetNotifier,
      builder: (context, scrollPosition, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _controller.isOpenNotifier,
          builder: (context, isOpen, _) {
            // build final body widget
            return _buildDraggableBodyWidgetWithState(
                context,
                constraints,
                isOpen,
                scrollPosition);
          }
        );
      },
    );

    // wrap with scroll listener for handling nested scroll
    bodyChild = _scrollNotificationManager.buildListener(child: bodyChild);

    return bodyChild;
  }

  // Build a menu part of widget in phone mode with all needed state parameters.
  Widget _buildDraggableBodyWidgetWithState(BuildContext context,
      BoxConstraints constraints,
      bool isOpen,
      double scrollOffset) {

    // initial calculations
    final scrimColor = widget.scrimColor ?? Colors.transparent;
    final alphaOfScrimColor = scrimColor.opacity;
    final shadowColor = widget.shadowColor ?? Colors.transparent;
    final alphaOfShadowColor = shadowColor.opacity;

    final scrollPositionFactor = _calculateScrollPositionFactor();

    final bodyOffset = (scrollOffset) * widget.bodyParallaxFactor;

    final scrollPosition = (-scrollOffset / _calculatedDraggableMenuWidth).clamp(0.0, 1.0);
    final scrimOpacity = scrollPosition * alphaOfScrimColor;

    // create scrim color widget
    Widget? widgetScrim;
    if (isOpen) {
      widgetScrim = ColoredBox(
        color: scrimColor.withOpacity(scrimOpacity),
      );
    }

    // create shadow
    Widget? widgetShadow;
    if (isOpen) {
      widgetShadow = Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              shadowColor.withOpacity(scrollPositionFactor * alphaOfShadowColor),
              shadowColor.withOpacity(scrollPositionFactor * alphaOfShadowColor
                  * _alphaMultiplierForShadowCenter),
              shadowColor.withAlpha(0)
            ])),
        width: widget.shadowWidth,
      );

      widgetShadow = Transform.translate(
        offset: Offset(-bodyOffset.ceil().toDouble() - 1, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: widgetShadow,
        ),
      );
    }

    // initial body
    Widget widgetBody = Container(
        key: _globalKeyBody,
        child: widget.body
    );

    // create scrim blur effect
    if (widget.scrimBlurEffect && isOpen) {
      widgetBody = Stack(
        fit: StackFit.expand,
        children: [
          widgetBody,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5 * scrollPosition,
                  sigmaY: 5 * scrollPosition
              ),
              child: const SizedBox(),
            ),
          ),
        ],
      );
    }

    // apply RepaintBoundary optimization
    if(widget.useRepaintBoundaries) {
      widgetBody = RepaintBoundary(
        child: widgetBody,
      );
    }

    // append shadow and scrim color
    if(widgetScrim != null || widgetShadow != null) {
      widgetBody = Stack(
        fit: StackFit.expand,
        children: [
          widgetBody,
          //if(widgetScrimBlur != null)
          //  widgetScrimBlur,
          if(widgetScrim != null)
            widgetScrim,
          if(widgetShadow != null)
            widgetShadow,
        ],
      );
    }

    // add parallax offset
    if(bodyOffset != 0.0) {
      widgetBody = Transform.translate(
        offset: Offset(bodyOffset, 0),
        child: widgetBody,
      );
    }

    // setup body size
    widgetBody = SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: ClipRect(
        child: widgetBody,
      ),
    );

    // add tap detector
    widgetBody = GestureDetector(
      onTap: _controller.isOpenNotifier.value ? close : null,
      child: AbsorbPointer(
        absorbing: _controller.isOpenNotifier.value,
        child: widgetBody,
      ),
    );

    return widgetBody;
  }
}