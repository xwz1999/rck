import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_minus_view.dart';

import 'models/wholesale_car_model.dart';
import 'models/wholesale_detail_model.dart';

typedef SelectedItemClickListener = Function(int goodsNum);
typedef ItemClick = Function(int goodsNum);
typedef WidgetBuilder = Function();

class WholesaleCarSpecs extends StatefulWidget {
  final WholesaleCarModel data;
  final SelectedItemClickListener listener;

  const WholesaleCarSpecs({
    Key key,
    this.data,
    this.listener,
  }) : super(key: key);

  @override
  _WholesaleCarSpecsState createState() => _WholesaleCarSpecsState();
}

class _WholesaleCarSpecsState extends State<WholesaleCarSpecs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SelectedListItem(
                itemModel: widget.data,
                itemClick: (int num) {
                  if (widget.listener != null) {
                    widget.listener(num);
                  }
                  setState(() {});
                },
              ),
            );
  }
}

class SelectedListItem extends StatefulWidget {
  final WholesaleCarModel itemModel;

  final ItemClick itemClick;


  const SelectedListItem({
    Key key,
    this.itemModel,
    this.itemClick,

  }) : super(key: key);

  @override
  _SelectedListItemState createState() => _SelectedListItemState();
}

class _SelectedListItemState extends State<SelectedListItem> {
  bool _isFirstLoad = true;
  num goodsNum = 0;

  @override
  void initState() {
    super.initState();
    goodsNum = widget.itemModel.quantity;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 10.rw),
      //width: 400.rw,
      height: 60.rw,
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // CustomImageButton(
          //   icon: Icon(
          //     widget.itemModel.selected
          //         ? AppIcons.icon_check_circle
          //         : AppIcons.icon_circle,
          //     color: widget.itemModel.selected
          //         ? AppColor.themeColor
          //         : Colors.grey,
          //     size: rSize(20),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       for (int i = 0; i < widget.data.length; i++) {
          //         if (i != widget.index) {
          //           widget.data[i].selected = false;
          //         }
          //       }
          //       widget.itemModel.selected = !widget.itemModel.selected;
          //     });
          //     if (widget.itemClick != null) {
          //       widget.itemClick(widget.index,goodsNum);
          //     }
          //   },
          // ),

          Expanded(
            child: Container(

              //alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal:14.rw ),
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(

                              child: Text(
                                '规格：${widget.itemModel.skuName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12 * 2.sp),
                              ),
                              width: 190.rw,
                            ),
                            // 16.wb,
                            // Text(
                            //   '库存：${widget.itemModel.sku.saleInventory}',
                            //   style: TextStyle(
                            //       color: Color(0xFF999999),
                            //       fontSize: 10 * 2.sp),
                            // ),
                          ],
                        ),
                        10.hb,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '批发价：¥${widget.itemModel.salePrice}',
                              style: TextStyle(
                                  color: Color(0xFFD5101A),
                                  fontSize: 14 * 2.sp,fontWeight: FontWeight.bold),
                            ),
                            16.wb,
                            Text(
                              '零售价：¥${widget.itemModel.discountPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 10 * 2.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    WholesaleMinusView(
                        initialValue:  widget.itemModel.quantity!=null? widget.itemModel.quantity: widget.itemModel.min,
                        minValue: widget.itemModel.min,
                        limit: widget.itemModel.limit,
                        onInputComplete: (String getNum) {
                          goodsNum = int.parse(getNum);
                          widget.itemClick(goodsNum);
                        },
                        onValueChanged: (int getNum) {
                          goodsNum = getNum;
                          widget.itemClick(goodsNum);
                        },
                      ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

/*
  实现淘宝sku 可选不可选
 */
class SelectedItemModel {
  WholesaleSku sku;
  bool selected;
  num selectedNum;

  SelectedItemModel({this.sku, this.selected = false,this.selectedNum});
}

//
// class SelectedListItemModel<T extends SelectedListItemChildModel> {
//   String sectionTitle;
//   List<T> items;
//   int selectedIndex;
//
//   SelectedListItemModel(this.sectionTitle, this.items);
// }
//
// /*
//   实现淘宝sku 可选不可选
//  */
// class SelectedListItemChildModel {
//   String itemTitle;
//   bool canSelected;
//   int id;
//
//   SelectedListItemChildModel(
//       {this.id, this.itemTitle, this.canSelected = true});
// }
