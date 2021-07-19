import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:recook/widgets/alert.dart';
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
        30.w.heightBox,
        Row(children: <Widget>[
          30.w.widthBox,
          Container(
            height: 18.rw,
            width: 2.5.rw,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          6.wb,
          '${UserLevelTool.currentRoleLevel()}考核'
              .text
              .bold
              .size(16.rsp)
              .black
              .make(),
          Spacer(),
        ]),
        12.w.heightBox,
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
                .size(12.rsp)
                .make()
                .pOnly(left: 16.rw),
            4.w.widthBox,
          ].row(),
        ),
        Row(
          children: [
            60.w.wb,
            '考核目标：店铺销售额${widget.target.toStringAsFixed(0)}元'
                .text
                .color(Colors.black45)
                .size(12.rsp)
                .make(),
            MaterialButton(
              padding: EdgeInsets.all(4.rw),
              minWidth: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Icon(
                Icons.help_outline,
                size: 12.rw,
                color: Color(0xFFA5A5A5),
              ),
              onPressed: () {
                Alert.show(
                  context,
                  NormalTextDialog(
                    title: '提示',
                    content: '店铺销售额为店铺内已确认收货订单的销售额合计',
                    items: ["确认"],
                    listener: (index) => Alert.dismiss(context),
                  ),
                );
              },
            ),
          ],
        ),
        20.w.heightBox,
        Container(
          height: 68.rw,
          width: 68.rw,
          child: CustomPaint(
            child: Image.asset(
              R.ASSETS_SHOP_PAGE_PROGRESS_ICON_MASTER_SALE_PNG,
              height: 16.rw,
              width: 16.rw,
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
        10.w.heightBox,
        title.text.size(12.rsp).black.center.make().centered(),
        30.w.heightBox,
      ],
    )).color(Colors.white).margin(EdgeInsets.only(bottom: 10)).make();
  }
}
