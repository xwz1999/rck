import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/pages/user/model/user_benefit_day_expect_model.dart';
import 'package:recook/pages/user/model/user_benefit_expect_extra_model.dart';
import 'package:recook/pages/user/model/user_benefit_month_expect_model.dart';
import 'package:recook/pages/user/user_benefit_sub_page.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/widgets/animated_rotate.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/recook_back_button.dart';

class DisplayCard {
  num benefit = 0;
  num sales = 0;
  num count = 0;
  bool isPercent = false;
  DisplayCard({
    this.benefit,
    this.sales,
    this.count,
    this.isPercent = false,
  });
}

class BenefitViewGen extends StatefulWidget {
  final UserBenefitPageType type;
  BenefitViewGen({Key key, @required this.type}) : super(key: key);

  @override
  _BenefitViewGenState createState() => _BenefitViewGenState();
}

class _BenefitViewGenState extends State<BenefitViewGen>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabs = ['今日', '昨日', '本月', '上月'];
  List<DisplayCard> _cardItems = List.generate(4, (index) => DisplayCard());
  dynamic _todayModel;
  dynamic _yestodayModel;
  dynamic _thisMonthModel;
  dynamic _lastMonthModel;
  bool _itemReverse = false;
  Widget _buildCard(DisplayCard card) {
    return VxBox(
      child: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '预估收益(瑞币)'.text.color(Colors.black45).size(16.sp).make(),
                (card.benefit ?? 0.0)
                    .toStringAsFixed(2)
                    .text
                    .black
                    .size(34.sp)
                    .bold
                    .make(),
              ],
            ).expand(),
            Image.asset(
              UserLevelTool.currentMedalImagePath(),
              height: 55.w,
              width: 55.w,
            ),
          ],
        ),
        Spacer(),
        <Widget>[
          <Widget>[
            '销售额'.text.color(Colors.black45).size(16.sp).make(),
            (card.sales ?? 0.0)
                .toStringAsFixed(2)
                .text
                .black
                .size(24.sp)
                .make(),
          ].column(crossAlignment: CrossAxisAlignment.start),
          Spacer(),
          <Widget>[
            (card.isPercent ? '提成比例(%)' : '订单数(笔)')
                .text
                .color(Colors.black45)
                .size(16.sp)
                .make(),
            (card.isPercent ? ((card.count ?? 0) * 100) : (card.count ?? 0))
                .toString()
                .text
                .black
                .size(24.sp)
                .make(),
          ].column(),
        ].row(),
      ].column(),
    )
        .padding(EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w))
        .withDecoration(
          BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            image: DecorationImage(
              image: AssetImage(UserLevelTool.currentCardImagePath()),
              fit: BoxFit.cover,
            ),
          ),
        )
        .margin(EdgeInsets.symmetric(horizontal: 15.w))
        .make();
  }

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

  Widget noMoreDataView({String text, Widget icon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          icon != null
              ? icon
              : Image.asset(
                  ShopImageName.shop_page_smile,
                  width: 22,
                  height: 12,
                ),
          Container(
            height: 10,
          ),
          Text(
            TextUtils.isEmpty(text) ? "这是我最后的底线" : text,
            style: TextStyle(color: Color(0xff666666), fontSize: 12),
          )
        ],
      ),
    );
  }

  Future loadData() async {
    DateTime _now = DateTime.now();
    GSDialog.of(context).showLoadingDialog(
      context,
      '加载中',
    );
    if (widget.type == UserBenefitPageType.GUIDE ||
        widget.type == UserBenefitPageType.SELF) {
      _todayModel = await UserBenefitFunc.getBenefitDayExpect(DateTime.now());
      _yestodayModel = await UserBenefitFunc.getBenefitDayExpect(
          DateTime.now().subtract(Duration(days: 1)));

      _thisMonthModel = await UserBenefitFunc.getBenefitMonthExpect(_now);
      _lastMonthModel = await UserBenefitFunc.getBenefitMonthExpect(
          DateTime(_now.year, _now.month - 1));
    } else {
      _todayModel = await UserBenefitFunc.getBenefitExpectExtra(
        BenefitDateType.DAY,
        DateTime.now(),
      );
      _yestodayModel = await UserBenefitFunc.getBenefitExpectExtra(
        BenefitDateType.DAY,
        DateTime.now().subtract(Duration(days: 1)),
      );

      _thisMonthModel = await UserBenefitFunc.getBenefitExpectExtra(
        BenefitDateType.MONTH,
        _now,
      );
      _lastMonthModel = await UserBenefitFunc.getBenefitExpectExtra(
        BenefitDateType.MONTH,
        DateTime(_now.year, _now.month - 1),
      );
    }
    _cardItems[0] = _getCard(_todayModel);
    _cardItems[1] = _getCard(_yestodayModel);
    _cardItems[2] = _getCard(_thisMonthModel);
    _cardItems[3] = _getCard(_lastMonthModel);

    GSDialog.of(context).dismiss(context);
    setState(() {});
  }

  DisplayCard _getCard(dynamic model) {
    if (model is UserBenefitDayExpectModel) {
      return widget.type == UserBenefitPageType.SELF
          ? model.purchase.card
          : model.guide.card;
    }
    if (model is UserBenefitMonthExpectModel) {
      return widget.type == UserBenefitPageType.SELF
          ? model.purchase.card
          : model.guide.card;
    }

    if (model is UserBenefitExpectExtraModel) {
      switch (widget.type) {
        case UserBenefitPageType.TEAM:
          return model.team.card;
          break;
        case UserBenefitPageType.RECOMMEND:
          return model.recommend.card;
          break;
        case UserBenefitPageType.PLATFORM:
          return model.reward.card;
          break;
        default:
          return DisplayCard();
      }
    }
    return DisplayCard();
  }

  String get title {
    switch (widget.type) {
      case UserBenefitPageType.SELF:
        return '自购收益';
        break;
      case UserBenefitPageType.GUIDE:
        return '导购收益';
        break;
      case UserBenefitPageType.TEAM:
        return '团队收益';
        break;
      case UserBenefitPageType.RECOMMEND:
        return '推荐收益';
        break;
      case UserBenefitPageType.PLATFORM:
        return '平台收益';
        break;
    }
    return '';
  }

  Widget _buildTeamRecommendPlatformCard() {
    UserBenefitExpectExtraModel model;
    switch (_tabController.index) {
      case 0:
        model = _todayModel;
        break;
      case 1:
        model = _yestodayModel;
        break;
      case 2:
        model = _thisMonthModel;
        break;
      case 3:
        model = _lastMonthModel;
        break;
    }
    if (model == null) return SizedBox();
    List<TeamList> team = [];
    switch (widget.type) {
      case UserBenefitPageType.TEAM:
        team = model.teamList;
        break;
      case UserBenefitPageType.RECOMMEND:
        team = model.recommendList;
        break;
      case UserBenefitPageType.PLATFORM:
        team = model.rewardList;
        break;
      default:
        team = [];
    }
    return <Widget>[
      _buildBackBar(),
      Positioned(
        top: 6.w,
        left: 16.w,
        right: 16.w,
        bottom: 0,
        child: SingleChildScrollView(
          child: [
            VxBox(
              child: Column(
                children: [
                  20.hb,
                  Row(
                    children: [
                      15.wb,
                      '团队贡献榜'
                          .text
                          .size(14.sp)
                          .color(Color(0xFF333333))
                          .bold
                          .make(),
                      Spacer(),
                      '团队人数:${team?.length ?? 0}'
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: _itemReverse,
                    itemBuilder: (context, index) {
                      final _ = team[index];
                      return UserGroupCard.flat(
                        name: _.nickname,
                        wechatId: _.wechatNo,
                        phone: _.phone,
                        shopRole: UserLevelTool.roleLevelEnum(_.roleLevel),
                        groupCount: _.count,
                        headImg: _.headImgUrl,
                        id: _.userId,
                        isRecommend: false,
                        remarkName: _.remarkName,
                      );
                    },
                    itemCount: team?.length ?? 0,
                  ),
                ],
              ),
            )
                .withDecoration(BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 4.w,
                      offset: Offset(0, 2.w),
                    ),
                  ],
                ))
                .margin(EdgeInsets.only(bottom: 100))
                .make(),
            noMoreDataView(),
          ].column(),
        ),
      ),
    ].stack().expand();
  }

  _buildTable(UserBenefitMonthExpectModel model) {
    _buildTitle(String title, {bool red = false, bool bold = false}) {
      return title.text
          .size(14.sp)
          .color(red ? Color(0xFFD5101A) : Color(0xFF333333))
          .fontWeight(bold ? FontWeight.bold : FontWeight.normal)
          .make()
          .centered()
          .box
          .height(45.w)
          .make();
    }

    return Table(
      children: [
        TableRow(
          children: [
            _buildTitle('日期', bold: true),
            _buildTitle('销售额', bold: true),
            _buildTitle('订单数', bold: true),
            _buildTitle('预估收益', bold: true),
          ],
        ),
        ...widget.type == UserBenefitPageType.SELF
            ? model.purchaseList.map((e) {
                return TableRow(
                  children: [
                    _buildTitle(DateUtil.formatDate(e.date, format: 'M月dd日')),
                    _buildTitle(e.salesVolume.toStringAsFixed(2)),
                    _buildTitle(e.count.toString()),
                    _buildTitle(e.amount.toString()),
                  ],
                );
              }).toList()
            : model.guideList.map((e) {
                return TableRow(
                  children: [
                    _buildTitle(DateUtil.formatDate(e.date, format: 'M月dd日')),
                    _buildTitle(e.salesVolume.toStringAsFixed(2)),
                    _buildTitle(e.count.toString()),
                    _buildTitle(e.amount.toString()),
                  ],
                );
              }).toList(),
      ],
    ).material(color: Colors.white);
  }

  _parseBottomCard() {
    if (widget.type == UserBenefitPageType.SELF ||
        widget.type == UserBenefitPageType.GUIDE) {
      if (_tabController.index == 0 || _tabController.index == 1)
        return SizedBox();
      else
        return _buildTable(
          _tabController.index == 2 ? _thisMonthModel : _lastMonthModel,
        );
    } else
      return _buildTeamRecommendPlatformCard();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(Duration(milliseconds: 300), loadData);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: RecookBackButton(white: true),
        title: title.text.make(),
        centerTitle: true,
        backgroundColor: Color(0xFF16182B),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 212.w,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.fromHeight(197.w),
                  painter: RoundBackgroundPainter(),
                ),
                Column(
                  children: [
                    _BenefitTabBar(
                      items: _tabs,
                      tabController: _tabController,
                    ),
                    TabBarView(
                      children: List.generate(
                        4,
                        (index) => _buildCard(_cardItems[index]),
                      ),
                      controller: _tabController,
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
          10.hb,
          _parseBottomCard(),
        ],
      ),
    );
  }
}

