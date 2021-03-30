import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/widget/shop_check_painter.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ShopCheckView extends StatefulWidget {
  final double target;
  final double amount;
  ShopCheckView({Key key, @required this.target, @required this.amount})
      : super(key: key);

  @override
  _ShopCheckViewState createState() => _ShopCheckViewState();
}

class _ShopCheckViewState extends State<ShopCheckView> {
  UserLevel get role => UserLevelTool.currentUserLevelEnum();

  //sliverColors
  final Color sliverTheme = Color(0xFF4F646C);
  final Color sliverBegin = Color(0xFFB2C1CF);
  final Color sliverEnd = Color(0xFF364C53);

  //goldColors
  final Color goldTheme = Color(0xFFE2B56B);
  final Color goldBegin = Color(0xFFECD5A7);
  final Color goldEnd = Color(0xFFE0AE5C);

  Color _themeColor;
  Color _beginColor;
  Color _endColor;
  @override
  void initState() {
    super.initState();
    if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold) {
      _themeColor = goldTheme;
      _beginColor = goldBegin;
      _endColor = goldEnd;
    } else {
      _themeColor = sliverTheme;
      _beginColor = sliverBegin;
      _endColor = sliverEnd;
    }
  }

  double get _target => widget.target ?? 100;
  double get _amount => widget.amount ?? 0;

  DateTime get _now => DateTime.now();

  String get title => _amount <= _target
      ? '还需团队销售额${_target - _amount}元'
      : '已满足${UserLevelTool.currentRoleLevel()}考核标准';
  double get percent {
    if (_target == 0) return 100;
    if (_amount == 0) return 0;
    return _amount / _target * 100;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(_now.year, _now.month, 1);
    DateTime limitDate = DateTime(_now.year, _now.month + 1, -1);
    DateTime checkDate = DateTime(_now.year, _now.month + 1, 1);
    return VxBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        <Widget>[
          15.wb,
          40.hb,
          Container(
            height: 18.w,
            width: 2.5.w,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          6.wb,
          '${UserLevelTool.currentRoleLevel()}考核'
              .text
              .bold
              .size(16.sp)
              .black
              .make(),
          Spacer(),
        ].row(),
        CustomImageButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: [
            '本考核期${DateUtil.formatDate(
              date,
              format: 'MM月dd日',
            )}至${DateUtil.formatDate(
              limitDate,
              format: 'MM月dd日',
            )},将于${DateUtil.formatDate(
              checkDate,
              format: 'MM月dd日',
            )}考核。'
                .text
                .color(Colors.black45)
                .size(12.sp)
                .make()
                .pOnly(left: 16.w),
            2.wb,
            Image.asset(
              R.ASSETS_SHOP_HELPER_PNG,
              height: 12.w,
              width: 12.w,
            ),
          ].row(),
        ),
        '考核目标：店铺销售额${widget.target.toStringAsFixed(0)}元'
            .text
            .color(Colors.black45)
            .size(12.sp)
            .make()
            .pSymmetric(h: 16.w),
        10.hb,
        Container(
          height: 68.w,
          width: 68.w,
          child: CustomPaint(
            child: Image.asset(
              R.ASSETS_SHOP_PAGE_PROGRESS_ICON_MASTER_SALE_PNG,
              height: 16.w,
              width: 16.w,
              color: _themeColor,
            ).centered(),
            painter: ShopCheckPainter(
              themeColor: _themeColor.withOpacity(0.5),
              beginColor: _beginColor,
              endColor: _endColor,
              percentage: percent,
            ),
          ),
        ).centered(),
        5.hb,
        title.text.size(12.sp).black.center.make().centered(),
        15.hb,
      ],
    )).color(Colors.white).margin(EdgeInsets.only(bottom: 10)).make();
  }
}
