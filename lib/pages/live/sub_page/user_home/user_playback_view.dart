import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/activity_video_list_model.dart';
import 'package:recook/pages/live/widget/user_live_playback_card.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserPlaybackView extends StatefulWidget {
  final int userId;
  UserPlaybackView({Key key, @required this.userId}) : super(key: key);

  @override
  _UserPlaybackViewState createState() => _UserPlaybackViewState();
}

class _UserPlaybackViewState extends State<UserPlaybackView>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _controller = GSRefreshController();
  int _page = 1;
  List<ActivityVideoListModel> _videoModels = [];
  bool get selfFlag => widget.userId == UserManager.instance.user.info.id;

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
        getActivityVideoList().then((models) {
          setState(() {
            _videoModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      onLoadMore: () {
        _page++;
        getActivityVideoList().then((models) {
          setState(() {
            _videoModels.addAll(models);
          });
          if (models.isEmpty)
            _controller.loadNoData();
          else
            _controller.loadComplete();
        });
      },
      body: _videoModels.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(R.ASSETS_IMG_NO_DATA_PNG),
                  rHBox(10),
                  Text(
                    selfFlag ? '您没有直播记录' : 'TA没有直播记录',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(16),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return UserPlaybackCard(model: _videoModels[index]);
              },
              itemCount: _videoModels.length,
            ),
    );
  }

  Future<List<ActivityVideoListModel>> getActivityVideoList() async {
    ResultData resultData = await HttpManager.post(LiveAPI.activityVideoList, {
      'userId': widget.userId,
      'limit': 10,
      'page': _page,
    });
    if (resultData?.data['data']['lists'] == null)
      return [];
    else
      return (resultData?.data['data']['lists'] as List)
          .map((e) => ActivityVideoListModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
