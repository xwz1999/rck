import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recook/constants/header.dart';

class DiamondRecommendationWidget extends StatelessWidget {
  final String title;
  const DiamondRecommendationWidget({Key key, this.title = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size postSize = Size(ScreenUtil.getInstance().width - 2 * rSize(40),
        334 / 300.0 * (ScreenUtil.getInstance().width - 2 * rSize(40)));
    return Center(
      child: Container(
        width: ScreenUtil.getInstance().width,
        padding: EdgeInsets.symmetric(horizontal: rSize(40)),
        child: Container(
          alignment: Alignment.center,
          height: postSize.height,
          width: postSize.width,
          child: Stack(
            children: <Widget>[
              Image.asset(
                AppImageName.diamond_recommendation_success,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: 0.2 * postSize.height,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: rSize(20),
                      vertical: ScreenAdapterUtils.setHeight(10)),
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: ScreenAdapterUtils.setSp(18),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
