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
import 'package:recook/pages/home/items/oversea_accept_license_page.dart';
import 'package:recook/pages/user/address/receiving_address_page.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/bottom_sheet/bottom_list.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/toast.dart';

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

  bool _accept = false;

  ///瑞币抵扣按钮是否可以点击
  bool switchEnabled = true;

  @override
  void initState() {
    super.initState();
    _orderModel = widget.arguments["order"];
    _presenterImpl = OrderPresenterImpl();
    _controller = ScrollController();
    _controller.addListener(() {});
    _editController =
        TextEditingController(text: _orderModel.data?.buyerMessage ?? '');
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        String text = _editController.text;
        if (text == _orderModel.data.buyerMessage) {
          return;
        }
        _changeBuyerMessage(text);
      }
    });
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted)
        _changeOrderCoinOnOff().then((_) {
          if (_orderModel.data.addr.isDeliveryArea == 0) {
            _canNotDeliver();
          }
        });
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
                    child: _orderModel.data.hasAuth
                        ? UserManager.instance.user.info.realInfoStatus
                            ? SizedBox()
                            : CustomImageButton(
                                onPressed: () {
                                  AppRouter.push(
                                    context,
                                    RouteName.USER_VERIFY,
                                    arguments: {},
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 243, 203, 1),
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(100),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(
                                      0, rSize(10), rSize(13), 0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        R.ASSETS_ORDER_ALERT_PNG,
                                        width: rSize(20),
                                        height: rSize(20),
                                      ),
                                      rWBox(10),
                                      Expanded(
                                        child: Text(
                                          '海关提醒：跨境订单订购人和支付人信息不一致，可能会影响订单通关，请务必认证！',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(210, 137, 64, 1),
                                            fontSize: rSP(13),
                                          ),
                                        ),
                                      ),
                                      rWBox(10),
                                      Text(
                                        '去认证 >',
                                        style: TextStyle(
                                          fontSize: rSP(13),
                                          color:
                                              Color.fromRGBO(210, 137, 64, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : SizedBox(),
                  ),
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
                    child: _buildOverseaTitle(),
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
            _changeAddress(address).then((value) {
              if (_orderModel.data.addr.isDeliveryArea == 0) {
                _canNotDeliver();
              }
            });
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
                      style: AppTextStyle.generate(15 * 2.sp),
                      children: [
                    TextSpan(
                        text: "   ${_orderModel.data.addr.mobile}",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.grey))
                  ])),
              Container(
                margin: EdgeInsets.only(top: 8 * 2.sp),
                child: Text(
                  TextUtils.isEmpty(_orderModel.data.addr.address)
                      ? "空地址"
                      : _orderModel.data.addr.province +
                          _orderModel.data.addr.city +
                          _orderModel.data.addr.district +
                          _orderModel.data.addr.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(14 * 2.sp,
                      fontWeight: FontWeight.w300),
                ),
              ),
              // Offstage(
              //   offstage: !(_orderModel.data.addr.isDeliveryArea == 0),
              //   child: Container(
              //     margin: EdgeInsets.only(top: rSize(6)),
              //     child: Text(
              //       "当前地址不支持快递发货",
              //       style: AppTextStyle.generate(12*2.sp,
              //           color: Colors.red, fontWeight: FontWeight.w300),
              //     ),
              //   ),
              // ),
            ],
          );
  }

  _canNotDeliver() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(rSize(32), rSize(32), rSize(32), rSize(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    '提示',
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: rSP(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: rSize(16)),
                Text(
                  '不支持配送到该地区',
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: rSP(12),
                  ),
                ),
                SizedBox(height: rSize(16)),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('我知道了'),
                  color: Color.fromRGBO(244, 3, 5, 1),
                ),
              ],
            ),
          ),
        );
      },
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
                    style: AppTextStyle.generate(13 * 2.sp,
                        color: Color(0xff373737)),
                    // style: AppTextStyle.generate(13*2.sp,
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

  ///下单页面 包税仓类型2，3 不能使用瑞币抵扣
  ///
  ///找到包含 2，3类型的仓库返回true
  bool get _checkSwitchEnabled {
    bool reslut = false;
    _orderModel.data.brands.forEach((element) {
      element.goods.forEach((v) {
        if (v.storehouse == 2 || v.storehouse == 3) {
          reslut = true;
        }
      });
    });
    return reslut;
  }

  _coinTile() {
    String text = _orderModel.data.coinTotalAmount > 0
        ? "可用：¥${_orderModel.data.coinTotalAmount.toStringAsFixed(2)}"
        : "可用：¥0.0";
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
          Builder(
            builder: (context) {
              return _titleRow(
                "瑞币",
                text,
                "本单抵扣: ￥${_orderModel.data.coinTotalAmount.toStringAsFixed(2)}",
                rightTitleColor: Colors.black,
                switchValue: _orderModel.data.coinStatus.isUseCoin, //后台回显 TODO:
                switchEnable: switchEnabled,
                switchChange: (change) {
                  // 切换瑞币抵扣状态
                  _changeOrderCoinOnOff();
                },
              );
            },
          ),
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
          Builder(
            builder: (context) {
              bool isOversea = false;
              for (var item in _orderModel.data.brands) {
                for (var childItem in item.goods) {
                  if (childItem.storehouse == 2 || childItem.storehouse == 3)
                    isOversea = true;
                }
              }

              return isOversea
                  ? _titleRow("进口税", "", "+￥${(0).toStringAsFixed(2)}",
                      rightTitleColor: Colors.black)
                  : SizedBox();
            },
          ),
          _titleRow(
            "优惠券",
            "",
            "-￥${(_orderModel.data.universeCouponTotalAmount + _orderModel.data.brandCouponTotalAmount).toStringAsFixed(2)}",
          ),
          if (!_checkSwitchEnabled)
            _titleRow("瑞币抵扣", "",
                "-￥${_orderModel.data.coinTotalAmount.toStringAsFixed(2)}"),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }

  _buildOverseaTitle() {
    bool isOversea = false;
    for (var item in _orderModel.data.brands) {
      for (var childItem in item.goods) {
        if (childItem.isImport == 1) isOversea = true;
      }
    }
    return isOversea
        ? Container(
            margin: EdgeInsets.only(top: rSize(16), bottom: rSize(42)),
            child: GestureDetector(
              onTap: () {
                _accept = !_accept;
                setState(() {});
              },
              child: Row(
                children: [
                  rWBox(15),
                  RecookCheckBox(state: _accept),
                  rWBox(10),
                  Text(
                    '同意并接受',
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: rSP(13),
                    ),
                  ),
                  InkWell(
                    onTap: () => CRoute.push(
                      context,
                      OverseaAcceptLicensePage(),
                    ),
                    child: Text(
                      '《跨境商品用户购买须知》',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: rSP(13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
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
                  ? AppTextStyle.generate(12 * 2.sp,
                      color: subTitleColor, fontWeight: FontWeight.w300)
                  : AppTextStyle.generate(12 * 2.sp,
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
                          ? (change) {
                              Toast.showError('订单含保税仓或海外仓商品，无法使用瑞币抵扣');
                            }
                          : (change) => switchChange(change)),
                ),
          Container(
            width: 5,
          ),
        ],
      ),
    );
  }

  bool get _overseaNeedIdentifier {
    for (var item in _orderModel.data.brands) {
      for (var good in item.goods) {
        if (good.storehouse == 2 || good.storehouse == 3) {
          return true;
        }
      }
    }
    return false;
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
    bool isOversea = false;
    for (var item in _orderModel.data.brands) {
      for (var childItem in item.goods) {
        if (childItem.isImport == 1) isOversea = true;
      }
    }
    // bool canDeliver = _orderModel.data.addr?.isDeliveryArea == 1 ||
    // (_orderModel.data.addr?.isDeliveryArea == 0 && _orderModel.data.shippingMethod == 1);
    bool canDeliver = _orderModel.data.addr?.isDeliveryArea == 1 ||
        (_orderModel.data.shippingMethod == 1);
    if (isOversea) {
      if (!_accept) canDeliver = false;
    }
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
          AppConfig.commissionByRoleLevel
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
                      13 * 2.sp,
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
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.grey[600]),
                        children: [
                          TextSpan(
                              text: "应付金额: ",
                              style: AppTextStyle.generate(
                                15 * 2.sp,
                              )),
                          TextSpan(
                              text:
                                  "￥${_orderModel.data.actualTotalAmount.toStringAsFixed(2)}",
                              style: AppTextStyle.generate(
                                16 * 2.sp,
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
                      fontSize: 14 * 2.sp,
                      onPressed: !canDeliver
                          ? null
                          : () {
                              if (_overseaNeedIdentifier &&
                                  (!UserManager
                                      .instance.user.info.realInfoStatus)) {
                                ReToast.err(
                                    text: '因订单含跨境商品，收货人联系方式需与当前账号实名认证姓名相同');
                                AppRouter.push(
                                  context,
                                  RouteName.USER_VERIFY,
                                );
                              } else
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
        height: kToolbarHeight + 30 + ScreenUtil().bottomBarHeight,
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              alignment: Alignment.center,
              color: Color.fromARGB(255, 250, 231, 235),
              child: Text(
                "下单可返￥${_orderModel.data.goodsTotalCommission}",
                style: TextStyle(color: Colors.red, fontSize: 11 * 2.sp),
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

  Future _changeAddress(Address address) async {
    final cancel = ReToast.loading();
    HttpResultModel<OrderPreviewModel> model =
        await _presenterImpl.changeAddress(
      UserManager.instance.user.info.id,
      _orderModel.data.id,
      address.id,
    );
    cancel();
    if (!model.result) {
      ReToast.err(text: model.msg);
      return;
    }
    _orderModel = model.data;
    setState(() {});
  }

  Future _changeOrderCoinOnOff() async {
    final cancel = ReToast.loading();
    HttpResultModel<OrderPreviewModel> model =
        await _presenterImpl.changeCoinOnOff(
      UserManager.instance.user.info.id,
      _orderModel.data.id,
    );
    cancel();
    if (!model.result) {
      ReToast.err(text: model.msg);
      return;
    }
    _orderModel = model.data;
    if (_checkSwitchEnabled) {
      switchEnabled = false;
    }
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
    final cancel = ReToast.loading();
    HttpResultModel<BaseModel> resultModel =
        await _presenterImpl.changeBuyerMessage(
            UserManager.instance.user.info.id, _orderModel.data.id, msg);
    // GSDialog.of(context).dismiss(context);
    cancel();
    if (!resultModel.result) {
      ReToast.err(text: resultModel.code);
      return;
    }
    _orderModel.data.buyerMessage = msg;
  }

  _submit(BuildContext context) async {
    final cancel = ReToast.loading();
    HttpResultModel<OrderPrepayModel> resultModel = await _presenterImpl
        .submitOrder(_orderModel.data.id, UserManager.instance.user.info.id);
    cancel();
    if (!resultModel.result) {
      ReToast.err(text: resultModel.msg);
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    UserManager.instance.refreshShoppingCartNumber.value = true;
    AppRouter.pushAndReplaced(context, RouteName.ORDER_PREPAY_PAGE,
        arguments: OrderPrepayPage.setArguments(
          resultModel.data,
          goToOrder: true,
          canUseBalance: !_checkSwitchEnabled,
        ));
  }
}
