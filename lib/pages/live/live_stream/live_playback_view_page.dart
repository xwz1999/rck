import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/show_goods_list.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class LivePlaybackViewPage extends StatefulWidget {
  final int id;

  LivePlaybackViewPage({Key key, @required this.id}) : super(key: key);

  @override
  _LivePlaybackViewPageState createState() => _LivePlaybackViewPageState();
}

class _LivePlaybackViewPageState extends State<LivePlaybackViewPage> {
  bool _showTools = true;
  LiveStreamInfoModel _streamInfoModel;

  @override
  void initState() {
    super.initState();

    getPlaybackInfoModel().then((model) {
      if (model == null)
        Navigator.pop(context);
      else
        setState(() {
          _streamInfoModel = model;
        });
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

  parseMessage(ListenerTypeEnum type, dynamic params) {
    print(type.toString());
  }

  @override
  void dispose() {
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
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black54,
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
                            SizedBox(width: rSize(10)),
                            Image.asset(
                              R.ASSETS_LIVE_LIVE_SHARE_PNG,
                              width: rSize(32),
                              height: rSize(32),
                            ),
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
                            ),
                            SizedBox(width: rSize(10)),
                            Spacer(),
                            CustomImageButton(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                width: rSize(44),
                                height: rSize(44),
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
}
