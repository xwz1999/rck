import 'package:flutter/material.dart';
import 'package:recook/pages/live/widget/user_live_playback_card.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserPlaybackView extends StatefulWidget {
  UserPlaybackView({Key key}) : super(key: key);

  @override
  _UserPlaybackViewState createState() => _UserPlaybackViewState();
}

class _UserPlaybackViewState extends State<UserPlaybackView> {
  GSRefreshController _controller = GSRefreshController();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        _controller.refreshCompleted();
      },
      body: ListView.builder(itemBuilder: (context, index) {
        return UserPlaybackCard();
      }),
    );
  }
}
