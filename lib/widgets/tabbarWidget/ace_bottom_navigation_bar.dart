import 'package:flutter/material.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/tabBar/TabbarWidget.dart';
import 'package:recook/widgets/tabbarWidget/navigation_item.dart';

enum ACEBottomNavigationBarType {
  normal,
  zoom,
  zoomout,
  zoomoutonlypic,
  protruding
}

class ACEBottomNavigationBar extends StatefulWidget {
  final Key key;
  final BottomBarController barController;
  final List<NavigationItemBean> items;
  final int initSelectedIndex;
  final Color bgColor;
  final ImageProvider bgImage;
  final Function(int position) onTabChangedListener;
  final Function(int position) onProtrudingItemClickListener;
  final String textStr;
  final Color textUnSelectedColor;
  final Color textSelectedColor;
  final IconData icon;
  final Color iconUnSelectedColor;
  final Color iconSelectedColor;
  final ImageProvider image;
  final dynamic imageSelected;
  final Color protrudingColor;
  final ACEBottomNavigationBarType type;

  ACEBottomNavigationBar(
      {@required this.items,
      @required this.onTabChangedListener,
      ACEBottomNavigationBarType type,
      this.key,
      this.barController,
      this.initSelectedIndex = 0,
      this.textStr,
      this.textSelectedColor,
      this.textUnSelectedColor,
      this.icon,
      this.iconSelectedColor,
      this.iconUnSelectedColor,
      this.image,
      this.imageSelected,
      this.bgColor = Colors.white,
      this.bgImage,
      this.protrudingColor,
      this.onProtrudingItemClickListener})
      : assert(onTabChangedListener != null),
        assert(onProtrudingItemClickListener != null),
        assert(items != null),
        assert(items.length >= 1 && items.length <= 5),
        type = type;

  @override
  _ACEBottomNavigationBar createState() => _ACEBottomNavigationBar();
}

