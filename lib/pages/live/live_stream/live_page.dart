import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/live_pick_goods_page.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
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
  LiveStreamInfoModel _streamInfoModel;
  TencentGroupTool group;
  List<MessageEntity> chatObjects = [];
  ScrollController _scrollController = ScrollController();
  int nowExplain = 0;

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
    TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
    TencentImPlugin.removeListener(parseMessage);
    TencentImPlugin.logout();
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
                    GSDialog.of(context).showLoadingDialog(context, '上传图片中');
                    HttpManager.uploadFile(
                      url: CommonApi.upload,
                      file: _imageFile,
                      key: "photo",
                    ).then((result) {
                      GSDialog.of(context).dismiss(context);
                      GSDialog.of(context)
                          .showLoadingDialog(context, '准备开始直播中');
                      HttpManager.post(LiveAPI.startLive, {
                        'title': _editingController.text,
                        'cover': result.url,
                        'topic': _topicModel == null ? 0 : _topicModel.id,
                        'goodsIds': pickedIds,
                      }).then((resultData) {
                        GSDialog.of(context).dismiss(context);
                        liveItemId = resultData.data['data']['liveItemId'];
                        _livePusher
                            .startPush(resultData.data['data']['pushUrl']);
                        _isStream = true;
                        setState(() {});
                        TencentIMTool.login().then((_) {
                          DPrint.printLongJson('用户登陆');
                          getLiveStreamModel(liveItemId).then((model) {
                            if (model == null)
                              Navigator.pop(context);
                            else {
                              setState(() {
                                _streamInfoModel = model;
                              });
                              TencentImPlugin.applyJoinGroup(
                                  groupId: model.groupId, reason: 'enterLive');
                              TencentImPlugin.addListener(parseMessage);
                              group = TencentGroupTool.fromId(model.groupId);
                            }
                          });
                        });
                      });
                    });
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
            bottom: _isStream ? 0 : -300,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    height: 300,
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildChatBox(
                            chatObjects[index].sender, chatObjects[index].note);
                      },
                      itemCount: chatObjects.length,
                    ),
                  ),
                ),
                CustomImageButton(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: rSize(44),
                    height: rSize(44),
                    child: Text(
                      _streamInfoModel == null
                          ? ''
                          : _streamInfoModel.goodsLists.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: rSP(13),
                        height: 28 / 13,
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(R.ASSETS_LIVE_LIVE_GOOD_PNG),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showGoodsListDialog(
                      context,
                      models: _streamInfoModel.goodsLists,
                      onExplain: (index) {
                        setState(() {
                          nowExplain = index;
                        });
                      },
                      initExplain: nowExplain,
                      id: _streamInfoModel.id,
                      isLive: true,
                    );
                  },
                ),
              ],
            ),
            duration: Duration(milliseconds: 250),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            right: _isStream ? -100 : 0,
            top: MediaQuery.of(context).viewPadding.top + rSize(15),
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
            right: rSize(15),
            left: rSize(15),
            top: _isStream
                ? (MediaQuery.of(context).viewPadding.top + rSize(15))
                : -100,
            child: Row(
              children: [
                LiveUserBar(
                  initAttention: true,
                  onAttention: () {},
                  title: UserManager.instance.user.info.nickname,
                  avatar:
                      Api.getImgUrl(UserManager.instance.user.info.headImgUrl),
                ),
                Spacer(),
                CustomImageButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    R.ASSETS_LIVE_SHUTDOWN_PNG,
                    height: rSize(21),
                    width: rSize(21),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<LiveStreamInfoModel> getLiveStreamModel(int id) async {
    ResultData resultData = await HttpManager.post(
      LiveAPI.liveStreamInfo,
      {'id': id},
    );
    if (resultData?.data['data'] == null)
      return null;
    else
      return LiveStreamInfoModel.fromJson(resultData.data['data']);
  }

  _buildChatBox(String sender, String note) {
    final Color color = Color.fromRGBO(
      180 + Random().nextInt(55),
      180 + Random().nextInt(55),
      180 + Random().nextInt(55),
      1,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: '$sender:',
              style: TextStyle(
                color: color,
                fontSize: rSP(13),
              ),
            ),
            TextSpan(
              text: note,
              style: TextStyle(
                color: Colors.white,
                fontSize: rSP(13),
              ),
            ),
          ]),
          maxLines: 5,
        ),
        margin: EdgeInsets.symmetric(vertical: rSize(5 / 2)),
        padding: EdgeInsets.symmetric(
          horizontal: rSize(10),
          vertical: rSize(4),
        ),
        constraints: BoxConstraints(
          maxWidth: rSize(200),
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(rSize(16)),
        ),
      ),
    );
  }

  parseMessage(ListenerTypeEnum type, params) {
    print('ListenerTypeEnum$type');
    switch (type) {
      case ListenerTypeEnum.ForceOffline:
        break;
      case ListenerTypeEnum.UserSigExpired:
        break;
      case ListenerTypeEnum.Connected:
        break;
      case ListenerTypeEnum.Disconnected:
        break;
      case ListenerTypeEnum.WifiNeedAuth:
        break;
      case ListenerTypeEnum.Refresh:
        break;
      case ListenerTypeEnum.RefreshConversation:
        break;
      case ListenerTypeEnum.MessageRevoked:
        break;
      case ListenerTypeEnum.NewMessages:
        chatObjects.insertAll(0, params);
        _scrollController.animateTo(
          -50,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        );
        setState(() {});
        break;
      case ListenerTypeEnum.GroupTips:
        break;
      case ListenerTypeEnum.RecvReceipt:
        break;
      case ListenerTypeEnum.ReConnFailed:
        break;
      case ListenerTypeEnum.ConnFailed:
        break;
      case ListenerTypeEnum.Connecting:
        break;
      case ListenerTypeEnum.UploadProgress:
        break;
      case ListenerTypeEnum.DownloadProgress:
        break;
    }
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
