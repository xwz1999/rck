import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/widget/user_page_self_income_widget.dart';
import 'package:recook/pages/user/widget/user_page_share_income_widget.dart';
import 'package:recook/pages/user/widget/user_page_team_income_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';

enum UserPageSubIncomesPageType {
  UserPageSelfIncome,
  UserPageShareIncome,
  UserPageTeamIncome
}

class UserPageSubIncomesPage extends StatefulWidget {
  final Map arguments;
  UserPageSubIncomesPage({
    Key key,
    this.arguments,
  }) : super(key: key);
  static setArguments(UserPageSubIncomesPageType subType) {
    return {"subType": subType};
  }

  @override
  _UserPageSubIncomesPageState createState() => _UserPageSubIncomesPageState();
}

class _UserPageSubIncomesPageState
    extends BaseStoreState<UserPageSubIncomesPage> {
  UserPageSubIncomesPageType _shopPageSubIncomesPageType;
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
        UserPageSubIncomesPageType.UserPageSelfIncome) {
      title = "自购收益";
      body = UserPageSelfIncomeWidget();
    } else if (_shopPageSubIncomesPageType ==
        UserPageSubIncomesPageType.UserPageShareIncome) {
      title = "导购收益";
      body = UserPageShareIncomeWidget();
    } else if (_shopPageSubIncomesPageType ==
        UserPageSubIncomesPageType.UserPageTeamIncome) {
      title = "团队收益";
      body = UserPageTeamIncomeWidget();
    }
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: title,
      ),
      body: Container(
        color: AppColor.frenchColor,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: body,
            ),
            _shopPageSubIncomesPageType ==
                    UserPageSubIncomesPageType.UserPageTeamIncome
                ? Container(
                    width: double.infinity,
                    height: 30,
                    color: AppColor.frenchColor.withOpacity(0.95),
                    alignment: Alignment.center,
                    child: Text(
                      '每月22号结算上月团队收益',
                      style: TextStyle(
                        color: AppColor.blackColor,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
