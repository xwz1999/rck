import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/utils/user_level_tool.dart';

class RoleLevelUpgradeAlert extends StatelessWidget {
  final UserRoleLevel userRoleLevel;
  final UserLevel userLevel;
  final double width;
  const RoleLevelUpgradeAlert({Key key, this.userRoleLevel, this.width=0, this.userLevel,}) : super(key: key);


  final String master3Alert = "assets/alert_master3.png";
  final String master4Alert = "assets/alert_master4.png";
  final String silverAlert = "assets/alert_silver.png";
  final String goldAlert = "assets/alert_gold.png";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _body(),
      ),
    );
  }
  _body(){
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

  _masterWidget(){
    return Container(
      child: Container(
        width: width -80,
        height: (width - 80)*(350.0/301.0),
        child: Image.asset(userLevel == UserLevel.Others ? master4Alert : master3Alert , fit: BoxFit.fill,),
      ),
    );
  }

  _silverWidget(){
    return Container(
      width: width -80,
      height: (width - 80)*(355.0/301.0),
      child: Image.asset(silverAlert, fit: BoxFit.fill,),
    );
  }

  _goldWidget(){
    return Container(
      width: width -80,
      height: (width - 80)*(355.0/301.0),
      child: Image.asset(goldAlert, fit: BoxFit.fill,),
    );
  }

}


class ShopPageUpgradeAlert extends StatelessWidget {
  final UserRoleLevel userRoleLevel;
  final double width;
  const ShopPageUpgradeAlert({Key key, this.userRoleLevel, this.width=0,}) : super(key: key);


  final String masterAlert = "assets/shop_page_alert_master.png";
  final String silverAlert = "assets/shop_page_alert_silver.png";
  final String goldAlert = "assets/shop_page_alert_gold.png";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _body(),
      ),
    );
  }
  _body(){
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

  _masterWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: width -80,
            height: (width - 80)*(457.0/301.0),
            child: Image.asset(masterAlert, fit: BoxFit.fill,),
          ),
          Container(
            height: 40,
            child: Icon(Icons.clear , color: Colors.white, size: 30,),
          ),
        ],
      ),
    );
  }

  _silverWidget(){
    return Container(
      width: width -80,
      height: (width - 80)*(355.0/301.0),
      child: Image.asset(silverAlert, fit: BoxFit.fill,),
    );
  }

  _goldWidget(){
    return Container(
      width: width -80,
      height: (width - 80)*(355.0/301.0),
      child: Image.asset(goldAlert, fit: BoxFit.fill,),
    );
  }

}