import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/pages/home/function/home_fuc.dart';
import 'package:jingyaoyun/pages/home/model/aku_video_list_model.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/play_widget/video_player.dart';
import 'package:velocity_x/velocity_x.dart';
class AkuCollegeDetailPage extends StatefulWidget {
  final AkuVideo akuVideo;

  const AkuCollegeDetailPage({Key key, @required this.akuVideo})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AkuCollegeDetailPageState();
  }
}

class _AkuCollegeDetailPageState extends BaseStoreState<AkuCollegeDetailPage> {


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      String code = await HomeFuc.addHits(widget.akuVideo.id);
      print(code);
    });


  }

  @override
  void dispose() {

    super.dispose();

  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: "".text.bold.size(18.rsp).make(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
        child: Column(
      children: [
        40.hb,
        Row(
          children: [
            30.wb,
            Text(
              widget.akuVideo.title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ).expand(),
            30.wb,
          ],
        ),
        20.hb,
        Row(
          children: [
            30.wb,
            Text(
              widget.akuVideo.subTitle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.rsp,
                color: Color(0xFF333333),
              ),
            ),
            40.wb,
            Container(
              padding: EdgeInsets.only(top: 3.rw),
              child: Text(
                _getDateTime(widget.akuVideo.createDTime),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.rsp,
                  color: Color(0xFF999999),
                ),
              ),
            ),
            40.wb,
            Text(
              widget.akuVideo.numberOfHits.toString() + '人已学习',
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.rsp,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        20.hb,
        widget.akuVideo.type == 1 ? VideoPlayer(url: widget.akuVideo.videoUrl,isNetWork: true,) : _playImagText()
      ],
    ));
  }

  _getDateTime(String date) {
    if (date.isEmpty) {
      return date;
    } else {
      DateTime dateTime = DateUtil.getDateTime(date);
      return DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd');
    }
  }


  _playImagText() {
    return HtmlWidget(
      widget.akuVideo.textBody,
      textStyle: TextStyle(color: Color(0xFF333333)),
    );
  }




}
