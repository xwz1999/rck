import 'dart:math';

import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_benefit_extra_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_detail_model.dart';
import 'package:recook/pages/user/model/user_benefit_sub_model.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/animated_rotate.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserBenefitShopPage extends StatefulWidget {
  final int teamType;
  UserBenefitShopPage({Key key, @required this.teamType, int type})
      : super(key: key);

  @override
  _UserBenefitShopPageState createState() => _UserBenefitShopPageState();
}

class _UserBenefitShopPageState extends State<UserBenefitShopPage> {
  DateTime _date = DateTime.now();

  String _amount = '';
  String _salesVolume = '';
  String _count = '';

  bool _itemReverse = false;

  GSRefreshController _refreshController = GSRefreshController();

  ///仅在自购和导购收益中可用
  List<UserBenefitMonthDetailModel> _models = [];
  UserBenefitExtraDetailModel _extraDetailModel;

  ///头部卡片
  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.rw, vertical: 10.rw),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ('当日未到账补贴(瑞币)')
                      .text
                      .color(Colors.black54)
                      .size(16.rsp)
                      .make(),
                  "120.00".text.color(Color(0xFF333333)).size(34.rsp).make(),
                ],
              ),
              Spacer(),
              Image.asset(
                UserLevelTool.currentMedalImagePath(),
                height: 55.rw,
                width: 55.rw,
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '销售额(元)'.text.color(Colors.black54).size(16.rsp).make(),
                  '111.00'.text.color(Color(0xFF333333)).size(24.rsp).make(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '品牌推广补贴(%)'.text.color(Colors.black54).size(16.rsp).make(),
                  "3".text.color(Color(0xFF333333)).size(24.rsp).make(),
                ],
              ),
              Column(
                children: [
                  ('订单数(笔)').text.color(Colors.black54).size(16.rsp).make(),
                  '5'.text.color(Color(0xFF333333)).size(24.rsp).make(),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.rw),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            color: Color.fromRGBO(166, 166, 173, 0.43),
            blurRadius: 6.rw,
          )
        ],
        image: DecorationImage(
          image: AssetImage(UserLevelTool.currentCardImagePath()),
          fit: BoxFit.cover,
        ),
      ),
      height: 170.rw,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 10.rw),
    );
  }

  ///时间选择器
  showTimePickerBottomSheet(
      {List<BottomTimePickerType> timePickerTypes,
      Function(DateTime, BottomTimePickerType) submit}) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: timePickerTypes == null
                  ? [BottomTimePickerType.BottomTimePickerMonth]
                  : timePickerTypes,
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: submit != null
                  ? submit
                  : (time, type) {
                      Navigator.maybePop(context);
                      _date = time;
                      setState(() {});
                    },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  ///背景条
  _buildBackBar() {
    return Container(
      height: 10.rw,
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 7.rw),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.rw),
            color: Colors.black.withOpacity(0.24),
            blurRadius: 4.rw,
          ),
        ],
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(5.rw),
      ),
      child: Container(
        height: 4.rw,
        margin: EdgeInsets.symmetric(horizontal: 4.rw),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.rw),
              color: Colors.black.withOpacity(0.39),
              blurRadius: 4.rw,
            ),
          ],
          color: Color(0xFFBBBBBB),
          borderRadius: BorderRadius.circular(5.rw),
        ),
      ),
    );
  }

  Widget _buildGroupItems() {
    if (_extraDetailModel == null) return SizedBox();
    return Stack(
      children: [
        _buildBackBar(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 6.rw),
          child: <Widget>[
            20.hb,
            Row(
              children: [
                15.wb,
                '团队贡献榜'.text.size(14.rsp).color(Color(0xFF333333)).bold.make(),
                Spacer(),
                '团队人数:${_extraDetailModel.data.count}'
                    .text
                    .size(14.rsp)
                    .color(Color(0xFF333333))
                    .bold
                    .make(),
                10.wb,
                MaterialButton(
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      _itemReverse = !_itemReverse;
                    });
                  },
                  child: AnimatedRotate(
                    child: Image.asset(
                      R.ASSETS_ASCSORT_PNG,
                      height: 15.rw,
                      width: 15.rw,
                    ),
                    angle: _itemReverse ? 0 : pi,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.rw),
                ),
              ],
            ),
            10.hb,
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              reverse: _itemReverse,
              children: _extraDetailModel.data.userIncome.map((e) {
                bool hasExtraName = TextUtil.isEmpty(e.remarkName);
                return UserGroupCard(
                  id: e.userId,
                  isRecommend: false,
                  shopRole: UserLevelTool.roleLevelEnum(e.roleLevel),
                  wechatId: e.wechatNo ?? '',
                  name: '${e.nickname}${hasExtraName ? '' : e.remarkName}',
                  groupCount: e.count,
                  phone: e.phone ?? '',
                  headImg: e.headImgUrl ?? '',
                  remarkName: e.remarkName ?? '',
                );
              }).toList(),
            ),
          ].column(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.rw)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2.rw),
                blurRadius: 4.rw,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(
    //   Duration(milliseconds: 300),
    //   () => _refreshController.requestRefresh(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: '_title',
        // bottom: PreferredSize(
        //   child: '每月22号结算上月'
        //       .text
        //       .size(14.rsp)
        //       .color(Color(0xFF333333))
        //       .make()
        //       .centered()
        //       .material(color: Color(0xFFFAFAFA)),
        //   preferredSize: Size.fromHeight(24.rw),
        // ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        color: Colors.white,
        //onRefresh: () async {
        // UserBenefitSubModel model =
        //     await UserBenefitFunc.subInfo(widget.type);
        // _amount = model.data.amount.toStringAsFixed(2);
        // _salesVolume = model.data.salesVolume.toStringAsFixed(2);
        // _count = model.data.count.toStringAsFixed(0);
        // if (!_notSelfNotGUide) {
        //   _models = await UserBenefitFunc.monthDetail(_date);
        // } else {
        //   _extraDetailModel = await UserBenefitFunc.extraDetail(
        //     type: widget.type,
        //     date: _date,
        //   );
        // }
        // setState(() {});
        // _refreshController.refreshCompleted();
        //},
       body: ListView(
          children: [
            Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: CustomPaint(painter: RoundBackgroundPainter()),
                ),
                _buildCard(),
              ],
            ),
            Row(
              children: [
                10.wb,
                MaterialButton(
                  shape: StadiumBorder(),
                  elevation: 0,
                  color: Colors.white,
                  onPressed: () {
                    showTimePickerBottomSheet(
                        submit: (time, type) {
                          Navigator.maybePop(context);
                          _date = time;
                          _refreshController.requestRefresh();
                          setState(() {});
                        },
                        timePickerTypes: [
                          BottomTimePickerType.BottomTimePickerMonth
                        ]);
                  },
                  height: 31.rw,
                  child: Row(
                    children: [
                      DateUtil.formatDate(_date, format: 'yyyy-MM')
                          .text
                          .black
                          .size(14.rsp)
                          .make(),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Spacer(),
                
                15.wb,
              ],
            ),

          ],
        ),
          //_buildGroupItems(),
        ),
      ),
    );
  }
}
