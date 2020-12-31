import 'package:flutter/material.dart';
import 'package:recook/pages/user/benefit_view_gen.dart';
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
  Widget _buildTabView(String value) {
    return <Widget>[
      '预估收益'.text.color(Colors.black54).size(18.sp).make(),
      value.text.color(Color(0xFF333333)).size(28.sp).make(),
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
            children: tabs.map((e) => _buildTabView(e)).toList(),
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
        firstItem: _ItemClass(title: '订单(笔)', value: '151X'),
        secondItem: _ItemClass(title: '销售额(元)', value: '1111.11X'),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: '124.12X',
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_SHARE_PNG,
        title: '导购收益',
        firstItem: _ItemClass(title: '订单(笔)', value: '151X'),
        secondItem: _ItemClass(title: '销售额(元)', value: '1111.11X'),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: '124.12X',
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_GROUP_PNG,
        title: '团队收益',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: '151.00X',
          onHelper: () {},
        ),
        secondItem: _ItemClass(title: '提成比例(%)', value: '3X'),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: '124.12X',
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_GREAT_PNG,
        title: '推荐收益',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: '151.00X',
          onHelper: () {},
        ),
        secondItem: _ItemClass(title: '提成比例(%)', value: '3X'),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: '124.12X',
          onHelper: () {},
        ),
      ),
      _buildItem(
        onTap: () {},
        path: R.ASSETS_USER_PINK_PLATFORM_PNG,
        title: '平台奖励',
        firstItem: _ItemClass(
          title: '团队销售额(元)',
          value: '151.00X',
          onHelper: () {},
        ),
        secondItem: _ItemClass(title: '提成比例(%)', value: '3X'),
        thirdItem: _ItemClass(
          title: '预估收益(瑞币)',
          value: '124.12X',
          onHelper: () {},
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
