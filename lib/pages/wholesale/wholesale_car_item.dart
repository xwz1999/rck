
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/wholesale/wholesale_car_specs.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';

import 'models/wholesale_car_model.dart';
typedef GoodsSelectedCallback = Function(WholesaleCarModel goods);
typedef GoodsClickCallback = Function(WholesaleCarModel goods);
typedef PlusMinusUpdateCallback = Function(
    WholesaleCarModel goods, int num);

class WholesaleCarItem extends StatefulWidget {
  final WholesaleCarModel model;
  final GoodsSelectedCallback selectedListener;
  final GoodsClickCallback? clickListener;
  final PlusMinusUpdateCallback? numUpdateCompleteCallback;
  final TextInputChangeCallBack? onBeginInput;
  final bool isEdit;
  const WholesaleCarItem(
      {Key? key,
        required this.model,
        required this.selectedListener,
        this.clickListener,
        this.numUpdateCompleteCallback,
        this.onBeginInput,
        this.isEdit = false});

  @override
  _WholesaleCarItemState createState() => _WholesaleCarItemState();
}

class _WholesaleCarItemState extends State<WholesaleCarItem> {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 170.rw,
      padding: EdgeInsets.only(top: rSize(10)),
      margin: EdgeInsets.only(bottom: 8.rw),
      decoration: BoxDecoration(
          color: Colors.white,
          ),
      child: _goodsItem(widget.model),
    );
  }

  _goodsItemImage(WholesaleCarModel goods) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(4)),
      child: CustomCacheImage(
        width: 72.rw,
        height: 72.rw,
        // imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, rSize(80).toInt()),
        imageUrl: Api.getResizeImgUrl(goods.picUrl!, rSize(200).toInt(),print: true),
        borderRadius: BorderRadius.all(Radius.circular(8.rw)),
      ),
    );
  }

  _goodsItemSelectIcon(WholesaleCarModel goods) {
    bool selected = goods.selected;
    return Container(
      color: Colors.transparent,
      height: 72.rw,
      alignment: Alignment.center,
      child: CustomImageButton(
        width: rSize(26),
        // padding: EdgeInsets.only(left: rSize(0)),
        height: double.infinity,
        icon: goods.salePublish == 1 || widget.isEdit
            ? Icon(
          selected ? AppIcons.icon_check_circle : AppIcons.icon_circle,
          color: selected ? AppColor.themeColor : Colors.grey,
          size: rSize(20),
        )
            : Image.asset(
          R.ASSETS_NOT_SELECT_PNG,
          width: 20.rw,
          height: 20.rw,
        ),
        onPressed: goods.salePublish == 1 || widget.isEdit
            ? () {
          goods.selected = !goods.selected;
          widget.selectedListener(goods);
          setState(() {});
        }
            : () {},
      ),
    );
  }

  _goodsItem(WholesaleCarModel goods) {
    return CustomImageButton(
      padding: EdgeInsets.all(0),
      onPressed: goods.salePublish == 0
          ? () {}
          : () {
        if (widget.clickListener != null) {
          widget.clickListener!(goods);
        }
      },
      child: Container(
        // height: rSize(130),
        padding:
        EdgeInsets.symmetric( horizontal: rSize(10)),
        child: Column(
          children: [
            Container(
              // color: Colors.lightBlue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _goodsItemSelectIcon(goods),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _goodsItemImage(goods),
                      4.hb,
                      goods.salePublish == 0
                          ? Text(
                        '该产品已下架',
                        style: TextStyle(
                            fontSize: 12.rsp,
                            color: Color(0xFFC92219),
                            fontWeight: FontWeight.bold),
                      )
                          : SizedBox()
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(minHeight: 40.rw),
                            child: ExtendedText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: goods.goodsName,
                                    style: AppTextStyle.generate(15 * 2.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.rw),
                            decoration: BoxDecoration(
                              color: AppColor.frenchColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 6),
                            child: Text(
                              '${goods.min}件起批 本品按箱批发 一箱=${goods.limit}件',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.generate(12 * 2.sp,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 2 * 2.w,
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            20.hb,
            Container(
              padding: EdgeInsets.only(left: 30.rw),
              child: WholesaleCarSpecs(
                data: widget.model,
                listener: (int goodsNum) {
                  if (goodsNum ==
                      widget.model.quantity) return;
                  if (widget
                      .numUpdateCompleteCallback !=
                      null) {
                    widget.numUpdateCompleteCallback!(
                        widget.model, goodsNum);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}



