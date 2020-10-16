import 'package:chewie/chewie.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/sub_page/user_home_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:video_player/video_player.dart';

class LivePlaybackViewPage extends StatefulWidget {
  final int id;

  LivePlaybackViewPage({Key key, @required this.id}) : super(key: key);

  @override
  _LivePlaybackViewPageState createState() => _LivePlaybackViewPageState();
}

class _LivePlaybackViewPageState extends State<LivePlaybackViewPage> {
  bool _showTools = true;
  LiveStreamInfoModel _streamInfoModel;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool upload = false;
  @override
  void initState() {
    super.initState();

    getPlaybackInfoModel().then((model) {
      if (model == null) Navigator.pop(context);
      if (TextUtil.isEmpty(model.playUrl)) {
        setState(() {
          upload = true;
        });
      } else {
        setState(() {
          upload = false;
          _streamInfoModel = model;
        });
        _videoPlayerController = VideoPlayerController.network(model.playUrl);
        _videoPlayerController.initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: true,
            showControls: true,
          );

          setState(() {});
        });
      }
    });
  }

  Future<LiveStreamInfoModel> getPlaybackInfoModel() async {
    ResultData resultData = await HttpManager.post(
      LiveAPI.livePlaybackInfo,
      {'id': widget.id},
    );
    if (resultData?.data['data'] == null)
      return null;
    else
      return LiveStreamInfoModel.fromJson(resultData.data['data']);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: upload
          ? Center(
              child: Text(
                '录播上传中',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: rSP(20),
                ),
              ),
            )
          : _streamInfoModel == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: _chewieController == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Chewie(
                              controller: _chewieController,
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
                                    initAttention:
                                        _streamInfoModel.isFollow == 1,
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
                                showToast('关注成功');
                              },
                              title: _streamInfoModel.nickname,
                              subTitle: '点赞数 ${_streamInfoModel.praise}',
                              avatar: _streamInfoModel.headImgUrl,
                            ),
                            Spacer(),
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
                      bottom: _showTools ? 0 : -rSize(15 + 44.0),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomImageButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext) {
                                          return Container(
                                            width: rSize(200),
                                            height: rSize(200),
                                            color: Colors.black87,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: rSize(60),
                                                            height: rSize(60),
                                                            child: Icon(
                                                              
                                                              Icons.clear_all,
                                                              
                                                              size: rSize(30),),
                                                          ),
                                                          Text('清屏'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: rSize(60),
                                                            height: rSize(60),
                                                            child: Icon(Icons.report_problem,
                                                            size: rSize(30),),
                                                          ),
                                                          Text('举报'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    //ActionSheet.show(
                                    //context,
                                    //items: ['举报'],
                                    //listener: (index) {
                                    //Navigator.pop(context);
                                    //fake
                                    //Future.delayed(
                                    //  Duration(milliseconds: 1000), () {
                                    //GSDialog.of(context)
                                    //  .showSuccess(context, '举报成功');
                                    //});
                                    //},
                                    //);
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

                                SizedBox(width: rSize(10)),
                                Spacer(),
                                CustomImageButton(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: rSize(44),
                                    height: rSize(44),
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
                                    showGoodsListDialog(
                                      context,
                                      models: _streamInfoModel.goodsLists,
                                      onLive: false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
