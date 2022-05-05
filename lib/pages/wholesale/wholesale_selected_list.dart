import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/wholesale/wholesale_minus_view.dart';
import 'package:recook/widgets/custom_image_button.dart';

import 'models/wholesale_detail_model.dart';

typedef SelectedItemClickListener = Function(int index,int goodsNum);
typedef ItemClick = Function(int index,int goodsNum);
typedef WidgetBuilder = Function();

class WholesaleSelectedList extends StatefulWidget {
  final List<SelectedItemModel> data;
  final SelectedItemClickListener listener;

  const WholesaleSelectedList({
    Key key,
    this.data,
    this.listener,
  }) : super(key: key);

  @override
  _WholesaleSelectedListState createState() => _WholesaleSelectedListState();
}

class _WholesaleSelectedListState extends State<WholesaleSelectedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return SelectedListItem(
                itemModel: widget.data[index],
                index: index,
                data: widget.data,
                itemClick: (int itemIndex,int num) {
                  if (widget.listener != null) {
                    widget.listener(itemIndex,num);
                  }
                },
              );
            }));
  }
}

class SelectedListItem extends StatefulWidget {
  final SelectedItemModel itemModel;
  final int index;
  final ItemClick itemClick;
  final List<SelectedItemModel> data;

  const SelectedListItem({
    Key key,
    this.index,
    this.itemModel,
    this.itemClick,
    this.data,
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

    goodsNum = widget.itemModel.selectedNum!=null?widget.itemModel.selectedNum: widget.itemModel.sku.min;

    Future.delayed(Duration.zero, () async {
      if (widget.data.length == 1 && _isFirstLoad) {
        _isFirstLoad = false;
        widget.data[0].selected = true;
        widget.itemClick(0,goodsNum);
      }
    });

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
          CustomImageButton(
            icon: Icon(
              widget.itemModel.selected
                  ? AppIcons.icon_check_circle
                  : AppIcons.icon_circle,
              color: widget.itemModel.selected
                  ? AppColor.themeColor
                  : Colors.grey,
              size: rSize(20),
            ),
            onPressed: () {

                for (int i = 0; i < widget.data.length; i++) {
                  if (i != widget.index) {
                    widget.data[i].selected = false;
                  }
                }
                widget.itemModel.selected = !widget.itemModel.selected;


              if (widget.itemClick != null) {
                widget.itemClick(widget.index,goodsNum);
              }
            },
          ),

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
                                '规格：${widget.itemModel.sku.name}',
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
                              '批发价：¥${widget.itemModel.sku.salePrice}',
                              style: TextStyle(
                                  color: Color(0xFFD5101A),
                                  fontSize: 14 * 2.sp,fontWeight: FontWeight.bold),
                            ),
                            16.wb,
                            Text(
                              '零售价：${widget.itemModel.sku.discountPrice.toStringAsFixed(2)}',
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
                        initialValue:  widget.itemModel.selectedNum!=null? widget.itemModel.selectedNum: widget.itemModel.sku.min,
                        minValue: widget.itemModel.sku.min,
                        limit: widget.itemModel.sku.limit,
                        onInputComplete: (String getNum) {
                          goodsNum = int.parse(getNum);
                          widget.itemClick(widget.index,goodsNum);
                        },
                        onValueChanged: (int getNum) {

                          goodsNum = getNum;
                          widget.itemClick(widget.index,goodsNum);
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
