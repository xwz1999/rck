import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/review/add_review_page.dart';
import 'package:recook/pages/user/review/models/order_review_list_model.dart';
import 'package:recook/pages/user/review/review_detail_page.dart';
import 'package:recook/utils/custom_route.dart';

class  ReviewCard extends StatelessWidget {
  final OrderReviewListModel model;
  final VoidCallback onBack;
  final bool reviewStatusAdd;
  const ReviewCard(
      {Key? key,
        required this.model,
        required this.onBack,
        this.reviewStatusAdd = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              FadeInImage.assetNetwork(
                image: Api.getImgUrl(model.myOrderGoodsDea!.mainPhotoUrl)!,
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
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
                      model.myOrderGoodsDea!.goodsName!,
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
                      '型号规格 ${model.myOrderGoodsDea!.skuName}',
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
                                  '¥ ${model.myOrderGoodsDea!.goodsAmount!.toStringAsFixed(0)}',
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
                                  text: '${model.myOrderGoodsDea!.quantity}',
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
                child:
                GestureDetector(
                  onTap: (){
                    if (reviewStatusAdd) {
                      CRoute.push(
                        context,
                        AddReviewPage(
                          goodsDetailId: model.myOrderGoodsDea!.goodsDetailId,
                          model: model,
                        ),
                      ).then((value) {
                        onBack();
                      });
                    } else {
                      Get.to(ReviewDetailPage(reviewModel: model));
                    }
                  },
                  child: Container(
                    color:  Color(0xFF666666),
                    decoration: BoxDecoration(
                      border: Border.all( color: Colors.red,),
                      borderRadius: BorderRadius.circular(rSize(14)),
                    ),
                    padding: EdgeInsets.all(1),
                    child: Text(
                      reviewStatusAdd ? '评价' : '查看评价',
                      style: TextStyle(
                        color: Color(0xFFDB2D2D),
                      ),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}