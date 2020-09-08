/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-12  13:39 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/order_prepay_model.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/models/self_pickup_store_list_model.dart';
import 'package:recook/pages/home/classify/mvp/order_mvp/order_presenter_impl.dart';
import 'package:recook/pages/home/classify/order_prepay_page.dart';
import 'package:recook/pages/home/items/goods_item_order.dart';
import 'package:recook/pages/user/address/receiving_address_page.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/bottom_sheet/bottom_list.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';

class GoodsOrderPage extends StatefulWidget {
  final Map arguments;

  const GoodsOrderPage({Key key, this.arguments}) : super(key: key);

  static setArguments(OrderPreviewModel model) {
    return {"order": model};
  }

  @override
  State<StatefulWidget> createState() {
    return _GoodsOrderPageState();
  }
}

class _GoodsOrderPageState extends BaseStoreState<GoodsOrderPage> {
  OrderPreviewModel _orderModel;
  OrderPresenterImpl _presenterImpl;
  ScrollController _controller;

  TextEditingController _editController;
  FocusNode _focusNode = FocusNode();
  List<SelfPickupStoreModel> _storeList;
  String _selectedStoreName;

  @override
  void initState() {
    super.initState();
    _orderModel = widget.arguments["order"];
    _presenterImpl = OrderPresenterImpl();
    _controller = ScrollController();
    _controller.addListener(() {});
    _editController =
        TextEditingController(text: _orderModel.data.buyerMessage);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        String text = _editController.text;
        if (text == _orderModel.data.buyerMessage) {
          return;
        }
        _changeBuyerMessage(text);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _editController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    // int totalNum = 0;
    // _orderModel.data.brands.forEach((brand) {
    //   brand.goods.forEach((goods) {
    //     totalNum += goods.quantity;
    //   });
    // });
    return Scaffold(
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: CustomAppBar(
        elevation: 0,
        title: "确认订单",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragDown: (detail) {
                if (globalContext != null) {
                  FocusScope.of(globalContext).requestFocus(FocusNode());
                }
              },
              child: CustomScrollView(
                controller: _controller,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _orderModel.data.shippingMethod == 1
                        ? Container(
                            height: 10,
                          )
                        : _buildAddress(context),
                    // child: _buildAddress(context),
                  ),
                  SliverToBoxAdapter(
                    child: _otherTiles(),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return GoodsOrderItem(
                      brand: _orderModel.data.brands[index],
                      shippingMethod: _orderModel.data.shippingMethod,
                    );
                  }, childCount: _orderModel.data.brands.length)),
                  // SliverToBoxAdapter(
                  //   child: _allAmountTitle(),
                  // ),
                  SliverToBoxAdapter(
                    child: _coinTile(),
                  ),
                  SliverToBoxAdapter(
                    child: _bottomInfoTitle(),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 80 + MediaQuery.of(context).viewPadding.bottom,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: _bottomBar(context, _orderModel.data.totalGoodsCount),
        ),
      ],
    );
  }

  _buildAddress(BuildContext context) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE,
                arguments: ReceivingAddressPage.setArguments(
                    canBack: true, addr: _orderModel.data.addr))
            .then((address) {
          DPrint.printf(address.runtimeType);
          if (address != null && address is Address) {
//            if (_orderModel.data.addr != null && address.id == _orderModel.data.addr.addressId) return;
            _changeAddress(address);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(rSize(13)),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        constraints: BoxConstraints(minHeight: 70),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5, right: 10),
              child: Image.asset(
                AppImageName.address_icon,
                width: 40,
                height: 40,
              ),
              // child: Icon(AppIcons.icon_address)
            ),
            Expanded(child: _addressView()),
            Icon(
              AppIcons.icon_next,
              size: rSize(16),
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  _addressView() {
    return _orderModel.data.addr == null
        ? Text(
            "请先选择地址",
            style: AppTextStyle.generate(15),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                  text: TextSpan(
                      text: _orderModel.data.addr.receiverName,
                      style:
                          AppTextStyle.generate(ScreenAdapterUtils.setSp(15)),
                      children: [
                    TextSpan(
                        text: "   ${_orderModel.data.addr.mobile}",
                        style: AppTextStyle.generate(
                            ScreenAdapterUtils.setSp(14),
                            color: Colors.grey))
                  ])),
              Container(
                margin: EdgeInsets.only(top: ScreenAdapterUtils.setSp(8)),
                child: Text(
                  TextUtils.isEmpty(_orderModel.data.addr.address)
                      ? "空地址"
                      : _orderModel.data.addr.province +
                          _orderModel.data.addr.city +
                          _orderModel.data.addr.district +
                          _orderModel.data.addr.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                      fontWeight: FontWeight.w300),
                ),
              ),
              Offstage(
                offstage: !(_orderModel.data.addr.isDeliveryArea == 0),
                child: Container(
                  margin: EdgeInsets.only(top: rSize(6)),
                  child: Text(
                    "当前地址不支持快递发货",
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(12),
                        color: Colors.red, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          );
  }

  _otherTiles() {
    String shippingMethod = "门店自提";
    if (_orderModel.data.shippingMethod == 0) {
      shippingMethod = "快递配送";
    }
    return Container(
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: rSize(6)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          // _couponTile(),
          _expressTile("配送方式", shippingMethod, needArrow: false, listener: () {
            // ActionSheet.show(globalContext, items: ["快递配送", "门店自提"], listener: (int index) {
            //   Navigator.pop(globalContext);
            //   print("------- $index");
            //   if (index == _orderModel.data.shippingMethod) {
            //     return;
            //   }
            //   if (index == 0) {
            //     _changeShippingMethod(0, 0, "");
            //   } else {
            //     _selectedSelfPickupStore();
            //   }
            // });
          }),
          Offstage(
            offstage: _orderModel.data.shippingMethod == 0,
            child: _expressTile(
                "附近门店",
                TextUtils.isEmpty(_selectedStoreName)
                    ? "请选择自提门店"
                    : _selectedStoreName, listener: () {
              _selectedSelfPickupStore();
            }),
          ),
          _tileInput("买家留言", "选填"),
        ],
      ),
    );
  }

  _couponTile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8)),
      child: Row(
        children: <Widget>[
          Image.asset(
            AppImageName.coupon_common,
            width: ScreenAdapterUtils.setWidth(rSize(60)),
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: rSize(8)),
                  child: Text(
                    _orderModel.data.coupon == null
                        ? "暂无优惠券"
                        : _orderModel.data.coupon.couponName,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                        color: Color(0xff373737)),
                    // style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                    //     fontWeight: FontWeight.w300, color: Colors.grey[700]),
                    textAlign: TextAlign.end,
                  ))),
