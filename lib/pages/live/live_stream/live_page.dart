import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:tencent_im_plugin/entity/group_member_entity.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/group_system_message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
import 'package:wakelock/wakelock.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/functions/live_function.dart';
import 'package:recook/pages/live/live_stream/live_blur_page.dart';
import 'package:recook/pages/live/live_stream/live_pick_goods_page.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/pages/live/live_stream/live_users_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/live_stream/widget/live_buying_widget.dart';
import 'package:recook/pages/live/live_stream/widget/live_chat_box.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/models/live_exit_model.dart';
import 'package:recook/pages/live/models/live_resume_model.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart' as LSI;
import 'package:recook/pages/live/models/topic_list_model.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/video/pick_topic_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LivePage extends StatefulWidget {
  final bool resumeLive;

  ///只在resumeLive 为`true`时可用
  final LiveResumeModel model;
  LivePage({Key key, this.resumeLive = false, this.model}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with WidgetsBindingObserver {
  LivePusher _livePusher;
  File _imageFile;
  TopicListModel _topicModel;
  TextEditingController _editingController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  List<num> pickedIds = [];
  int liveItemId = 0;
  bool _isStream = false;
  LSI.LiveStreamInfoModel _streamInfoModel;
  TencentGroupTool group;
  List<ChatObj> chatObjects = [];
  ScrollController _scrollController = ScrollController();
  int nowExplain = 0;
  List<GroupMemberEntity> _groupMembers = [];
  int _praise = 0;
  LiveBaseInfoModel _liveBaseInfoModel;

  GlobalKey<LiveBuyingWidgetState> _globalBuyingWidgetKey =
      GlobalKey<LiveBuyingWidgetState>();

  FocusNode _focusNode = FocusNode();
  FocusNode _focusNodeB = FocusNode();

  ///正在讲解的物品
  LSI.GoodsLists nowGoodList;

  ///正在讲解的窗口
  bool showDetailWindow = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      precacheImage(AssetImage(R.ASSETS_LIVE_LIVE_ANIMAL_PNG), context);
    });
    WidgetsBinding.instance.addObserver(this);
    Wakelock.enable();

    _editingController.text = '${UserManager.instance.user.info.nickname}的直播';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isStream)
      switch (state) {
        case AppLifecycleState.inactive:
          _livePusher.pausePush();

          break;
        case AppLifecycleState.resumed:
          _livePusher.resumePush();
          break;
        case AppLifecycleState.paused:
          _livePusher.pausePush();
          break;
        case AppLifecycleState.detached:
          print('detached');
          break;
      }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PickCart.picked.clear();
    Wakelock.disable();
    _livePusher?.stopPush();
    _livePusher?.stopPreview();
    _editingController?.dispose();
    if (_streamInfoModel != null) {
      TencentImPlugin.quitGroup(groupId: _streamInfoModel?.groupId ?? '');
      TencentImPlugin.removeListener(parseMessage);
      TencentImPlugin.logout();
    }
    if (_isStream)
      HttpManager.post(LiveAPI.exitLive, {
        'liveItemId': liveItemId,
      });
    super.dispose();
  }

  Future<bool> checkPop() async {
    return await showDialog(
      context: context,
      builder: (context) => NormalTextDialog(
        title: '确认停止直播间吗',
        content: '',
        deleteItem: '确认',
        items: ['取消'],
        type: NormalTextDialogType.delete,
        listener: (_) => Navigator.pop(context),
        deleteListener: () => Navigator.pop(context, true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
                  _livePusher.setPauseConfig(
                    300,
                    5,
                    AssetImage(R.ASSETS_LIVE_LIVE_HOLD_PLACEHOLDER_PNG),
                    ImageConfiguration(),
                  );
                  _livePusher.setOnEventListener(
                    onWaringNetBusy: () {
                      print('');
                    },
                    onWaringReconnect: () {
                      print('');
                    },
                    onWaringHardwareAccelerationFail: () {
                      print('');
                    },
                    onWaringDNSFail: () {
                      print('');
                    },
                    onWaringServerConnFail: () {
                      print('');
                    },
                    onWaringShakeFail: () {
                      print('');
                    },
                    onWaringServerDisconnect: () {
                      print('');
                    },
                    onEventConnectSucc: () {
                      print('');
                    },
                    onEventPushBegin: () {
                      print('');
                    },
                    onEventOpenCameraSuccess: () {
                      print('');
                    },
                    onErrorOpenCameraFail: () {
                      showToast('相机打开失败');
                    },
                    onErrorOpenMicFail: () {
                      print('');
                    },
                    onErrorVideoEncodeFail: () {
                      print('');
                    },
                    onErrorAudioEncodeFail: () {
                      print('');
                    },
                    onErrorUnsupportedResolution: () {
                      print('');
                    },
                    onErrorUnsupportedSampleRate: () {
                      print('');
                    },
                    onErrorNetDisconnect: () {
                      print('');
                    },
                  );
                  _livePusher.setBeautyFilter(
                    BeautyFilter.NATURE,
                    whiteningLevel: 6,
                    beautyLevel: 6,
                    ruddyLevel: 6,
                  );
                  if (widget.resumeLive) {
                    _isStream = true;
                    liveItemId = widget.model.liveItemId;
                    _streamInfoModel =
                        LSI.LiveStreamInfoModel.fromLiveResume(widget.model);
                    HttpManager.post(LiveAPI.baseInfo, {
                      'findUserId': _streamInfoModel.userId,
                    }).then((resultData) {
                      if (resultData?.data['data'] != null) {
                        _liveBaseInfoModel =
                            LiveBaseInfoModel.fromJson(resultData.data['data']);
                      }
                    });
                    _livePusher.startPush(widget.model.pushUrl);
                    _praise = _streamInfoModel.praise;
                    setState(() {});
                    TencentIMTool.login().then((_) {
                      DPrint.printLongJson('用户登陆');
                      getLiveStreamModel(liveItemId).then((model) {
                        if (model == null)
                          Navigator.pop(context);
                        else {
                          HttpManager.post(LiveAPI.baseInfo, {
                            'findUserId': _streamInfoModel.userId,
                          }).then((resultData) {
                            if (resultData?.data['data'] != null) {
                              _liveBaseInfoModel = LiveBaseInfoModel.fromJson(
                                  resultData.data['data']);
                            }
                          });
                          setState(() {
                            _streamInfoModel = model;
                            HttpManager.post(LiveAPI.baseInfo, {
                              'findUserId': _streamInfoModel.userId,
                            }).then((resultData) {
                              if (resultData?.data['data'] != null) {
                                _liveBaseInfoModel = LiveBaseInfoModel.fromJson(
                                    resultData.data['data']);
                              }
                            });
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
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                child: Container(color: Colors.transparent),
                onTap: () {
                  _focusNode.unfocus();
                  _focusNodeB.unfocus();
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
                              Future<File> getImage() {
                                if (index == 0)
                                  return ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                if (index == 1)
                                  return ImagePicker.pickImage(
                                      source: ImageSource.gallery);
                                return null;
                              }

                              getImage().then((file) {
                                if (file != null)
                                  ImageUtils.cropImage(file).then((file) {
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
                              focusNode: _focusNodeB,
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
                                _focusNodeB.unfocus();
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
                      _focusNodeB.unfocus();
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
                                  HttpManager.post(LiveAPI.baseInfo, {
                                    'findUserId': _streamInfoModel.userId,
                                  }).then((resultData) {
                                    if (resultData?.data['data'] != null) {
                                      _liveBaseInfoModel =
                                          LiveBaseInfoModel.fromJson(
                                              resultData.data['data']);
                                    }
                                  });
                                  _praise = model.praise;
                                });
                                TencentImPlugin.applyJoinGroup(
                                    groupId: model.groupId,
                                    reason: 'enterLive');
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
              bottom: _isStream ? rSize(15) : -300,
              left: rSize(15),
              right: rSize(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LiveBuyingWidget(key: _globalBuyingWidgetKey),
                        GestureDetector(
                          onTap: () {
                            _focusNode.unfocus();
                          },
                          child: Container(
                            height: 300,
                            child: ListView.builder(
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
                        Container(
                          height: rSize(32),
                          width: rSize(150),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(rSize(16)),
                          ),
                          child: TextField(
                            controller: _messageController,
                            focusNode: _focusNode,
                            onEditingComplete: () {
                              if (!TextUtil.isEmpty(_messageController.text)) {
                                TencentImPlugin.sendMessage(
                                  sessionId: _streamInfoModel.groupId,
                                  sessionType: SessionType.Group,
                                  node: TextMessageNode(
                                      content: _messageController.text),
                                );
                                chatObjects.insert(
                                    0,
                                    ChatObj(
                                      UserManager.instance.user.info.nickname,
                                      _messageController.text,
                                    ));
                                _scrollController.animateTo(
                                  -50,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                );
                                setState(() {});
                                _messageController.clear();
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '说点什么吧…',
                              hintStyle: TextStyle(
                                fontSize: rSP(12),
                                color: Colors.white,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: rSize(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomImageButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _focusNode.unfocus();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Material(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  CustomImageButton(
                                    onPressed: () {
                                      if (UserManager.instance.haveLogin) {
                                        Navigator.pop(context);
                                        // ShareTool().liveShare(
                                        //   context,
                                        //   liveId: liveItemId,
                                        //   title:
                                        //       '好友${_streamInfoModel.nickname}正在瑞库客直播，快来一起看看😘',
                                        //   des: '让消费服务生活，让生活充满精致',
                                        //   headUrl: _streamInfoModel.headImgUrl,
                                        // );
                                        WeChatUtils.miniProgramShareLive(
                                          id: liveItemId,netWorkThumbnail: Api.getImgUrl(_streamInfoModel.headImgUrl),
                                          des: '好友${_streamInfoModel.nickname}正在瑞库客直播，快来一起看看😘'
                                        );
                                      } else {
                                        showToast('未登陆，请先登陆');
                                        CRoute.push(context, UserPage());
                                      }
                                    },
                                    padding: EdgeInsets.all(rSize(15)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          R.ASSETS_SHARE_BOTTOM_SHARE_BOTTOM_WECHAT_PNG,
                                          height: rSize(40),
                                          width: rSize(40),
                                        ),
                                        rHBox(10),
                                        Text(
                                          '微信分享',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: rSP(14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomImageButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ShareTool().clipBoard(liveId: liveItemId);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          ShareToolIcon.copyurl,
                                          width: rSize(40),
                                          height: rSize(40),
                                        ),
                                        Text(
                                          '复制链接',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: rSP(14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Image.asset(
                      R.ASSETS_LIVE_LIVE_SHARE_PNG,
                      width: rSize(32),
                      height: rSize(32),
                    ),
                  ),
                  SizedBox(width: rSize(10)),
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
                      _focusNode.unfocus();
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
              right: _isStream ? -100 : 10,
              top: MediaQuery.of(context).viewPadding.top + rSize(15),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildVerticalButton(R.ASSETS_LIVE_FLIP_CAM_PNG, '翻转',
                          () {
                        _livePusher.switchCamera();
                      }),
                      _buildVerticalButton(R.ASSETS_LIVE_WHITE_CART_PNG, '商品',
                          () {
                        CRoute.push(context, LivePickGoodsPage(
                          onPickGoods: (ids) {
                            pickedIds = ids;
                          },
                        ));
                      }),
                      // _buildVerticalButton(R.ASSETS_LIVE_ALL_SHARE_PNG, '分享', () {
                      //   showModalBottomSheet(
                      //       context: context,
                      //       builder: (context) {
                      //         return Material(
                      //           color: Colors.black,
                      //           child: Row(
                      //             children: [
                      //               CustomImageButton(
                      //                 onPressed: () {
                      //                   if (UserManager.instance.haveLogin) {
                      //                     Navigator.pop(context);
                      //                     ShareTool().liveShare(
                      //                       context,
                      //                       liveId: liveItemId,
                      //                       title:
                      //                           '好友${_streamInfoModel.nickname}正在瑞库客直播，快来一起看看😘',
                      //                       des: '',
                      //                       headUrl: _streamInfoModel.headImgUrl,
                      //                     );
                      //                   } else {
                      //                     showToast('未登陆，请先登陆');
                      //                     CRoute.push(context, UserPage());
                      //                   }
                      //                 },
                      //                 padding: EdgeInsets.all(rSize(15)),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Image.asset(
                      //                       R.ASSETS_SHARE_BOTTOM_SHARE_BOTTOM_WECHAT_PNG,
                      //                       height: rSize(40),
                      //                       width: rSize(40),
                      //                     ),
                      //                     rHBox(10),
                      //                     Text(
                      //                       '微信分享',
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontSize: rSP(14),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       });
                      // }),
                    ],
                  ),
                ),
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
                    subTitle: '点赞数$_praise',
                    onTapAvatar: () {
                      _focusNode.unfocus();
                      HttpManager.post(LiveAPI.baseInfo, {
                        'findUserId': _streamInfoModel.userId,
                      }).then((resultData) {
                        if (resultData?.data['data'] != null) {
                          _liveBaseInfoModel = LiveBaseInfoModel.fromJson(
                              resultData.data['data']);
                        }
                        showLiveChild(
                          context,
                          initAttention: true,
                          title: _streamInfoModel.nickname,
                          fans: _liveBaseInfoModel.fans,
                          follows: _liveBaseInfoModel.follows,
                          headImg: _liveBaseInfoModel.headImgUrl,
                          id: _liveBaseInfoModel.userId,
                        );
                      });
                    },
                    avatar: Api.getImgUrl(
                        UserManager.instance.user.info.headImgUrl),
                  ),
                  Spacer(),
                  MorePeople(
                    onTap: () {
                      _focusNode.unfocus();
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
                    images: (_groupMembers
                          ..removeWhere((element) {
                            return element.userProfile.nickName ==
                                _streamInfoModel.nickname;
                          }))
                        .map((e) => e.userProfile.faceUrl)
                        .toList(),
                  ),
                  rWBox(10),
                  CustomImageButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      showDialog(
                        context: context,
                        builder: (context) => NormalTextDialog(
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
            AnimatedPositioned(
              curve: Curves.easeInOutCubic,
              child: nowGoodList == null
                  ? SizedBox()
                  : Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          height: rSize(155),
                          width: rSize(110),
                          margin: EdgeInsets.all(rSize(10)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(rSize(4)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: rSize(110),
                                height: rSize(24),
                                alignment: Alignment.center,
                                child: Text(
                                  '宝贝正在讲解中',
                                  style: TextStyle(
                                    color: Color(0xFF0091FF),
                                    fontSize: rSP(11),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFDEF0FA),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(rSize(4)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(rSize(5)),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: R
                                              .ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                          image: Api.getImgUrl(
                                            nowGoodList.mainPhotoUrl,
                                          ),
                                        ),
                                        color: AppColor.frenchColor,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                '¥',
                                                style: TextStyle(
                                                  color: Color(0xFFC92219),
                                                  fontSize: rSP(10),
                                                ),
                                              ),
                                              Text(
                                                nowGoodList.discountPrice,
                                                style: TextStyle(
                                                  color: Color(0xFFC92219),
                                                  fontSize: rSP(14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CustomImageButton(
                            onPressed: () {
                              _focusNode.unfocus();
                              setState(() {
                                showDetailWindow = false;
                              });
                            },
                            child: Image.asset(
                              R.ASSETS_LIVE_DETAIL_CLOSE_PNG,
                              height: rSize(20),
                              width: rSize(20),
                            ),
                          ),
                        ),
                      ],
                    ),
              bottom: rSize(67),
              right: showDetailWindow ? rSize(25) : -rSize(25 + 20 + 110.0),
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        bool result = (await checkPop()) == true;
        if (result) {
          _stopLive();
          return true;
        }
        return false;
      },
    );
  }

  _stopLive() async {
    _livePusher?.stopPush();
    if (_streamInfoModel != null) {
      try {
        await TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
      } catch (e) {
        print(e);
      }
      TencentImPlugin.removeListener(parseMessage);
      try {
        await TencentImPlugin.logout();
      } catch (e) {
        print(e);
      }
    }
    if (_isStream)
      await HttpManager.post(LiveAPI.exitLive, {
        'liveItemId': liveItemId,
      }).then((resultData) {
        if (resultData?.data['data'] == null) {
          showToast('直播开启失败');
          Navigator.pop(context);
        } else {
          CRoute.pushReplace(
              context,
              LiveBlurPage(
                context: context,
                isLive: true,
                exitModel: LiveExitModel.fromJson(resultData.data['data']),
                streamModel: _streamInfoModel,
              ));
        }
      });
  }

  Future<LSI.LiveStreamInfoModel> getLiveStreamModel(int id) async {
    ResultData resultData = await HttpManager.post(
      LiveAPI.liveStreamInfo,
      {'id': id},
    );
    if (resultData?.data['data'] == null)
      return null;
    else
      return LSI.LiveStreamInfoModel.fromJson(resultData.data['data']);
  }

  parseMessage(ListenerTypeEnum type, params) {
    print('ListenerTypeEnum$type');
    print(params);
    switch (type) {
      case ListenerTypeEnum.ForceOffline:
        break;
      case ListenerTypeEnum.UserSigExpired:
        TencentIMTool.login();
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
                case 'BuyGoods':
                  _globalBuyingWidgetKey.currentState
                      .updateChild(customParams['data']['content']);
                  break;
                case 'UnExplain':
                  setState(() {
                    showDetailWindow = false;
                  });
                  break;
                case 'Explain':
                  int goodsId = customParams['data']['goodsId'];
                  nowGoodList = _streamInfoModel.goodsLists.where((element) {
                    return element.id == goodsId;
                  }).first;
                  setState(() {
                    showDetailWindow = true;
                  });
                  break;
                case 'LiveStop':
                  break;
                case 'Praise':
                  int extra = customParams['data']['addPraise'];
                  // int nowPraise = customParams['data']['praise'];
                  _praise += extra;
                  setState(() {});
                  break;
                case 'Notice':
                  chatObjects.insertAll(
                      0,
                      messageEntities.map(
                        (e) => ChatObj("", customParams['data']['content']),
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
