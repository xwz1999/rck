import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/activity_list_model.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/widget/user_activity_card.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/const/resource.dart';

class UserActivityView extends StatefulWidget {
  final int id;
  final LiveBaseInfoModel userModel;
  final bool initAttention;
  UserActivityView(
      {Key key,
      @required this.id,
      @required this.userModel,
      @required this.initAttention})
      : super(key: key);

  @override
  _UserActivityViewState createState() => _UserActivityViewState();
}

class _UserActivityViewState extends State<UserActivityView>
    with AutomaticKeepAliveClientMixin {
  List<ActivityListModel> activityListModels = [];
  int _page = 1;
  GSRefreshController _controller = GSRefreshController();
  bool get selfFlag => widget.id == UserManager.instance.user.info.id;
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
        getActivityModels().then((models) {
          setState(() {
            activityListModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      onLoadMore: () {
        _page++;
        getActivityModels().then((models) {
          setState(() {
            activityListModels.addAll(models);
          });
          if (models.isEmpty)
            _controller.loadNoData();
          else
            _controller.loadComplete();
        });
      },
      body: activityListModels.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(R.ASSETS_IMG_NO_DATA_PNG),
                  rHBox(10),
                  Text(
                    selfFlag ? '您还未发布过动态' : 'TA还未发布过动态',
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
                return UserActivityCard(
                  model: activityListModels[index],
                  userModel: widget.userModel,
                  initAttention: widget.initAttention,
                );
              },
              itemCount: activityListModels.length,
            ),
    );
  }

  Future<List<ActivityListModel>> getActivityModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.activityList, {
      'userId': widget.id,
      'page': _page,
      'limit': 10,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => ActivityListModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
