// ignore_for_file: prefer_asserts_with_message, comment_references

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderedCustomScrollView extends ScrollView {
  /// Creates a [ScrollView] that creates custom scroll effects using slivers.
  ///
  /// See the [ScrollView] constructor for more details on these arguments.
  const OrderedCustomScrollView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    this.slivers = const <Widget>[],
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  /// The slivers to place inside the viewport.
  ///
  /// ## What is a sliver?
  ///
  /// > _**sliver** (noun): a small, thin piece of something._
  ///
  /// A _sliver_ is a widget backed by a [RenderSliver] subclass, i.e. one that
  /// implements the constraint/geometry protocol that uses [SliverConstraints]
  /// and [SliverGeometry].
  ///
  /// This is as distinct from those widgets that are backed by [RenderBox]
  /// subclasses, which use [BoxConstraints] and [Size] respectively, and are
  /// known as box widgets. (Widgets like [Container], [Row], and [SizedBox] are
  /// box widgets.)
  ///
  /// While boxes are much more straightforward (implementing a simple
  /// two-dimensional Cartesian layout system), slivers are much more powerful,
  /// and are optimized for one-axis scrolling environments.
  ///
  /// Slivers are hosted in viewports, also known as scroll views, most notably
  /// [CustomScrollView].
  ///
  /// ## Examples of slivers
  ///
  /// The Flutter framework has many built-in sliver widgets, and custom widgets
  /// can be created in the same manner. By convention, sliver widgets always
  /// start with the prefix `Sliver` and are always used in properties called
  /// `sliver` or `slivers` (as opposed to `child` and `children` which are used
  /// for box widgets).
  ///
  /// Examples of widgets unique to the sliver world include:
  ///
  /// * [SliverList], a lazily-loading list of variably-sized box widgets.
  /// * [SliverFixedExtentList], a lazily-loading list of box widgets that are
  ///   all forced to the same height.
  /// * [SliverPrototypeExtentList], a lazily-loading list of box widgets that
  ///   are all forced to the same height as a given prototype widget.
  /// * [SliverGrid], a lazily-loading grid of box widgets.
  /// * [SliverAnimatedList] and [SliverAnimatedGrid], animated variants of
  ///   [SliverList] and [SliverGrid].
  /// * [SliverFillRemaining], a widget that fills all remaining space in a
  ///   scroll view, and lays a box widget out inside that space.
  /// * [SliverFillViewport], a widget that lays a list of boxes out, each
  ///   being sized to fit the whole viewport.
  /// * [SliverPersistentHeader], a sliver that implements pinned and floating
  ///   headers, e.g. used to implement [SliverAppBar].
  /// * [SliverToBoxAdapter], a sliver that wraps a box widget.
  ///
  /// Examples of sliver variants of common box widgets include:
  ///
  /// * [SliverOpacity], [SliverAnimatedOpacity], and [SliverFadeTransition],
  ///   sliver versions of [Opacity], [AnimatedOpacity], and [FadeTransition].
  /// * [SliverIgnorePointer], a sliver version of [IgnorePointer].
  /// * [SliverLayoutBuilder], a sliver version of [LayoutBuilder].
  /// * [SliverOffstage], a sliver version of [Offstage].
  /// * [SliverPadding], a sliver version of [Padding].
  /// * [SliverReorderableList], a sliver version of [ReorderableList]
  /// * [SliverSafeArea], a sliver version of [SafeArea].
  /// * [SliverVisibility], a sliver version of [Visibility].
  ///
  /// ## Benefits of slivers over boxes
  ///
  /// The sliver protocol ([SliverConstraints] and [SliverGeometry]) enables
  /// _scroll effects_, such as floating app bars, widgets that expand and
  /// shrink during scroll, section headers that are pinned only while the
  /// section's children are visible, etc.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=Mz3kHQxBjGg}
  ///
  /// ## Mixing slivers and boxes
  ///
  /// In general, slivers always wrap box widgets to actually render anything
  /// (for example, there is no sliver equivalent of [Text] or [Container]);
  /// the sliver part of the equation is mostly about how these boxes should
  /// be laid out in a viewport (i.e. when scrolling).
  ///
  /// Typically, the simplest way to combine boxes into a sliver environment is
  /// to use a [SliverList] (maybe using a [ListView, which is a convenient
  /// combination of a [CustomScrollView] and a [SliverList]). In rare cases,
  /// e.g. if a single [Divider] widget is needed between two [SliverGrid]s,
  /// a [SliverToBoxAdapter] can be used to wrap the box widgets.
  ///
  /// ## Performance considerations
  ///
  /// Because the purpose of scroll views is to, well, scroll, it is common
  /// for scroll views to contain more contents than are rendered on the screen
  /// at any particular time.
  ///
  /// To improve the performance of scroll views, the content can be rendered in
  /// _lazy_ widgets, notably [SliverList] and [SliverGrid] (and their variants,
  /// such as [SliverFixedExtentList] and [SliverAnimatedGrid]). These widgets
  /// ensure that only the portion of their child lists that are actually
  /// visible get built, laid out, and painted.
  ///
  /// The [ListView] and [GridView] widgets provide a convenient way to combine
  /// a [CustomScrollView] and a [SliverList] or [SliverGrid] (respectively).
  final List<Widget> slivers;

  @override
  List<Widget> buildSlivers(BuildContext context) => slivers;
}

