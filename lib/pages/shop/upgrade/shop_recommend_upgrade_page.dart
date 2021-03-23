import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/shop_upgrade_code_model.dart';
import 'package:recook/models/shop_upgrade_role_message_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class ShopRecommendUpgradePage extends StatefulWidget {
  ShopRecommendUpgradePage({Key key}) : super(key: key);

  @override
  _ShopRecommendUpgradePageState createState() =>
      _ShopRecommendUpgradePageState();
}

class _ShopRecommendUpgradePageState
    extends BaseStoreState<ShopRecommendUpgradePage> {
  double _width;
  final double _uiWidth = 375;
  final double _uiHeight = 767.6;

  ShopUpgradeCodeModel _shopUpgradeCodeModel;
  ShopUpgradeRoleMessageModel _roleMessageModel;

  @override
  Widget buildContext(BuildContext context, {store}) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: Colors.white,
        elevation: 0,
        title: "推荐升级",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: SingleChildScrollView(
        // controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            _imageBgWidgetS(),
          ],
        ),
      ),
    );
  }

  _imageBgWidgetS() {
    return Image.asset(
      R.ASSETS_MEMBERBENEFITSPAGE_BG_S_WEBP,
      fit: BoxFit.fill,
    );
  }
}
