import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/hot_video_model.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/models/life_service/news_model.dart';
import 'package:recook/pages/life_service/sudoku_start_game_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/webView.dart';

import 'news_detail_page.dart';

///热门视频列表
class HotVideoListWidget extends StatefulWidget {

  const HotVideoListWidget({Key? key,}) : super(key: key);

  @override
  _HotVideoListWidgetState createState() => _HotVideoListWidgetState();
}

class _HotVideoListWidgetState extends State<HotVideoListWidget> {
  List<HotVideoModel> _videoList = [];

  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    _videoList = [
      HotVideoModel(title: '宁波黑坑水库盘老板，看看最后的渔获在你们那里能值多少钱。 #钓鱼  #dou来钓鱼516',
          shareUrl: 'https://www.iesdouyin.com/share/video/6960674964378897677/?region=CN&mid=6960676544603851533&u_code=0&titleType=title&did=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&iid=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&with_sec_did=1',
          author: '天元邓刚',
          itemCover: 'https://p6.douyinpic.com/img/tos-cn-p-0015/cd3cd955c1ec40d8a346c7fc652db36f~c5_300x400.jpeg?from=2563711402_large',
          hotValue: 188721410,
          hotWords: '老板,最后的,钓鱼,宁波,黑坑,水库,看看,渔获,你们,那里,能值,多少,dou,516',
          playCount: 303819638,
          diggCount: 2209478,
          commentCount: 97122
      ),
      HotVideoModel(title: '宁波黑坑水库盘老板，看看最后的渔获在你们那里能值多少钱。 #钓鱼  #dou来钓鱼516',
          shareUrl: 'https://www.iesdouyin.com/share/video/6960674964378897677/?region=CN&mid=6960676544603851533&u_code=0&titleType=title&did=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&iid=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&with_sec_did=1',
          author: '天元邓刚',
          itemCover: 'https://p6.douyinpic.com/img/tos-cn-p-0015/cd3cd955c1ec40d8a346c7fc652db36f~c5_300x400.jpeg?from=2563711402_large',
          hotValue: 188721410,
          hotWords: '老板,最后的,钓鱼,宁波,黑坑,水库,看看,渔获,你们,那里,能值,多少,dou,516',
          playCount: 303819638,
          diggCount: 2209478,
          commentCount: 97122
      ),
      HotVideoModel(title: '宁波黑坑水库盘老板，看看最后的渔获在你们那里能值多少钱。 #钓鱼  #dou来钓鱼516',
          shareUrl: 'https://www.iesdouyin.com/share/video/6960674964378897677/?region=CN&mid=6960676544603851533&u_code=0&titleType=title&did=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&iid=MS4wLjABAAAANwkJuWIRFOzg5uCpDRpMj4OX-QryoDgn-yYlXQnRwQQ&with_sec_did=1',
          author: '天元邓刚',
          itemCover: 'https://p6.douyinpic.com/img/tos-cn-p-0015/cd3cd955c1ec40d8a346c7fc652db36f~c5_300x400.jpeg?from=2563711402_large',
          hotValue: 188721410,
          hotWords: '老板,最后的,钓鱼,宁波,黑坑,水库,看看,渔获,你们,那里,能值,多少,dou,516',
          playCount: 303819638,
          diggCount: 2209478,
          commentCount: 97122
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      color: AppColor.themeColor,
      onRefresh: () async {
        _refreshController.refreshCompleted();
        //setState(() {});
      },
      body: ListView.builder(
        itemCount: _videoList.length,
        padding: EdgeInsets.only(
          left: 12.rw,
          right: 12.rw,
          top: 0.rw,
        ),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(_videoList[index]),
      ),
    );
  }


  _itemWidget(HotVideoModel model) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(
          context,
          RouteName.WEB_VIEW_PAGE,
          arguments: WebViewPage.setArguments(
            url: model.shareUrl??'',
            hideBar: true,),
        );
      },
      child: Container(
        width: double.infinity,
        height: 110.rw,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130.rw,
              height: 90.rw,
              child: Stack(
                children: [
                  CustomCacheImage(
                    borderRadius: BorderRadius.circular(4.rw),
                    imageUrl: model.itemCover ?? '',
                    fit: BoxFit.fitWidth,
                    width: 140.rw,
                    height: 94.rw,
                  ),
                  Positioned(
                      top: 0,
                      child: Container(
                        width: 130.rw,
                        height: 20.rw,
                        decoration: BoxDecoration(
                          color: Color(0x66000000),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4.rw),topRight:Radius.circular(4.rw),),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            20.wb,
                            Image.asset(Assets.imgZhishu.path,width: 12.rw,height: 12.rw,),
                            20.wb,
                            Text('${model.hotValue}',style: TextStyle(
                                color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.rsp
                            ),)
                          ],
                        ),
                      ))
                ],
              ),
            ),
            24.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: 200.rw,
                    height: 50.rw,
                    child: Text(model.title??'',style: TextStyle(
                      fontSize: 16.rsp,color: Color(0xFF333333),
                    ),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                Text(model.author??'',style: TextStyle(
                  fontSize: 12.rsp,color: Color(0xFF999999),
                )),
                10.hb,
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(Assets.imgBofang.path,width: 16.rw,height: 16.rw,),
                        8.wb,
                        Text(_getNumWithW(model.playCount??0),style: TextStyle(color: Color(0xFF999999),fontSize: 10.rsp),),

                        20.wb,
                        Image.asset(Assets.imgDianzan.path,width: 16.rw,height: 16.rw,),
                        8.wb,
                        Text(_getNumWithW(model.diggCount??0),style: TextStyle(color: Color(0xFF999999),fontSize: 10.rsp),),
                        20.wb,
                        Image.asset(Assets.imgPinglun.path,width: 16.rw,height: 16.rw,),
                        8.wb,
                        Text(_getNumWithW(model.commentCount??0),style: TextStyle(color: Color(0xFF999999),fontSize: 10.rsp),),

                      ],
                    )
                  ],
                )

              ],
            )
          ],
        ),
      ),
    );
  }


  _getNumWithW(int num){
    if(num>=10000){
      return (num/10000).toStringAsFixed(1)+'w';
    }
    else{
      return '$num}';
    }
  }
}
