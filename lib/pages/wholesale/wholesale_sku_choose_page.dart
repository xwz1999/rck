
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/wholesale/wholesale_selected_list.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/toast.dart';

import 'models/wholesale_detail_model.dart';

typedef ChooseClickListener = Function(WholesaleSkuChooseModel skuModel);

class WholesaleSkuChoosePage extends StatefulWidget {
  final WholesaleDetailModel model;
  final List<SelectedItemModel> itemModels;
  final List<String> results;
  final ChooseClickListener listener;

  const WholesaleSkuChoosePage(
      {Key key,
        this.model,
        @required this.itemModels,
        @required this.results,
        this.listener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleSkuChoosePageState();
  }
}

class _WholesaleSkuChoosePageState extends BaseStoreState<WholesaleSkuChoosePage> {
  WholesaleSku _sku;
  String _commission, _price;
  List<String> _skuDes;
  StringBuffer _stringBuffer;
  int _num;
  List _photoList = [];
  List<PicSwiperItem> picSwiperItem = [];

  /// 存放 sku id 列表
  List selectedIds = [];

  bool haveSelected = false;

  @override
  void initState() {
    super.initState();
    ///为了图片和规格选择顺序对应 先进行排序
    widget.model.sku.sort((a,b)=>a.combineId.compareTo(b.combineId));
    _num = 1;
    _stringBuffer = StringBuffer();
    _skuDes = [];
    // widget.itemModels.forEach((element) {
    //   if(element.selected){
    //     _num = element.selectedNum;
    //     _sku = element.sku;
    //     _skuClicked(widget.model.sku.indexOf(_sku),_num);
    //   }
    // });



    ///将所有的规格图片存入
    widget.model.sku.forEach((element) {
      _photoList.add(element.picUrl);
      picSwiperItem.add(PicSwiperItem(Api.getImgUrl(element.picUrl)));

    });


    // bool hasPromotion = widget.model.data.promotion != null;
    // bool hasPromotion = true;
    num minPrice, maxPrice, maxCommission, minCommission;

    maxCommission = widget.model.price.max.commission;
    minCommission = widget.model.price.min.commission;

    // if (hasPromotion) {
    minPrice = widget.model.price.min.salePrice;
    maxPrice = widget.model.price.max.salePrice;
    // } else {
    // minPrice = widget.model.data.price.min.originalPrice;
    // maxPrice = widget.model.data.price.max.originalPrice;
    // }

    if (maxPrice == minPrice) {
      _price = maxPrice.toStringAsFixed(2);
    } else {
      _price = "${minPrice.toStringAsFixed(2)}-${maxPrice.toStringAsFixed(2)}";
    }

    if (maxCommission == minCommission) {
      _commission = maxCommission.toStringAsFixed(2);
    } else {
      _commission =
      "${minCommission.toStringAsFixed(2)}-${maxCommission.toStringAsFixed(2)}";
    }
  }

