import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/shop/widget/shop_page_self_income_widget.dart';
import 'package:recook/pages/shop/widget/shop_page_share_income_widget.dart';
import 'package:recook/pages/shop/widget/shop_page_team_income_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';

enum ShopPageSubIncomesPageType {
  ShopPageSelfIncome,
  ShopPageShareIncome,
  ShopPageTeamIncome
}

class ShopPageSubIncomesPage extends StatefulWidget {
  final Map arguments;
  ShopPageSubIncomesPage({
    Key key,
    this.arguments,
  }) : super(key: key);
  static setArguments(ShopPageSubIncomesPageType subType) {
    return {"subType": subType};
  }

  @override
  _ShopPageSubIncomesPageState createState() => _ShopPageSubIncomesPageState();
}

class _ShopPageSubIncomesPageState
    extends BaseStoreState<ShopPageSubIncomesPage> {
  ShopPageSubIncomesPageType _shopPageSubIncomesPageType;
  @override
  void initState() {
    super.initState();
    _shopPageSubIncomesPageType = widget.arguments["subType"];
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    String title = "";
    Widget body = Container();
    if (_shopPageSubIncomesPageType ==
        ShopPageSubIncomesPageType.ShopPageSelfIncome) {
      title = "自购收益";
      body = ShopPageSelfIncomeWidget();
    } else if (_shopPageSubIncomesPageType ==
        ShopPageSubIncomesPageType.ShopPageShareIncome) {
      title = "导购收益";
      body = ShopPageShareIncomeWidget();
    } else if (_shopPageSubIncomesPageType ==
        ShopPageSubIncomesPageType.ShopPageTeamIncome) {
      title = "团队收益";
      body = ShopPageTeamIncomeWidget();
    }
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        appBar: CustomAppBar(
          appBackground: AppColor.blackColor,
          themeData: AppThemes.themeDataMain.appBarTheme,
          elevation: 0,
          title: title,
        ),
        body: Container(
          child: body,
        ));
  }
}
