/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  2:55 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';

class VideoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: AppColor.frenchColor,
      // child: ListView.builder(
      //     padding: EdgeInsets.symmetric(vertical: 10),
      //     itemCount: 20,
      //     itemBuilder: (_, index) {

      //     }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

