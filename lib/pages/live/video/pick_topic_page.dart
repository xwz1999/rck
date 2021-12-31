import 'dart:async';

import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/live/models/topic_list_model.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';

class PickTopicPage extends StatefulWidget {
  final Function(TopicListModel model) onPick;
  PickTopicPage({Key key, @required this.onPick}) : super(key: key);

  @override
  _PickTopicPageState createState() => _PickTopicPageState();
}

class _PickTopicPageState extends State<PickTopicPage> {
  bool onSearch = false;
  Timer _inputTimer;
  bool _showSearchResult = false;
  TextEditingController _editingController = TextEditingController();

  List<TopicListModel> hotTopics = [];
  List<TopicListModel> searchResultModels = [];

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
    _editingController?.dispose();
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
        title: Text(
          '自定义话题',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          Center(
            child: MaterialButton(
              color: Color(0xFFFFDB2D2D),
              height: rSize(28),
              minWidth: rSize(60),
              onPressed: () async {
                if (TextUtil.isEmpty(_editingController.text)) {
                  ReToast.err(text: '话题不能为空');
                  return;
                }
                final cancel = ReToast.loading(text: '创建话题');
                try {
                  ResultData result = await HttpManager.post(
                    LiveAPI.topicAddNew,
                    {'title': _editingController.text},
                  );
                  cancel();
                  if (result.data['data']['topicId'] is int) {
                    widget.onPick(TopicListModel(
                      title: _editingController.text,
                      id: result.data['data']['topicId'],
                    ));
                    return;
                  }
                } catch (e) {
                  cancel();
                  ReToast.err(text: '创建失败');
                }

                Navigator.pop(context);
              },
              child: Text('提交'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rSize(14)),
              ),
            ),
          ),
          rWBox(15),
        ],
      ),
      body:
          // onSearch
          //     ? RefreshWidget(
          //         controller: _controller,
          //         onRefresh: () {
          //           _page = 1;
          //           getSearchTopicList().then((models) {
          //             setState(() {
          //               searchResultModels = models;
          //             });
          //             _controller.refreshCompleted();
          //           });
          //         },
          //         onLoadMore: () {
          //           _page++;
          //           getSearchTopicList().then((models) {
          //             setState(() {
          //               searchResultModels.addAll(models);
          //             });
          //             _controller.loadComplete();
          //           });
          //         },
          //         body: ListView.builder(
          //           itemBuilder: (context, index) {
          //             return _buildTopicCard(searchResultModels[index]);
          //           },
          //           itemCount: searchResultModels.length,
          //         ),
          //       )
          //     :
          Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rHBox(50),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rHBox(15),
              Row(
                children: [
                  rWBox(15),
                  Image.asset(
                    R.ASSETS_LIVE_TOPIC_PNG,
                    height: rSize(16),
                    width: rSize(16),
                  ),
                  rWBox(15),
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      autofocus: true,
                      onChanged: (text) {
                        _inputTimer?.cancel();
                        _inputTimer = Timer(Duration(milliseconds: 500), () {});
                        searchResultModels = null;
                        setState(() {
                          _showSearchResult = !TextUtil.isEmpty(text);
                        });
                        getSearchTopicList().then((models) {
                          setState(() {
                            searchResultModels = models;
                          });
                        });
                      },
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(13),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: '请输入话题名称',
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: rSP(13),
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  rWBox(15),
                ],
              ),
              _showSearchResult ? _buildSearchData() : SizedBox(),
            ],
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

  _buildSearchData() {
    return Container(
      margin: EdgeInsets.only(left: rSize(45)),
      width: rSize(293),
      child: searchResultModels == null
          ? Center(child: CircularProgressIndicator())
          : searchResultModels.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(rSize(15)),
                  child: Text(
                    '点击提交新建话题',
                    style: TextStyle(
                      color: Color(0xFF333333),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MaterialButton(
                      height: rSize(22 + 18.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          searchResultModels[index].title,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: rSP(14),
                          ),
                        ),
                      ),
                      onPressed: () {
                        widget.onPick(searchResultModels[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                  itemCount: searchResultModels.length,
                ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rSize(4)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, rSize(2)),
            blurRadius: rSize(8),
            spreadRadius: 0,
            color: Color(0xFF26000000),
          )
        ],
      ),
    );
  }

  Future<List<TopicListModel>> getSearchTopicList() async {
    ResultData resultData = await HttpManager.post(LiveAPI.topicSearchList, {
      'keyword': _editingController.text,
      'page': 1,
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
