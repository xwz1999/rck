import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/models/activity_list_model.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/widget/user_activity_card.dart';
import 'package:recook/widgets/refresh_widget.dart';

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
        getActivityModels().then((models) {
          _page = 1;
          setState(() {
            activityListModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      body: ListView.builder(
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
