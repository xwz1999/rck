import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/user/review/models/order_review_list_model.dart';
import 'package:recook/pages/user/review/presenter/review_presenter.dart';
import 'package:recook/widgets/refresh_widget.dart';

class AlreadyReviewPage extends StatefulWidget {
  AlreadyReviewPage({Key key}) : super(key: key);

  @override
  _AlreadyReviewPageState createState() => _AlreadyReviewPageState();
}

class _AlreadyReviewPageState extends State<AlreadyReviewPage>
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
        ReviewPresenter().getReviewList(status: 1).then((models) {
          setState(() {
            reviewModels = models;
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
          return _buildReviewCard(reviewModels[index]);
        },
        itemCount: reviewModels.length,
      ),
    );
  }

  _buildReviewCard(OrderReviewListModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rSize(8)),
      ),
      padding: EdgeInsets.all(rSize(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                Api.getImgUrl(model.mainPhotoUrl),
                height: rSize(80),
                width: rSize(80),
              ),
              SizedBox(width: rSize(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      model.goodsName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: rSP(14),
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Text(
                      '型号规格 ${model.skuName}',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: rSP(13),
                      ),
                    ),
                    SizedBox(height: rSize(16)),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '订单金额 ',
                                ),
                                TextSpan(
                                  text:
                                      '¥ ${model.goodsAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: rSP(14),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '购买数量 ',
                                ),
                                TextSpan(
                                  text: '${model.quantity}',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: rSP(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: rSize(20)),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: rSize(28),
              width: rSize(76),
              child: OutlineButton(
                padding: EdgeInsets.all(1),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(14)),
                ),
                child: Text(
                  '评价',
                  style: TextStyle(
                    color: Color(0xFFDB2D2D),
                  ),
                ),
                splashColor: Colors.red.withOpacity(0.3),
                highlightedBorderColor: Colors.red,
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