//          Icon(
//            AppIcons.icon_next,
//            size: rSize(14),
//            color: Colors.grey,
//          )
        ],
      ),
    );
  }

  _expressTile(String title, String value,
      {Widget customTitle, VoidCallback listener, bool needArrow = true}) {
    return GestureDetector(
      onTap: listener,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: rSize(8)),
        child: Row(
          children: <Widget>[
            customTitle ??
                Container(
                    width: rSize(80),
                    child: Text(
                      title,
                      style: AppTextStyle.generate(
                          ScreenAdapterUtils.setSp(13.5),
                          fontWeight: FontWeight.w400),
                    )),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                    color: Colors.grey[600], fontWeight: FontWeight.w300),
              ),
            ),
            Offstage(
                offstage: !needArrow,
                child: Icon(
                  AppIcons.icon_next,
                  size: rSize(14),
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    );
  }

  _tileInput(String title, String hint) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8)),
      child: Row(
        children: <Widget>[
          Container(
              width: rSize(80),
              child: Text(
                title,
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                    fontWeight: FontWeight.w400),
              )),
          Expanded(
            child: InputView(
              showClear: false,
              padding: EdgeInsets.zero,
              textStyle: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                  color: Colors.grey[600], fontWeight: FontWeight.w300),
              hintStyle: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                  color: Colors.grey[600], fontWeight: FontWeight.w300),
              controller: _editController,
              focusNode: _focusNode,
              maxLength: 50,
              maxLines: 1,
              hint: hint,
              onValueChanged: (text) {
                // if (text == _orderModel.data.buyerMessage) {
                //   return;
                // }
                // _changeBuyerMessage(text);
              },
              onInputComplete: (String text) {
                // if (text == _orderModel.data.buyerMessage) {
                //   return;
                // }
                // _changeBuyerMessage(text);
              },
            ),
          ),
        ],
      ),
    );
  }

  _coinTile() {
    // String text = _orderModel.data.coinTotalAmount > 0
    // ? "可用 ${(_orderModel.data.coinTotalAmount * 100).toInt()} 瑞币抵扣 ${_orderModel.data.coinTotalAmount} 元"
    // : "瑞币抵扣0元";
    // _orderModel.data.coupon = null;
    return Container(
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: rSize(6)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          _titleRow("优惠券", "已选择最大优惠",
              "-￥${(_orderModel.data.brandCouponTotalAmount + _orderModel.data.universeCouponTotalAmount).toStringAsFixed(2)}"),
          Container(
            height: 5,
          ),
          _titleRow("瑞币抵扣", "",
              "本单抵扣: ￥${_orderModel.data.coinTotalAmount.toStringAsFixed(2)}",
              rightTitleColor: Colors.black,
              switchValue: _orderModel.data.coinStatus.isUseCoin,
              switchEnable: _orderModel.data.coinStatus.isEnable,
              switchChange: (change) {
            // 切换瑞币抵扣状态
            _changeOrderCoinOnOff();
          }),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }

  _bottomInfoTitle() {
    return Container(
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: rSize(6)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          _titleRow("商品金额", "",
              "￥${_orderModel.data.goodsTotalAmount.toStringAsFixed(2)}",
              rightTitleColor: Colors.black),
          _titleRow("运费", "",
              "+￥${_orderModel.data.expressTotalFee.toStringAsFixed(2)}",
              rightTitleColor: Colors.black),
          _titleRow(
            "优惠券",
            "",
            "-￥${(_orderModel.data.universeCouponTotalAmount + _orderModel.data.brandCouponTotalAmount).toStringAsFixed(2)}",
          ),
          _titleRow("瑞币抵扣", "",
              "-￥${_orderModel.data.coinTotalAmount.toStringAsFixed(2)}"),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }

  _titleRow(title, subTitle, rightTitle,
      {titleColor,
      subTitleColor,
      rightTitleColor,
      Function(bool) switchChange,
      bool switchValue = false,
      bool switchEnable = false}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // height: 55,
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              child: Text(
                title,
                style: titleColor != null
                    ? AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                        color: titleColor, fontWeight: FontWeight.w400)
                    : AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                        fontWeight: FontWeight.w400),
              )),
          Expanded(
            child: Text(
              subTitle,
              maxLines: 1,
              style: subTitleColor != null
                  ? AppTextStyle.generate(ScreenAdapterUtils.setSp(12),
                      color: subTitleColor, fontWeight: FontWeight.w300)
                  : AppTextStyle.generate(ScreenAdapterUtils.setSp(12),
                      color: Color.fromARGB(255, 249, 62, 13),
                      fontWeight: FontWeight.w300),
            ),
          ),
          Container(
              child: Text(
            rightTitle,
            style: rightTitleColor != null
                ? TextStyle(
                    fontSize: ScreenAdapterUtils.setSp(13.5),
                    fontWeight: FontWeight.w400,
                    color: rightTitleColor)
                : TextStyle(
                    fontSize: ScreenAdapterUtils.setSp(13.5),
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 249, 62, 13)),
          )),
          switchChange == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 5),
                  child: CupertinoSwitch(
                      activeColor: AppColor.priceColor,
                      value: switchValue,
                      onChanged: !switchEnable
                          ? null
                          : (change) => switchChange(change)),
                ),
          Container(
            width: 5,
          ),
        ],
      ),
    );
  }

  _allAmountTitle() {
    return Container(
      height: 55,
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: rSize(6)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          Container(
              child: Text(
            "小计  ",
            style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                fontWeight: FontWeight.w400),
          )),
          Expanded(
            child: Text(
              "(共${_orderModel.data.totalGoodsCount}件)",
              maxLines: 1,
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                  color: Colors.grey[600], fontWeight: FontWeight.w300),
            ),
          ),
          Container(
              child: Text(
            "￥${_orderModel.data.goodsTotalAmount.toStringAsFixed(2)}",
            style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 249, 62, 13)),
          )),
          Container(
            width: 5,
          ),
        ],
      ),
    );
  }

  Container _bottomBar(BuildContext context, int totalNum) {
    // bool canDeliver = _orderModel.data.addr?.isDeliveryArea == 1 ||
    // (_orderModel.data.addr?.isDeliveryArea == 0 && _orderModel.data.shippingMethod == 1);
    bool canDeliver = _orderModel.data.addr?.isDeliveryArea == 1 ||
        (_orderModel.data.shippingMethod == 1);
    double ruiCoin = 0;
    _orderModel.data.brands.forEach((brand) {
      brand.goods.forEach((good) {
        ruiCoin += good.totalCommission;
      });
    });
    Container bottomWidget = Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppConfig.getShowCommission()
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  color: Color(0xFFf3b5b8).withOpacity(0.95),
                  child: Text(
                    '共赚 ${ruiCoin.toStringAsFixed(2)} 瑞币',
                    style: AppTextStyle.generate(
                      ScreenAdapterUtils.setSp(13),
                      color: Color.fromARGB(255, 249, 62, 13),
                    ),
                  ),
                )
              : SizedBox(),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: SafeArea(
              bottom: true,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        // text: "共$totalNum件,",
                        style: AppTextStyle.generate(
                            ScreenAdapterUtils.setSp(14),
                            color: Colors.grey[600]),
                        children: [
                          TextSpan(
                              text: "应付金额: ",
                              style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(15),
                              )),
                          TextSpan(
                              text: "￥${_orderModel.data.actualTotalAmount}",
                              style: AppTextStyle.generate(
                                ScreenAdapterUtils.setSp(16),
                                color: Color.fromARGB(255, 249, 62, 13),
                              )),
                        ]),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: rSize(14)),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        gradient: !canDeliver
                            ? const LinearGradient(colors: [
                                AppColor.tableViewGrayColor,
                                AppColor.tableViewGrayColor,
                              ])
                            : const LinearGradient(colors: [
                                Color.fromARGB(255, 249, 117, 10),
                                Color.fromARGB(255, 249, 67, 7),
                              ])),
                    child: CustomImageButton(
                      padding: EdgeInsets.symmetric(
                          vertical: rSize(4), horizontal: rSize(25)),
                      title: "提交订单",
                      color: Colors.white,
                      disabledColor: Colors.grey[600],
                      fontSize: ScreenAdapterUtils.setSp(14),
                      onPressed: !canDeliver
                          ? null
                          : () {
                              _submit(context);
                            },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (_orderModel != null &&
        _orderModel.data.goodsTotalCommission > 0 &&
        _orderModel.data.userRole > 0) {
      return Container(
        height: kToolbarHeight + 30 + ScreenUtil.bottomBarHeight,
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              alignment: Alignment.center,
              color: Color.fromARGB(255, 250, 231, 235),
              child: Text(
                "下单可返￥${_orderModel.data.goodsTotalCommission}",
                style: TextStyle(
                    color: Colors.red, fontSize: ScreenAdapterUtils.setSp(11)),
              ),
            ),
            bottomWidget,
          ],
        ),
      );
    } else {
      return bottomWidget;
    }
  }

  _getStoreList(int method) async {
    HttpResultModel<SelfPickupStoreListModel> model =
        await _presenterImpl.getStoreList();
    if (!model.result) {
      GSDialog.of(context).showError(globalContext, model.msg);
      return;
    }
    _storeList = model.data.data;
    _selectedSelfPickupStore();
  }

  _selectedSelfPickupStore() {
    if (_storeList == null) {
      _getStoreList(1);
      return;
    }
    DPrint.printf("${_storeList.length}");
    BottomList.show<SelfPickupStoreModel>(globalContext,
        title: "请选择自提门店",
        data: _storeList, itemBuilder: (int index, SelfPickupStoreModel model) {
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(
          horizontal: rSize(15),
          vertical: rSize(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              model.name,
              style: AppTextStyle.generate(13),
            ),
            Text(
              model.address,
              style: AppTextStyle.generate(11),
            ),
          ],
        ),
      );
    }, clickListener: (int index, SelfPickupStoreModel model) {
      _changeShippingMethod(1, model.id, model.name);
    });
  }

  _changeAddress(Address address) async {
    GSDialog.of(context).showLoadingDialog(context, "");
    HttpResultModel<OrderPreviewModel> model =
        await _presenterImpl.changeAddress(
            UserManager.instance.user.info.id, _orderModel.data.id, address.id);
    GSDialog.of(context).dismiss(context);
    if (!model.result) {
      GSDialog.of(context).showError(globalContext, model.msg);
      return;
    }
    _orderModel = model.data;
    setState(() {});
  }

  _changeOrderCoinOnOff() async {
    GSDialog.of(context).showLoadingDialog(context, "");
    HttpResultModel<OrderPreviewModel> model =
        await _presenterImpl.changeCoinOnOff(
      UserManager.instance.user.info.id,
      _orderModel.data.id,
    );
    GSDialog.of(context).dismiss(context);
    if (!model.result) {
      GSDialog.of(context).showError(globalContext, model.msg);
      return;
    }
    _orderModel = model.data;
    setState(() {});
  }

  // _changeAddressWithShippingMethod(int id) async {
  //   GSDialog.of(context).showLoadingDialog(context, "");
  //   HttpResultModel<OrderPreviewModel> model = await _presenterImpl.changeAddress(
  //       UserManager.instance.user.info.id, _orderModel.data.id, id);
  //   GSDialog.of(context).dismiss(context);
  //   if (!model.result) {
  //     GSDialog.of(context).showError(globalContext, model.msg);
  //     return;
  //   }
  //   _orderModel = model.data;
  //   setState(() {});
  // }
  _changeShippingMethod(int method, int storeId, String name) async {
    if (method == 1 && name == _selectedStoreName) {
      return;
    }
    GSDialog.of(context).showLoadingDialog(context, "");
    HttpResultModel<OrderPreviewModel> resultModel =
        await _presenterImpl.changeShippingMethod(
            UserManager.instance.user.info.id,
            _orderModel.data.id,
            method,
            storeId);
    GSDialog.of(context).dismiss(context);
    if (!resultModel.result) {
      GSDialog.of(context).showError(globalContext, resultModel.msg);
      return;
    }
    _orderModel = resultModel.data;
    if (method == 1) {
      _selectedStoreName = name;
    } else {
      _selectedStoreName = "";
    }
    setState(() {});
    //同步更改收货地址
    // _changeAddressWithShippingMethod(storeId);
  }

  _changeBuyerMessage(String msg) async {
    GSDialog.of(context).showLoadingDialog(context, "");
    HttpResultModel<BaseModel> resultModel =
        await _presenterImpl.changeBuyerMessage(
            UserManager.instance.user.info.id, _orderModel.data.id, msg);
    // GSDialog.of(context).dismiss(context);
    GSDialog.of(context).dismiss(context);
    if (!resultModel.result) {
      GSDialog.of(context).showError(globalContext, resultModel.code);
      return;
    }
    _orderModel.data.buyerMessage = msg;
  }

  _submit(BuildContext context) async {
    GSDialog.of(context).showLoadingDialog(context, "");
    HttpResultModel<OrderPrepayModel> resultModel = await _presenterImpl
        .submitOrder(_orderModel.data.id, UserManager.instance.user.info.id);
    GSDialog.of(context).dismiss(context);
    if (!resultModel.result) {
      GSDialog.of(context).showError(context, resultModel.msg);
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    UserManager.instance.refreshShoppingCartNumber.value = true;
    AppRouter.pushAndReplaced(context, RouteName.ORDER_PREPAY_PAGE,
        arguments:
            OrderPrepayPage.setArguments(resultModel.data, goToOrder: true));
  }
}
