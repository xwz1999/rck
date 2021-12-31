import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/live/functions/live_function.dart';
import 'package:jingyaoyun/pages/live/models/live_base_info_model.dart';
import 'package:jingyaoyun/pages/live/models/live_stream_info_model.dart';
import 'package:jingyaoyun/pages/live/widget/live_user_bar.dart';

class LiveAvatarWithDialog extends StatefulWidget {
  final VoidCallback onTapAvatar;
  final bool initAttention;
  final LiveStreamInfoModel model;
  final LiveBaseInfoModel liveBaseModel;
  final liveId;
  final int praise;

  LiveAvatarWithDialog({
    Key key,
    @required this.onTapAvatar,
    @required this.initAttention,
    @required this.model,
    @required this.liveBaseModel,
    @required this.liveId,
    @required this.praise,
  }) : super(key: key);

  @override
  _LiveAvatarWithDialogState createState() => _LiveAvatarWithDialogState();
}

class _LiveAvatarWithDialogState extends State<LiveAvatarWithDialog> {
  bool initAttention = false;
  String get title => widget.model == null ? '' : widget.model.nickname;
  GlobalKey<LiveUserBarState> _key = GlobalKey<LiveUserBarState>();
  @override
  void initState() {
    super.initState();
    initAttention = widget.initAttention;
  }

  @override
  Widget build(BuildContext context) {
    return LiveUserBar(
      key: _key,
      onTapAvatar: () {
        showLiveChild(context,
            initAttention: initAttention,
            title: widget.model.nickname,
            fans: widget.liveBaseModel.fans,
            follows: widget.liveBaseModel.follows,
            headImg: widget.liveBaseModel.headImgUrl,
            id: widget.liveBaseModel.userId, callback: (state) {
          setState(() {
            initAttention = state;
            _key.currentState.updateAttention(state);
          });
        });
      },
      initAttention: widget.model.userId == UserManager.instance.user.info.id
          ? true
          : initAttention,
      onAttention: () {
        initAttention = true;
        HttpManager.post(
          LiveAPI.addFollow,
          {
            'followUserId': widget.liveBaseModel.userId,
            'liveItemId': widget.liveId,
          },
        );
        setState(() {});
      },
      title: title,
      subTitle: '点赞数 ${widget.praise}',
      avatar: widget.liveBaseModel?.headImgUrl,
    );
  }
}
