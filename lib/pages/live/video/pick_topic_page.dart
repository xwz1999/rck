import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class PickTopicPage extends StatefulWidget {
  final Function(TopicListModel model) onPick;
  PickTopicPage({Key key, @required this.onPick}) : super(key: key);

  @override
  _PickTopicPageState createState() => _PickTopicPageState();
}

class _PickTopicPageState extends State<PickTopicPage> {
  bool onSearch = false;
  String _keyword = '';
  int _page = 1;

  List<TopicListModel> hotTopics = [];
  List<TopicListModel> searchResultModels = [];

  GSRefreshController _controller = GSRefreshController();
  @override
  void initState() {
    super.initState();
    HttpManager.post(LiveAPI.hotTopics, {}).then((resultData) {
      setState(() {
        hotTopics = (resultData?.data['data'] as List)
            .map((e) => TopicListModel.fromJson(e))
            .toList();
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: rSize(30 + 28.0),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '取消',
            softWrap: false,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(rSize(16)),
          ),
          margin: EdgeInsets.only(
            left: rSize(5),
            right: rSize(15),
          ),
          child: TextField(
            autofocus: true,
            onChanged: (text) {
              if (TextUtil.isEmpty(text)) {
                setState(() {
                  onSearch = false;
                });
              }
            },
            onSubmitted: (text) {
              setState(() {
                onSearch = true;
                _keyword = text;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted) _controller.requestRefresh();
              });
            },
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(13),
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '搜索你想参与的话题',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
                fontSize: rSP(13),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: rSize(13), right: rSize(3)),
                child: Image.asset(
                  R.ASSETS_SEARCH_PNG,
                  height: rSize(16),
                  width: rSize(16),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: onSearch
          ? RefreshWidget(
              controller: _controller,
              onRefresh: () {
                _page = 1;
                getSearchTopicList().then((models) {
                  setState(() {
                    searchResultModels = models;
                  });
                  _controller.refreshCompleted();
                });
              },
              onLoadMore: () {
                _page++;
                getSearchTopicList().then((models) {
                  setState(() {
                    searchResultModels.addAll(models);
                  });
                  _controller.loadComplete();
                });
              },
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildTopicCard(searchResultModels[index]);
                },
                itemCount: searchResultModels.length,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(rSize(15)),
                  child: Text(
                    '热门搜索',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return _buildTopicCard(hotTopics[index]);
                    },
                    itemCount: hotTopics.length,
                  ),
                ),
              ],
            ),
    );
  }

  _buildTopicCard(TopicListModel model) {
    return MaterialButton(
      onPressed: () {
        widget.onPick(model);
        Navigator.pop(context);
      },
      splashColor: Colors.black26,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            R.ASSETS_LIVE_TOPIC_PNG,
            height: rSize(12),
            width: rSize(12),
          ),
          rWBox(4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(
                    color: Color(0xFFEB8A49),
                    fontSize: rSP(14),
                    height: 1,
                  ),
                ),
                Text(
                  '${model.partake}人参与 ｜ 共${model.substance}条内容',
                  style: TextStyle(
                    color: Color(0xFF979797),
                    fontSize: rSP(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: rSize(15),
        vertical: rSize(10),
      ),
    );
  }

  Future<List<TopicListModel>> getSearchTopicList() async {
    ResultData resultData = await HttpManager.post(LiveAPI.topicSearchList, {
      'keyword': _keyword,
      'page': _page,
      'limit': 15,
    });

    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => TopicListModel.fromJson(e))
          .toList();
  }
}
