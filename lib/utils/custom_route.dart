import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO 路由重构计划
class CRoute {
  static get isIOS => Platform.isIOS;
  static Route _cPageRoute(BuildContext context, Widget child) {
    return isIOS
        ? CupertinoPageRoute(builder: (context) => child)
        : MaterialPageRoute(builder: (context) => child);
  }

  static Future push(BuildContext context, Widget page) async {
    await Navigator.push(context, _cPageRoute(context, page));
  }

  ///路由到根
  static popBottom(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      popBottom(context);
    } else {
      return;
    }
  }
}
