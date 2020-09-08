/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  10:28 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

class SCTabBar extends StatefulWidget implements PreferredSizeWidget {
  const SCTabBar({
    Key key,
    this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
    this.needRefresh = false,
    this.itemBuilder,
  })  :assert(isScrollable != null),
        assert(dragStartBehavior != null),
        assert(indicator != null ||
            (indicatorWeight != null && indicatorWeight > 0.0)),
        assert(indicator != null || (indicatorPadding != null)),
        super(key: key);

  // 是否需要每次切换时刷新item
  final bool needRefresh;
  final List<Widget> tabs;
  final TabController controller;
  final bool isScrollable;
  final Color indicatorColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration indicator;
  final TabBarIndicatorSize indicatorSize;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry labelPadding;
  final TextStyle unselectedLabelStyle;
  final DragStartBehavior dragStartBehavior;
  final ValueChanged<int> onTap;
  final Function(int index) itemBuilder;

  @override
  Size get preferredSize {
    for (Widget item in tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null)
          return Size.fromHeight(_kTextAndIconTabHeight + indicatorWeight);
      }
    }
    return Size.fromHeight(_kTabHeight + indicatorWeight);
  }

  @override
  _SCTabBarState createState() => _SCTabBarState();
}

class _SCTabBarState extends State<SCTabBar> {
  @override
  void initState() {
    super.initState();
    if (widget.needRefresh) {
      widget.controller.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: widget.tabs ?? _tabItems(),
      controller: widget.controller,
      isScrollable: widget.isScrollable,
      indicator: widget.indicator,
      indicatorColor: widget.indicatorColor,
      indicatorWeight: widget.indicatorWeight,
      indicatorPadding: widget.indicatorPadding,
      indicatorSize: widget.indicatorSize,
      labelPadding: widget.labelPadding,
      labelColor: widget.labelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelColor: widget.unselectedLabelColor,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      dragStartBehavior: widget.dragStartBehavior,
      onTap: widget.onTap,
    );
  }

  _tabItems() {
    assert(widget.itemBuilder != null);
    List<Widget> items = [];
    for (int i = 0;  i < widget.controller.length; i++) {
      items.add(widget.itemBuilder(i));
    }
    return items;
  }
}
