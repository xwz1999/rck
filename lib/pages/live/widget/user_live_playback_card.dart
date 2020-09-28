import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/widget/user_base_card.dart';

class UserPlaybackCard extends StatefulWidget {
  UserPlaybackCard({Key key}) : super(key: key);

  @override
  _UserPlaybackCardState createState() => _UserPlaybackCardState();
}

class _UserPlaybackCardState extends State<UserPlaybackCard> {
  @override
  Widget build(BuildContext context) {
    return UserBaseCard(
      date: '今天',
      detailDate: '14:30',
      children: [
        SizedBox(height: rSize(35)),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: rSize(5)),
              decoration: BoxDecoration(
                color: Color(0xFF050505).withOpacity(0.18),
                borderRadius: BorderRadius.circular(rSize(2)),
              ),
              height: rSize(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(R.ASSETS_LIVE_ON_STREAM_PNG),
                  SizedBox(width: rSize(5)),
                  Text(
                    '正在直播中',
                    style: TextStyle(
                      fontSize: rSP(12),
                      height: 1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: rSize(5)),
          child: Text(
            '一波清仓大福利来袭，请速速收下',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '999人观看 ｜ 24个宝贝',
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: rSP(12),
          ),
        ),
        SizedBox(
          height: rSize(15),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                R.ASSETS_LIVE_VIDEO_PLAY_PNG,
                height: rSize(34),
                width: rSize(34),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rSize(4)),
                color: Colors.blue,
              ),
              height: rSize(234),
              width: rSize(234),
            )
          ],
        ),
      ],
    );
  }
}
