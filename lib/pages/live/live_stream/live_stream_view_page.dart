import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/live_blur_page.dart';
import 'package:recook/pages/live/live_stream/live_report_view.dart';
import 'package:recook/pages/live/live_stream/live_users_view.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/live_stream/widget/live_avatar_with_dialog.dart';
import 'package:recook/pages/live/live_stream/widget/live_buying_widget.dart';
import 'package:recook/pages/live/live_stream/widget/live_chat_box.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_im_plugin/entity/group_member_entity.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/group_system_message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
import 'package:wakelock/wakelock.dart';

class LiveStreamViewPage extends StatefulWidget {
  final int id;

  LiveStreamViewPage({Key key, @required this.id}) : super(key: key);

  @override
  _LiveStreamViewPageState createState() => _LiveStreamViewPageState();
}

class _LiveStreamViewPageState extends State<LiveStreamViewPage> {
  bool _showTools = true;
  LivePlayer _livePlayer;
  LiveStreamInfoModel _streamInfoModel;
  TencentGroupTool group;
  bool isAttention;
  List<ChatObj> chatObjects = [
    ChatObj('系统消息',
        '欢迎来到直播间，瑞库客禁止未成年人进行直播，请大家共同遵守、监督。直播间内严禁出现违法违规、低俗色情、吸烟酗酒等内容，如有违规行为请及时举报。请大家注意财产安全，谨防网络诈骗。'),
  ];
  ScrollController _scrollController = ScrollController();
  TextEditingController _editingController = TextEditingController();
  LiveBaseInfoModel _liveBaseInfoModel;

  ///正在讲解的物品
  GoodsLists nowGoodList;

  ///正在讲解的窗口
  bool showDetailWindow = true;

  List<GroupMemberEntity> _groupMembers = [];

  int _praise = 0;

  GlobalKey<LiveBuyingWidgetState> _globalBuyingWidgetKey =
      GlobalKey<LiveBuyingWidgetState>();

  FocusNode _focusNode = FocusNode();

  Timer _liveTimer;
  bool _waitSignal = false;
  int _livePauseTimeStamp = 0;

