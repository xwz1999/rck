import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/live_blur_page.dart';
import 'package:recook/pages/live/live_stream/live_pick_goods_page.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/pages/live/live_stream/live_users_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/live_stream/widget/live_chat_box.dart';
import 'package:recook/pages/live/models/live_exit_model.dart';
import 'package:recook/pages/live/models/live_resume_model.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_im_plugin/entity/group_member_entity.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/group_system_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakelock/wakelock.dart';

class LivePage extends StatefulWidget {
  final bool resumeLive;

  ///只在resumeLive 为`true`时可用
  final LiveResumeModel model;
  LivePage({Key key, this.resumeLive = false, this.model}) : super(key: key);

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
  List<ChatObj> chatObjects = [];
  ScrollController _scrollController = ScrollController();
  int nowExplain = 0;
  List<GroupMemberEntity> _groupMembers = [];

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _editingController.text = '${UserManager.instance.user.info.nickname}的直播';
  }

  @override
  void dispose() {
    PickCart.picked.clear();
    Wakelock.disable();
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
            height: MediaQuery.of(context).size.height,
            child: CloudVideo(
              onCloudVideoCreated: (controller) async {
                _livePusher = await LivePusher.create();
                _livePusher.startPreview(controller);
                if (widget.resumeLive) {
                  _isStream = true;
                  liveItemId = widget.model.liveItemId;
                  _streamInfoModel =
                      LiveStreamInfoModel.fromLiveResume(widget.model);
                  _livePusher.startPush(widget.model.pushUrl);
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
                }
              },
            ),
          ),
          AnimatedPositioned(
            left: _isStream ? -100 : rSize(15),
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            duration: Duration(milliseconds: 250),
            top: MediaQuery.of(context).viewPadding.top + rSize(15),
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
                          ? Stack(
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder:
                                      R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                  image: Api.getImgUrl(UserManager
                                      .instance.user.info.headImgUrl),
                                  height: rSize(68),
                                  width: rSize(68),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black.withOpacity(0.1),
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                              ],
                            )
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
                            Navigator.pop(context);
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
                                ImageUtils.cropImage(File(pickedFile.path))
                                    .then((file) {
                                  _imageFile = file;
                                  setState(() {});
                                });
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
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: rSP(14),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.edit),
                              suffixIconConstraints: BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
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
                    upload(String path) {
                      GSDialog.of(context)
                          .showLoadingDialog(context, '准备开始直播中');
                      HttpManager.post(LiveAPI.startLive, {
                        'title': (TextUtils.isEmpty(_editingController.text)
                            ? '${UserManager.instance.user.info.nickname}正在直播'
                            : _editingController.text),
                        'cover': path,
                        'topic': _topicModel == null ? 0 : _topicModel.id,
                        'goodsIds': pickedIds ?? [],
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
                      }).catchError((e) {
                        GSDialog.of(context).dismiss(context);
                      });
                    }

                    if (pickedIds.isEmpty) {
                      showToast('必须选择一个商品');
                    } else {
                      if (_imageFile != null) {
                        GSDialog.of(context)
                            .showLoadingDialog(context, '上传图片中');
                        HttpManager.uploadFile(
                          url: CommonApi.upload,
                          file: _imageFile,
                          key: "photo",
                        ).then((result) {
                          GSDialog.of(context).dismiss(context);
                          upload(result.url);
                        });
                      } else {
                        upload(UserManager.instance.user.info.headImgUrl);
                      }
                    }
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
                      padding: EdgeInsets.only(bottom: 50),
                      reverse: true,
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemBuilder: (context, index) {
                        return LiveChatBox(
                          sender: chatObjects[index].name,
                          note: chatObjects[index].message,
                          userEnter: chatObjects[index].enterUser,
                        );
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
                MorePeople(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return LiveUsersView(
                          members: _groupMembers,
                          usersId: _groupMembers.map((e) => e.user).toList(),
                        );
                      },
                    );
                  },
                  images:
                      _groupMembers.map((e) => e.userProfile.faceUrl).toList(),
                ),
                rWBox(10),
                CustomImageButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: NormalTextDialog(
                        title: '确认关闭直播吗',
                        content: '当前直播间还有${_groupMembers.length}人',
                        items: ['取消', '确定'],
                        listener: (index) {
                          switch (index) {
                            case 0:
                              Navigator.pop(context);
                              break;
                            case 1:
                              _stopLive();
                              Navigator.pop(context);
                              break;
                          }
                        },
                      ),
                    );
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

  _stopLive() {
    _livePusher?.stopPush();
    TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
    TencentImPlugin.removeListener(parseMessage);
    TencentImPlugin.logout();
    if (_isStream)
      HttpManager.post(LiveAPI.exitLive, {
        'liveItemId': liveItemId,
      }).then((resultData) {
        if (resultData?.data['data'] == null)
          Navigator.pop(context);
        else {
          CRoute.transparent(
              context,
              LiveBlurPage(
                context: context,
                isLive: true,
                exitModel: LiveExitModel.fromJson(resultData.data['data']),
              ));
        }
      });
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

  parseMessage(ListenerTypeEnum type, params) {
    print('ListenerTypeEnum$type');
    print(params);
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
        if (params is List<MessageEntity>) {
          List<MessageEntity> messageEntities = params;
          if (messageEntities[0].sessionType == SessionType.System) {
            if (messageEntities[0].elemList[0] is GroupSystemMessageNode) {
              String userData =
                  (messageEntities[0].elemList[0] as GroupSystemMessageNode)
                      .userData;
              Map<String, dynamic> customParams = jsonDecode(userData);
              print(customParams);
              switch (customParams['type']) {
                case 'UnExplain':
                  break;
                case 'Explain':
                  break;
                case 'LiveStop':
                  break;
                case 'Notice':
                  chatObjects.insertAll(
                      0,
                      messageEntities.map(
                        (e) => ChatObj("", customParams['content']),
                      ));
                  _scrollController.animateTo(
                    -50,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                  setState(() {});
                  break;
              }
            }
          } else {
            chatObjects.insertAll(
                0,
                messageEntities.map(
                  (e) => ChatObj(e.userInfo.nickName, e.note),
                ));
            _scrollController.animateTo(
              -50,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
            setState(() {});
          }
        }

        break;
      case ListenerTypeEnum.GroupTips:
        TencentImPlugin.getGroupMembers(groupId: _streamInfoModel.groupId)
            .then((models) {
          setState(() {
            _groupMembers = models;
          });
        });
        if (params is String) {
          dynamic parseParams = jsonDecode(params);
          if (parseParams['tipsType'] == 'Join') {
            chatObjects.insert(
              0,
              ChatObj(parseParams['opUserInfo']['nickName'], '来了',
                  enterUser: true),
            );
            _scrollController.animateTo(
              -50,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
          } else if (parseParams['tipsType'] == 'Quit') {
            //exit
          }
        }
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
