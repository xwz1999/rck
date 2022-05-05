import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/follow_list_model.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserSupportPage extends StatefulWidget {
  //获赞页面
  final int id;

  UserSupportPage({Key key, @required this.id}) : super(key: key);

  @override
  _UserSupportPageState createState() => _UserSupportPageState();
}

class _UserSupportPageState extends State<UserSupportPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool get selfFlag => widget.id == UserManager.instance.user.info.id;
  GSRefreshController _controller = GSRefreshController();
  List<FollowListModel> followModels = [];
  int _page = 1;

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
    return RecookScaffold(
        title: selfFlag ? '我的获赞' : 'TA的获赞',
        whiteBg: true,
        body: RefreshWidget(
          controller: _controller,
          onRefresh: () {
            _page = 1;
            getUserModels().then((models) {
              followModels = models;
              if (mounted) setState(() {});
              _controller.refreshCompleted();
            });
          },
          onLoadMore: () {
            _page++;
            getUserModels().then((models) {
              followModels.addAll(models);
              if (mounted) setState(() {});
              if (models.isEmpty)
                _controller.loadNoData();
              else
                _controller.loadComplete();
            });
          },
          body: ListView.builder(
            itemBuilder: (context, index) {
              final model = followModels[index];
              return _buildUserCard(model);
            },
            itemCount: followModels.length,
          ),
        )
    );
  }

  Future<List<FollowListModel>> getUserModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.followList, {
      'findUserId': widget.id,
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => FollowListModel.fromJson(e))
          .toList();
  }

}


Widget _buildUserCard(FollowListModel model) {
  return Container(
    padding: EdgeInsets.all(rSize(15)),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(rSize(42 / 2)),
          child: FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
            image: Api.getImgUrl(model.headImgUrl),
            height: rSize(42),
            width: rSize(42),
          ),
        ),
        SizedBox(width: rSize(15)),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.nickname,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: rSize(3)),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '赞了你的视频 '+'09-06',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: rSP(13),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
        SizedBox(width: rSize(15)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rSize(5)),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
            image: Api.getImgUrl(model.headImgUrl),
            height: rSize(40),
            width: rSize(40),
          ),
        )
      ],
    ),
  );
}
