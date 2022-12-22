
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/models/life_service/news_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/no_data_view.dart';
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
  List<NewsModel?> _newsList = [];

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  int page = 1;
  bool _onLoad = true;

  @override
  void initState() {
    super.initState();
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
                  page = 1;
                  _newsList = await LifeFunc.getNewsList(page)??[];
                  _refreshController.refreshCompleted();
                  _onLoad = false;
                  setState(() {});
                },
                onLoadMore: () async {
                  page++;
                  await LifeFunc.getNewsList(page).then((models) {
                    setState(() {
                      _newsList.addAll(models ?? []);
                    });
                    _refreshController.loadComplete();
                  });
                },
                body: _onLoad?SizedBox(): _newsList.isEmpty
                    ? NoDataView(
                        title: "没有数据哦～",
                        height: 600,
                      )
                    : ListView.builder(
                        itemCount: _newsList.length,
                        padding: EdgeInsets.only(
                          left: 12.rw,
                          right: 12.rw,
                          top: 0.rw,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            _itemWidget(_newsList[index]!),
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
      onTap: () async{

        NewsDetailModel? newsDetailModel = await LifeFunc.getNewsDetailModel(model.uniquekey??'');
        if(newsDetailModel!=null)
        Get.to(() => NewsDetailPage(
              newsDetailModel: newsDetailModel,
            ));
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        height: 115.rw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                model.thumbnailPicS != null && model.thumbnailPicS!.isNotEmpty
                    ? Container(
                        width: 88.rw,
                        height: 66.rw,
                        child: CustomCacheImage(
                          borderRadius: BorderRadius.circular(4.rw),
                          imageUrl: model.thumbnailPicS ?? '',
                          fit: BoxFit.fill,
                        ))
                    : SizedBox()
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Text(((model.authorName??'').split('，')[0]),
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
                16.wb,
                Text(model.date ?? '',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
              ],
            ),
            20.hb,
          ],
        ),
      ),
    );
  }
}
