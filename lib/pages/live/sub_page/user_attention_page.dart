import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/follow_list_model.dart';
import 'package:recook/pages/live/sub_page/topic_page.dart';
import 'package:recook/pages/live/sub_page/user_home_page.dart';
import 'package:recook/pages/live/widget/live_attention_button.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/recook_indicator.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserAttentionPage extends StatefulWidget {
  final int id;
  UserAttentionPage({Key key, @required this.id}) : super(key: key);

  @override
  _UserAttentionPageState createState() => _UserAttentionPageState();
}

class _UserAttentionPageState extends State<UserAttentionPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  GSRefreshController _userController = GSRefreshController();
  GSRefreshController _topicController = GSRefreshController();

  int _page = 1;
  List<FollowListModel> followModels = [];

  bool get selfFlag => widget.id == UserManager.instance.user.info.id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: 300), () {
      _userController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _userController?.dispose();
    _topicController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: selfFlag ? '我的关注' : 'TA的关注',
      whiteBg: true,
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(rSize(38)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(110)),
          child: TabBar(
            tabs: [
              Tab(text: '用户'),
              Tab(text: '话题'),
            ],
            indicatorPadding: EdgeInsets.symmetric(
              horizontal: 0,
            ),
            indicator: RecookIndicator(
              borderSide: BorderSide(
                color: Color(0xFFDB2D2D),
                width: rSize(3),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xFF333333),
            unselectedLabelColor: Color(0xFF666666),
            controller: _tabController,
            onTap: (index) {
              switch (index) {
                case 0:
                  Future.delayed(Duration(milliseconds: 300), () {
                    _userController.requestRefresh();
                  });
                  break;
                case 1:
                  break;
              }
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshWidget(
            controller: _userController,
            onRefresh: () {
              getUserModels().then((models) {
                if (mounted) followModels = models;
                setState(() {});
                _userController.refreshCompleted();
              });
            },
            body: ListView.builder(
              itemBuilder: (context, index) {
                final model = followModels[index];
                return _buildUserCard(model);
              },
              itemCount: followModels.length,
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return _buildTopicCard();
            },
          ),
        ],
      ),
    );
  }

  _buildUserCard(FollowListModel model) {
    return _buildUserBaseCard(
      prefix: ClipRRect(
        borderRadius: BorderRadius.circular(rSize(42 / 2)),
        child: FadeInImage.assetNetwork(
          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          image: Api.getImgUrl(model.headImgUrl),
          height: rSize(42),
          width: rSize(42),
        ),
      ),
      title: model.nickname,
      subTitlePrefix: '关注 ${model.follows}',
      subTitleSuffix: '粉丝 ${model.fans}',
      initAttention: model.isFollow == 1,
      onTap: () {
        CRoute.push(
          context,
          UserHomePage(userId: model.userId),
        );
      },
      onAttention: (bool oldState) {
        HttpManager.post(
          oldState ? LiveAPI.cancelFollow : LiveAPI.addFollow,
          {'followUserId': model.userId},
        );
      },
    );
  }

  _buildTopicCard() {
    return _buildUserBaseCard(
      prefix: Image.asset(
        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
        height: rSize(42),
        width: rSize(42),
      ),
      title: '# 高颜值厨房好物',
      subTitlePrefix: '共23条内容',
      subTitleSuffix: '537人参与',
      onTap: () {
        CRoute.push(context, TopicPage());
      },
      onAttention: (bool oldState) {},
    );
  }

  Widget _buildUserBaseCard({
    Widget prefix,
    @required String title,
    String subTitlePrefix,
    String subTitleSuffix,
    @required VoidCallback onTap,
    bool initAttention = false,
    @required Function(bool oldState) onAttention,
  }) {
    return CustomImageButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.all(rSize(15)),
        child: Row(
          children: [
            prefix,
            SizedBox(width: rSize(15)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                          subTitlePrefix,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(13),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subTitleSuffix,
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
            LiveAttentionButton(
              initAttention: initAttention,
              onAttention: onAttention,
            ),
          ],
        ),
      ),
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