class _ACEBottomNavigationBar extends State<ACEBottomNavigationBar>
    with TickerProviderStateMixin, RouteAware {
  var curSelectedIndex = 0;
  var textSelectedColor;
  var textUnSelectedColor;
  var iconSelectedColor;
  var iconUnSelectedColor;
  var protrudingIndex = -1;

  @override
  void dispose() {
    super.dispose();
    UserManager.instance.selectTabbar.removeListener(_selectTabbar);
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.items[widget.initSelectedIndex].key);
    // widget.barController.selectIndex.addListener(_selectIndex);
    UserManager.instance.selectTabbar.addListener(_selectTabbar);
  }
  // _selectIndex(){
  //   if (!widget.barController.selectIndexChange) {return;}
  //   _setSelected(widget.items[widget.barController.selectIndex.value].key);
  //   widget.barController.selectIndexChange = false;
  //   widget.barController.selectIndex.value = 0;
  // }
  _selectTabbar(){
    int index = UserManager.instance.selectTabbarIndex;
    _setSelected(widget.items[index].key);
  }

  _setSelected(UniqueKey key) {
    if (mounted) {
      setState(() {
        curSelectedIndex =
            widget.items.indexWhere((tabData) => tabData.key == key);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textUnSelectedColor = (widget.textUnSelectedColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textUnSelectedColor;
    textSelectedColor = (widget.textSelectedColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black87
        : widget.textSelectedColor;
    iconUnSelectedColor = (widget.iconUnSelectedColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.iconUnSelectedColor;
    iconSelectedColor = (widget.iconSelectedColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black87
        : widget.iconSelectedColor;

    if (widget.items.length == 1) {
      protrudingIndex = 0;
    } else if (widget.items.length == 3) {
      protrudingIndex = 1;
    } else if (widget.items.length == 5) {
      protrudingIndex = 2;
    } else {
      protrudingIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: SafeArea(
        child: Stack(
            alignment: Alignment.bottomCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                  height: ScreenAdapterUtils.setWidth(50.0),
                  decoration: navigationBarBg(),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: widget.items
                          .map((item) => NavigationItem(
                              uniqueKey: item.key,
                              selected: item.key ==
                                  widget.items[curSelectedIndex].key,
                              icon: item.icon,
                              textStr: item.textStr,
                              textSelectedColor:
                                  (item.textSelectedColor == null)
                                      ? this.textSelectedColor
                                      : item.textSelectedColor,
                              textUnSelectedColor:
                                  (item.textUnSelectedColor == null)
                                      ? this.textUnSelectedColor
                                      : item.textUnSelectedColor,
                              iconSelectedColor:
                                  (item.iconSelectedColor == null)
                                      ? this.iconSelectedColor
                                      : item.iconSelectedColor,
                              iconUnSelectedColor:
                                  (item.iconUnSelectedColor == null)
                                      ? this.iconUnSelectedColor
                                      : item.iconUnSelectedColor,
                              type: widget.type != null
                                  ? (widget.type ==
                                          ACEBottomNavigationBarType.protruding)
                                      ? ACEBottomNavigationBarType.normal
                                      : widget.type
                                  : ACEBottomNavigationBarType.normal,
                              image: item.image,
                              imageSelected: item.imageSelected,
                              isProtruding: (protrudingIndex != -1 &&
                                      widget.type ==
                                          ACEBottomNavigationBarType
                                              .protruding &&
                                      widget.items.indexOf(item) ==
                                          protrudingIndex)
                                  ? true
                                  : false,
                              protrudingIcon: item.protrudingIcon,
                              callbackFunction: (uniqueKey) {
                                int selected = widget.items.indexWhere(
                                    (tabData) => tabData.key == uniqueKey);
                                _setSelected(uniqueKey);
                                widget.onTabChangedListener(selected);
                              }))
                          .toList())),
              protrudingWid()
            ]),
      ),
    );
  }

  BoxDecoration navigationBarBg() {
    return widget.bgImage != null
        ? BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: widget.bgImage))
        : BoxDecoration(
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Color.fromARGB(10, 0, 0, 0), //阴
                  blurRadius: 5, // 影颜色,
                  offset: Offset(0, -8)),
            ],
            color: widget.bgColor != null ? widget.bgColor : Colors.white,
          );
  }

  Widget protrudingWid() {
    Widget proWid;
    if (widget.items.length % 2 == 0 ||
        widget.type != ACEBottomNavigationBarType.protruding) {
      proWid = Container(width: 0.0, height: 0.0);
    } else {
      proWid = Positioned.fill(
          top: -20,
          child: Container(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.protrudingColor != null
                                    ? widget.protrudingColor
                                    : Colors.white),
                            child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: protrudingItemWid(
                                    widget.items[protrudingIndex]))))
                  ]))));
    }
    return proWid;
  }

  Widget protrudingItemWid(NavigationItemBean item) {
    Widget itemWidget;

    bool isProtruding = (protrudingIndex != -1 &&
            widget.type == ACEBottomNavigationBarType.protruding &&
            widget.items.indexOf(item) == protrudingIndex)
        ? true
        : false;

    if (item.image != null) {
      itemWidget = GestureDetector(
          child: Image(image: item.image),
          onTap: () {
//            widget.onTabChangedListener(protrudingIndex);
            widget.onProtrudingItemClickListener(protrudingIndex);
            _setSelected(item.key);
          });
    } else {
      itemWidget = IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          alignment: Alignment(0, 0),
          icon: Icon(
            isProtruding ? item.protrudingIcon : item.icon,
            size: 40.0,
            color: Colors.white,
          ),
          onPressed: () {
//            widget.onTabChangedListener(protrudingIndex);
            widget.onProtrudingItemClickListener(protrudingIndex);
            _setSelected(item.key);
          });
    }
    return itemWidget;
  }
}

class NavigationItemBean {
  String textStr;
  Color textUnSelectedColor;
  Color textSelectedColor;
  IconData icon;
  IconData protrudingIcon;
  Color iconUnSelectedColor;
  Color iconSelectedColor;
  ImageProvider image;
  dynamic imageSelected;
  bool selected;
  bool isProtruding;
  ACEBottomNavigationBarType type;

  NavigationItemBean(
      {this.selected,
      this.textStr,
      this.textSelectedColor,
      this.textUnSelectedColor,
      this.icon,
      this.iconSelectedColor,
      this.iconUnSelectedColor,
      this.image,
      this.imageSelected,
      this.type,
      this.isProtruding,
      this.protrudingIcon});

  final UniqueKey key = UniqueKey();
}
