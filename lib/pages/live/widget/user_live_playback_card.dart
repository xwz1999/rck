import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/live_stream/live_playback_view_page.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/pages/live/models/activity_video_list_model.dart';
import 'package:recook/pages/live/widget/user_base_card.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/date/recook_date_util.dart';
import 'package:recook/widgets/custom_image_button.dart';

class UserPlaybackCard extends StatefulWidget {
  final ActivityVideoListModel model;
  UserPlaybackCard({Key key, @required this.model}) : super(key: key);

  @override
  _UserPlaybackCardState createState() => _UserPlaybackCardState();
}

class _UserPlaybackCardState extends State<UserPlaybackCard> {
  @override
  Widget build(BuildContext context) {
    final RecookDateUtil dateUtil =
        RecookDateUtil.fromMillsecond(widget.model.startAt * 1000);
    return UserBaseCard(
      date: dateUtil.prefixDay,
      detailDate: DateUtil.formatDate(dateUtil.dateTime, format: 'HH:mm'),
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
                  Image.asset(widget.model.isLive == 1
                      ? R.ASSETS_LIVE_ON_STREAM_PNG
                      : R.ASSETS_LIVE_STREAM_PLAY_BACK_PNG),
                  SizedBox(width: rSize(5)),
                  Text(
                    widget.model.isLive == 1 ? '正在直播中' : '回放',
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
            widget.model.title,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '${widget.model.look}人观看 ｜ ${widget.model.goodsCount}个宝贝',
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: rSP(12),
          ),
        ),
        SizedBox(
          height: rSize(15),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(rSize(4)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(widget.model.cover),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Material(
                  color: Colors.black.withOpacity(0.1),
                  child: InkWell(
                    child: Center(
                      child: Image.asset(
                        R.ASSETS_LIVE_VIDEO_PLAY_PNG,
                        height: rSize(34),
                        width: rSize(34),
                      ),
                    ),
                    onTap: () {
                      if (widget.model.isLive == 1)
                        CRoute.push(
                          context,
                          LiveStreamViewPage(id: widget.model.id),
                        );
                      else
                        CRoute.push(
                            context, LivePlaybackViewPage(id: widget.model.id));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
