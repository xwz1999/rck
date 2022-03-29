import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/models/shopping_cart_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_like_grid.dart';
import 'package:jingyaoyun/pages/shopping_cart/function/shopping_cart_fuc.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_detail_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholeasale_detail_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_car_item.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_order_preview_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_sku_choose_page.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'models/goods_dto.dart';
import 'models/wholesale_car_model.dart';
import 'models/wholesale_good_model.dart';
import 'models/wholesale_order_preview_model.dart';
import 'more_goods/whoesale_goods_grid.dart';

class WholesaleCarPage extends StatefulWidget {
  final bool canBack;
  WholesaleCarPage({
    Key key, this.canBack ,
  }) : super(key: key);

  @override
  _WholesaleCarPageState createState() => _WholesaleCarPageState();
}

class _WholesaleCarPageState extends State<WholesaleCarPage>{
  bool _manageStatus = false;//是否进入删除商品的状态
  bool _checkAll = false;//全选
  bool _editting = false;
  GSRefreshController _refreshController;
  List<WholesaleCarModel> _selectedGoods = [];
  List<WholesaleGood> _likeGoodsList = [];

  List<WholesaleCarModel> _carList = [];
  StateSetter _bottomStateSetter;
  int _totalNum = 0;
  bool _canback = false;
  bool _onLoad = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    if(widget.canBack!=null){
      _canback = widget.canBack;
    }
    _refreshController = GSRefreshController(initialRefresh: true);
    Future.delayed(Duration.zero, () async {
      _carList =  await WholesaleFunc.getCarList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: _canback? RecookBackButton():null,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.menu),
            // ),
            32.wb,
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  child: Row(
                    children: [
                      Text(
                        "进货单",
                        style: TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 20.rsp,
                        ),

                      ),
                      Text(
                        " ($_totalNum)",
                        style: TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 15.rsp,
                        ),

                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
        elevation: 0,
        actions: [
          CustomImageButton(
            padding: EdgeInsets.only(right: rSize(10), top: rSize(5)),
            title: !_manageStatus ? "管理" : "完成",
            color: Color(0xFF666666),
            fontSize: 14 * 2.sp,
            onPressed: () {
              if (_editting) {
                FocusScope.of(context).requestFocus(FocusNode());
                return;
              }
              //切换管理状态  重置所以数据到原始数据
              for (WholesaleCarModel _brandModel
              in _carList) {
                _brandModel.selected = false;
                // for (ShoppingCartGoodsModel _goodsModel
                // in _brandModel.children) {
                //   _goodsModel.selected = false;
                // }
              }
              _checkAll = false;
              _selectedGoods.clear();
              _manageStatus = !_manageStatus;
              setState(() {});
            },
          )
        ],

      ),
      body:  _bodyWidget(),

      bottomNavigationBar: _bottomTool() ,
    );
  }

  _bodyWidget() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
         _carList =  await WholesaleFunc.getCarList();
         _likeGoodsList = await WholesaleFunc.getLikeGoodsList(UserManager.instance.user.info.id,isSale: true);
         _checkAll = false;
         _selectedGoods.clear();
         _totalNum = 0;
         _totalNum = _carList.length;
         _onLoad = false;
         if(mounted){
           setState(() {

           });
         }

        _refreshController.refreshCompleted();
      },

      body:
      _onLoad?SizedBox():
      _carList.isNotEmpty?ListView.builder(
          itemBuilder: (context, index) {
            if(index==0){
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    WholesaleCarItem(
                      isEdit: _manageStatus,
                      //isEdit: true,
                      model: _carList[index],
                      selectedListener: (WholesaleCarModel goods) {

                        bool goodsSelected = goods.selected;
                        if(goodsSelected){

                          _selectedGoods.clear();
                          _selectedGoods.add(goods);

                          _carList.forEach((element) {
                            element.selected = false;
                          });
                          goods.selected = true;
                        }else{
                          _carList.forEach((element) {
                            element.selected = false;
                          });
                          _selectedGoods.clear();
                        }

                        if (_selectedGoods.length == _totalNum) {
                          _checkAll = true;
                        } else {
                          _checkAll = false;
                        }
                        setState(() {

                        });
                      },
                      clickListener: (WholesaleCarModel goods) {
                        if (_editting) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          return;
                        }
                        Get.to(()=>WholesaleDetailPage(goodsId: goods.goodsId,))


                            .then((onValue) async {
                          _carList =  await WholesaleFunc.getCarList();
                          setState(() {

                          });
                        });
                      },
                      onBeginInput: (value) {
                        _editting = true;
                      },
                      numUpdateCompleteCallback: (goods, num) {
                        _editting = false;
                        List<GoodsDTO> list = [];
                        list.add(GoodsDTO(skuId:goods.skuId,quantity:num));
                        goods.quantity = num;
                        WholesaleFunc.UpdateShopCar(list);
                        setState(() {

                        });
                      },
                    ),
                    _likeGoodsList.isNotEmpty ? _buildLikeWidget() : SizedBox(),
                  ],
                )
              );
            }else if((index == _carList.length-1)) {
              return Column(
                children: [
                  WholesaleCarItem(
                    isEdit: _manageStatus,
                    //isEdit: true,
                    model: _carList[index],
                    selectedListener: (WholesaleCarModel goods) {

                      bool goodsSelected = goods.selected;
                      if(goodsSelected){

                        _selectedGoods.clear();
                        _selectedGoods.add(goods);

                        _carList.forEach((element) {
                          element.selected = false;
                        });
                        goods.selected = true;
                      }else{
                        _carList.forEach((element) {
                          element.selected = false;
                        });
                        _selectedGoods.clear();
                      }

                      if (_selectedGoods.length == _totalNum) {
                        _checkAll = true;
                      } else {
                        _checkAll = false;
                      }
                      setState(() {

                      });
                    },
                    clickListener: (WholesaleCarModel goods) {
                      if (_editting) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        return;
                      }
                      Get.to(()=>WholesaleDetailPage(goodsId: goods.goodsId,))
                          .then((onValue) async {
                        _carList =  await WholesaleFunc.getCarList();
                        setState(() {

                        });
                      });
                    },
                    onBeginInput: (value) {
                      _editting = true;
                    },
                    numUpdateCompleteCallback: (goods, num) {
                      _editting = false;
                      List<GoodsDTO> list = [];
                      list.add(GoodsDTO(skuId:goods.skuId,quantity:num));
                      goods.quantity = num;
                      WholesaleFunc.UpdateShopCar(list);
                      setState(() {

                      });
                    },
                  ),
                  _likeGoodsList.isNotEmpty ? _buildLikeWidget() : SizedBox(),
                ],
              );
            }else{
              return WholesaleCarItem(
                isEdit: _manageStatus,
                //isEdit: true,
                model: _carList[index],
                selectedListener: (WholesaleCarModel goods) {

                  bool goodsSelected = goods.selected;
                  if(goodsSelected){

                    _selectedGoods.clear();
                    _selectedGoods.add(goods);

                    _carList.forEach((element) {
                      element.selected = false;
                    });
                    goods.selected = true;
                  }else{
                    _carList.forEach((element) {
                      element.selected = false;
                    });
                    _selectedGoods.clear();
                  }

                  if (_selectedGoods.length == _totalNum) {
                    _checkAll = true;
                  } else {
                    _checkAll = false;
                  }
                  setState(() {

                  });
                },
                clickListener: (WholesaleCarModel goods) {
                  if (_editting) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    return;
                  }
                  Get.to(()=>WholesaleDetailPage(goodsId: goods.goodsId,))
                      .then((onValue) async {
                    _carList =  await WholesaleFunc.getCarList();
                    setState(() {

                    });
                  });
                },
                onBeginInput: (value) {
                  _editting = true;
                },
                numUpdateCompleteCallback: (goods, num) {
                  _editting = false;
                  List<GoodsDTO> list = [];
                  list.add(GoodsDTO(skuId:goods.skuId,quantity:num));
                  goods.quantity = num;
                  WholesaleFunc.UpdateShopCar(list);
                  setState(() {

                  });
                },
              );
            }

          },
          itemCount: _carList.length,
        ):noDataView("购物车是空的~快去逛逛吧"),

            // :noDataView('没有申请记录...'),
    );
  }

  noDataView(String text, {Widget icon}) {
    return ListView(
      //height: double.infinity,
      children: <Widget>[
        100.hb,
        icon ??
            Image.asset(
              R.ASSETS_NODATA_PNG,
              width: rSize(80),
              height: rSize(80),
            ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
        ),

        SizedBox(
          height: rSize(30),
        ),
        _likeGoodsList.isNotEmpty ? _buildLikeWidget() : SizedBox(),
      ],
    );
  }

  _buildLikeTitle() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          20.wb,
          Text(
            '您可能还喜欢',
            style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
          ),
          20.wb,
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
        ],
      ),
    );
  }

  _buildLikeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.rw),
      //height: _likeGoodsList?.length * 381.rw / 2,
      width: double.infinity,
      child: Column(
        children: [
          35.hb,
          _buildLikeTitle(),
          50.hb,
          WaterfallFlow.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
              physics: NeverScrollableScrollPhysics(),
              itemCount: _likeGoodsList?.length,
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                WholesaleGood goods = _likeGoodsList[index];

                return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(()=>WholesaleDetailPage(goodsId: goods.id,));

                    },
                    child: WholesaleGoodsGrid(goods: goods,));
              }),
          40.hb,
          // Container(
          //   alignment: Alignment.center,
          //   child: Text(
          //     '已经到底啦~',
          //     style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
          //   ),
          // ),
        ],
      ),
    );
  }

  _bottomTool() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter bottomSetState) {
        double totalPrice = 0;

        _selectedGoods.forEach((goods) {
          totalPrice += goods.salePrice * goods.quantity;
        });
        _bottomStateSetter = bottomSetState;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(8)),
          color: Colors.white,
          height: rSize(65),
          child:  _bottomBarChildren(totalPrice,
                ),

        );
      },
    );
  }

  _bottomBarChildren(totalPrice,) {
    return Row(
      children: [
        _manageStatus?_checkAllButton():SizedBox(),
        Spacer(),
        !_manageStatus?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: "合计: ",
                    style: AppTextStyle.generate(14 * 2.sp,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: "¥",
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "${totalPrice.toStringAsFixed(2)}",
                          style:
                          AppTextStyle.generate(22 * 2.sp, color: Color(0xffc70404),fontWeight: FontWeight.bold))
                    ])),
          ],
        ):SizedBox(),

        !_manageStatus?10.wb:SizedBox(),
        !_manageStatus?_settlementButton():SizedBox(),
        _manageStatus?_deleteButton():SizedBox(),

      ],
    );
  }

  CustomImageButton _checkAllButton() {
    ///每个订单只能有一个商品 所有编辑状态下才有全选操作
    return CustomImageButton(
      direction: Direction.horizontal,
      title: "全选",
      fontSize: 14 * 2.sp,
      color: Colors.grey[700],
      icon: Icon(
        !_checkAll ? AppIcons.icon_circle : AppIcons.icon_check_circle,
        color: _checkAll ? AppColor.themeColor : Colors.grey,
        size: rSize(18),
      ),
      contentSpacing: rSize(5),
      onPressed: () {
        if (_editting) {
          FocusScope.of(context).requestFocus(FocusNode());
          return;
        }
        _checkAll = !_checkAll;
        _selectedGoods.clear();
        // 如果是编辑状态 可以选中所以
        // 如果不是编辑状态 只能选中未下架的商品
        _carList.forEach((brand) {
          if(brand.salePublish!=0){
            if(_checkAll){
              _selectedGoods.add(brand);
            }

            brand.selected = _checkAll;
          }

          // brand.children.forEach((goods) {
          //   if (_checkAll) {
          //     if(goods.publishStatus!=0){//判断是否下架
          //
          //     }
          //   }
          //   goods.selected = _checkAll;
          // });
        });
        setState(() {});
      },
    );
  }

  Widget _deleteButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(3)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          gradient: const LinearGradient(colors: [
            Color(0xFFE05346),
            Color(0xFFDB1E1E),
          ])),
      child: CustomImageButton(
        title: "删除(${_selectedGoods.length})",
        padding:
        EdgeInsets.symmetric(vertical: rSize(9), horizontal: rSize(23)),
        color: Colors.white,
        fontSize: 16 * 2.sp,
        onPressed: () {
          if (_editting) {
            FocusScope.of(context).requestFocus(FocusNode());
            return;
          }
          if (_selectedGoods.length == 0) {
            Toast.showInfo("您还没有选择商品");
            return;
          }
          Alert.show(
              context,
              NormalTextDialog(
                content: "确认将这${_selectedGoods.length}个宝贝删除?",
                items: ["我在想想"],
                listener: (int index) {
                  Alert.dismiss(context);
                },
                type: NormalTextDialogType.delete,
                deleteListener: () {
                  List<GoodsDTO> list = [];
                  _selectedGoods.forEach((element) {
                    list.add(GoodsDTO(skuId:element.skuId,quantity:element.quantity));
                  });
                  WholesaleFunc.deleteShopCart(list);
                  _refreshController.requestRefresh();
                  Alert.dismiss(context);
                },
              ));
        },
      ),
    );
  }

  Container _settlementButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(3)),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          gradient: const LinearGradient(colors: [
            Color(0xFFE05346),
            Color(0xFFDB1E1E),
          ])),
      child: CustomImageButton(
        padding:
        EdgeInsets.symmetric(vertical: rSize(9), horizontal: rSize(23)),
        title: "结算(${_selectedGoods.length})",
        color: Colors.white,
        fontSize: 16 * 2.sp,
        onPressed: () {
          if (_selectedGoods.length == 0) {
            Toast.showInfo("您还没有选择商品");
            return;
          }
          _createOrder(_selectedGoods[0].skuId,_selectedGoods[0].quantity);
        },
      ),
    );
  }

  Future<dynamic> _createOrder(int skuId,int num) async {
    List<GoodsDTO> list = [];
    list.add(GoodsDTO(skuId:skuId,quantity:num));
    WholesaleOrderPreviewModel order = await WholesaleFunc.createOrderPreview(
      list,
      0,
    );
    if (order==null) {
      Get.back();
      return;
    }else
    {

      AppRouter.push(context, RouteName.WHOLESALE_GOODS_ORDER_PAGE,
          arguments: WholesaleGoodsOrderPage.setArguments(order));

      // Get.to(()=>WholesaleGoodsOrderPage(model: order,));
    }

  }

}