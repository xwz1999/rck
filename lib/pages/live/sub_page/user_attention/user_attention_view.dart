import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/follow_list_model.dart';
import 'package:recook/pages/live/sub_page/user_attention_page.dart';
import 'package:recook/pages/live/sub_page/user_home_page.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:oktoast/oktoast.dart';

class UserAttentionView extends StatefulWidget {
  final int? id;
  UserAttentionView({Key? key, required this.id}) : super(key: key);

  @override
  _UserAttentionViewState createState() => _UserAttentionViewState();
}

class _UserAttentionViewState extends State<UserAttentionView>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _controller = GSRefreshController();
  int _page = 1;
  List<FollowListModel> followModels = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
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
    );
  }

  Future<List<FollowListModel>> getUserModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.followList, {
      'findUserId': widget.id,
      'page': _page,
      'limit': 15,
    });
    if (resultData.data['data'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => FollowListModel.fromJson(e))
          .toList();
  }

  _buildUserCard(FollowListModel model) {
    return buildUserBaseCard(
      prefix: ClipRRect(
        borderRadius: BorderRadius.circular(rSize(42 / 2)),
        child: FadeInImage.assetNetwork(
          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          image: Api.getImgUrl(model.headImgUrl)!,
          height: rSize(42),
          width: rSize(42),
        ),
      ),
      title: model.nickname!,
      subTitlePrefix: '关注 ${model.follows}',
      subTitleSuffix: '粉丝 ${model.fans}',
      initAttention: model.isFollow == 1,
      onTap: () {
        CRoute.push(
          context,
          UserHomePage(
            userId: model.userId,
            initAttention: model.isFollow == 1,
          ),
        );
      },
      onAttention: (bool oldState) {
        if (UserManager.instance!.haveLogin)
          HttpManager.post(
            oldState ? LiveAPI.cancelFollow : LiveAPI.addFollow,
            {'followUserId': model.userId},
          );
        else {
          showToast('未登陆，请先登陆');
          CRoute.push(context, UserPage());
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
