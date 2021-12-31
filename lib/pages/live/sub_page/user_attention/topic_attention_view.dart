import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/live/models/topic_list_model.dart';
import 'package:jingyaoyun/pages/live/sub_page/topic_page.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_attention_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class TopicAttentionView extends StatefulWidget {
  final int id;
  TopicAttentionView({Key key, @required this.id}) : super(key: key);

  @override
  _TopicAttentionViewState createState() => _TopicAttentionViewState();
}

class _TopicAttentionViewState extends State<TopicAttentionView>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _topicController = GSRefreshController();
  int _page = 1;
  List<TopicListModel> topicModels = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _topicController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _topicController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _topicController,
      onRefresh: () {
        _page = 1;
        getTopicModel().then((models) {
          topicModels = models;
          if (mounted) setState(() {});
          _topicController.refreshCompleted();
        });
      },
      onLoadMore: () {
        _page++;
        getTopicModel().then((models) {
          topicModels = models;
          if (mounted) setState(() {});
          _topicController.refreshCompleted();
        });
      },
      body: ListView.builder(
        itemBuilder: (context, index) {
          final model = topicModels[index];
          return _buildTopicCard(model);
        },
        itemCount: topicModels.length,
      ),
    );
  }

  Future<List<TopicListModel>> getTopicModel() async {
    ResultData resultData = await HttpManager.post(LiveAPI.topicList, {
      'findUserId': widget.id,
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => TopicListModel.fromJson(e))
          .toList();
  }

  _buildTopicCard(TopicListModel model) {
    return buildUserBaseCard(
      prefix: Image.asset(
        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
        height: rSize(42),
        width: rSize(42),
      ),
      title: '# ${model.title}',
      subTitlePrefix: '共${model.substance}条内容',
      subTitleSuffix: '${model.partake}人参与',
      onTap: () {
        CRoute.push(context,
            TopicPage(topicId: model.id, initAttention: model.isFollow == 1));
      },
      initAttention: model.isFollow == 1,
      onAttention: (bool oldState) {
        HttpManager.post(
          oldState ? LiveAPI.cancelTopic : LiveAPI.addTopic,
          {'topicId': model.id},
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
