import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/recook_back_button.dart';

class LiveBlurPage extends StatefulWidget {
  LiveBlurPage({Key key}) : super(key: key);

  @override
  _LiveBlurPageState createState() => _LiveBlurPageState();
}

class _LiveBlurPageState extends State<LiveBlurPage> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Scaffold(
        backgroundColor: Color(0xFF232323).withOpacity(0.78),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: SizedBox(),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '直播已结束',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: rSP(20),
                ),
              ),
              rHBox(40),
              ClipRRect(
                borderRadius: BorderRadius.circular(rSize(80 / 2)),
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image:
                      Api.getImgUrl(UserManager.instance.user.info.headImgUrl),
                  height: rSize(80),
                  width: rSize(80),
                ),
              ),
              rHBox(55),
              Row(
                children: [],
              ),
              rHBox(50),
              MaterialButton(
                height: rSize(40),
                minWidth: rSize(209),
                child: Text(
                  '关注',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(18),
                  ),
                ),
                onPressed: () {},
                color: Color(0xFFDB2D2D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(20)),
                ),
              ),
              rHBox(16),
              Text(
                '关注主播，不错过更多精彩内容',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: rSP(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
