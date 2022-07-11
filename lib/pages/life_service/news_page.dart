import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/models/life_service/news_model.dart';
import 'package:recook/pages/life_service/sudoku_start_game_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'news_detail_page.dart';

///新闻
class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsModel> _newsList = [];

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    _newsList = [
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
            'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
            'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
            'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title:
            '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
            'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS: '',
      ),
      NewsModel(
        title:
        '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
        'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS: '',
      ),
      NewsModel(
        title:
        '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS:
        'https://dfzximg02.dftoutiao.com//news//20220627//20220627141409_018fce642b59c40e57e73fd0b87ba247_1_mwpm_03201609.jpeg',
      ),
      NewsModel(
        title: '“新时代女性的自我关爱”主题沙龙暨双山街道福泰社区妇儿活动家园启动仪式举行',
        date: '2021-03-08 13:47:00',
        authorName: '鲁网',
        thumbnailPicS: '',
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Stack(
      children: [
        Positioned(
            child: Image.asset(
          Assets.imgXwtt.path,
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
                  Text('新闻头条',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.rsp,
                      )),
                  SizedBox(
                    width: 110.w,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshWidget(
                controller: _refreshController,
                color: Colors.white,
                onRefresh: () async {
                  _refreshController.refreshCompleted();
                  //setState(() {});
                },
                body: ListView.builder(
                  itemCount: _newsList.length,
                  padding: EdgeInsets.only(
                    left: 12.rw,
                    right: 12.rw,
                    top: 0.rw,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      _itemWidget(_newsList[index]),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _itemWidget(NewsModel model) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>NewsDetailPage(newsDetailModel: NewsDetailModel(),));
      },
      child: Container(
        width: double.infinity,
        height: 115.rw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  model.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.rsp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                )),
                24.wb,
                model.thumbnailPicS!=null&&model.thumbnailPicS!.isNotEmpty? Container(
                    width: 88.rw,
                    height: 66.rw,
                    child:CustomCacheImage(
                            borderRadius: BorderRadius.circular(4.rw),
                            imageUrl: model.thumbnailPicS ?? '',
                            fit: BoxFit.fill,
                          )
                      ):SizedBox()
              ],
            ),
            8.hb,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(model.authorName ?? '',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
                16.wb,
                Padding(
                  padding: EdgeInsets.only(top: 3.rw),
                  child: Text(model.date ?? '',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12.rsp,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
