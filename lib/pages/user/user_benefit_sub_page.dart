import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
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
import 'package:velocity_x/velocity_x.dart';

enum UserBenefitPageType {
  ///自购收益
  SELF,

  ///导购收益
  GUIDE,

  ///团队收益
  TEAM,

  ///推荐收益
  RECOMMEND,

  ///平台收益
  PLATFORM,
}

class UserBenefitSubPage extends StatefulWidget {
  final UserBenefitPageType type;
  UserBenefitSubPage({Key key, this.type}) : super(key: key);

  @override
  _UserBenefitSubPageState createState() => _UserBenefitSubPageState();
}

class _UserBenefitSubPageState extends State<UserBenefitSubPage> {
  Map<UserBenefitPageType, String> _typeTitleMap = {
    UserBenefitPageType.SELF: '自购收益',
    UserBenefitPageType.GUIDE: '导购收益',
    UserBenefitPageType.TEAM: '团队收益',
    UserBenefitPageType.RECOMMEND: '推荐收益',
    UserBenefitPageType.PLATFORM: '平台奖励',
  };
  String get _title => _typeTitleMap[widget.type];

  DateTime _date = DateTime.now();

  ///不是自购和导购
  bool get _notSelfNotGUide =>
      widget.type != UserBenefitPageType.SELF &&
      widget.type != UserBenefitPageType.GUIDE;
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.type == UserBenefitPageType.PLATFORM
                          ? '累计奖励(瑞币)'
                          : '累计收益(瑞币)')
                      .text
                      .color(Colors.black54)
                      .size(16.sp)
                      .make(),
                  _amount.text.color(Color(0xFF333333)).size(34.sp).make(),
                ],
              ),
              Spacer(),
              Image.asset(
                UserLevelTool.currentMedalImagePath(),
                height: 55.w,
                width: 55.w,
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  '销售额(元)'.text.color(Colors.black54).size(16.sp).make(),
                  _salesVolume.text.color(Color(0xFF333333)).size(24.sp).make(),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  (!_notSelfNotGUide ? '订单数(笔)' : '团队人数(人)')
                      .text
                      .color(Colors.black54)
                      .size(16.sp)
                      .make(),
                  _count.text.color(Color(0xFF333333)).size(24.sp).make(),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.w),
            color: Color.fromRGBO(166, 166, 173, 0.43),
            blurRadius: 6.w,
          )
        ],
        image: DecorationImage(
          image: AssetImage(UserLevelTool.currentCardImagePath()),
          fit: BoxFit.cover,
        ),
      ),
      height: 170.w,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
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

  ///中间的按钮
  Widget _buildMidCard() {
    if (_extraDetailModel == null) return SizedBox();
    return VxBox(
      child: [
        '$_title\(元)'.text.color(Colors.black54).size(18).make(),
        _extraDetailModel.data.amount
            .toStringAsFixed(2)
            .text
            .color(Color(0xFF333333))
            .size(24)
            .make(),
        36.hb,
        [
          [
            '销售额(元)'.text.color(Colors.black54).size(14).make(),
            _extraDetailModel.data.salesVolume
                .toStringAsFixed(2)
                .text
                .color(Color(0xFF333333))
                .size(16)
                .make(),
          ].column(crossAlignment: CrossAxisAlignment.start),
          Spacer(),
          [
            '提成比例(%)'.text.color(Colors.black54).size(14).make(),
            _extraDetailModel.data.ratio
                .toStringAsFixed(2)
                .text
                .color(Color(0xFF333333))
                .size(16)
                .make(),
          ].column(),
        ].row(),
      ].column(crossAlignment: CrossAxisAlignment.start),
    )
        .withRounded(value: 5.w)
        .white
        .padding(EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w))
        .margin(EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w))
        .make();
  }

  ///表格标题
  _buildTableTitle(String title, [bool red = false, bool bold = true]) =>
      SizedBox(
        height: 45.w,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: red ? Color(0xFFD5101A) : Color(0xFF333333),
            fontSize: 16.sp,
          ),
        ).centered(),
      );

  ///表格内容
  _buildTableItem(String value, [bool red = false]) =>
      _buildTableTitle(value, red, false);
  TableRow _buildTableRow({
    DateTime date,
    double volume,
    int count,
    double benefit,
  }) {
    return TableRow(
      children: [
        _buildTableItem(DateUtil.formatDate(date, format: 'M月dd日')),
        _buildTableItem(volume.toStringAsFixed(2)),
        _buildTableItem(count.toString()),
        _buildTableItem(benefit.toStringAsFixed(2), true),
      ],
    );
  }

  ///表格
  ///
  ///自购收益和导购收益的列表
  _buildTable() {
    if (_models.isEmpty) return SizedBox();
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Color(0xFFEEEEEE), width: 1.w),
      ),
      children: [
        TableRow(
          children: [
            _buildTableTitle('日期'),
            _buildTableTitle('销售额'),
            _buildTableTitle('订单数'),
            _buildTableTitle('结算收益'),
          ],
        ),
        ..._models.map((e) {
          double amount = 0;
          double salesVolume = 0;
          int count = 0;
          if (widget.type == UserBenefitPageType.SELF) {
            amount = e.purchaseAmount;
            salesVolume = e.purchaseSalesVolume;
            count = e.purchaseCount;
          }
          if (widget.type == UserBenefitPageType.GUIDE) {
            amount = e.guideAmount;
            salesVolume = e.guideSalesVolume;
            count = e.guideCount;
          }

          return _buildTableRow(
            date: e.day,
            volume: salesVolume,
            count: count,
            benefit: amount,
          );
        }).toList(),
      ],
    ).material(color: Colors.white).pSymmetric(v: 10.w);
  }

  ///背景条
  _buildBackBar() {
    return Container(
      height: 10.w,
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2.w),
            color: Colors.black.withOpacity(0.24),
            blurRadius: 4.w,
          ),
        ],
        color: Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Container(
        height: 4.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2.w),
              color: Colors.black.withOpacity(0.39),
              blurRadius: 4.w,
            ),
          ],
          color: Color(0xFFBBBBBB),
          borderRadius: BorderRadius.circular(5.w),
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
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.w),
          child: <Widget>[
            20.hb,
            Row(
              children: [
                15.wb,
                '团队贡献榜'.text.size(14.sp).color(Color(0xFF333333)).bold.make(),
                Spacer(),
                '团队人数:${_extraDetailModel.data.count}'
                    .text
                    .size(14.sp)
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
                      height: 15.w,
                      width: 15.w,
                    ),
                    angle: _itemReverse ? 0 : pi,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                );
              }).toList(),
            ),
          ].column(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.w)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2.w),
                blurRadius: 4.w,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag() {
    // if(_models.isEmpty)return SizedBox()
    double benefitValue = 0;
    if (widget.type == UserBenefitPageType.SELF) {
      _models.forEach((element) => benefitValue += element.purchaseAmount);
    }
    if (widget.type == UserBenefitPageType.GUIDE)
      _models.forEach((element) => benefitValue += element.guideAmount);
    return '当月收益(瑞币)：${benefitValue.toStringAsFixed(2)}'
        .text
        .color(Color(0xFF999999))
        .size(16.sp)
        .make();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 300),
      () => _refreshController.requestRefresh(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: _title,
        bottom: _notSelfNotGUide
            ? PreferredSize(
                child: '每月22号结算上月$_title'
                    .text
                    .size(14.sp)
                    .color(Color(0xFF333333))
                    .make()
                    .centered()
                    .material(color: Color(0xFFFAFAFA)),
                preferredSize: Size.fromHeight(24.w),
              )
            : null,
      ),
      body: RefreshWidget(
        controller: _refreshController,
        color: Colors.white,
        onRefresh: () async {
          UserBenefitSubModel model =
              await UserBenefitFunc.subInfo(widget.type);
          _amount = model.data.amount.toStringAsFixed(2);
          _salesVolume = model.data.salesVolume.toStringAsFixed(2);
          _count = model.data.count.toStringAsFixed(2);
          if (!_notSelfNotGUide) {
            _models = await UserBenefitFunc.monthDetail(_date);
          } else {
            _extraDetailModel = await UserBenefitFunc.extraDetail(
              type: widget.type,
              date: _date,
            );
          }
          setState(() {});
          _refreshController.refreshCompleted();
        },
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
                  height: 31.w,
                  child: Row(
                    children: [
                      DateUtil.formatDate(_date, format: 'yyyy-MM')
                          .text
                          .black
                          .size(14.sp)
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
                _notSelfNotGUide ? SizedBox() : _buildTag(),
                15.wb,
              ],
            ),
            _notSelfNotGUide ? _buildMidCard() : SizedBox(),
            _notSelfNotGUide ? _buildGroupItems() : _buildTable(),
          ],
        ),
      ),
    );
  }
}