abstract class ScrollView extends StatelessWidget {
  /// Creates a widget that scrolls.
  ///
  /// The [ScrollView.primary] argument defaults to true for vertical
  /// scroll views if no [controller] has been provided.
  /// The [controller] argument must be null if [primary]
  /// is explicitly set to true. If [primary] is true,
  /// the nearest [PrimaryScrollController] surrounding the widget is attached
  /// to this scroll view.
  ///
  /// If the [shrinkWrap] argument is true, the [center] argument must be null.
  ///
  /// The [scrollDirection], [reverse], and [shrinkWrap] arguments
  /// must not be null.
  ///
  /// The [anchor] argument must be non-null and in the range 0.0 to 1.0.
  const ScrollView({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    ScrollPhysics? physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })
      : assert(
  !(controller != null && (primary ?? false)),
  'Primary ScrollViews obtain their ScrollController via inheritance '
      'from a PrimaryScrollController widget. You cannot both '
      'set primary to true and pass an explicit controller.',
  ),
        assert(!shrinkWrap || center == null),
        assert(anchor >= 0.0 && anchor <= 1.0),
        assert(semanticChildCount == null || semanticChildCount >= 0),
        physics = physics ?? ((primary ?? false)
            || (primary == null && controller == null
                && identical(scrollDirection, Axis.vertical))
            ? const AlwaysScrollableScrollPhysics() : null);

  /// {@template flutter.widgets.scroll_view.scrollDirection}
  /// The [Axis] along which the scroll view's offset increases.
  ///
  /// For the direction in which active scrolling may be occurring, see
  /// [ScrollDirection].
  ///
  /// Defaults to [Axis.vertical].
  /// {@endtemplate}
  final Axis scrollDirection;

  /// {@template flutter.widgets.scroll_view.reverse}
  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool reverse;

  /// {@template flutter.widgets.scroll_view.controller}
  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  /// {@endtemplate}
  final ScrollController? controller;

