import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class BussinessCooperationPage extends StatelessWidget {
  const BussinessCooperationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '商务合作',
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: ListView(
        children: [
          Image.asset(
            R.ASSETS_BUSINESSCOOPERATION_PNG_WEBP,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
