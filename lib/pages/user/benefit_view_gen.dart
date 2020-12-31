import 'package:flutter/material.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/custom_painters/round_background_painter.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class BenefitViewGen extends StatefulWidget {
  BenefitViewGen({Key key}) : super(key: key);

  @override
  _BenefitViewGenState createState() => _BenefitViewGenState();
}

class _BenefitViewGenState extends State<BenefitViewGen>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabs = ['今日', '昨日', '本月', '上月'];

  Widget _buildCard() {
    return VxBox(
      child: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                '预估收益(瑞币)'.text.color(Colors.black45).size(16.sp).make(),
                '1231.12X'.text.black.size(34.sp).bold.make(),
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
            '2123.11X'.text.black.size(24.sp).make(),
          ].column(crossAlignment: CrossAxisAlignment.start),
          Spacer(),
          <Widget>[
            '订单数(笔)'.text.color(Colors.black45).size(16.sp).make(),
            '212X'.text.black.size(24.sp).make(),
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
        title: '推荐收益'.text.make(),
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
                      children: _tabs.map((index) => _buildCard()).toList(),
                      controller: _tabController,
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
          10.hb,
          <Widget>[
            _buildBackBar(),
            Positioned(
              top: 6.w,
              left: 16.w,
              right: 16.w,
              bottom: 0,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: [
                  VxBox()
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
                      .height(1000)
                      .make(),
                  noMoreDataView(),
                ].column(),
              ),
            ),
          ].stack().expand(),
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