  /// {@template flutter.widgets.scroll_view.primary}
  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// Also when true, the scroll view is used for default [ScrollAction]s. If a
  /// ScrollAction is not handled by an otherwise focused part
  /// of the application, the ScrollAction will be evaluated using
  /// this scroll view, for example, when executing [Shortcuts]
  /// key events like page up and down.
  ///
  /// On iOS, this also identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Cannot be true while a [ScrollController] is provided to `controller`,
  /// only one ScrollController can be associated with a ScrollView.
  ///
  /// Setting to false will explicitly prevent inheriting any
  /// [PrimaryScrollController].
  ///
  /// Defaults to null. When null, and a controller is not provided,
  /// [PrimaryScrollController.shouldInherit] is used to decide automatic
  /// inheritance.
  ///
  /// By default, the [PrimaryScrollController] that is injected by each
  /// [ModalRoute] is configured to automatically be inherited on
  /// [TargetPlatformVariant.mobile] for ScrollViews in the [Axis.vertical]
  /// scroll direction. Adding another to your app will override the
  /// PrimaryScrollController above it.
  ///
  /// The following video contains more information about scroll controllers,
  /// the PrimaryScrollController widget, and their impact on your apps:
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=33_0ABjFJUU}
  ///
  /// {@endtemplate}
  final bool? primary;

  /// {@template flutter.widgets.scroll_view.physics}
  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  ///
  /// To force the scroll view to always be scrollable even if there is
  /// insufficient content, as if [primary] was true but without necessarily
  /// setting it to true, provide an [AlwaysScrollableScrollPhysics] physics
  /// object, as in:
  ///
  /// ```dart
  ///   physics: const AlwaysScrollableScrollPhysics(),
  /// ```
  ///
  /// To force the scroll view to use the default platform conventions and not
  /// be scrollable if there is insufficient content, regardless of the value of
  /// [primary], provide an explicit [ScrollPhysics] object, as in:
  ///
  /// ```dart
  ///   physics: const ScrollPhysics(),
  /// ```
  ///
  /// The physics can be changed dynamically (by providing a new object in a
  /// subsequent build), but new physics will only take effect if the _class_ of
  /// the provided object changes. Merely constructing a new instance with a
  /// different configuration is insufficient to cause the physics to be
  /// reapplied. (This is because the final object used is generated
  /// dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  /// {@endtemplate}
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// {@template flutter.widgets.scroll_view.shrinkWrap}
  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=LUqDNnv_dh0}
  /// {@endtemplate}
  final bool shrinkWrap;

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [AxisDirection] determined
  /// by [scrollDirection] and [reverse] relative to the [center]. Children
  /// before [center] will be placed in the opposite of the axis direction
  /// relative to the [center]. This makes the [center] the inflection point of
  /// the growth direction.
  ///
  /// The [center] must be the key of one of the slivers
  /// built by [buildSlivers].
  ///
  /// Of the built-in subclasses of [ScrollView], only [CustomScrollView]
  /// supports [center]; for that class, the given key must be the key of one of
  /// the slivers in the [CustomScrollView.slivers] list.
  ///
  /// Most scroll views by default are ordered [GrowthDirection.forward].
  /// Changing the default values of [ScrollView.anchor],
  /// [ScrollView.center], or both, can configure a scroll view for
  /// [GrowthDirection.reverse].
  ///
  /// {@tool dartpad}
  /// This sample shows a [CustomScrollView], with [Radio] buttons in the
  /// [AppBar.bottom] that change the [AxisDirection] to illustrate different
  /// configurations. The [CustomScrollView.anchor]
  /// and [CustomScrollView.center] properties are also set to have
  /// the 0 scroll offset positioned in the middle of the viewport,
  /// with [GrowthDirection.forward] and [GrowthDirection.reverse]
  /// illustrated on either side.
  /// The sliver that shares the [CustomScrollView.center] key is
  /// positioned at the [CustomScrollView.anchor].
  ///
  /// ** See code in examples/api/lib/rendering/growth_direction/growth_direction.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [anchor], which controls where the [center] as aligned in the viewport.
  final Key? center;

  /// {@template flutter.widgets.scroll_view.anchor}
  /// The relative position of the zero scroll offset.
  ///
  /// For example, if [anchor] is 0.5 and the [AxisDirection] determined by
  /// [scrollDirection] and [reverse] is [AxisDirection.down] or
  /// [AxisDirection.up], then the zero scroll offset is vertically centered
  /// within the viewport. If the [anchor] is 1.0, and the axis direction is
  /// [AxisDirection.right], then the zero scroll offset is on the left edge of
  /// the viewport.
  ///
  /// Most scroll views by default are ordered [GrowthDirection.forward].
  /// Changing the default values of [ScrollView.anchor],
  /// [ScrollView.center], or both, can configure a scroll view for
  /// [GrowthDirection.reverse].
  ///
  /// {@tool dartpad}
  /// This sample shows a [CustomScrollView], with [Radio] buttons in the
  /// [AppBar.bottom] that change the [AxisDirection] to illustrate different
  /// configurations. The [CustomScrollView.anchor]
  /// and [CustomScrollView.center] properties are also set to have
  /// the 0 scroll offset positioned in the middle of the viewport,
  /// with [GrowthDirection.forward] and [GrowthDirection.reverse]
  /// illustrated on either side. The sliver that shares the
  /// [CustomScrollView.center] key is positioned at
  /// the [CustomScrollView.anchor].
  ///
  /// ** See code in examples/api/lib/rendering/growth_direction/growth_direction.0.dart **
  /// {@end-tool}
  /// {@endtemplate}
  final double anchor;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// The number of children that will contribute semantic information.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided. If the
  /// number is unknown or unbounded this should be left unset or set to null.
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics
  ///  property.
  final int? semanticChildCount;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.widgets.scroll_view.keyboardDismissBehavior}
  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  /// {@endtemplate}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Returns the [AxisDirection] in which the scroll view scrolls.
  ///
  /// Combines the [scrollDirection] with the [reverse] boolean to obtain the
  /// concrete [AxisDirection].
  ///
  /// If the [scrollDirection] is [Axis.horizontal], the ambient
  /// [Directionality] is also considered when selecting the concrete
  /// [AxisDirection]. For example, if the ambient [Directionality] is
  /// [TextDirection.rtl], then the non-reversed [AxisDirection] is
  /// [AxisDirection.left] and the reversed [AxisDirection] is
  /// [AxisDirection.right].
  @protected
  AxisDirection getDirection(BuildContext context) =>
      getAxisDirectionFromAxisReverseAndDirectionality(
          context, scrollDirection, reverse);

  /// Build the list of widgets to place inside the viewport.
  ///
  /// Subclasses should override this method to build the slivers for the inside
  /// of the viewport.
  ///
  /// To learn more about slivers, see [CustomScrollView.slivers].
  @protected
  List<Widget> buildSlivers(BuildContext context);

  /// Build the viewport.
  ///
  /// Subclasses may override this method to change how the viewport is built.
  /// The default implementation uses a [ShrinkWrappingViewport] if [shrinkWrap]
  /// is true, and a regular [Viewport] otherwise.
  ///
  /// The `offset` argument is the value obtained from
  /// [Scrollable.viewportBuilder].
  ///
  /// The `axisDirection` argument is the value obtained from [getDirection],
  /// which by default uses [scrollDirection] and [reverse].
  ///
  /// The `slivers` argument is the value obtained from [buildSlivers].
  @protected
  Widget buildViewport(BuildContext context,
      ViewportOffset offset,
      AxisDirection axisDirection,
      List<Widget> slivers,) {
    assert(() {
      switch (axisDirection) {
        case AxisDirection.up:
        case AxisDirection.down:
          return debugCheckHasDirectionality(
            context,
            why: 'to determine the cross-axis direction of the scroll view',
            hint: 'Vertical scroll views create Viewport widgets that try '
                'to determine their cross axis direction '
                'from the ambient Directionality.',
          );
        case AxisDirection.left:
        case AxisDirection.right:
          return true;
      }
    }());
    if (shrinkWrap) {
      return ShrinkWrappingViewport(
        axisDirection: axisDirection,
        offset: offset,
        slivers: slivers,
        clipBehavior: clipBehavior,
      );
    }
    return Viewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      cacheExtent: cacheExtent,
      center: center,
      anchor: anchor,
      clipBehavior: clipBehavior,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = buildSlivers(context);
    final AxisDirection axisDirection = getDirection(context);

    final bool effectivePrimary = primary
        ?? controller == null &&
            PrimaryScrollController.shouldInherit(context, scrollDirection);

    final ScrollController? scrollController = effectivePrimary
        ? PrimaryScrollController.maybeOf(context)
        : controller;

    final Scrollable scrollable = Scrollable(
      dragStartBehavior: dragStartBehavior,
      axisDirection: axisDirection,
      controller: scrollController,
      physics: physics,
      scrollBehavior: scrollBehavior,
      semanticChildCount: semanticChildCount,
      restorationId: restorationId,
      viewportBuilder: (context, offset) =>
          buildViewport(context, offset, axisDirection, slivers),
      clipBehavior: clipBehavior,
    );

    final Widget scrollableResult = effectivePrimary && scrollController != null
    // Further descendant ScrollViews will not inherit
    // the same PrimaryScrollController
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    if (keyboardDismissBehavior == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: scrollableResult,
        onNotification: (notification) {
          final FocusScopeNode focusScope = FocusScope.of(context);
          if (notification.dragDetails != null && focusScope.hasFocus) {
            focusScope.unfocus();
          }
          return false;
        },
      );
    } else {
      return scrollableResult;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(
        EnumProperty<Axis>('scrollDirection', scrollDirection))..add(
        FlagProperty(
            'reverse', value: reverse,
            ifTrue: 'reversed',
            showName: true))..add(DiagnosticsProperty<ScrollController>(
        'controller', controller, showName: false, defaultValue: null))..add(
        FlagProperty('primary', value: primary,
            ifTrue: 'using primary controller',
            showName: true))..add(DiagnosticsProperty<ScrollPhysics>(
        'physics', physics, showName: false, defaultValue: null))..add(
        FlagProperty('shrinkWrap', value: shrinkWrap,
            ifTrue: 'shrink-wrapping',
            showName: true));
  }
}

