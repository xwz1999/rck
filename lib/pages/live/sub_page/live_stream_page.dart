import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/live/live_stream/live_playback_view_page.dart';
import 'package:jingyaoyun/pages/live/live_stream/live_stream_view_page.dart';
import 'package:jingyaoyun/pages/live/models/live_attention_list_model.dart';
import 'package:jingyaoyun/pages/live/models/live_list_model.dart';
import 'package:jingyaoyun/pages/live/num_tool/live_num_tool.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_home_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class LiveStreamPage extends StatefulWidget {
  LiveStreamPage({Key key}) : super(key: key);

  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage>
    with TickerProviderStateMixin {
  List<LiveAttentionListModel> _liveAttentionListModels = [];
  List<LiveListModel> _liveListModels = [];
  int _livePage = 1;
  int _attentionPage = 1;
  GSRefreshController _liveListController = GSRefreshController();
  GSRefreshController _liveAttentionController = GSRefreshController();
  GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _liveListController.requestRefresh();
        _liveAttentionController.requestRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: !UserManager.instance.haveLogin
                ? SizedBox(height: 10)
                : _buildAttentions(),
          ),
        ];
      },
      body: _buildLiveUsers(),
    );
  }

  _buildAttentions() {
    return Container(
      height: _liveAttentionListModels.isEmpty ? rSize(10) : rSize(102),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // rHBox(rSize(102)),
          Expanded(
            child: RefreshWidget(
              header: ClassicHeader(
                textStyle:
                    TextStyle(fontSize: 14 * 2.sp, color: Color(0xff555555)),
                idleIcon: Icon(
                  Icons.arrow_downward,
                  size: 20 * 2.sp,
                  color: Color(0xff555555),
                ),
                releaseIcon: Icon(
                  Icons.arrow_forward,
                  size: 20 * 2.sp,
                  color: Color(0xff555555),
                ),
                refreshingIcon: CupertinoActivityIndicator(
                  animating: true,
                  radius: 9.0 * 2.w,
                ),
                completeIcon: Icon(
                  Icons.check,
                  size: 20 * 2.sp,
                  color: Color(0xff555555),
                ),
                spacing: rSize(5),
                refreshingText: '',
                completeText: '',
                failedText: '网络错误',
                idleText: '',
                releaseText: '',
              ),
              noDataText: '',
              refreshingText: '',
              upIdleText: '',
              controller: _liveAttentionController,
              onRefresh: () {
                _attentionPage = 1;
                getUserModels().then((models) {
                  setState(() {
                    _liveAttentionListModels = models;
                  });
                  _liveAttentionController.refreshCompleted();
                });
              },
              onLoadMore: () {
                _attentionPage++;
                getUserModels().then((models) {
                  setState(() {
                    _liveAttentionListModels.addAll(models);
                  });
                  if (models.isEmpty)
                    _liveAttentionController.loadNoData();
                  else
                    _liveAttentionController.loadComplete();
                });
              },
              body: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(20),
                  vertical: rSize(10),
                ),
                separatorBuilder: (context, index) {
                  return SizedBox(width: rSize(16));
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (_liveAttentionListModels.isEmpty)
                    return SizedBox(height: rSize(10));
                  return _buildAttentionBox(_liveAttentionListModels[index]);
                },
                itemCount: _liveAttentionListModels.isEmpty
                    ? 1
                    : _liveAttentionListModels.length,
              ),
            ),
          ),
          // Container(
          //   width: rSize(52),
          //   child: CustomImageButton(
          //     height: rSize(102),
          //     onPressed: () {
          //       CRoute.push(
          //         context,
          //         UserAttentionPage(id: UserManager.instance.user.info.id),
          //       );
          //     },
          //     child: Text(
          //       '全部\n关注',
          //       style: TextStyle(
          //         color: Color(0xFFDB2D2D),
          //         fontSize: rSP(11),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildAttentionBox(LiveAttentionListModel model) {
    final bool isLive = model.isLive == 1;
    return CustomImageButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(rSize(52 / 2)),
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(model.headImgUrl),
                  height: rSize(52),
                  width: rSize(52),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: rSize(2)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(rSize(4)),
                    color: isLive ? Color(0xFFDB2D2D) : Color(0xFF8A8382),
                  ),
                  child: Row(
                    children: [
                      isLive
                          ? GifImage(
                              controller: _gifController,
                              image: AssetImage(R.ASSETS_LIVE_PLAY_GIF),
                              height: rSize(12),
                              width: rSize(12),
                            )
                          : Image.asset(
                              R.ASSETS_LIVE_STREAM_PLAY_BACK_PNG,
                              height: rSize(12),
                              width: rSize(12),
                            ),
                      Text(
                        '已关注',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: rSize(4)),
          Text(
            model.nickname,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: rSP(11),
            ),
          ),
        ],
      ),
      onPressed: () {
        if (isLive)
          CRoute.push(
            context,
            LiveStreamViewPage(id: model.id),
          );
        else
          CRoute.push(
            context,
            UserHomePage(
              userId: model.userId,
              initAttention: true,
            ),
          );
      },
    );
  }

  _buildLiveUsers() {
    return RefreshWidget(
      controller: _liveListController,
      onRefresh: () {
        _livePage = 1;
        getLiveListModels().then((models) {
          _liveListController.refreshCompleted();
          setState(() {
            _liveListModels = models;
          });
        });
      },
      onLoadMore: () {
        _livePage++;
        getLiveListModels().then((models) {
          setState(() {
            _liveListModels.addAll(models);
          });

          if (models.isEmpty)
            _liveListController.loadNoData();
          else
            _liveListController.loadComplete();
        });
      },
      body: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: rSize(16),
          vertical: rSize(5),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 165 / 249,
          crossAxisSpacing: rSize(15),
          mainAxisSpacing: rSize(15),
        ),
        itemBuilder: (context, index) {
          return _buildGridCard(_liveListModels[index]);
        },
        itemCount: _liveListModels.length,
      ),
    );
  }

  _buildGridCard(LiveListModel model) {
    final bool isLive = model.isLive == 1;
    return ClipRRect(
      borderRadius: BorderRadius.circular(rSize(10)),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (isLive)
            CRoute.push(
              context,
              LiveStreamViewPage(id: model.id),
            ).then((value) {
              _liveListController.requestRefresh();
              _liveAttentionController.requestRefresh();
            });
          else
            CRoute.push(context, LivePlaybackViewPage(id: model.id))
                .then((value) {
              _liveListController.requestRefresh();
              _liveAttentionController.requestRefresh();
            });
        },
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                    image: Api.getImgUrl(model.cover),
                    fit: BoxFit.cover,
                    height: rSize(165),
                    width: rSize(165),
                  ),
                  Positioned(
                    left: rSize(10),
                    top: rSize(10),
                    child: Container(
                      height: rSize(15),
                      decoration: BoxDecoration(
                        color: Color(0xFF050505).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(rSize(2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isLive
                              ? GifImage(
                                  controller: _gifController,
                                  image: AssetImage(R.ASSETS_LIVE_PLAY_GIF),
                                  height: rSize(15),
                                  width: rSize(15),
                                )
                              : Image.asset(
                                  R.ASSETS_LIVE_STREAM_PLAY_BACK_PNG,
                                ),
                          Text(
                            '${model.look}人${isLive ? '观看' : '看过'}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: rSP(10),
                            ),
                          ),
                          SizedBox(width: rSize(2)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: rSize(10),
                    bottom: rSize(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          R.ASSETS_LIVE_FAVORITE_PNG,
                          width: rSize(10),
                          height: rSize(10),
                        ),
                        Text(
                          getParseNum(model.praise),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: rSP(10),
                          ),
                        ),
                        SizedBox(width: rSize(2)),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(rSize(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                model.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: rSP(13),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(rSize(10)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                    image: Api.getImgUrl(model.headImgUrl),
                                    height: rSize(20),
                                    width: rSize(20),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: rSize(6),
                                    ),
                                    child: Text(
                                      model.nickname,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: rSP(13),
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: rSize(10)),
                      AspectRatio(
                        aspectRatio: 50 / 64,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(rSize(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  color: Color(0xFFE2DFDB),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                    image: Api.getImgUrl(model.mainPhotoUrl),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Color(0xFFF7F7F7),
                                  child: Text(
                                    '¥${model.originalPrice}',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: rSP(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<LiveAttentionListModel>> getUserModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.liveAttentionList, {
      'page': _attentionPage,
      'limit': 10,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data'] as List)
          .map((e) => LiveAttentionListModel.fromJson(e))
          .toList();
  }

  Future<List<LiveListModel>> getLiveListModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.liveList, {
      'page': _livePage,
      'limit': 10,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data'] as List)
          .map((e) => LiveListModel.fromJson(e))
          .toList();
  }
}
