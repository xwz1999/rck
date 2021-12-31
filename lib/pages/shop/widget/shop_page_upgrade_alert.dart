import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';

class RoleLevelUpgradeAlert extends StatelessWidget {
  final UserRoleLevel userRoleLevel;
  final UserLevel userLevel;
  final double width;
  const RoleLevelUpgradeAlert({
    Key key,
    this.userRoleLevel,
    this.width = 0,
    this.userLevel,
  }) : super(key: key);

  final String master3Alert = R.ASSETS_ALERT_MASTER3_PNG_WEBP;
  final String master4Alert = R.ASSETS_ALERT_MASTER4_PNG_WEBP;
  final String silverAlert = R.ASSETS_ALERT_SILVER_PNG_WEBP;
  final String goldAlert = R.ASSETS_ALERT_GOLD_PNG_WEBP;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    switch (userRoleLevel) {
      case UserRoleLevel.Master:
        return _masterWidget();
        break;
      case UserRoleLevel.Silver:
        return _silverWidget();
        break;
      case UserRoleLevel.Gold:
        return _goldWidget();
        break;
      default:
        return _masterWidget();
        break;
    }
  }

  _masterWidget() {
    return Container(
      child: Container(
        width: width - 80,
        height: (width - 80) * (350.0 / 301.0),
        child: Image.asset(
          userLevel == UserLevel.Others ? master4Alert : master3Alert,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _silverWidget() {
    return Container(
      width: width - 80,
      height: (width - 80) * (355.0 / 301.0),
      child: Image.asset(
        silverAlert,
        fit: BoxFit.fill,
      ),
    );
  }

  _goldWidget() {
    return Container(
      width: width - 80,
      height: (width - 80) * (355.0 / 301.0),
      child: Image.asset(
        goldAlert,
        fit: BoxFit.fill,
      ),
    );
  }
}

class ShopPageUpgradeAlert extends StatelessWidget {
  final UserRoleLevel userRoleLevel;
  final double width;
  const ShopPageUpgradeAlert({
    Key key,
    this.userRoleLevel,
    this.width = 0,
  }) : super(key: key);

  final String masterAlert = R.ASSETS_SHOP_PAGE_ALERT_MASTER_PNG_WEBP;
  final String silverAlert = R.ASSETS_SHOP_PAGE_ALERT_SILVER_PNG_WEBP;
  final String goldAlert = R.ASSETS_SHOP_PAGE_ALERT_GOLD_PNG_WEBP;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    switch (userRoleLevel) {
      case UserRoleLevel.Master:
        return _masterWidget();
        break;
      case UserRoleLevel.Silver:
        return _silverWidget();
        break;
      case UserRoleLevel.Gold:
        return _goldWidget();
        break;
      default:
        return Container();
        break;
    }
  }

  _masterWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: width - 80,
            height: (width - 80) * (457.0 / 301.0),
            child: Image.asset(
              masterAlert,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 40,
            child: Icon(
              Icons.clear,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  _silverWidget() {
    return Container(
      width: width - 80,
      height: (width - 80) * (355.0 / 301.0),
      child: Image.asset(
        silverAlert,
        fit: BoxFit.fill,
      ),
    );
  }

  _goldWidget() {
    return Container(
      width: width - 80,
      height: (width - 80) * (355.0 / 301.0),
      child: Image.asset(
        goldAlert,
        fit: BoxFit.fill,
      ),
    );
  }
}
