import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/models/video_goods_model.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/video/video_goods_page.dart';
import 'package:recook/pages/live/video/video_preview_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/recook/recook_list_tile.dart';

class UploadVideoPage extends StatefulWidget {
  final File videoFile;
  final File coverImageFile;
  UploadVideoPage(
      {Key key, @required this.videoFile, @required this.coverImageFile})
      : super(key: key);

  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  TopicListModel _topicListModel;
  VideoGoodsModel _videoGoodsModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '发布',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        leading: FlatButton(
          color: Colors.white,
          splashColor: Colors.black12,
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Text(
            '取消',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(16),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: rSize(15)),
        children: [
          TextField(
            minLines: 5,
            maxLines: 99,
            style: TextStyle(
              color: Color(0xFF404040),
              fontSize: rSP(14),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: rSize(20),
                horizontal: 0,
              ),
              border: InputBorder.none,
              hintText: '填写视频说明并添加话题，让更多的人看到…',
              hintStyle: TextStyle(
                color: Color(0xFF979797),
                fontSize: rSP(14),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: rSize(100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(rSize(4)),
              child: Hero(
                tag: 'preview_video',
                child: Material(
                  child: Ink.image(
                    image: FileImage(widget.coverImageFile),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        CRoute.push(
                            context, VideoPreviewPage(file: widget.videoFile));
                      },
                      child: Container(
                        width: rSize(100),
                        height: rSize(100),
                        alignment: Alignment.center,
                        child: Image.asset(
                          R.ASSETS_LIVE_VIDEO_PLAY_PNG,
                          height: rSize(34),
                          width: rSize(34),
                        ),
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          rHBox(48),
          RecookListTile(
            title: _topicListModel == null
                ? Row(
                    children: [
                      Text(
                        '添加话题',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '（推荐）',
                        style: TextStyle(
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  )
                : _topicListModel.title,
            titleColor: Color(0xFFEB8A49),
            prefix: Image.asset(
              R.ASSETS_LIVE_TOPIC_PNG,
              width: rSize(16),
              height: rSize(16),
            ),
            onTap: () {
              CRoute.push(
                context,
                PickTopicPage(
                  onPick: (model) {
                    _topicListModel = model;
                  },
                ),
              ).then((value) {
                setState(() {});
              });
            },
          ),
          RecookListTile(
            title: _videoGoodsModel == null
                ? '添加关联产品'
                : _videoGoodsModel.goodsName,
            prefix: Image.asset(
              R.ASSETS_LIVE_UPLOAD_CART_PNG,
              width: rSize(16),
              height: rSize(16),
            ),
            onTap: () {
              CRoute.push(
                context,
                VideoGoodsPage(
                  onPick: (model) {
                    _videoGoodsModel = model;
                  },
                ),
              ).then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}
