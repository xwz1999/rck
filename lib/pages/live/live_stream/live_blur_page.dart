import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/live_exit_model.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart';
import 'package:recook/utils/date/recook_date_util.dart';

class LiveBlurPage extends StatefulWidget {
  final bool isLive;
  final LiveExitModel exitModel;
  final BuildContext context;
  final int look;
  final int praise;
  final LiveStreamInfoModel streamModel;
  LiveBlurPage(
      {Key key,
      this.isLive = false,
      this.exitModel,
      @required this.context,
      this.look,
      this.praise,
      this.streamModel})
      : super(key: key);

  @override
  _LiveBlurPageState createState() => _LiveBlurPageState();
}

class _LiveBlurPageState extends State<LiveBlurPage> {
  @override
  void dispose() {
    Navigator.pop(widget.context);
    super.dispose();
  }

  String get liveDuration => RecookDateUtil(
          DateTime.fromMillisecondsSinceEpoch(widget.exitModel.duration * 1000)
              .toUtc())
      .detailDateWithSecond;

  String get allDuration => RecookDateUtil(DateTime.fromMillisecondsSinceEpoch(
              widget.exitModel.monthDuration * 1000)
          .toUtc())
      .detailDateWithSecond;

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
              },
            ),
          ],
        ),
        body: widget.isLive
            ? Center(
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
                        image: Api.getImgUrl(
                            UserManager.instance.user.info.headImgUrl),
                        height: rSize(80),
                        width: rSize(80),
                      ),
                    ),
                    rHBox(30),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '本次直播 ',
                          style: TextStyle(
                            fontSize: rSP(14),
                            color: Color(0xFF999999),
                          ),
                        ),
                        Text(
                          '$liveDuration',
                          style: TextStyle(
                            fontSize: rSP(14),
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        rWBox(30),
                        Text(
                          '本月共累计 ',
                          style: TextStyle(
                            fontSize: rSP(14),
                            color: Color(0xFF999999),
                          ),
                        ),
                        Text(
                          '$allDuration',
                          style: TextStyle(
                            fontSize: rSP(14),
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: rSize(40),
                      thickness: rSize(1),
                      color: Colors.white.withOpacity(0.06),
                      indent: rSize(16),
                      endIndent: rSize(16),
                    ),
                    GridView(
                      padding: EdgeInsets.symmetric(horizontal: rSize(54)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      children: [
                        _buildColumn('${widget.exitModel.salesVolume}', '销售金额'),
                        _buildColumn(
                            '${widget.exitModel.anticipatedRevenue}', '预计收入'),
                        _buildColumn('${widget.exitModel.buy}', '购买人数'),
                        _buildColumn('${widget.exitModel.look}', '观看'),
                        _buildColumn('${widget.exitModel.praise}', '获赞'),
                        _buildColumn('${widget.exitModel.fans}', '新增粉丝'),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                    rHBox(82),
                    MaterialButton(
                      height: rSize(40),
                      minWidth: rSize(209),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: rSP(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Color(0xFFDB2D2D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(rSize(20)),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
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
                        image: Api.getImgUrl(widget.streamModel.headImgUrl),
                        height: rSize(80),
                        width: rSize(80),
                      ),
                    ),
                    rHBox(55),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColumn('${widget.look}', '观看人数'),
                        _buildColumn('${widget.praise}', '获赞'),
                      ],
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
                      onPressed: () {
                        HttpManager.post(
                          LiveAPI.addFollow,
                          {'followUserId': widget.streamModel.userId},
                        );
                      },
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

  _buildColumn(String title, String subTitle) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: rSP(20),
          ),
        ),
        rHBox(10),
        Text(
          subTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.62),
            fontSize: rSP(14),
          ),
        ),
      ],
    );
  }
}
