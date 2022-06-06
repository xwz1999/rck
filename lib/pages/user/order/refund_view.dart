/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-14  17:51 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

typedef RefundViewCallback = Function(
    List<int?> selectedGoodsIds, List<Goods> selectedGoodsList);

class RefundView extends StatefulWidget {
  final List<Goods>? goodsList;
  final RefundViewCallback? callback;

  const RefundView({Key? key, this.goodsList, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundViewState();
  }
}

class _RefundViewState extends BaseStoreState<RefundView> {
  @override
  Widget buildContext(BuildContext context, {store}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: EdgeInsets.only(
            top: rSize(10),
            left: rSize(8),
            right: rSize(8),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(rSize(10)))),
          height: DeviceInfo.screenHeight! * 0.65,
          child: Column(
            children: <Widget>[
              Text(
                "请选择您需要退款的商品",
                style: AppTextStyle.generate(14, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: rSize(5)),
                  child: ListView.builder(
                      itemCount: widget.goodsList!.length,
                      itemBuilder: (_, index) {
                        return _goodsItem(widget.goodsList![index]);
                      }),
                ),
              ),
              SafeArea(
                bottom: true,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: rSize(10), vertical: rSize(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomImageButton(
                          padding: EdgeInsets.symmetric(vertical: rSize(5)),
                          title: "取消",
                          fontSize: 14 * 2.sp,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          backgroundColor: AppColor.tableViewGrayColor,
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: rSize(10),
                      ),
                      Expanded(
                        child: CustomImageButton(
                          padding: EdgeInsets.symmetric(vertical: rSize(5)),
                          title: "确认",
                          color: Colors.white,
                          fontSize: 14 * 2.sp,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          backgroundColor: AppColor.themeColor,
                          onPressed: () {
                            if (widget.callback == null) return;
                            List<Goods> selectedGoods = [];
                            List<int?> selectedGoodsIds = [];
                            widget.goodsList!.forEach((goods) {
                              if (goods.selected!) {
                                selectedGoods.add(goods);
                                selectedGoodsIds.add(goods.goodsDetailId);
                              }
                            });
                            widget.callback!(selectedGoodsIds, selectedGoods);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  _goodsItem(Goods goods) {
    return CustomImageButton(
      onPressed: () {
        setState(() {
          goods.selected = !goods.selected!;
        });
      },
      child: Container(
        height: rSize(110),
        padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: rSize(90),
              alignment: Alignment.center,
              child: CustomImageButton(
                width: rSize(26),
                padding: EdgeInsets.only(right: rSize(5)),
                height: double.infinity,
                icon: Icon(
                  goods.selected!
                      ? AppIcons.icon_check_circle
                      : AppIcons.icon_circle,
                  color: goods.selected! ? AppColor.priceColor : Colors.grey,
                  size: rSize(19),
                ),
                onPressed: () {
                  setState(() {
                    goods.selected = !goods.selected!;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: rSize(4)),
              child: CustomCacheImage(
                width: rSize(90),
                height: rSize(90),
                imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
                borderRadius: BorderRadius.all(Radius.circular(6)),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goods.goodsName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(14 * 2.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        goods.skuName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(13 * 2.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Text(
                          "￥ ${goods.unitPrice}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: AppColor.priceColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
