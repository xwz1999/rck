import 'package:flutter/material.dart';
import 'package:recook/pages/user/benefit_view_gen.dart';
import 'package:recook/pages/user/functions/user_benefit_func.dart';
import 'package:recook/pages/user/model/user_benefit_common_model.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class UserBenefitPage extends StatefulWidget {
  UserBenefitPage({Key key}) : super(key: key);

  @override
  _UserBenefitPageState createState() => _UserBenefitPageState();
}

class _UserBenefitPageState extends State<UserBenefitPage>
    with TickerProviderStateMixin {
  List<String> tabs = ['今日', '昨日', '本月', '上月'];
  TabController _tabController;
  UserBenefitCommonModel _displayModel = UserBenefitCommonModel.zero();
  UserBenefitCommonModel _todayModel = UserBenefitCommonModel.zero();
  UserBenefitCommonModel _yestodayModel = UserBenefitCommonModel.zero();
  UserBenefitCommonModel _thisMonthModel = UserBenefitCommonModel.zero();
  UserBenefitCommonModel _lastMonthModel = UserBenefitCommonModel.zero();

  Future getData() async {
    _todayModel = await UserBenefitFunc.getCommonModel(
      BenefitDateType.DAY,
      DateTime.now(),
    );
    _yestodayModel = await UserBenefitFunc.getCommonModel(
      BenefitDateType.DAY,
      DateTime.now().subtract(Duration(days: 1)),
    );
    _thisMonthModel = await UserBenefitFunc.getCommonModel(
      BenefitDateType.MONTH,
      DateTime.now(),
    );
    _thisMonthModel = await UserBenefitFunc.getCommonModel(
      BenefitDateType.MONTH,
      DateTime(DateTime.now().year, DateTime.now().month - 1),
    );
    _displayModel = _todayModel;
    setState(() {});
  }

  Widget _buildTabView(int index) {
    double allCount = 0;
    switch (index) {
      case 0:
        allCount = _todayModel.allAmount;
        break;
      case 1:
        allCount = _yestodayModel.allAmount;
        break;
      case 2:
        allCount = _thisMonthModel.allAmount;
        break;
      case 3:
        allCount = _lastMonthModel.allAmount;
        break;
    }
    return <Widget>[
      '预估收益'.text.color(Colors.black54).size(18.sp).make(),
      allCount
          .toStringAsFixed(2)
          .text
          .color(Color(0xFF333333))
          .size(28.sp)
          .make(),
    ].column(
      alignment: MainAxisAlignment.center,
    );
  }

  _buildCard() {
    return [
      VxBox(
        child: <Widget>[
          SizedBox(
            height: 40.w,
            child: TabBar(
              tabs: tabs.map((e) => e.text.make()).toList(),
              labelColor: Colors.black87,
              controller: _tabController,
              indicator: RecookIndicator(
                borderSide: BorderSide(
                  width: 4.w,
                  color: Color(0xFFFF7473),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          TabBarView(
            children:
                List.generate(tabs.length, (index) => _buildTabView(index)),
            controller: _tabController,
          ).expand(),
        ].column(),
      )
          .withDecoration(
            BoxDecoration(
              image: DecorationImage(
                image: AssetImage(R.ASSETS_SHOP_PAGE_INCOME_CARD_PNG),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10.w),
            ),
          )
          .height(134.w)
          .margin(EdgeInsets.all(10.w))
          .make(),
    ].stack();
  }

  _buildItem({
    @required String path,
    @required String title,
    @required _ItemClass firstItem,
    @required _ItemClass secondItem,
    @required _ItemClass thirdItem,
    @required VoidCallback onTap,
  }) {
    Widget getColumnItem(_ItemClass item) {
      Widget helper = CustomImageButton(
        onPressed: item.onHelper,
        padding: EdgeInsets.all(5.w),
        child: Image.asset(
          R.ASSETS_SHOP_HELPER_PNG,
          height: 9.w,
          width: 9.w,
        ),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          [
            item.title.text.color(Colors.black45).size(12.sp).make(),
            item.onHelper == null ? SizedBox() : helper,
          ].row(),
          10.hb,
          item.value.text.black.size(16.sp).make(),
        ],
      ).expand();
    }

    return VxBox(
      child: <Widget>[
        CustomImageButton(
          onPressed: onTap,
          child: <Widget>[
            46.hb,
            16.wb,
            Image.asset(path, height: 20.w, width: 20.w),
            6.wb,
            title.text.size(16.sp).color(Colors.black).bold.make(),
            Spacer(),
            '查看明细'.text.color(Colors.black54).size(12).make(),
            Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.black38),
            16.wb,
          ].row(),
        ),
        Divider(
          height: 1.w,
          thickness: 1.w,
          indent: 16.w,
          endIndent: 16.w,
          color: Color(0xFFEEEEEE),
        ),
        Row(
          children: [
            16.wb,
            66.hb,
            getColumnItem(firstItem),
            getColumnItem(secondItem),
            getColumnItem(thirdItem),
            16.wb,
          ],
        ),
      ].column(
        crossAlignment: CrossAxisAlignment.start,
      ),
    ).margin(EdgeInsets.only(bottom: 10.w)).color(Colors.white).make();
  }

  List<Widget> _buildBottomItems() {
    return [
      _buildItem(
        onTap: () => CRoute.push(context, BenefitViewGen()),
        path: R.ASSETS_USER_PINK_BUYER_PNG,
        title: '自购收益',
        firstItem: _ItemClass(
          title: '订单(笔)',
          value: _displayModel.purchase.count.toString(),
        ),
        secondItem: _ItemClass(
          title: '销售额(元)',
          value: _displayModel.purchase.salesVolume.toStringAsFixed(2),
        ),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: _displayModel.purchase.amount.toStringAsFixed(2),
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_SHARE_PNG,
        title: '导购收益',
        firstItem: _ItemClass(
          title: '订单(笔)',
          value: _displayModel.guide.count.toString(),
        ),
        secondItem: _ItemClass(
          title: '销售额(元)',
          value: _displayModel.guide.salesVolume.toStringAsFixed(2),
        ),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: _displayModel.guide.amount.toStringAsFixed(2),
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_GROUP_PNG,
        title: '团队收益',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: _displayModel.team.salesVolume.toStringAsFixed(2),
          onHelper: () {},
        ),
        secondItem: _ItemClass(
          title: '提成比例(%)',
          value: _displayModel.team.ratio.toString(),
        ),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: _displayModel.team.amount.toStringAsFixed(2),
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_GREAT_PNG,
        title: '推荐收益',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: _displayModel.recommend.salesVolume.toStringAsFixed(2),
          onHelper: () {},
        ),
        secondItem: _ItemClass(
          title: '提成比例(%)',
          value: _displayModel.recommend.ratio.toString(),
        ),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: _displayModel.recommend.amount.toStringAsFixed(2),
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_PLATFORM_PNG,
        title: '平台奖励',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: _displayModel.reward.salesVolume.toStringAsFixed(2),
          onHelper: () {},
        ),
        secondItem: _ItemClass(
          title: '提成比例(%)',
          value: _displayModel.reward.ratio.toString(),
        ),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: _displayModel.reward.amount.toStringAsFixed(2),
          onHelper: () {},
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        switch (_tabController.index) {
          case 0:
            _displayModel = _todayModel;
            break;
          case 1:
            _displayModel = _yestodayModel;
            break;
          case 2:
            _displayModel = _thisMonthModel;
            break;
          case 3:
            _displayModel = _lastMonthModel;
            break;
        }
        setState(() {});
      });
    getData();
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
        backgroundColor: Color(0xFF16182B),
        title: '我的收益'.text.make(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: RoundBackgroundPainter(),
            size: Size.fromHeight(197.w),
          ),
          ListView(
            children: [
              _buildCard(),
              ..._buildBottomItems(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemClass {
  String title;
  String value;
  VoidCallback onHelper;
  _ItemClass({
    @required this.title,
    @required this.value,
    this.onHelper,
  });
}
