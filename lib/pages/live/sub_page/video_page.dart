import 'package:flutter/material.dart';

import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:jingyaoyun/const/resource.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/live/activity/video_fall_through_page.dart';
import 'package:jingyaoyun/pages/live/models/video_list_model.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _controller = GSRefreshController();
  int _page = 1;
  List<VideoListModel> _videoListModels = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        _page = 1;
        _getVideoList().then((models) {
          _videoListModels = models;
          if (mounted) setState(() {});
          _controller.refreshCompleted();
        });
      },
      onLoadMore: () {
        _page++;
        _getVideoList().then((models) {
          _videoListModels.addAll(models);
          if (mounted) setState(() {});
          if (models.isEmpty)
            _controller.loadNoData();
          else
            _controller.loadComplete();
        });
      },
      body: WaterfallFlow.builder(
        padding: EdgeInsets.all(rSize(15)),
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: rSize(15),
          mainAxisSpacing: rSize(15),
        ),
        itemBuilder: (context, index) {
          return _buildVideoCard(_videoListModels[index], index);
        },
        itemCount: _videoListModels.length,
      ),
    );
  }

  _buildVideoCard(VideoListModel model, int index) {
    return GestureDetector(
      onTap: () {
        CRoute.push(
          context,
          VideoFallThroughPage(models: _videoListModels, index: index),
        );

        // CRoute.push(context, VideoPreviewPage.network(path: model.))
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rSize(10)),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(model.coverUrl),
              ),
              Container(
                padding: EdgeInsets.all(rSize(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600,
                        fontSize: rSP(13),
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: FadeInImage.assetNetwork(
                            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                            image: Api.getImgUrl(model.headImgUrl),
                            height: rSize(18),
                            width: rSize(18),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: rSize(4),
                            ),
                            child: Text(
                              model.nickname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: rSP(12),
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          model.isPraise == 1
                              ? R.ASSETS_LIVE_LIKE_ON_PNG
                              : R.ASSETS_LIVE_FAVORITE_BLACK_PNG,
                          height: rSize(14),
                          width: rSize(14),
                        ),
                        SizedBox(width: rSize(2)),
                        Text(
                          model.praise.toString(),
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<VideoListModel>> _getVideoList() async {
    ResultData resultData = await HttpManager.post(LiveAPI.videoList, {
      'page': _page,
      'limit': 16,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => VideoListModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
