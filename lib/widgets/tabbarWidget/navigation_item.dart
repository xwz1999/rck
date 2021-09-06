import 'package:flutter/material.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/widgets/tabbarWidget/ace_bottom_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class NavigationItem extends StatelessWidget {
  final UniqueKey uniqueKey;
  final textStr;
  final textUnSelectedColor;
  final textSelectedColor;
  final icon;
  final protrudingIcon;
  final iconUnSelectedColor;
  final iconSelectedColor;
  final image;
  final imageSelected;
  final selected;
  final isProtruding;
  final ACEBottomNavigationBarType type;
  final Function(UniqueKey uniqueKey) callbackFunction;

  NavigationItem(
      {@required this.uniqueKey,
      @required this.selected,
      @required this.textStr,
      @required this.textSelectedColor,
      @required this.textUnSelectedColor,
      @required this.icon,
      @required this.iconSelectedColor,
      @required this.iconUnSelectedColor,
      @required this.image,
      @required this.imageSelected,
      @required this.callbackFunction,
      @required this.type,
      @required this.isProtruding,
      this.protrudingIcon});

  @override
  Widget build(BuildContext context) {
    var child = GestureDetector(
        onTap: () {
          callbackFunction(uniqueKey);
        },
        child: Container(
          color: Colors.white,
          child: Stack(children: <Widget>[
            Container(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                    opacity: textOption(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 6),
                      child: GestureDetector(
                        child: Text(textStr,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: selected ? 11 * 2.sp : 11 * 2.sp,
                                // fontWeight: FontWeight.normal,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? textSelectedColor
                                    : textUnSelectedColor)),
                        onTap: () {
                          callbackFunction(uniqueKey);
                        },
                      ),
                    ))),
            Container(
                child: AnimatedAlign(
                    duration: Duration(milliseconds: 1000),
                    alignment: picZoomAlignment(),
                    child: childWid())),
          ]),
        ));

    return Expanded(
        child: Opacity(opacity: isProtruding ? 0.0 : 1.0, child: child));
  }

  double picSize() {
    var size;
    if (type == ACEBottomNavigationBarType.normal) {
      // size = ScreenAdapterUtils.setWidth(25.0);
      size = 36.w;
    } else {
      size = selected
          ? 36.w
          : 32.w;
      // size = selected
      //     ? ScreenAdapterUtils.setWidth(28.0)
      //     : ScreenAdapterUtils.setWidth(25.0);
    }
    return size;
  }

  double textOption() {
    var option;
    if (type == ACEBottomNavigationBarType.zoom ||
        type == ACEBottomNavigationBarType.zoomoutonlypic) {
//      option = selected ? 0.0 : 1.0;
      option = 1.0;
    } else {
      option = 1.0;
    }
    return option;
  }

  Alignment picZoomAlignment() {
    var alignment;
    if (type == ACEBottomNavigationBarType.normal ||
        type == ACEBottomNavigationBarType.zoom) {
      alignment = Alignment(0, 0);
    } else if (type == ACEBottomNavigationBarType.zoomout) {
      alignment = Alignment(0, (selected) ? -4 : 0);
    } else if (type == ACEBottomNavigationBarType.zoomoutonlypic) {
      alignment = Alignment(0, (selected) ? -2 : 0);
    } else {
      alignment = Alignment(0, 0);
    }
    return alignment;
  }

  EdgeInsetsGeometry imagePadding() {
    EdgeInsetsGeometry edge;
    if (type == ACEBottomNavigationBarType.zoom) {
      edge = selected
          ? EdgeInsets.only(top: 6.0, bottom: 6.0)
          : EdgeInsets.only(bottom: 20.0);
    } else if (type == ACEBottomNavigationBarType.zoomout ||
        type == ACEBottomNavigationBarType.zoomoutonlypic) {
      edge = selected
          ? EdgeInsets.only(bottom: 0.0)
          : EdgeInsets.only(bottom: 20.0);
    } else if (type == ACEBottomNavigationBarType.normal) {
      edge = EdgeInsets.only(
        bottom: 20.0,
      );
    } else {
      edge = EdgeInsets.only(bottom: 0.0);
    }
    return edge;
  }

  Widget childWid() {
    Widget widget;
    if (image != null) {
      widget = GestureDetector(
          child: Container(
            width: rSize(40),
            child: Padding(
                padding: imagePadding(),
                child: Image(
                    image: (selected && imageSelected != null)
                        ? imageSelected
                        : image,
                    width: picSize(),
                    height: picSize())),
          ),
          onTap: () {
            callbackFunction(uniqueKey);
          });
    } else {
      widget = IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.only(bottom: 23.0, top: 2),
          alignment: Alignment(0, 0),
          icon: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: Icon(icon,
                size: picSize(),
                color: selected ? iconSelectedColor : iconUnSelectedColor),
          ),
          onPressed: () {
            callbackFunction(uniqueKey);
          });
    }
    return widget;
  }
}
