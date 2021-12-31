import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';

class ItemTagWidget {
  static SliverGridDelegate getSliverGridDelegate(_displayList, context) {
    return new SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: _displayList ? 5 : 10,
        crossAxisSpacing: _displayList ? 0 : 10,
        // childAspectRatio: _displayList ? 2.9 : 0.61,
        // childAspectRatio: _displayList ? MediaQuery.of(context).size.width/180 : 0.59,
        childAspectRatio: _displayList
            ? MediaQuery.of(context).size.width /
                ((MediaQuery.of(context).size.width - 20) * 150.0 / 350.0)
            : 174/330,
        crossAxisCount: _displayList ? 1 : 2);
  }

  static Widget imageMaskWidget(
      {double padding = 20, double width = 82, double height = 82}) {
    return Container(
      padding: EdgeInsets.all(padding),
      color: Colors.black.withOpacity(0.2).withAlpha(110),
      child: Image.asset(
        "assets/goods_sold_out.png",
        width: width,
        height: height,
      ),
    );
  }

  static Widget getWidgetWithTag(String tag,
      {Color color = AppColor.themeColor}) {
    if (!TextUtils.isEmpty(tag) && "限时特卖" == tag) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.only(right: 5),
          height: 15,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
          ),
          child: Container(
            child: Text(
              tag,
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ));
    }
    if (!TextUtils.isEmpty(tag) && "新人特惠" == tag) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.only(right: 5),
          height: 15,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
          ),
          child: Container(
            child: Text(
              tag,
              style: TextStyle(color: color, fontSize: 9),
            ),
          )
          // child: Text(tag, style: TextStyle(color: color,fontSize: 9),),
          );
    }
    return Container();
  }
}