  @override
  void dispose() {
    super.dispose();
    // if(_sku!=null){
    //   widget.listener(
    //       WholesaleSkuChooseModel(2, _num, _sku, _skuDes.join("+")));
    // }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: _buildBody(context),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: DeviceInfo.bottomBarHeight == 0
              ? 20
              : DeviceInfo.bottomBarHeight),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.white),
      height: DeviceInfo.screenHeight * 0.8,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _header(context),
            Container(
              color: Colors.grey[300],
              height: 0.3,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            _plusMinusView(),
            _priceAndNum(),
            40.hb,
            _bottomBar(),
          ],
        ),
      ),
    );
  }



  _priceAndNum(){
    return Container(
      padding: EdgeInsets.only(left: 16.rw,right: 16.rw),
      child: _sku!=null&&haveSelected?Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '已选$_num件',

            style: AppTextStyle.generate(12.rsp,
                color: Color(0xFF666666)),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "商品金额：",
                  style: AppTextStyle.generate(12 * 2.sp,
                      color: Color(0xFF111111))),
              TextSpan(
                  text: "¥",
                  style: AppTextStyle.generate(16 * 2.sp,fontWeight: FontWeight.bold,
                      color: Color(0xFFD5101A))),
              TextSpan(
                text: "${(_num*_sku.salePrice).toStringAsFixed(2)}",
                style: AppTextStyle.generate(16 * 2.sp,fontWeight: FontWeight.bold,
                    color: Color(0xFFD5101A)),
              )
            ]),
          ),

        ],
      ):SizedBox(),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      height: rSize(110),
      padding: EdgeInsets.symmetric(vertical: 10.rw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomCacheImage(
            imageClick: () async{
              var data = await  AppRouter.fade(
                context,
                RouteName.PIC_SWIPER,
                arguments: PicSwiper.setArguments(
                  index: _sku==null?0: widget.model.sku.indexOf(_sku),
                  pics: picSwiperItem,
                ),
              );
              print(data);

            },
            width: rSize(100),
            height: rSize(100),
            fit: BoxFit.cover,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            imageUrl: _sku == null
                ? Api.getImgUrl(widget.model.mainPhotos[0].url)
                : Api.getImgUrl(_sku.picUrl),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),

              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _sku!=null?_sku.name: widget.model.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(16.rsp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  // Builder(
                  //   builder: (context) {
                  //     final skuNotNull =
                  //         _sku != null ;
                  //     return RichText(
                  //       text: TextSpan(children: [
                  //         TextSpan(
                  //           text:
                  //           "￥${_sku != null ? _sku.discountPrice.toStringAsFixed(2) : _price}",
                  //           // "￥ ${_sku.discountPrice}",
                  //           style: AppTextStyle.generate(18 * 2.sp,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.black),
                  //         ),
                  //       ]),
                  //     );
                  //   },
                  // ),
                  Container(
                    child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                "${_sku!=null?_sku.min:widget.model.price.min.min}",
                                // "￥ ${_sku.discountPrice}",
                                style: AppTextStyle.generate(12 * 2.sp,
                                    color: Color(0xFF666666)),
                              ),
                              TextSpan(
                                text:
                                "件起批",
                                // "￥ ${_sku.discountPrice}",
                                style: AppTextStyle.generate(12 * 2.sp,
                                    color: Color(0xFF666666)),
                              ),
                              TextSpan(
                                text:
                                "  本品按箱批发  ",
                                // "￥ ${_sku.discountPrice}",
                                style: AppTextStyle.generate(12 * 2.sp,
                                    color: Color(0xFF666666)),
                              ),
                              TextSpan(
                                text:
                                "一箱=${_sku!=null?_sku.limit:widget.model.price.min.limit}件",
                                // "￥ ${_sku.discountPrice}",
                                style: AppTextStyle.generate(12 * 2.sp,
                                    color: Color(0xFF666666)),
                              ),
                            ]),
                          ),
                  ),
                  Text(
                    "批发价 ¥${_sku!=null?_sku.salePrice:_price}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(14 * 2.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD5101A)),
                  )
                ],
              ),
            ),

          ),
          CustomImageButton(
            icon: Icon(
              AppIcons.icon_cancle_circle,
              size: 18,
            ),
            padding: EdgeInsets.all(5),
            color: Colors.grey[500],
            onPressed: () {
              Navigator.maybePop(context);
            },
          )
        ],
      ),
    );
  }

  Expanded _plusMinusView() {
    return Expanded(
        child: WholesaleSelectedList(
          data: widget.itemModels,
          listener: ( int index,int goodsNum) {
            _skuClicked( index,goodsNum);
          },
        ));
  }

  Container _bottomBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: CustomImageButton(
              title: "加入购物车",
              color: Colors.white,
              height: 40,
              boxDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xff979797), Color(0xff5d5e5d)]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              fontSize: 16 * 2.sp,
              onPressed: () {
                if (_sku == null) {
                  Toast.showInfo('请先选择规格',
                      color: Colors.black87);
                  return;
                }
                if (widget.listener != null) {
                  widget.listener(
                      WholesaleSkuChooseModel(0, _num, _sku, _skuDes.join("-")));
                }
              },
            ),
          ),
          Container(
            width: 2,
          ),
          Expanded(
            child: CustomImageButton(
              title: "立即购买",
              color: Colors.white,
              height: 40,
              boxDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xffc81a3e), Color(0xfffa4968)]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              fontSize: 16 * 2.sp,
              onPressed: () {
                if (_sku == null) {
                  Toast.showInfo('请先选择规格', color: Colors.black);
                  return;
                }

                if (widget.listener != null) {
                  widget.listener(
                      WholesaleSkuChooseModel(1, _num, _sku, _skuDes.join("+")));

                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _skuClicked(int index,int goodsNum) {
     _sku = widget.itemModels[index].sku;
     _num = goodsNum;
     haveSelected = false;
     for(int i=0;i<widget.itemModels.length;i++){
       if(widget.itemModels[i].selected){
         haveSelected = true;
         widget.itemModels[i].selectedNum = _num;
       }
     }
     if(mounted)
       setState(() {

       });
    print(index);
  }
}
class WholesaleSkuChooseModel {
  int selectedIndex;
  int num;
  WholesaleSku sku;
  String des;

  WholesaleSkuChooseModel(this.selectedIndex, this.num, this.sku, this.des);
}
