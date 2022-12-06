
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/joke_model.dart';
import 'package:recook/pages/life_service/constellation_pairing_page.dart';
import 'package:recook/pages/life_service/figure_calculator_page.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/pages/life_service/nba_match_page.dart';
import 'package:recook/pages/life_service/soul_soother_page.dart';
import 'package:recook/pages/life_service/sudoku_game_page.dart';
import 'package:recook/pages/life_service/zodiac_page.dart';
import 'package:recook/pages/life_service/zodiac_pairing_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/webView.dart';

import 'OilPriceModel.dart';
import 'Oil_price_inquiry_page.dart';
import 'birth_flower_page.dart';
import 'constellation_page.dart';
import 'football_league_page.dart';
import 'health/health_calculator_page.dart';
import 'hot_video_page.dart';
import 'hw_calculator_page.dart';
import 'idiom_solitaire_page.dart';
import 'jokes_collection_page.dart';
import 'loan_page.dart';
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
          },
          detail: '最新新闻头条，各类国内、国际资讯'
      ),

      Service(
          img: Assets.icRmsp.path,
          title: '热门视频榜单',
          page: () {
            Get.to(()=>HotVideoPage());
          },
          detail: '抖音热门视频榜及各类达人视频榜单。'),
      Service(
          img: Assets.icFyzc.path,
          title: '2022出行防疫政策指南',
          page: () {
            AppRouter.push(
              context,
              RouteName.WEB_VIEW_PAGE,
              arguments: WebViewPage.setArguments(
                url: WebApi.chuXing,
                hideBar: true,),
            );
          },
          detail: '各地出行防疫政策查询'),
      Service(
          img: Assets.icSdyx.path,
          title: '数独游戏生成器',
          page: () {
            Get.to(()=>SudokuGamePage());
          },
          detail: '数学智力拼图游戏'),
      Service(
          img: Assets.icXhdq.path,
          title: '笑话大全',
          page: () async{
            List<JokeModel> _jokes = (await LifeFunc.getJokeList( ))??[];
            if(_jokes.isNotEmpty)
            Get.to(()=>JokesCollectionPage(jokes: _jokes,));
          },
          detail: '搜集网络幽默、搞笑、内涵段子，不间断更新'),
      Service(
          img: Assets.icSgtz.path,
          title: '标准身高体重计算器',
          page: () {
            Get.to(()=>HWCalculatorPage());
          },
          detail: '基于BMI指数来了解身体是否健康'),
      Service(
          img: Assets.icCyjl.path,
          title: '成语接龙',
          page: () {

            Get.to(()=>IdiomSolitairePage());
            FocusManager.instance.primaryFocus!.unfocus();
          },
          detail: '通过输入指定的信息来查询成语'),
      Service(
          img: Assets.icNba.path,
          title: 'NBA赛事',
          page: () {
            Get.to(()=>NBAMatchPage());
          },
          detail: 'NBA赛事赛程相关信息'),
      Service(
          img: Assets.icZqls.path,
          title: '足球联赛',
          page: () {
            Get.to(()=>FootballLeaguePage());
          },
          detail: '足球赛事近期赛程及积分榜排名查询'),
      Service(
          img: Assets.icXljt.path,
          title: '每日心灵鸡汤语录',
          page: () async{
           String text = (await LifeFunc.getSoul())??'';
           if(text.isNotEmpty)
            Get.to(()=>SoulSootherPage(text: text,));
          },
          detail: '每日一条励志心灵鸡汤语录'),
      Service(
          img: Assets.icSrhy.path,
          title: '生日花语',
          page: () {
            Get.to(()=>BirthFlowerPage());
          },
          detail: '根据出生日期查询生日花语'),
      Service(
          img: Assets.icSxcx.path,
          title: '生肖查询',
          page: () {
            Get.to(()=>ZodiacPage());
          },
          detail: '根据出生日期查询生日花语'),
      Service(
          img: Assets.icXzcx.path,
          title: '星座查询',
          page: () {
            Get.to(()=>ConstellationPage());
          },
          detail: '根据日期或星座名称,查询星座详细信息'),
      Service(
          img: Assets.icDkgjj.path,
          title: '贷款公积金计算器',
          page: () {
            Get.to(()=>LoanPage());
          },
          detail: '用于计算申请公积金贷款时每一期需偿还的金'),
      Service(
          img: Assets.icZjsc.path,
          title: '最佳身材计算器',
          page: () {
            Get.to(()=>FigureCalculatorPage());
          },
          detail: '女性最佳身材计算器,如:最佳上臂围、最佳'),
      Service(
          img: Assets.icJcjk.path,
          title: '基础健康指数计算器',
          page: () {
            Get.to(()=>HealthCalculatorPage());
          },
          detail: '通过身高、体重、年龄计算基础代谢率（BMR）'),
      Service(
          img: Assets.icXzpd.path,
          title: '星座配对',
          page: () {
            Get.to(()=>ConstellationPairingPage());
          },
          detail: '查看你跟哪个星座最配!'),
      Service(
          img: Assets.icJryj.path,
          title: '今日国内油价查询',
          page: () async{
            List<OilPriceModel> list = (await  LifeFunc.getOilPriceList())??[];
            if(list.isNotEmpty)
            Get.to(()=>OilPriceInquiryPage(oilList: list,));
          },
          detail: '今日汽油价格查询'),
      Service(
          img: Assets.icSxpd.path,
          title: '生肖配对',
          page: () {
            Get.to(()=>ZodiacPairingPage());
          },
          detail: '生肖配对查询'),
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
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
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
    return ListView.builder(
      itemCount: _items.length,
      padding: EdgeInsets.only(left: 12.rw, right: 12.rw, top: 0.rw,bottom: 20.rw),
      itemBuilder: (BuildContext context, int index) =>
          _itemWidget(_items[index]),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp,fontWeight: FontWeight.bold),
                ),
                5.hb,
                Text(
                  model.detail,
                  style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
                ),
              ],
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
  final String detail;

  Service( {
    required this.img,
    required this.title,
    required this.page,
    required this.detail,
  });
}