///TabBar
class _BenefitTabBar extends StatefulWidget {
  final List<String> items;
  final TabController tabController;
  _BenefitTabBar({Key key, @required this.items, @required this.tabController})
      : super(key: key);

  @override
  __BenefitTabBarState createState() => __BenefitTabBarState();
}

class __BenefitTabBarState extends State<_BenefitTabBar> {
  Color _getColor(int index, double offset, {bool reverse = false}) {
    if (offset >= index + 0.5 || offset <= index - 0.5) {
      return reverse ? Colors.white : Colors.black;
    }
    int colorValue = (((1 - offset - index) * 255).abs()).toInt();
    if (reverse) colorValue = 255 - colorValue;
    return Color.fromRGBO(colorValue, colorValue, colorValue, 1);
  }

  Widget _buildTabBarButton(String title, int index) {
    return CustomImageButton(
      onPressed: () {
        widget.tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 22.w,
        width: 60.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.w),
          borderRadius: BorderRadius.circular(11.w),
          color: _getColor(index, widget.tabController.animation.value),
        ),
        child: DefaultTextStyle(
          child: title.text.size(14).make(),
          style: TextStyle(
            color: _getColor(
              index,
              widget.tabController.animation.value,
              reverse: true,
            ),
          ),
        ),
      ),
    );
  }

  tabListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.tabController?.animation?.addListener(tabListener);
  }

  @override
  void dispose() {
    widget.tabController?.animation?.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.items.length,
          (index) => _buildTabBarButton(widget.items[index], index),
        ),
      ),
    );
  }
}
