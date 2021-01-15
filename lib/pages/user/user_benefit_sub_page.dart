import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/utils/user_level_tool.dart';
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

  GSRefreshController _refreshController = GSRefreshController();

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
    int amount,
    double benefit,
  }) {
    return TableRow(
      children: [
        _buildTableItem(DateUtil.formatDate(date, format: 'M月dd日')),
        _buildTableItem(volume.toStringAsFixed(2)),
        _buildTableItem(amount.toString()),
        _buildTableItem(benefit.toStringAsFixed(2), true),
      ],
    );
  }

  ///表格
  _buildTable() {
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
        _buildTableRow(
          date: DateTime.now(),
          volume: 100,
          amount: 1,
          benefit: 40,
        ),
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
                '团队人数:12'.text.size(14.sp).color(Color(0xFF333333)).bold.make(),
                10.wb,
                MaterialButton(
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {},
                  child: Image.asset(
                    R.ASSETS_ASCSORT_PNG,
                    height: 15.w,
                    width: 15.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                ),
              ],
            ),
          ].column(),
          decoration: BoxDecoration(
            color: Colors.white,
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
        onRefresh: () {
          UserBenefitFunc.subInfo(widget.type).then((model) {
            _amount = model.data.amount.toStringAsFixed(2);
            _salesVolume = model.data.salesVolume.toStringAsFixed(2);
            _count = model.data.count.toStringAsFixed(2);
            setState(() {});
          });
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
            _notSelfNotGUide ? _buildGroupItems() : _buildTable(),
          ],
        ),
      ),
    );
  }
}
