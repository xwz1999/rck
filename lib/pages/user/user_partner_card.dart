import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:velocity_x/velocity_x.dart';


class UserPartnerCard extends StatelessWidget {
  final int userId;
  final String headImgUrl;
  final String nickname;
  final String phone;
  final String wechatNo;
  final String remarkName;
  final int count;
  final int roleLevel;
  final num amount;
  final int order_count;

  //final UserIncome model;
  const UserPartnerCard({
    Key key,
    this.userId,
    this.headImgUrl,
    this.nickname,
    this.phone,
    this.wechatNo,
    this.remarkName,
    this.count,
    this.roleLevel,
    this.amount,
    this.order_count,
  }) : super(key: key);
  UserRoleLevel get roleLevelEnum => UserLevelTool.roleLevelEnum(roleLevel);

  _renderItem(String asset, String value) {
    String displayValue = value;
    if (displayValue?.isEmpty ?? true) {
      displayValue = ' —';
    }
    return Row(
      children: [
        Image.asset(asset, width: 10.rw, height: 10.rw),
        2.wb,
        displayValue.text.size(11.rsp).color(Color(0xFF999999)).make().expand(),
      ],
    ).expand();
  }

  _renderNoItem() {
    return Row(
      children: [],
    ).expand();
  }

  String get itemName {
    String item = nickname;
    if (remarkName.isNotEmpty && UserManager.instance.user.info.id != userId) {
      item += '($remarkName)';
    }

    if (UserManager.instance.user.info.id == userId) {
      item += '(本人)';
    }
    if(phone.startsWith('2')){
      item = '【该账户已注销】';
    }

    return item;
  }

  String get countValue {
    if (count == -1)
      return '—';
    else
      return (count ?? 0).toString();
  }

  String get amountValue {
    if (amount == -1)
      return '—';
    else
      return (amount ?? 0.0).toStringAsFixed(2);
  }

  String get orderValue {
    if (order_count == -1)
      return '—';
    else
      return (order_count ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      children: [
        16.wb,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.rw),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(headImgUrl),
                height: 40.rw,
                width: 40.rw,
              ),
            ),
            8.hb,
            Image.asset(
              UserLevelTool.getRoleLevelIcon(roleLevelEnum),
              width: 12.rw,
              height: 12.rw,
            ),
          ],
        ),
        10.wb,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.hb,
            itemName.text.black.size(14.rsp).make(),
            10.hb,
            Row(
              children: [
                _renderItem(R.ASSETS_USER_ICON_PHONE_PNG, phone.startsWith('2')?'—':phone),
                _renderItem(R.ASSETS_USER_ICON_WECHAT_PNG, wechatNo),
                _renderNoItem(),
              ],
            ),
            12.hb,
            Row(
              children: [
                _renderItem(R.ASSETS_USER_ICON_GROUP_PNG, countValue),
                _renderItem(R.ASSETS_USER_ICON_ORDER_PNG, orderValue),
                _renderItem(
                  R.ASSETS_USER_ICON_MONEY_PNG,
                  amountValue,
                ),
              ],
            ),
            16.hb,
          ],
        ).expand(),
      ],
    );
    return GestureDetector(
      onTap: () {},
      child: widget,
    );
  }
}