class Viewport extends MultiChildRenderObjectWidget {
  /// Creates a widget that is bigger on the inside.
  ///
  /// The viewport listens to the [offset], which means you do not need to
  /// rebuild this widget when the [offset] changes.
  ///
  /// The [offset] argument must not be null.
  ///
  /// The [cacheExtent] must be specified if the [cacheExtentStyle] is
  /// not [CacheExtentStyle.pixel].
  Viewport({
    required this.offset, super.key,
    this.axisDirection = AxisDirection.down,
    this.crossAxisDirection,
    this.anchor = 0.0,
    this.center,
    this.cacheExtent,
    this.cacheExtentStyle = CacheExtentStyle.pixel,
    this.clipBehavior = Clip.hardEdge,
    List<Widget> slivers = const <Widget>[],
  })
      : assert(center == null || slivers
      .where((child) => child.key == center)
      .length == 1),
        assert(cacheExtentStyle != CacheExtentStyle.viewport ||
            cacheExtent != null),
        super(children: slivers);

  /// The direction in which the [offset]'s [ViewportOffset.pixels] increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.down], a scroll
  /// offset of zero is at the top of the viewport and increases towards the
  /// bottom of the viewport.
  final AxisDirection axisDirection;

  /// The direction in which child should be laid out in the cross axis.
  ///
  /// If the [axisDirection] is [AxisDirection.down] or [AxisDirection.up], this
  /// property defaults to [AxisDirection.left] if the ambient [Directionality]
  /// is [TextDirection.rtl] and [AxisDirection.right] if the ambient
  /// [Directionality] is [TextDirection.ltr].
  ///
  /// If the [axisDirection] is [AxisDirection.left] or [AxisDirection.right],
  /// this property defaults to [AxisDirection.down].
  final AxisDirection? crossAxisDirection;

