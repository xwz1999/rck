import 'dart:math';
import 'dart:convert';

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
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/sub_page/user_home_page.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/utils/custom_route.dart';
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
  List<MessageEntity> chatObjects = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _editingController = TextEditingController();

  ///正在讲解的物品
  GoodsLists nowGoodList;

  ///正在讲解的窗口
  bool showDetailWindow = true;

  List<GroupMemberEntity> _groupMembers = [];

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
      DPrint.printLongJson('用户登陆');
      getLiveStreamModel().then((model) {
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
                  showToastWidget(
                    Container(
                      margin: EdgeInsets.all(rSize(15)),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: rSize(10)),
                      height: rSize(26),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4BC22),
                        borderRadius: BorderRadius.circular(rSize(13)),
                      ),
                      child: Text(
                        '${customParams['data']['content']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(13),
                        ),
                      ),
                    ),
                    position: ToastPosition.top,
                  );
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
                  _livePlayer?.stopPlay();
                  TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
                  TencentImPlugin.logout();
                  CRoute.push(
                      context,
                      LiveBlurPage(
                        context: context,
                        praise: data['praise'],
                        look: data['look'],
                        streamModel: _streamInfoModel,
                      ));
                  break;
              }
            }
          } else {
            chatObjects.insertAll(0, messageEntities);
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
            showToastWidget(
              Container(
                margin: EdgeInsets.all(rSize(15)),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: rSize(10)),
                height: rSize(26),
                decoration: BoxDecoration(
                  color: Color(0xFFDC5353),
                  borderRadius: BorderRadius.circular(rSize(13)),
                ),
                child: Text(
                  '${parseParams['opUser']}来了',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(13),
                  ),
                ),
              ),
              position: ToastPosition.top,
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

  @override
  void dispose() {
    _livePlayer?.stopPlay();
    TencentImPlugin.quitGroup(groupId: _streamInfoModel.groupId);
    TencentImPlugin.removeListener(parseMessage);
    TencentImPlugin.logout();
    _scrollController?.dispose();
    DPrint.printLongJson('用户退出');
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _streamInfoModel == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
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
                        _livePlayer.startPlay(_streamInfoModel.playUrl);
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
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
                        LiveUserBar(
                          onTapAvatar: () {
                            CRoute.pushReplace(
                              context,
                              UserHomePage(
                                userId: _streamInfoModel.userId,
                                initAttention: _streamInfoModel.isFollow == 1,
                              ),
                            );
                          },
                          initAttention: _streamInfoModel.userId ==
                                  UserManager.instance.user.info.id
                              ? true
                              : _streamInfoModel.isFollow == 1,
                          onAttention: () {
                            HttpManager.post(
                              LiveAPI.addFollow,
                              {'followUserId': _streamInfoModel.userId},
                            );
                          },
                          title: _streamInfoModel.nickname,
                          subTitle: '点赞数 ${_streamInfoModel.praise}',
                          avatar: _streamInfoModel.headImgUrl,
                        ),
                        Spacer(),
                        MorePeople(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return LiveUsersView(
                                  avatars: _groupMembers.map((e) => e.userProfile.faceUrl).toList(),
                                  usersId:
                                      _groupMembers.map((e) => e.user).toList(),
                                );
                              },
                            );
                          },
                          images: _groupMembers
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
                    onPressed: () => Navigator.pop(context),
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
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return _buildChatBox(chatObjects[index].sender,
                                  chatObjects[index].note);
                            },
                            itemCount: chatObjects.length,
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
                                  onEditingComplete: () {
                                    TencentImPlugin.sendMessage(
                                      sessionId: _streamInfoModel.groupId,
                                      sessionType: SessionType.Group,
                                      node: TextMessageNode(
                                          content: _editingController.text),
                                    );
                                    chatObjects.insert(
                                      0,
                                      MessageEntity(
                                        note: _editingController.text,
                                        sender: UserManager
                                            .instance.user.info.nickname,
                                      ),
                                    );
                                    _scrollController.animateTo(
                                      -50,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOutCubic,
                                    );
                                    setState(() {});
                                    _editingController.clear();
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
                                ActionSheet.show(
                                  context,
                                  items: ['举报'],
                                  listener: (index) {
                                    Navigator.pop(context);
                                    //fake
                                    Future.delayed(Duration(milliseconds: 1000),
                                        () {
                                      GSDialog.of(context)
                                          .showSuccess(context, '举报成功');
                                    });
                                  },
                                );
                              },
                              child: CustomImageButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
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
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return LiveReportView();
                                                          },
                                                        );
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
                            ),
                            // SizedBox(width: rSize(10)),
                            // Image.asset(
                            //   R.ASSETS_LIVE_LIVE_SHARE_PNG,
                            //   width: rSize(32),
                            //   height: rSize(32),
                            // ),
                            SizedBox(width: rSize(10)),
                            ManyLikeButton(
                              child: Image.asset(
                                R.ASSETS_LIVE_LIVE_LIKE_PNG,
                                width: rSize(32),
                                height: rSize(32),
                              ),
                              popChild: Image.asset(
                                R.ASSETS_LIVE_LIVE_LIKE_PNG,
                                width: rSize(32),
                                height: rSize(32),
                              ),
                              tapCallbackOnlyOnce: false,
                              onTap: (index) {
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
                                  _streamInfoModel.goodsLists.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: rSP(13),
                                    height: 28 / 13,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(R.ASSETS_LIVE_LIVE_GOOD_PNG),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showGoodsListDialog(
                                  context,
                                  onLive: true,
                                  id: widget.id,
                                  models: _streamInfoModel.goodsLists,
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
                                nowGoodList == null
                                    ? showToast('未知错误')
                                    : showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(rSize(15)),
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
                                                        color:
                                                            Color(0xFFC92219),
                                                        fontSize: rSP(10),
                                                      ),
                                                    ),
                                                    Text(
                                                      nowGoodList.discountPrice,
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
    );
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
}

class ChatObj {
  String name;
  String message;
  ChatObj(this.name, this.message);
}
