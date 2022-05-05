

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';

import 'models/wholesale_order_preview_model.dart';

class WholesaleGoodsOrderItem extends StatefulWidget {
  final SkuList brand;
  final int index;
  final int length;

  const WholesaleGoodsOrderItem({Key key, this.brand,this.length, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleGoodsOrderItemState();
  }
}

class _WholesaleGoodsOrderItemState extends State<WholesaleGoodsOrderItem> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Container _buildBody(BuildContext context) {

    return Container(
      margin:
      EdgeInsets.only(left: rSize(13), right: rSize(13)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:BorderRadius.all(Radius.circular(8.rw))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _goods(context),
        ],
      ),
    );
  }


  _goods(context) {
    return MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: _buildSku(widget.brand)
    );
  }

  Container _buildSku(SkuList goods) {
    return Container(
      //padding: EdgeInsets.only(top: 10.rw,bottom: 10.rw),
      height: 100.rw ,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomCacheImage(
            imageUrl: Api.getImgUrl(goods.picUrl),
            fit: BoxFit.cover,
            width: 80.rw,
            height: 80.rw,
            borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.only(top: 15.rw,bottom: 15.rw),
            width: 160.rw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  goods.goodsName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(12.rsp,
                      fontWeight: FontWeight.w400),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color(0xffeff1f6),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Text(
                    goods.skuName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(11 * 2.sp,
                        color: Colors.grey[600], fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),

          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                20.hb,
                Text(
                  "￥ ${goods.salePrice.toStringAsFixed(2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(14 * 2.sp,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  "x${goods.quantity}",
                  style: AppTextStyle.generate(13,
                      color: Colors.grey, fontWeight: FontWeight.w300),
                ),
              ]),

        ],
      ),
    );
  }
}
