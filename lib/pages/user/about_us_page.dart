import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends BaseStoreState<AboutUsPage> {
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "关于我们",
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Container(
        // padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          R.ASSETS_RECOOK_ABOUT_US_JPG_WEBP,
          fit: BoxFit.fill,
        ),
      )),
    );
  }
}
