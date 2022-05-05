import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/user/review/models/order_review_list_model.dart';
import 'package:recook/pages/user/review/presenter/review_presenter.dart';
import 'package:recook/pages/user/review/widgets/review_card.dart';
import 'package:recook/widgets/refresh_widget.dart';

class NeedReviewPage extends StatefulWidget {
  final Function(int count) updateTabBar;
  NeedReviewPage({Key key, @required this.updateTabBar}) : super(key: key);

  @override
  _NeedReviewPageState createState() => _NeedReviewPageState();
}

class _NeedReviewPageState extends State<NeedReviewPage>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _gsRefreshController = GSRefreshController();
  List<OrderReviewListModel> reviewModels = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _gsRefreshController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _gsRefreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _gsRefreshController,
      onRefresh: () async {
        ReviewPresenter().getReviewList(status: 0).then((models) {
          setState(() {
            reviewModels = models;
            widget.updateTabBar(models.length);
          });
          _gsRefreshController.refreshCompleted();
        });
      },
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(rSize(15), rSize(15), rSize(15), 0),
        separatorBuilder: (context, index) {
          return SizedBox(
            height: rSize(15),
          );
        },
        itemBuilder: (context, index) {
          return ReviewCard(
            model: reviewModels[index],
            onBack: () {
              _gsRefreshController.requestRefresh();
            },
          );
        },
        itemCount: reviewModels.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
