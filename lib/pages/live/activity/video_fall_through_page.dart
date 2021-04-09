import 'package:flutter/material.dart';

import 'package:recook/pages/live/activity/activity_preview_page.dart';
import 'package:recook/pages/live/models/activity_list_model.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/models/video_list_model.dart';

class VideoFallThroughPage extends StatefulWidget {
  final List<VideoListModel> models;
  final int index;
  VideoFallThroughPage({Key key, @required this.models, @required this.index})
      : super(key: key);

  @override
  _VideoFallThroughPageState createState() => _VideoFallThroughPageState();
}

class _VideoFallThroughPageState extends State<VideoFallThroughPage> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ActivityPreviewPage(
            controller: _pageController,
            page: index,
            model: ActivityListModel.fromVideoList(widget.models[index]),
            userModel:
                LiveBaseInfoModel.fromVideoListModel(widget.models[index]),
          );
        },
        itemCount: widget.models.length,
      ),
    );
  }
}
