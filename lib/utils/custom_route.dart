import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO CLEAN BOTTOM CODES.
@Deprecated("move CRoute to GetX")
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

  static Future pushReplace(BuildContext context, Widget page) async {
    await Navigator.pushReplacement(context, _cPageRoute(context, page));
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

  ///透明路由
  static transparent(BuildContext context, Widget child) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondAnimation) {
            return FadeTransition(opacity: animation, child: child);
          },
          opaque: false,
        ));
  }
}
