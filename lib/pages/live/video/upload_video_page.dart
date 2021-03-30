import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_txugcupload/flutter_txugcupload.dart';
import 'package:oktoast/oktoast.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/models/video_goods_model.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/video/tencent_video_listener.dart';
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
  TextEditingController _editingController = TextEditingController();
  File uploadFile;
  @override
  void initState() {
    super.initState();
    uploadFile = widget.videoFile.renameSync(
      widget.videoFile.path.replaceAll(':', ''),
    );
  }

  @override
  void dispose() {
    _editingController?.dispose();
    super.dispose();
  }

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
        actions: [
          Center(
            child: MaterialButton(
              color: Color(0xFFDB2D2D),
              height: rSize(28),
              minWidth: rSize(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rSize(14)),
              ),
              onPressed: () {
                if (TextUtils.isEmpty(_editingController.text)) {
                  GSDialog.of(context).showError(context, '说明不能为空');
                } else if (_videoGoodsModel == null) {
                  GSDialog.of(context).showError(context, '需要选择一个商品');
                } else {
                  GSDialog.of(context).showLoadingDialog(context, '初始化');
                  TXUGCPublish txugcPublish = TXUGCPublish(
                      customKey: '${UserManager.instance.user.info.id}');
                  HttpManager.post(LiveAPI.uploadKey, {}).then((resultData) {
                    GSDialog.of(context).dismiss(context);
                    if (resultData?.data['data'] == null)
                      showToast(resultData?.data['msg']);
                    else {
                      GSDialog.of(context).showLoadingDialog(context, '上传视频中');
                      String sign = resultData?.data['data']['sign'];
                      txugcPublish.setVideoPublishListener(VideoPublishListener(
                        onVideoPublishProgress: (uploadBytes, totalBytes) {
                          int progress =
                              ((uploadBytes / totalBytes) * 100).toInt();
                          print(progress);
                        },
                        onVideoPublishComplete: (result) {
                          GSDialog.of(context).dismiss(context);
                          if (result.retCode == 0) {
                            GSDialog.of(context)
                                .showLoadingDialog(context, '发布中');
                            HttpManager.post(LiveAPI.pushVideo, {
                              'content': _editingController.text,
                              'fileId': result.videoId,
                              'topicId': _topicListModel == null
                                  ? 0
                                  : _topicListModel.id,
                              'goodsId': _videoGoodsModel.id,
                            }).then((resultData) {
                              GSDialog.of(context).dismiss(context);
                              Navigator.pop(context);
                            });
                          }
                          // 当 result.errCode 为 0 时即为上传成功，更多错误码请查看下方链接
                          // https://cloud.tencent.com/document/product/266/9539#.E9.94.99.E8.AF.AF.E7.A0.81
                        },
                      ));
                      txugcPublish.publishVideo(TXPublishParam(
                        signature: sign,
                        videoPath: uploadFile.path,
                        coverPath: widget.coverImageFile.path,
                      ));
                    }
                  });
                }
              },
              child: Text('发布'),
            ),
          ),
          rWBox(15),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: rSize(15)),
        children: [
          TextField(
            minLines: 5,
            maxLines: 99,
            controller: _editingController,
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
                            context, VideoPreviewPage(file: uploadFile));
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
