import 'package:flutter/material.dart';
import 'package:recook/const/resource.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/review/models/order_review_list_model.dart';
import 'package:recook/pages/user/review/models/review_result_model.dart';
import 'package:recook/widgets/recook_back_button.dart';

class ReviewDetailPage extends StatefulWidget {
  final OrderReviewListModel reviewModel;
  ReviewDetailPage({Key key, @required this.reviewModel}) : super(key: key);

  @override
  _ReviewDetailPageState createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  ReviewResultModel _model;
  @override
  void initState() {
    super.initState();
    HttpManager.post(OrderApi.checkReview, {
      "id": widget.reviewModel.evaluatedId,
    }).then((data) {
      setState(() {
        _model = ReviewResultModel.fromJson(data.data['data']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: RecookBackButton(),
        centerTitle: true,
        title: Text(
          '我的评价',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _model == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(rSize(15)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(rSize(8)),
                ),
                padding: EdgeInsets.all(rSize(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(widget.reviewModel.mainPhotoUrl),
                          height: rSize(56),
                          width: rSize(56),
                        ),
                        SizedBox(width: rSize(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.reviewModel.goodsName,
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
                                '型号规格 ${widget.reviewModel.skuName}',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: rSP(13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rSize(20)),
                    Text(
                      _model.goodsEva.content,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                    SizedBox(height: rSize(20)),
                    _model.goodsEvaGoods.isEmpty
                        ? SizedBox()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  padding: EdgeInsets.only(
                                    top: rSize(20),
                                    right: rSize(10),
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: rSize(8),
                                    mainAxisSpacing: rSize(8),
                                  ),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(rSize(4)),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                        image: Api.getImgUrl(
                                            _model.goodsEvaGoods[index].url),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _model.goodsEvaGoods.length,
                                ),
                              ),
                              Text(
                                '共${_model.goodsEvaGoods.length}张',
                                style: TextStyle(
                                  fontSize: rSP(12),
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
