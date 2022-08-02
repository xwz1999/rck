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
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/webView.dart';

import 'life_func.dart';
import 'news_detail_page.dart';

///热门视频列表
class HotVideoListWidget extends StatefulWidget {
  const HotVideoListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _HotVideoListWidgetState createState() => _HotVideoListWidgetState();
}

class _HotVideoListWidgetState extends State<HotVideoListWidget> {
  List<HotVideoModel> _videoList = [];

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
    return RefreshWidget(
      controller: _refreshController,
      color: AppColor.themeColor,
      onRefresh: () async {
        page = 1;
        _videoList = await LifeFunc.getHotVideoList('hot_video') ?? [];
        _refreshController.refreshCompleted();
        _onLoad = false;
        setState(() {});
      },
      // onLoadMore: () async {
      //   page++;
      //   await LifeFunc.getHotVideoList('hot_video').then((models) {
      //     setState(() {
      //       _videoList.addAll(models ?? []);
      //     });
      //     _refreshController.loadComplete();
      //   });
      // },
      body: _onLoad
          ? SizedBox()
          : _videoList.isEmpty
              ? NoDataView(
                  title: "没有数据哦～",
                  height: 600,
                )
              : ListView.builder(
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
      onTap: () {
        AppRouter.push(
          context,
          RouteName.WEB_VIEW_PAGE,
          arguments: WebViewPage.setArguments(
            url: model.shareUrl ?? '',
            hideBar: true,
          ),
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.rw),
                            topRight: Radius.circular(4.rw),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            20.wb,
                            Image.asset(
                              Assets.imgZhishu.path,
                              width: 12.rw,
                              height: 12.rw,
                            ),
                            20.wb,
                            Text(
                              '${model.hotValue}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.rsp),
                            )
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
                    child: Text(
                      model.title ?? '',
                      style: TextStyle(
                        fontSize: 16.rsp,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(model.author ?? '',
                    style: TextStyle(
                      fontSize: 12.rsp,
                      color: Color(0xFF999999),
                    )),
                10.hb,
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          Assets.imgBofang.path,
                          width: 16.rw,
                          height: 16.rw,
                        ),
                        8.wb,
                        Text(
                          _getNumWithW(model.playCount ?? 0),
                          style: TextStyle(
                              color: Color(0xFF999999), fontSize: 10.rsp),
                        ),
                        20.wb,
                        Image.asset(
                          Assets.imgDianzan.path,
                          width: 16.rw,
                          height: 16.rw,
                        ),
                        8.wb,
                        Text(
                          _getNumWithW(model.diggCount ?? 0),
                          style: TextStyle(
                              color: Color(0xFF999999), fontSize: 10.rsp),
                        ),
                        20.wb,
                        Image.asset(
                          Assets.imgPinglun.path,
                          width: 16.rw,
                          height: 16.rw,
                        ),
                        8.wb,
                        Text(
                          _getNumWithW(model.commentCount ?? 0),
                          style: TextStyle(
                              color: Color(0xFF999999), fontSize: 10.rsp),
                        ),
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

  _getNumWithW(int num) {
    if (num >= 10000) {
      return (num / 10000).toStringAsFixed(1) + 'w';
    } else {
      return '$num';
    }
  }
}
