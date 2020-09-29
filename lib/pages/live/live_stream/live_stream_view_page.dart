import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/widget/more_people.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LiveStreamViewPage extends StatefulWidget {
  LiveStreamViewPage({Key key}) : super(key: key);

  @override
  _LiveStreamViewPageState createState() => _LiveStreamViewPageState();
}

class _LiveStreamViewPageState extends State<LiveStreamViewPage> {
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
              child: Placeholder(),
            ),
          ),
          //头部工具栏
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(
                left: rSize(15),
                top: rSize(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(rSize(5)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(rSize(18)),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: rSize(16),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: rSize(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '吕贝贝',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: rSP(12),
                                ),
                              ),
                              Text(
                                '点赞数 10101',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: rSP(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: rSize(56),
                          height: rSize(26),
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(rSize(13)),
                            ),
                            child: Text(
                              '+ 关注',
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: rSP(12),
                                height: 1,
                              ),
                            ),
                            onPressed: () {},
                            color: Color(0xFFDB2D2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  MorePeople(),
                  CustomImageButton(
                    padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          //底部工具栏
          Positioned(
            bottom: 0,
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
                              contentPadding: EdgeInsets.symmetric(),
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
