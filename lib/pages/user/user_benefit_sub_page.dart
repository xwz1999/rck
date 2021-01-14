import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:velocity_x/velocity_x.dart';

enum UserBenefitPageType {
  ///自购收益
  SELF,

  ///导购收益
  GUIDE,

  ///团队收益
  TEAM,

  ///推荐收益
  RECOMMAND,

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
    UserBenefitPageType.RECOMMAND: '推荐收益',
    UserBenefitPageType.PLATFORM: '平台奖励',
  };
  String get _title => _typeTitleMap[widget.type];

  DateTime _date = DateTime.now();

  ///不是自购和导购
  bool get _notSelfNotGUide =>
      widget.type != UserBenefitPageType.SELF &&
      widget.type != UserBenefitPageType.GUIDE;

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
                  // (_incomeModel?.data?.teamIncome?.historyIncome
                  //             ?.toStringAsFixed(2) ??
                  //         '0.00')
                  //     .text
                  //     .color(Color(0xFF333333))
                  //     .size(34.sp)
                  //     .make(),
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
                  // (_incomeModel?.data?.teamIncome?.teamAmount
                  //             ?.toStringAsFixed(2) ??
                  //         '0.00')
                  //     .text
                  //     .color(Color(0xFF333333))
                  //     .size(24.sp)
                  //     .make(),
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
                  // (_incomeModel?.data?.teamIncome?.memberNum?.toString() ?? '0')
                  //     .text
                  //     .color(Color(0xFF333333))
                  //     .size(24.sp)
                  //     .make(),
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

  Widget _buildMidCard({
    String slot1 = '0',
    String slot2 = '0',
    String slot3 = '0',
  }) {
    return VxBox(
      child: [
        '$_title\(元)'.text.color(Colors.black54).size(18).make(),
        slot1.text.color(Color(0xFF333333)).size(24).make(),
        36.hb,
        [
          [
            '销售额(元)'.text.color(Colors.black54).size(14).make(),
            slot2.text.color(Color(0xFF333333)).size(16).make(),
          ].column(crossAlignment: CrossAxisAlignment.start),
          Spacer(),
          [
            '提成比例(%)'.text.color(Colors.black54).size(14).make(),
            slot3.text.color(Color(0xFF333333)).size(16).make(),
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
            ],
          ),
          _notSelfNotGUide ? _buildMidCard() : SizedBox(),
        ],
      ),
    );
  }
}
