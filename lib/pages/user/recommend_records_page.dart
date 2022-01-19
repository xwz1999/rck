import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/pages/user/recmmend_list_page.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/cache_tab_bar_view.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class RecommendRecordsPage extends StatefulWidget {
  RecommendRecordsPage({
    Key key,
  }) : super(key: key);

  @override
  _RecommendRecordsPageState createState() => _RecommendRecordsPageState();
}

class _RecommendRecordsPageState extends State<RecommendRecordsPage> with TickerProviderStateMixin{
  List<String> _items = ["全部", "待审核", "已通过", "已驳回"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "申请记录",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return  Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            child: SCTabBar(
              labelColor: Colors.white,
              needRefresh: true,
              labelPadding: EdgeInsets.only(left: 20.rw,right: 20.rw),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColor.themeColor,
              itemBuilder: (int index) {
                return _item(index);
              },
            )),
        Expanded(
          child: CacheTabBarView(
            controller: _tabController,
            children: <Widget>[
              RecommendListPage(state: 0,),
              RecommendListPage(state: 1),
              RecommendListPage(state: 2),
              RecommendListPage(state: 3),
            ],
          ),
        )
      ],
    );
  }

  _item(int index) {
    String title = _items[index];
    bool selected = index == _tabController.index;
    return Container(
        height: rSize(30),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyle.generate(
              ScreenAdapterUtils.setSp(selected ? 14 : 13),
              color: selected ? AppColor.themeColor : Colors.black,
              fontWeight: selected
                  ? FontWeight.w500
                  : FontWeight.lerp(FontWeight.w300, FontWeight.w400, 0.5)),
        ));
    }



}