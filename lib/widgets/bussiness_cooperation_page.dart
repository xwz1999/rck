import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class BussinessCooperationPage extends StatelessWidget {
  const BussinessCooperationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: CustomAppBar(
        title: '商务合作',
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 10.rw),
            child: Image.asset(
              R.ASSETS_BUSINESS_COOPERATION_WEBP,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 10.rw),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '''如果您
想致力于为消费者提供更有品质的生活；
倡导独立不盲从的价值观；
请联系我们。''',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    fontSize: 14.rsp,
                  ),
                ),
                10.hb,
                Text(
                  '''地址：浙江省宁波市鄞州区菁华路108号德邦大厦四楼
电话：400-889-4489
邮箱：Dora@cn-recook.com''',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 12.rsp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
