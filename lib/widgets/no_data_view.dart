/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/21  1:54 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class NoDataView extends StatelessWidget {
  final double height;
  final String title;

  const NoDataView({Key? key, this.height = 500, this.title = "没有数据喔~"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: Image.asset(
                AppImageName.img_no_data,
              )),
          Container(
            alignment: Alignment.center,
            child: Text(
              this.title,
              style: AppTextStyle.generate(16,
                  color: Colors.grey[400], fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }

}