  /// The relative position of the zero scroll offset.
  ///
  /// For example, if [anchor] is 0.5 and the [axisDirection] is
  /// [AxisDirection.down] or [AxisDirection.up], then the zero scroll offset is
  /// vertically centered within the viewport. If the [anchor] is 1.0, and the
  /// [axisDirection] is [AxisDirection.right], then the zero scroll offset is
  /// on the left edge of the viewport.
  ///
  /// {@macro flutter.rendering.GrowthDirection.sample}
  final double anchor;

  /// Which part of the content inside the viewport should be visible.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport, this value changes, which changes the content that
  /// is displayed.
  ///
  /// Typically a [ScrollPosition].
  final ViewportOffset offset;

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [axisDirection] relative to
  /// the [center]. Children before [center] will be placed in the opposite of
  /// the [axisDirection] relative to the [center].
  ///
  /// The [center] must be the key of a child of the viewport.
  ///
  /// {@macro flutter.rendering.GrowthDirection.sample}
  final Key? center;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  ///
  /// See also:
  ///
  ///  * [cacheExtentStyle], which controls the units of the [cacheExtent].
  final double? cacheExtent;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtentStyle}
  final CacheExtentStyle cacheExtentStyle;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Given a [BuildContext] and an [AxisDirection], determine the correct cross
  /// axis direction.
  ///
  /// This depends on the [Directionality] if the `axisDirection` is vertical;
  /// otherwise, the default cross axis direction is downwards.
  static AxisDirection getDefaultCrossAxisDirection(BuildContext context,
      AxisDirection axisDirection) {
    switch (axisDirection) {
      case AxisDirection.up:
        assert(debugCheckHasDirectionality(
          context,
          why: 'to determine the cross-axis direction when the viewport '
              "has an 'up' axisDirection",
          alternative: 'Alternatively, consider specifying the '
              "'crossAxisDirection' argument on the Viewport.",
        ));
        return textDirectionToAxisDirection(Directionality.of(context));
      case AxisDirection.right:
        return AxisDirection.down;
      case AxisDirection.down:
        assert(debugCheckHasDirectionality(
          context,
          why: 'to determine the cross-axis direction when the viewport '
              "has a 'down' axisDirection",
          alternative: 'Alternatively, consider specifying the '
              "'crossAxisDirection' argument on the Viewport.",
        ));
        return textDirectionToAxisDirection(Directionality.of(context));
      case AxisDirection.left:
        return AxisDirection.down;
    }
  }

  @override
  MyRenderViewport createRenderObject(BuildContext context) =>
      MyRenderViewport(
        axisDirection: axisDirection,
        crossAxisDirection: crossAxisDirection ??
            Viewport.getDefaultCrossAxisDirection(context, axisDirection),
        anchor: anchor,
        offset: offset,
        cacheExtent: cacheExtent,
        cacheExtentStyle: cacheExtentStyle,
        clipBehavior: clipBehavior,
      );

  @override
  void updateRenderObject(BuildContext context, RenderViewport renderObject) {
    renderObject
      ..axisDirection = axisDirection
      ..crossAxisDirection = crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection)
      ..anchor = anchor
      ..offset = offset
      ..cacheExtent = cacheExtent
      ..cacheExtentStyle = cacheExtentStyle
      ..clipBehavior = clipBehavior;
  }

  @override
  MultiChildRenderObjectElement createElement() => _ViewportElement(this);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(
        EnumProperty<AxisDirection>('axisDirection', axisDirection))..add(
        EnumProperty<AxisDirection>(
            'crossAxisDirection', crossAxisDirection, defaultValue: null))..add(
        DoubleProperty('anchor', anchor))..add(
        DiagnosticsProperty<ViewportOffset>('offset', offset));
    if (center != null) {
      properties.add(DiagnosticsProperty<Key>('center', center));
    } else if (children.isNotEmpty && children.first.key != null) {
      properties.add(DiagnosticsProperty<Key>(
          'center', children.first.key, tooltip: 'implicit'));
    }
    properties..add(
        DiagnosticsProperty<double>('cacheExtent', cacheExtent))..add(
        DiagnosticsProperty<CacheExtentStyle>(
            'cacheExtentStyle', cacheExtentStyle));
  }
}

