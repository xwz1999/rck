import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'hot_person_list_page.dart';
import 'hot_video_list_widget.dart';

///热门视频
class HotVideoPage extends StatefulWidget {
  const HotVideoPage({Key? key}) : super(key: key);

  @override
  _HotVideoPageState createState() => _HotVideoPageState();
}

class _HotVideoPageState extends State<HotVideoPage> with TickerProviderStateMixin{

  TabController? _tabController;

  int _chooseIndex = 0;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 8, vsync: this);

    _tabController!.addListener(() {
      setState(() {
        _chooseIndex = _tabController!.index;
      });
    });
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
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Stack(
      children: [
        Positioned(
            child: Image.asset(
          Assets.imgToutu.path,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RecookBackButton(
                    white: true,
                  ),
                  Spacer(),
                ],
              ),
            ),
            150.hb,
            TabBar(
                controller: _tabController,
                unselectedLabelColor: Color(0xff999999),
                labelColor: AppColor.themeColor,
                indicator: BoxDecoration(),
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 12.rw),
                labelStyle: AppTextStyle.generate(18, fontWeight: FontWeight.w500),
                unselectedLabelStyle: AppTextStyle.generate(16, fontWeight: FontWeight.w500),
                onTap: (int index) {
                  _chooseIndex = index;
                  setState(() {});
                },
                tabs: [
                  _topItem(0),
                  _topItem(1),
                  _topItem(2),
                  _topItem(3),
                  _topItem(4),
                  _topItem(5),
                  _topItem(6),
                  Padding( padding:  EdgeInsets.only(right: 12.rw),child: _topItem(7),)
                  ,
                ]),

            32.hb,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  HotVideoListWidget(),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                  HotPersonListPage(index: _chooseIndex,),
                ],
              ),
            )

          ],
        )
      ],
    );
  }

  _topItem(int index){
    return _chooseIndex == index?
      Container(
        width: 96.rw,
        height: 48.rw,
        child: Image.asset(_getImgChoose(index)),
    ):Container(
      width: 80.rw,
      height: 40.rw,
      child: Image.asset(_getImg(index)),
    );
  }


  _getImgChoose(int index){
    switch(index){
      case 0:
        return Assets.imgHotSel.path;
      case 1:
        return Assets.imgFunnySel.path;
      case 2:
        return Assets.imgGameSel.path;
      case 3:
        return Assets.imgFoodSel.path;
      case 4:
        return Assets.imgCarSel.path;
      case 5:
        return Assets.imgTravelSel.path;
      case 6:
        return Assets.imgSportsSel.path;
      case 7:
        return Assets.imgCartoonSel.path;
    }
  }

  _getImg(int index){
    switch(index){
      case 0:
        return Assets.imgHotNor.path;
      case 1:
        return Assets.imgFunnyNor.path;
      case 2:
        return Assets.imgGameNor.path;
      case 3:
        return Assets.imgFoodNor.path;
      case 4:
        return Assets.imgCarNor.path;
      case 5:
        return Assets.imgTravelNor.path;
      case 6:
        return Assets.imgSportsNor.path;
      case 7:
        return Assets.imgCartoonNor.path;
    }
  }

}
