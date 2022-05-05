import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/const/resource.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';

class NoDataView extends StatelessWidget {
  final String text;
  final Widget icon;
  NoDataView({Key key, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon ??
                Image.asset(
                  R.ASSETS_NODATA_PNG,
                  width: rSize(80),
                  height: rSize(80),
                ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
            SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
            ),
            SizedBox(
              height: rSize(30),
            )
          ],
        ),
      );

  }
}
