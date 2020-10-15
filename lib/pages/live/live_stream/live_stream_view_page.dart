import 'dart:math';

import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/tencent_im/tencent_im_tool.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/entity/session_entity.dart';
import 'package:tencent_im_plugin/message_node/group_system_message_node.dart';
import 'package:tencent_im_plugin/message_node/text_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';

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

  @override
  void initState() {
    super.initState();
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
                          initAttention: _streamInfoModel.isFollow == 1,
                          onAttention: () {},
                          title: _streamInfoModel.nickname,
                          subTitle: '点赞数 ${_streamInfoModel.praise}',
                          avatar: _streamInfoModel.headImgUrl,
                        ),
                        Spacer(),
                        MorePeople(),
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
                              child: Image.asset(
                                R.ASSETS_LIVE_LIVE_MORE_PNG,
                                width: rSize(32),
                                height: rSize(32),
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
                              onTap: () {
                                HttpManager.post(
                                  LiveAPI.liveLike,
                                  {'liveItemId': widget.id},
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
