
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/pages/life_service/sudoku_game_page.dart';

import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'hot_video_page.dart';
import 'hw_calculator_page.dart';
import 'idiom_solitaire_page.dart';
import 'jokes_collection_page.dart';
import 'news_page.dart';

class LifeServiceHomePage extends StatefulWidget {
  LifeServiceHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _LifeServiceHomePageState createState() => _LifeServiceHomePageState();
}

class _LifeServiceHomePageState extends State<LifeServiceHomePage>
    with TickerProviderStateMixin {
  List<Service> _items = [];

  @override
  void initState() {
    super.initState();
    _items = [
      Service(
          img: Assets.icSgtz.path,
          title: '新闻头条',
          page: () {
            Get.to(()=>NewsPage());
          }),
      Service(
          img: Assets.icRmsp.path,
          title: '热门视频榜单',
          page: () {
            Get.to(()=>HotVideoPage());
          }),
      Service(
          img: Assets.icFyzc.path,
          title: '2022出行防疫政策指南',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icSdyx.path,
          title: '数独游戏生成器',
          page: () {
            Get.to(()=>SudokuGamePage());
          }),
      Service(
          img: Assets.icXhdq.path,
          title: '笑话大全',
          page: () {
            Get.to(()=>JokesCollectionPage());
          }),
      Service(
          img: Assets.icLhl.path,
          title: '老黄历',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icSgtz.path,
          title: '标准身高体重计算器',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icCyjl.path,
          title: '成语接龙',
          page: () {
            Get.to(()=>IdiomSolitairePage());
          }),
      Service(
          img: Assets.icNba.path,
          title: 'NBA赛事',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icZqls.path,
          title: '足球联赛',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icXljt.path,
          title: '每日心灵鸡汤语录',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icSrhy.path,
          title: '生日花语',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icSxcx.path,
          title: '生肖查询',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icXzcx.path,
          title: '星座查询',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icDkgjj.path,
          title: '贷款公积金计算器',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icZjsc.path,
          title: '最佳身材计算器',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icJcjk.path,
          title: '基础健康指数计算器',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icXzpd.path,
          title: '星座配对',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icJryj.path,
          title: '今日国内油价查询',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
      Service(
          img: Assets.icSxpd.path,
          title: '生肖配对',
          page: () {
            Get.to(()=>HWCalculatorPage());
          }),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('生活服务',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Padding(
      padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
      child: ListView.builder(
        itemCount: _items.length,
        padding: EdgeInsets.only(left: 12.rw, right: 12.rw, top: 0.rw,bottom: 20.rw),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(_items[index]),
      ),
    );
  }

  _itemWidget(Service model) {
    return GestureDetector(
      onTap:model.page,
      child: Container(
        padding: EdgeInsets.only(bottom: 10.rw, top: 10.rw),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              model.img,
              width: 36.rw,
              height: 36.rw,
            ),
            16.wb,
            Text(
              model.title,
              style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
            ),
            Spacer(),
            Icon(
              AppIcons.icon_next,
              color: Colors.black38,
              size: 13 * 2.sp,
            ),
            24.wb,
          ],
        ),
      ),
    );
  }
}

class Service {
  final String img;
  final String title;
  final VoidCallback page;

  Service({
    required this.img,
    required this.title,
    required this.page,
  });
}