class MyRenderViewport extends RenderViewport {
  //MyRenderViewport({required super.crossAxisDirection,
  // required super.offset});
  MyRenderViewport({
    required super.crossAxisDirection, required super.offset,
    super.axisDirection,
    super.anchor,
    super.children,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
  });

  @override
  Iterable<RenderSliver> get childrenInPaintOrder =>
      super.childrenInPaintOrder
          .toList()
          .reversed;
}

class _ViewportElement extends MultiChildRenderObjectElement
    with NotifiableElementMixin, ViewportElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  _ViewportElement(Viewport super.widget);

  bool _doingMountOrUpdate = false;
  int? _centerSlotIndex;

  @override
  RenderViewport get renderObject => super.renderObject as RenderViewport;

  @override
  void mount(Element? parent, Object? newSlot) {
    assert(!_doingMountOrUpdate);
    _doingMountOrUpdate = true;
    super.mount(parent, newSlot);
    _updateCenter();
    assert(_doingMountOrUpdate);
    _doingMountOrUpdate = false;
  }

  @override
  void update(MultiChildRenderObjectWidget newWidget) {
    assert(!_doingMountOrUpdate);
    _doingMountOrUpdate = true;
    super.update(newWidget);
    _updateCenter();
    assert(_doingMountOrUpdate);
    _doingMountOrUpdate = false;
  }

  void _updateCenter() {
    final Viewport viewport = widget as Viewport;
    if (viewport.center != null) {
      int elementIndex = 0;
      for (final Element e in children) {
        if (e.widget.key == viewport.center) {
          renderObject.center = e.renderObject as RenderSliver?;
          break;
        }
        elementIndex++;
      }
      assert(elementIndex < children.length);
      _centerSlotIndex = elementIndex;
    } else if (children.isNotEmpty) {
      renderObject.center = children.first.renderObject as RenderSliver?;
      _centerSlotIndex = 0;
    } else {
      renderObject.center = null;
      _centerSlotIndex = null;
    }
  }

  @override
  void insertRenderObjectChild(RenderObject child, IndexedSlot<Element?> slot) {
    super.insertRenderObjectChild(child, slot);
    // Once [mount]/[update] are done, the `renderObject.center` will be updated
    // in [_updateCenter].
    if (!_doingMountOrUpdate && slot.index == _centerSlotIndex) {
      renderObject.center = child as RenderSliver?;
    }
  }

  @override
  void moveRenderObjectChild(RenderObject child, IndexedSlot<Element?> oldSlot,
      IndexedSlot<Element?> newSlot) {
    super.moveRenderObjectChild(child, oldSlot, newSlot);
    assert(_doingMountOrUpdate);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    super.removeRenderObjectChild(child, slot);
    if (!_doingMountOrUpdate && renderObject.center == child) {
      renderObject.center = null;
    }
  }

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.where((e) {
      final RenderSliver renderSliver = e.renderObject! as RenderSliver;
      return renderSliver.geometry!.visible;
    }).forEach(visitor);
  }
}
