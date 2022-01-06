import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/models/order_after_sales_list_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class AfterSalesItem extends StatefulWidget {
  final OrderAfterSalesModel saleModel;

  final Function itemClick;

  AfterSalesItem(this.saleModel, this.itemClick);

  @override
  State<StatefulWidget> createState() {
    return _AfterSalesItemState();
  }
}

class _AfterSalesItemState extends State<AfterSalesItem> {
  OrderAfterSalesModel _saleModel;

  @override
  void initState() {
    super.initState();
    _saleModel = widget.saleModel;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.itemClick != null) widget.itemClick();
      },
      child: Container(
        color: AppColor.frenchColor,
        child: Container(
          height: 190 * 2.h,
          // height: 193,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: _itemWidget(),
        ),
      ),
    );
  }

  _itemWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: rSize(4), vertical: 10 * 2.h),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "售后编号   ",
                style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: 14 * 2.sp,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                _saleModel.asId.toString(),
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: 14 * 2.sp,
                ),
              ),
              Spacer(),
              Text(
                _saleModel.asDesc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _saleModel.color == 1
                        ? AppColor.redColor
                        : _saleModel.color == 2
                            ? AppColor.greyColor
                            : Colors.black,
                    fontSize: 14 * 2.sp),
              ),
            ],
          ),
        ),
        Container(
          height: 80 * 2.h,
          child: Row(
            children: <Widget>[
              Container(
                color: AppColor.frenchColor,
                margin: EdgeInsets.symmetric(horizontal: rSize(4)),
                child: CustomCacheImage(
                  width: 80 * 2.h,
                  height: 80 * 2.h,
                  imageUrl: Api.getResizeImgUrl(
                      _saleModel.mainPhotoUrl, 160 * 2.h.toInt()),
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
              Container(
                width: rSize(10),
              ),
              Expanded(
                child: Container(
                  height: 80 * 2.h,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: AppColor.frenchColor))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _saleModel.goodsName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15 * 2.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Color(0xffeff1f6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  child: Text(_saleModel.skuName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 11 * 2.sp,
                                      )),
                                ),
                              ])),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: rSize(14) + 80 * 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "退款金额  ",
                        style: TextStyle(
                            color: Color(0xff666666), fontSize: 14 * 2.sp),
                      ),
                      Text(
                        "￥${_saleModel.refundAmount + _saleModel.refundCoin}",
                        style: TextStyle(
                            color: AppColor.redColor, fontSize: 14 * 2.sp),
                      ),
                      _saleModel.quantity != null && _saleModel.quantity > 0
                          ? Container(
                              margin: EdgeInsets.only(left: rSize(10)),
                              child: ExtendedText.rich(TextSpan(
                                  text: "退货数量 ",
                                  style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: 14 * 2.sp),
                                  children: [
                                    TextSpan(
                                      text: _saleModel.quantity
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          color: AppColor.redColor,
                                          fontSize: 14 * 2.sp),
                                    )
                                  ])),
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 10 * 2.h,
                  ),
                  Text(
                    TextUtils.isEmpty(_saleModel.createdAt)
                        ? ""
                        : "申请时间: ${_saleModel.createdAt}",
                    style: TextStyle(
                        color: Color(0xff999999), fontSize: 12 * 2.sp),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
