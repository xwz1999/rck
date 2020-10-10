import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/live_stream/live_blur_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';

class LiveStreamViewPage extends StatefulWidget {
  LiveStreamViewPage({Key key}) : super(key: key);

  @override
  _LiveStreamViewPageState createState() => _LiveStreamViewPageState();
}

class _LiveStreamViewPageState extends State<LiveStreamViewPage> {
  bool _showTools = true;
  LivePlayer _livePlayer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      _livePlayer?.pausePlay();
      CRoute.transparent(context, LiveBlurPage());
    });
  }

  @override
  void dispose() {
    _livePlayer?.stopPlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  _livePlayer
                      .startPlay('rtmp://58.200.131.2:1935/livetv/cctv1');
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
            top: _showTools ? MediaQuery.of(context).padding.top : -rSize(52),
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
                    initAttention: false,
                    onAttention: () {},
                    title: '吕贝贝',
                    subTitle: '点赞数 1235',
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
                      Expanded(
                        child: Container(
                          height: rSize(32),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(rSize(16)),
                          ),
                          child: TextField(
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
                      Image.asset(
                        R.ASSETS_LIVE_LIVE_MORE_PNG,
                        width: rSize(32),
                        height: rSize(32),
                      ),
                      SizedBox(width: rSize(10)),
                      Image.asset(
                        R.ASSETS_LIVE_LIVE_SHARE_PNG,
                        width: rSize(32),
                        height: rSize(32),
                      ),
                      SizedBox(width: rSize(10)),
                      Image.asset(
                        R.ASSETS_LIVE_LIVE_LIKE_PNG,
                        width: rSize(32),
                        height: rSize(32),
                      ),
                      SizedBox(width: rSize(10)),
                      Image.asset(
                        R.ASSETS_LIVE_LIVE_GOOD_PNG,
                        width: rSize(44),
                        height: rSize(44),
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
