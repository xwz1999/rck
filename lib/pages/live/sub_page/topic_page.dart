import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/models/topic_base_info_model.dart';
import 'package:recook/pages/live/models/topic_content_list_model.dart';
import 'package:recook/pages/live/widget/live_attention_button.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class TopicPage extends StatefulWidget {
  final int topicId;
  TopicPage({Key key, @required this.topicId}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  TopicBaseInfoModel _topicBaseInfoModel = TopicBaseInfoModel.zero();
  GSRefreshController _controller = GSRefreshController();
  int _page = 1;
  List<TopicContentListModel> models = [];
  @override
  void initState() {
    super.initState();
    HttpManager.post(LiveAPI.topicBaseInfo, {
      'topicId': widget.topicId,
    }).then((resultData) {
      setState(() {
        _topicBaseInfoModel =
            TopicBaseInfoModel.fromJson(resultData.data['data']);
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: RecookBackButton(white: true),
                  brightness: Brightness.light,
                  stretch: true,
                  floating: true,
                  expandedHeight:
                      rSize(140) + MediaQuery.of(context).viewPadding.top,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: FadeInImage.assetNetwork(
                            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                            image: Api.getImgUrl(_topicBaseInfoModel.topicImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.11),
                          ),
                        ),
                        Positioned(
                          bottom: rSize(22),
                          left: rSize(15),
                          right: rSize(15),
                          child: Row(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                image:
                                    Api.getImgUrl(_topicBaseInfoModel.topicImg),
                                fit: BoxFit.cover,
                                height: rSize(64),
                                width: rSize(64),
                                alignment: Alignment.bottomRight,
                              ),
                              SizedBox(width: rSize(15)),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '#${_topicBaseInfoModel.title}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: rSP(16),
                                            ),
                                          ),
                                        ),
                                        LiveAttentionButton(
                                          initAttention:
                                              _topicBaseInfoModel.isFollow == 1,
                                          filled: true,
                                          width: rSize(56),
                                          height: rSize(26),
                                          onAttention: (oldAttentionState) {
                                            HttpManager.post(
                                              oldAttentionState
                                                  ? LiveAPI.cancelTopic
                                                  : LiveAPI.addTopic,
                                              {'topicId': widget.topicId},
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: RefreshWidget(
              controller: _controller,
              onRefresh: () {
                _page = 1;
                _getTopicContentModels().then((getModels) {
                  models = getModels;
                  if (mounted) setState(() {});
                  _controller.refreshCompleted();
                });
              },
              body: WaterfallFlow.builder(
                padding: EdgeInsets.all(rSize(15)),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: rSize(15),
                  mainAxisSpacing: rSize(15),
                ),
                itemBuilder: (context, index) {
                  return _buildCard(models[index]);
                },
                itemCount: models.length,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(15),
                vertical: rSize(6),
              ),
              child: SizedBox(
                height: rSize(36),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(18)),
                  ),
                  onPressed: () {},
                  color: Color(0xFFDB2D2D),
                  child: Text(
                    '参与话题',
                    style: TextStyle(fontSize: rSP(16)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCard(TopicContentListModel model) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(rSize(10)),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        color: Colors.white,
        onPressed: () {},
        splashColor: Colors.black26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: model.coverUrl,
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
                      fontSize: rSP(13),
                      fontWeight: FontWeight.bold,
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
                      rWBox(4),
                      Expanded(
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
                      Image.asset(
                        R.ASSETS_LIVE_FAVORITE_BLACK_PNG,
                        height: rSize(14),
                        width: rSize(14),
                      ),
                      Text(
                        model.praise.toString(),
                        style: TextStyle(
                          color: Color(0xFf666666),
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
    );
  }

  Future<List<TopicContentListModel>> _getTopicContentModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.topicContentList, {
      'topicId': widget.topicId,
      'page': _page,
      'limit': 12,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => TopicContentListModel.fromJson(e))
          .toList();
  }
}
