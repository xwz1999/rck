import 'package:flutter/material.dart';

import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/live/live_stream/small_window/small_window_widget.dart';

class SmallWindowPage extends StatefulWidget {
  ///直播ID
  final int liveId;

  ///物品ID
  final int id;

  ///直播地址
  final String url;
  SmallWindowPage({
    Key key,
    @required this.liveId,
    @required this.id,
    this.url,
  }) : super(key: key);

  @override
  _SmallWindowPageState createState() => _SmallWindowPageState();
}

class _SmallWindowPageState extends State<SmallWindowPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommodityDetailPage(
          arguments: CommodityDetailPage.setArguments(widget.id),
          liveId: widget.liveId,
          isLive: true,
        ),
        SmallWindowWidget(url: widget.url),
      ],
    );
  }
}
