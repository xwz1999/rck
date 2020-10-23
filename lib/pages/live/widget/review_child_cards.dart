import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/models/activity_review_list_model.dart';
import 'package:recook/utils/date/recook_date_util.dart';
import 'package:recook/widgets/recook/recook_like_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class ReviewChildCards extends StatefulWidget {
  final int trendId;
  ReviewChildCards({Key key, @required this.trendId}) : super(key: key);

  @override
  _ReviewChildCardsState createState() => _ReviewChildCardsState();
}

class _ReviewChildCardsState extends State<ReviewChildCards> {
  int count = 0;
  int _page = 1;
  List<ActivityReviewListModel> activityReviewListModels = [];

  GSRefreshController _controller = GSRefreshController();
  TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _editingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height -
            rSize(233) +
            MediaQuery.of(context).viewInsets.bottom,
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            top: Radius.circular(rSize(15)),
          )),
          child: Column(
            children: [
              SizedBox(height: rSize(15)),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(width: rSize(15)),
                    Text(
                      '评论',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: rSize(8)),
                    Text(
                      count.toString(),
                      style: TextStyle(
                        color: Color(0xFF333333).withOpacity(0.4),
                        fontSize: rSP(16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: rSize(15)),
              Expanded(
                child: RefreshWidget(
                  controller: _controller,
                  onRefresh: () {
                    _page = 1;
                    getActivityReviews().then((models) {
                      setState(() {
                        activityReviewListModels = models;
                      });
                      _controller.refreshCompleted();
                    });
                  },
                  onLoadMore: () {
                    _page++;
                    getActivityReviews().then((models) {
                      setState(() {
                        activityReviewListModels.addAll(models);
                      });
                      if (models.isEmpty)
                        _controller.loadNoData();
                      else
                        _controller.loadComplete();
                    });
                  },
                  body: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                    itemBuilder: (context, index) {
                      return _buildReviewCard(activityReviewListModels[index]);
                    },
                    itemCount: activityReviewListModels.length,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: rSize(48),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: rSize(6),
                  horizontal: rSize(15),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _editingController,
                    onSubmitted: (text) {
                      addReview(widget.trendId, text).then((_) {
                        if (mounted) _controller.requestRefresh();
                        _editingController.clear();
                      });
                    },
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: '随便说两句…',
                      hintStyle: TextStyle(
                        color: Color(0xFF7F858D),
                        fontSize: rSP(14),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: rSize(15),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(rSize(18)),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: MediaQuery.of(context).viewPadding.bottom +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildReviewCard(ActivityReviewListModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(rSize(28 / 2)),
          child: FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
            image: Api.getImgUrl(model.headImgUrl),
            height: rSize(28),
            width: rSize(28),
          ),
        ),
        SizedBox(width: rSize(6)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    model.nickname,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  RecookLikeButton(
                    initValue: model.isPraise == 1,
                    onChange: (oldState) {
                      HttpManager.post(
                        oldState ? LiveAPI.dislikeComment : LiveAPI.likeComment,
                        {'commentId': model.id},
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: rSize(2)),
              Text(
                model.content,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(14),
                ),
              ),
              SizedBox(height: rSize(2)),
              Text(
                RecookDateUtil.fromString(model.createdAt).humanDate,
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: rSP(12),
                ),
              ),
              SizedBox(height: rSize(20)),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<ActivityReviewListModel>> getActivityReviews() async {
    ResultData resultData = await HttpManager.post(LiveAPI.activityReview, {
      'trendId': widget.trendId,
      'parentId': 0,
      'page': _page,
      "limit": 10,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else {
      count = resultData.data['data']['count'];
      return (resultData.data['data']['list'] as List)
          .map((e) => ActivityReviewListModel.fromJson(e))
          .toList();
    }
  }

  Future addReview(int id, String comment) async {
    await HttpManager.post(LiveAPI.addActivityReview, {
      'trendId': widget.trendId,
      'parentId': 0,
      "content": comment,
    });
  }
}
