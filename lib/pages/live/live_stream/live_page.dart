import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/live_pick_goods_page.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
import 'package:image_picker/image_picker.dart';

class LivePage extends StatefulWidget {
  LivePage({Key key}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  LivePusher _livePusher;
  File _imageFile;
  TopicListModel _topicModel;
  TextEditingController _editingController = TextEditingController();
  List<int> pickedIds = [];
  int liveItemId = 0;
  bool _isStream = false;

  @override
  void initState() {
    super.initState();
    _editingController.text = '${UserManager.instance.user.info.nickname}正在直播';
  }

  @override
  void dispose() {
    _livePusher?.stopPush();
    _livePusher?.stopPreview();
    _editingController?.dispose();
    if (_isStream)
      HttpManager.post(LiveAPI.exitLive, {
        'liveItemId': liveItemId,
      });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: CloudVideo(
              onCloudVideoCreated: (controller) async {
                _livePusher = await LivePusher.create();
                _livePusher.startPreview(controller);
              },
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: 0,
            left: 0,
            bottom: _isStream ? -200 : rSize(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    rWBox(72),
                    MaterialButton(
                      height: rSize(68),
                      minWidth: rSize(68),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      child: _imageFile == null
                          ? Icon(Icons.camera_alt)
                          : Image.file(
                              _imageFile,
                              height: rSize(68),
                              width: rSize(68),
                              fit: BoxFit.cover,
                            ),
                      color: Colors.black.withOpacity(0.25),
                      onPressed: () {
                        ActionSheet.show(
                          context,
                          items: ['相机', '相册'],
                          listener: (index) {
                            Future<PickedFile> getImage() {
                              if (index == 0)
                                return ImagePicker()
                                    .getImage(source: ImageSource.camera);
                              if (index == 1)
                                return ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                              return null;
                            }

                            getImage().then((pickedFile) {
                              if (pickedFile != null)
                                _imageFile = File(pickedFile.path);
                              setState(() {});
                            });
                          },
                        );
                      },
                    ),
                    rWBox(15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _editingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                          rHBox(8),
                          GestureDetector(
                            child: Text(
                              _topicModel == null
                                  ? '选择话题 >'
                                  : '#${_topicModel.title}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: rSP(14),
                              ),
                            ),
                            onTap: () {
                              CRoute.push(
                                context,
                                PickTopicPage(onPick: (model) {
                                  _topicModel = model;
                                }),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    rWBox(72),
                  ],
                ),
                rHBox(28),
                MaterialButton(
                  minWidth: rSize(205),
                  height: rSize(40),
                  onPressed: () {
                    _isStream = true;
                    setState(() {});
                    // GSDialog.of(context).showLoadingDialog(context, '上传图片中');
                    // HttpManager.uploadFile(
                    //   url: CommonApi.upload,
                    //   file: _imageFile,
                    //   key: "photo",
                    // ).then((result) {
                    //   GSDialog.of(context).dismiss(context);
                    //   GSDialog.of(context)
                    //       .showLoadingDialog(context, '准备开始直播中');
                    //   HttpManager.post(LiveAPI.startLive, {
                    //     'title': _editingController.text,
                    //     'cover': result.url,
                    //     'topic': _topicModel == null ? 0 : _topicModel.id,
                    //     'goodsIds': pickedIds,
                    //   }).then((resultData) {
                    //     GSDialog.of(context).dismiss(context);
                    //     liveItemId = resultData.data['data']['liveItemId'];
                    //     _livePusher
                    //         .startPush(resultData.data['data']['pushUrl']);
                    //   });
                    // });
                  },
                  child: Text(
                    '开始直播',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rSP(18),
                    ),
                  ),
                  color: Color(0xFFDB2D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(20)),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            right: _isStream ? -100 : 0,
            top: MediaQuery.of(context).viewPadding.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildVerticalButton(R.ASSETS_LIVE_FLIP_CAM_PNG, '翻转', () {
                  _livePusher.switchCamera();
                }),
                _buildVerticalButton(R.ASSETS_LIVE_WHITE_CART_PNG, '商品', () {
                  CRoute.push(context, LivePickGoodsPage(
                    onPickGoods: (ids) {
                      pickedIds = ids;
                    },
                  ));
                }),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            right: 0,
            left: 0,
            top: _isStream ? -100 : MediaQuery.of(context).viewPadding.top,
            child: Row(
              children: [
                LiveUserBar(
                  initAttention: true,
                  onAttention: () {},
                  title: UserManager.instance.user.info.nickname,
                  avatar:
                      Api.getImgUrl(UserManager.instance.user.info.headImgUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVerticalButton(String img, String title, VoidCallback onTap) {
    return CustomImageButton(
      padding: EdgeInsets.symmetric(
        horizontal: rSize(15),
        vertical: rSize(12),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            img,
            height: rSize(24),
            width: rSize(24),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(11),
            ),
          ),
        ],
      ),
    );
  }
}
