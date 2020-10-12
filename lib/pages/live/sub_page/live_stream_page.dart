import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/pages/live/models/follow_list_model.dart';
import 'package:recook/pages/live/models/live_list_model.dart';
import 'package:recook/pages/live/sub_page/user_attention_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class LiveStreamPage extends StatefulWidget {
  LiveStreamPage({Key key}) : super(key: key);

  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage>
    with AutomaticKeepAliveClientMixin {
  List<FollowListModel> followListModels = [];
  List<LiveListModel> _liveListModels = [];
  int _livePage = 1;
  GSRefreshController _liveListController = GSRefreshController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      getUserModels().then((models) {
        setState(() {
          followListModels = models;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildAttentions(),
        Expanded(
          child: _buildLiveUsers(),
        ),
      ],
    );
  }

  _buildAttentions() {
    return Container(
      height: rSize(102),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rHBox(rSize(102)),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(20),
                vertical: rSize(10),
              ),
              separatorBuilder: (context, index) {
                return SizedBox(width: rSize(16));
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _buildAttentionBox(followListModels[index]);
              },
              itemCount: followListModels.length,
            ),
          ),
          Container(
            width: rSize(52),
            child: CustomImageButton(
              height: rSize(102),
              onPressed: () {
                CRoute.push(
                  context,
                  UserAttentionPage(id: UserManager.instance.user.info.id),
                );
              },
              child: Text(
                '全部\n关注',
                style: TextStyle(
                  color: Color(0xFFDB2D2D),
                  fontSize: rSP(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildAttentionBox(FollowListModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(rSize(52 / 2)),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: model.headImgUrl,
                height: rSize(52),
                width: rSize(52),
              ),
            ),
            Positioned(
              right: rSize(3),
              bottom: 0,
              child: Image.asset(
                R.ASSETS_LIVE_ON_STREAM_PNG,
                height: rSize(12),
                width: rSize(12),
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
          _liveListController.loadComplete();
          setState(() {
            _liveListModels.addAll(models);
          });
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(rSize(10)),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () => CRoute.push(
          context,
          LiveStreamViewPage(),
        ),
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
                          Image.asset(R.ASSETS_LIVE_ON_STREAM_PNG),
                          Text(
                            '${model.look}人观看',
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
                          model.praise.toString(),
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

  Future<List<FollowListModel>> getUserModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.followList, {
      'findUserId': UserManager.instance.user.info.id,
      'page': 1,
      'limit': 10,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => FollowListModel.fromJson(e))
          .toList();
  }

  Future<List<LiveListModel>> getLiveListModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.liveList, {
      'page': _livePage,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data'] as List)
          .map((e) => LiveListModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