  /*ALL THE FUNCTION */
  Future<bool> checkPop() async {
    return await showDialog(
      context: context,
      builder: (context) => NormalTextDialog(
        title: '确认退出直播间吗',
        content: '',
        items: ['确认'],
        deleteItem: '取消',
        type: NormalTextDialogType.delete,
        listener: (_) => Navigator.pop(context, true),
        deleteListener: () => Navigator.pop(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    // Future.delayed(Duration(seconds: 10), () {
    //   _livePlayer?.pausePlay();
    //   CRoute.transparent(context, LiveBlurPage());
    // });
    //腾讯IM登陆
    TencentIMTool.login().then((_) {
      getLiveStreamModel().then((model) {
        if (model == null)
          Navigator.pop(context);
        else {
          _streamInfoModel = model;
          _praise = model.praise;
          isAttention = _streamInfoModel.isFollow == 1;
          nowGoodList = _streamInfoModel?.goodsLists
              ?.firstWhere((element) => element.isExplain == 1, orElse: () {
            return null;
          });
          if (nowGoodList != null) showDetailWindow = true;
          setState(() {});
          HttpManager.post(LiveAPI.baseInfo, {
            'findUserId': _streamInfoModel.userId,
          }).then((resultData) {
            if (resultData?.data['data'] != null) {
              setState(() {
                _liveBaseInfoModel =
                    LiveBaseInfoModel.fromJson(resultData.data['data']);
              });
            }
          });
          TencentImPlugin.applyJoinGroup(
              groupId: model.groupId, reason: 'enterLive');
          TencentImPlugin.addListener(parseMessage);
          group = TencentGroupTool.fromId(model.groupId);
        }
      });
    });
  }

  Future<LiveStreamInfoModel> getLiveStreamModel() async {
    ResultData resultData = await HttpManager.post(
      LiveAPI.liveStreamInfo,
      {'id': widget.id},
    );
    if (resultData?.data['data'] == null)
      return null;
    else
      return LiveStreamInfoModel.fromJson(resultData.data['data']);
  }

  parseMessage(ListenerTypeEnum type, params) {
    print('ListenerTypeEnum$type');
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
              dynamic data = customParams['data'];
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
                case 'Praise':
                  int extra = customParams['data']['addPraise'];
                  // int nowPraise = customParams['data']['praise'];
                  _praise += extra;
                  setState(() {});
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
                  if (data['liveItemId'] == widget.id) {
                    _livePlayer?.stopPlay();
                    TencentImPlugin.quitGroup(
                        groupId: _streamInfoModel.groupId);
                    TencentImPlugin.logout();
                    CRoute.push(
                        context,
                        LiveBlurPage(
                          context: context,
                          praise: data['praise'],
                          look: data['look'],
                          streamModel: _streamInfoModel,
                          isFansWhenLive: isAttention,
                        ));
                  }
                  break;

                case 'Notice':
                  chatObjects.insertAll(
                      0,
                      messageEntities.map(
                        (e) => ChatObj("", data['content']),
                      ));
                  _scrollController.animateTo(
                    -50,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                  setState(() {});
                  break;
                case 'Play':
                  int holdTimeStamp = data['time'];
                  if (holdTimeStamp > _livePauseTimeStamp) {
                    setState(() {
                      _waitSignal = data['type'] == 'pause';
                    });
                  }
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
            group = TencentGroupTool.fromId(_streamInfoModel.groupId);
            setState(() {});
            _scrollController.animateTo(
              -50,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
          } else if (parseParams['tipsType'] == 'Quit') {
            group = TencentGroupTool.fromId(_streamInfoModel.groupId);
            setState(() {});
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

  reconnectToLive() {
    _liveTimer?.cancel();
    _liveTimer = Timer(Duration(milliseconds: 5000), () {
      setState(() {
        _waitSignal = true;
      });
      // _livePlayer.push
      _livePlayer.stopPlay();
      _livePlayer.startPlay(_streamInfoModel.playUrl, type: PlayType.RTMP);
    });
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _livePlayer?.stopPlay();
    _livePlayer?.dispose();
    TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
    TencentImPlugin.removeListener(parseMessage);
    TencentImPlugin.logout();
    _scrollController?.dispose();
    DPrint.printLongJson('用户退出');
    Wakelock.disable();
    super.dispose();
  }

  _buildWait() {
    return _waitSignal
        ? BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    R.ASSETS_LIVE_LIVE_ANIMAL_PNG,
                    height: rSize(107),
                    width: rSize(35),
                  ),
                  rHBox(15),
                  Text(
                    '主播暂时离开',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rSP(20),
                    ),
                  ),
                  rHBox(10),
                  Text(
                    '休息片刻，阿库陪你一起等待精彩',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: rSP(14),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => (await checkPop()) == true,
      child: Scaffold(
        body: _streamInfoModel == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // Cloud Video view
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black54,
                      child: CloudVideo(
                        onCloudVideoCreated: (controller) async {
                          _livePlayer = await LivePlayer.create();
                          await _livePlayer.setPlayerView(controller);
                          _livePlayer.startPlay(_streamInfoModel.playUrl,
                              type: PlayType.RTMP);
                          _livePlayer.setOnEventListener(
                            onWarningReconnect: () {
                              reconnectToLive();
                            },
                            onEventPlayBegin: () {
                              setState(() {
                                _waitSignal = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // waiting viewe
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: _buildWait(),
                  ),
                  //tool tap view
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        _focusNode.unfocus();
                        setState(() {
                          _showTools = !_showTools;
                        });
                      },
                    ),
                  ),
                  //头部工具栏
                  AnimatedPositioned(
                    top: _showTools
                        ? MediaQuery.of(context).padding.top
                        : -rSize(52),
                    left: 0,
                    right: 0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: rSize(15),
                        top: rSize(15),
                      ),
                      child: Row(
                        children: [
                          // LiveUserBar(
                          //   onTapAvatar: () {
                          //     // CRoute.pushReplace(
                          //     //   context,
                          //     //   UserHomePage(
                          //     //     userId: _streamInfoModel.userId,
                          //     //     initAttention: _streamInfoModel.isFollow == 1,
                          //     //   ),
                          //     // );
                          //     _focusNode.unfocus();

                          //     showLiveChild(
                          //       context,
                          //       initAttention: _streamInfoModel.isFollow == 1,
                          //       title: _streamInfoModel.nickname,
                          //       fans: _liveBaseInfoModel.fans,
                          //       follows: _liveBaseInfoModel.follows,
                          //       headImg: _liveBaseInfoModel.headImgUrl,
                          //       id: _liveBaseInfoModel.userId,
                          //     );
                          //   },
                          //   initAttention: _streamInfoModel.userId ==
                          //           UserManager.instance.user.info.id
                          //       ? true
                          //       : _streamInfoModel.isFollow == 1,
                          //   onAttention: () {
                          //     isAttention = true;
                          //     HttpManager.post(
                          //       LiveAPI.addFollow,
                          //       {
                          //         'followUserId': _streamInfoModel.userId,
                          //         'liveItemId': widget.id,
                          //       },
                          //     );
                          //   },
                          //   title: _streamInfoModel.nickname,
                          //   subTitle: '点赞数 $_praise',
                          //   avatar: _streamInfoModel.headImgUrl,
                          // ),
                          LiveAvatarWithDialog(
                              onTapAvatar: () {
                                _focusNode.unfocus();
                              },
                              initAttention: _streamInfoModel.userId ==
                                      UserManager.instance.user.info.id
                                  ? true
                                  : _streamInfoModel.isFollow == 1,
                              model: _streamInfoModel,
                              liveBaseModel: _liveBaseInfoModel,
                              liveId: widget.id,
                              praise: _praise),
                          Spacer(),
                          MorePeople(
                            onTap: () {
                              _focusNode.unfocus();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return LiveUsersView(
                                    members: _groupMembers,
                                    usersId: _groupMembers
                                        .map((e) => e.user)
                                        .toList(),
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
                          SizedBox(width: rSize(54)),
                        ],
                      ),
                    ),
                  ),
//关闭
                  Positioned(
                    top: MediaQuery.of(context).padding.top + rSize(24),
                    right: 0,
                    child: CustomImageButton(
                      padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        bool result = await checkPop();
                        if (result == true) Navigator.pop(context);
                      },
                    ),
                  ),

                  //底部工具栏
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    bottom: _showTools
                        ? 0
                        : -(rSize(15 + 44.0) +
                            MediaQuery.of(context).size.height / 3),
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: rSize(15),
                        right: rSize(15),
                        bottom: rSize(15),
                      ),
                      child: Column(
                        children: [
                          LiveBuyingWidget(key: _globalBuyingWidgetKey),
                          GestureDetector(
                            onTap: () => _focusNode.unfocus(),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: ListView.builder(
                                reverse: true,
                                controller: _scrollController,
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemBuilder: (context, index) {
                                  return LiveChatBox(
                                    sender: chatObjects[index].name,
                                    note: chatObjects[index].message,
                                    userEnter: chatObjects[index].enterUser,
                                    type: chatObjects[index].type,
                                  );
                                },
                                itemCount: chatObjects.length,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  height: rSize(32),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(rSize(16)),
                                  ),
                                  child: TextField(
                                    controller: _editingController,
                                    focusNode: _focusNode,
                                    onEditingComplete: () {
                                      if (!TextUtil.isEmpty(
                                          _editingController.text)) {
                                        TencentImPlugin.sendMessage(
                                          sessionId: _streamInfoModel.groupId,
                                          sessionType: SessionType.Group,
                                          node: TextMessageNode(
                                            content: _editingController.text,
                                          ),
                                        );
                                        chatObjects.insert(
                                            0,
                                            ChatObj(
                                              UserManager
                                                  .instance.user.info.nickname,
                                              _editingController.text,
                                            ));
                                        _scrollController.animateTo(
                                          -50,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOutCubic,
                                        );
                                        setState(() {});
                                        _editingController.clear();
                                        _focusNode.unfocus();
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
                              ),
                              SizedBox(width: rSize(24)),
                              CustomImageButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _focusNode.unfocus();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          width: rSize(200),
                                          color: Colors.black87,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    CustomImageButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          chatObjects.clear();
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: rSize(60),
                                                            height: rSize(60),
                                                            child: Icon(
                                                              Icons.clear_all,
                                                              size: rSize(30),
                                                            ),
                                                          ),
                                                          Text('清屏'),
                                                        ],
                                                      ),
                                                    ),
                                                    CustomImageButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        if (UserManager.instance
                                                            .haveLogin) {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return LiveReportView();
                                                            },
                                                          );
                                                        } else {
                                                          showToast('未登陆，请先登陆');
                                                          CRoute.pushReplace(
                                                              context,
                                                              UserPage());
                                                        }
                                                      },
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            width: rSize(60),
                                                            height: rSize(60),
                                                            child: Icon(
                                                              Icons
                                                                  .report_problem,
                                                              size: rSize(30),
                                                            ),
                                                          ),
                                                          Text('举报'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Image.asset(
                                  R.ASSETS_LIVE_LIVE_MORE_PNG,
                                  width: rSize(32),
                                  height: rSize(32),
                                ),
                              ),
                              SizedBox(width: rSize(10)),
                              CustomImageButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _focusNode.unfocus();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Material(
                                          color: Colors.black,
                                          child: Row(
                                            children: [
                                              CustomImageButton(
                                                onPressed: () {
                                                  if (UserManager
                                                      .instance.haveLogin) {
                                                    Navigator.pop(context);
                                                    ShareTool().liveShare(
                                                      context,
                                                      liveId: widget.id,
                                                      title:
                                                          '好友${_streamInfoModel.nickname}正在瑞库客直播，快来一起看看😘',
                                                      des: '',
                                                      headUrl: _streamInfoModel
                                                          .headImgUrl,
                                                    );
                                                  } else {
                                                    showToast('未登陆，请先登陆');
                                                    CRoute.pushReplace(
                                                        context, UserPage());
                                                  }
                                                },
                                                padding:
                                                    EdgeInsets.all(rSize(15)),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                        color: Colors.white,
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
                              ManyLikeButton(
                                child: Image.asset(
                                  R.ASSETS_LIVE_LIVE_LIKE_PNG,
                                  width: rSize(32),
                                  height: rSize(32),
                                ),
                                duration: Duration(milliseconds: 1000),
                                popChild: Image.asset(
                                  R.ASSETS_LIVE_LIVE_LIKE_PNG,
                                  width: rSize(32),
                                  height: rSize(32),
                                ),
                                tapCallbackOnlyOnce: false,
                                onTap: (index) {
                                  _focusNode.unfocus();
                                  if (UserManager.instance.haveLogin) {
                                    HttpManager.post(
                                      LiveAPI.liveLike,
                                      {
                                        'liveItemId': widget.id,
                                        'praise': index,
                                      },
                                    );
                                  } else {
                                    showToast('未登陆，请先登陆');
                                    CRoute.pushReplace(context, UserPage());
                                  }
                                },
                                onLongPress: (index) {
                                  HttpManager.post(
                                    LiveAPI.liveLike,
                                    {
                                      'liveItemId': widget.id,
                                      'praise': index,
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: rSize(10)),
                              CustomImageButton(
                                child: Container(
                                  width: rSize(44),
                                  height: rSize(44),
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    _streamInfoModel.goodsLists.length
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: rSP(13),
                                      height: 28 / 13,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          R.ASSETS_LIVE_LIVE_GOOD_PNG),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _focusNode.unfocus();
                                  showGoodsListDialog(
                                    context,
                                    onLive: true,
                                    id: widget.id,
                                    models: _streamInfoModel.goodsLists,
                                    player: _livePlayer,
                                    url: _streamInfoModel.playUrl,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    curve: Curves.easeInOutCubic,
                    child: nowGoodList == null
                        ? SizedBox()
                        : Stack(
                            overflow: Overflow.visible,
                            children: [
                              CustomImageButton(
                                onPressed: () {
                                  _focusNode.unfocus();
                                  nowGoodList == null
                                      ? showToast('未知错误')
                                      : showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      rSize(15)),
                                                ),
                                                color: Colors.white,
                                              ),
                                              height: rSize(480),
                                              child: InternalGoodsDetail(
                                                model: nowGoodList,
                                                liveId: widget.id,
                                              ),
                                            );
                                          },
                                        );
                                },
                                child: Container(
                                  height: rSize(155),
                                  width: rSize(110),
                                  margin: EdgeInsets.all(rSize(10)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(rSize(4)),
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '¥',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC92219),
                                                          fontSize: rSP(10),
                                                        ),
                                                      ),
                                                      Text(
                                                        nowGoodList
                                                            .discountPrice,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC92219),
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
                    right:
                        showDetailWindow ? rSize(25) : -rSize(25 + 20 + 110.0),
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              ),
      ),
    );
  }
}

class ChatObj {
  String name;
  String message;
  bool enterUser = false;
  ChatType type = ChatType.NORMAL;
  ChatObj(this.name, this.message, {this.enterUser, this.type});
}
