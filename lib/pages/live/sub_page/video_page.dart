import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recook/const/resource.dart';
import 'package:recook/constants/constants.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return WaterfallFlow.builder(
      padding: EdgeInsets.all(rSize(15)),
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: rSize(15),
        mainAxisSpacing: rSize(15),
      ),
      itemBuilder: (context, index) {
        //TODO: TEST ONLY
        final randomHeight = 50 + Random().nextDouble() * 150;
        return ClipRRect(
          borderRadius: BorderRadius.circular(rSize(10)),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: randomHeight,
                  child: Placeholder(),
                ),
                Container(
                  padding: EdgeInsets.all(rSize(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '更有3档风速可调，风大风小随你掌控更有3档风速可调，风大风小随你掌控',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                          fontSize: rSP(13),
                        ),
                      ),
                      SizedBox(height: rSize(6)),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: rSize(9),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: rSize(4),
                              ),
                              child: Text(
                                'NAME NAME NAME',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: rSP(12),
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            R.ASSETS_LIVE_FAVORITE_BLACK_PNG,
                            height: rSize(14),
                            width: rSize(14),
                          ),
                          SizedBox(width: rSize(2)),
                          Text(
                            '${Random().nextInt(100)}',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: rSP(12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
