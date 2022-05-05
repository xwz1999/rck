/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/3  10:51 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recook/widgets/cache_view_page.dart';

/// A page view that displays the widget which corresponds to the currently
/// selected tab. Typically used in conjunction with a [TabBar].
///
/// If a [TabController] is not provided, then there must be a [DefaultTabController]
/// ancestor.
class CacheTabBarView extends StatefulWidget {
  /// Creates a page view with one child per tab.
  ///
  /// The length of [children] must be the same as the [controller]'s length.
  const CacheTabBarView({
    Key key,
    @required this.children,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.cacheCount = 0,
    this.needAnimation = true,
  })  : assert(children != null),
        assert(dragStartBehavior != null),
        super(key: key);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController controller;

  final bool needAnimation;

  /// cached page nums
  final cacheCount;

  /// One widget per tab.
  final List<Widget> children;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  _CacheTabBarViewState createState() => _CacheTabBarViewState();
}

final PageScrollPhysics _kTabBarViewPhysics =
    const PageScrollPhysics().applyTo(const ClampingScrollPhysics());

class _CacheTabBarViewState extends State<CacheTabBarView> {
  TabController _controller;
  PageController _pageController;
  List<Widget> _children;
  int _currentIndex;
  int _warpUnderwayCount = 0;

  void _updateTabController() {
    final TabController newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n'
            'When creating a ${widget.runtimeType}, you must either provide an explicit '
            'TabController using the "controller" property, or you must ensure that there '
            'is a DefaultTabController above the ${widget.runtimeType}.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());

    assert(() {
      if (newController.length != widget.children.length) {
        throw FlutterError(
            'Controller\'s length property (${newController.length}) does not match the \n'
            'number of elements (${widget.children.length}) present in TabBarView\'s children property.');
      }
      return true;
    }());

    if (newController == _controller) return;

    if (_controller != null)
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
    _controller = newController;
    if (_controller != null)
      _controller.animation.addListener(_handleTabControllerAnimationTick);
  }

  @override
  void initState() {
    super.initState();
    _children = widget.children;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller?.index;
    _pageController = PageController(initialPage: _currentIndex ?? 0);
  }

  @override
  void didUpdateWidget(CacheTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) _updateTabController();
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0)
      _children = widget.children;
  }

  @override
  void dispose() {
    if (_controller != null)
      _controller.animation.removeListener(_handleTabControllerAnimationTick);
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _handleTabControllerAnimationTick() {
    if (_warpUnderwayCount > 0 || !_controller.indexIsChanging)
      return; // This widget is driving the controller's animation.

    if (_controller.index != _currentIndex) {
      _currentIndex = _controller.index;
      _warpToCurrentIndex();
    }
  }

  Future<void> _warpToCurrentIndex() async {
    if (!mounted) return Future<void>.value();

    if (_pageController.page == _currentIndex.toDouble())
      return Future<void>.value();

    // final int previousIndex = _controller.previousIndex;

    /// 不注释点击间距大于1的时候  会刷新 children 界面
//    if ((_currentIndex - previousIndex).abs() == 1)
    if (widget.needAnimation) {
      return _pageController.animateToPage(_currentIndex,
          duration: kTabScrollDuration, curve: Curves.ease);
    }
    return _pageController.jumpToPage(_currentIndex);

    // assert((_currentIndex - previousIndex).abs() > 1);
    // int initialPage;
    // setState(() {
    //   _warpUnderwayCount += 1;
    //   _children = List<Widget>.from(widget.children, growable: false);
    //   if (_currentIndex > previousIndex) {
    //     _children[_currentIndex - 1] = _children[previousIndex];
    //     initialPage = _currentIndex - 1;
    //   } else {
    //     _children[_currentIndex + 1] = _children[previousIndex];
    //     initialPage = _currentIndex + 1;
    //   }
    // });
    //
    // _pageController.jumpToPage(initialPage);
    //
    // await _pageController.animateToPage(_currentIndex,
    //     duration: kTabScrollDuration, curve: Curves.ease);
    // if (!mounted) return Future<void>.value();
    //
    // setState(() {
    //   _warpUnderwayCount -= 1;
    //   _children = widget.children;
    // });
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0) return false;

    if (notification.depth != 0) return false;

    _warpUnderwayCount += 1;
    if (notification is ScrollUpdateNotification &&
        !_controller.indexIsChanging) {
      if ((_pageController.page - _controller.index).abs() > 1.0) {
        _controller.index = _pageController.page.floor();
        _currentIndex = _controller.index;
      }
      _controller.offset =
          (_pageController.page - _controller.index).clamp(-1.0, 1.0);
    } else if (notification is ScrollEndNotification) {
      _controller.index = _pageController.page.round();
      _currentIndex = _controller.index;
    }
    _warpUnderwayCount -= 1;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: CachePageView(
        dragStartBehavior: widget.dragStartBehavior,
        controller: _pageController,
        physics: widget.physics == null
            ? _kTabBarViewPhysics
            : _kTabBarViewPhysics.applyTo(widget.physics),
        children: _children,
        cacheCount: widget.cacheCount,
      ),
    );
  }
}
