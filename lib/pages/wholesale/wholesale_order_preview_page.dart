
import 'dart:async';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/order_prepay_model.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/pages/home/classify/mvp/order_mvp/order_presenter_impl.dart';
import 'package:recook/pages/user/address/receiving_address_page.dart';
import 'package:recook/pages/user/order/order_detail_page.dart';
import 'package:recook/pages/wholesale/func/wholesale_func.dart';
import 'package:recook/pages/wholesale/wholesale_customer_page.dart';
import 'package:recook/pages/wholesale/wholesale_goods_item_order.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_floating_action_button_location.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/toast.dart';

import 'models/wholesale_customer_model.dart';
import 'models/wholesale_order_preview_model.dart';

class WholesaleGoodsOrderPage extends StatefulWidget {
  //final WholesaleOrderPreviewModel model;
  final Map? arguments;
  static setArguments(WholesaleOrderPreviewModel model) {
    return {"order": model};
  }

  const WholesaleGoodsOrderPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleGoodsOrderPageState();
  }
}

class _WholesaleGoodsOrderPageState extends BaseStoreState<WholesaleGoodsOrderPage> {
  WholesaleOrderPreviewModel? _orderModel;
  late OrderPresenterImpl _presenterImpl;
  ScrollController? _controller;

  TextEditingController? _editController;
  FocusNode _focusNode = FocusNode();

  String? _selectedStoreName;
  int totalNum = 0;

  bool _accept = false;
  String _buyerMessage = '';


  @override
  void initState() {
    super.initState();

    _orderModel = widget.arguments!["order"];
    _orderModel!.skuList!.forEach((element) {
      totalNum+=element.quantity!;
    });

    _presenterImpl = OrderPresenterImpl();
    _controller = ScrollController();
    _controller!.addListener(() {});
    _editController =
        TextEditingController(text: '');
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        String text = _editController!.text;
        if (text == _buyerMessage) {
          return;
        }
        _changeOrder(_orderModel!.addr!.id,_orderModel!.previewId,text);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _editController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {

    return Scaffold(
      floatingActionButton: _customer(),
      floatingActionButtonLocation:CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endDocked, 0, -120.rw),
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: CustomAppBar(
        elevation: 0,
        title: "确认订单",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        backEvent: (){
          print('back');
          Get.back();
        },
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
                  FocusScope.of(globalContext!).requestFocus(FocusNode());
                }
              },
              child: CustomScrollView(
                controller: _controller,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child:  _buildAddress(context),
                    // child: _buildAddress(context),
                  ),
                  SliverToBoxAdapter(
                    child: _otherTiles(),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return WholesaleGoodsOrderItem(
                      brand: _orderModel!.skuList![index],
                      length: _orderModel!.skuList!.length,
                      index: index,
                    );
                  }, childCount: _orderModel!.skuList!.length)),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 10.rw,
                    )
                    // child: _buildAddress(context),
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
          child: _bottomBar(context),
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
                    canBack: true, addr: Addr(0, _orderModel!.addr!.id,_orderModel!.addr!.province, _orderModel!.addr!.city, _orderModel!.addr!.district, _orderModel!.addr!.address, _orderModel!.addr!.name, _orderModel!.addr!.mobile, 1)))
            .then((address) {
          DPrint.printf(address.runtimeType);
          if (address != null && address is Address) {
//            if (_orderModel.data.addr != null && address.id == _orderModel.data.addr.addressId) return;
              _changeOrder(address.id,_orderModel!.previewId,_editController!.text).then((value) {
              _orderModel!.addr = address;
              setState(() {

              });
            }
            );
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
    return _orderModel!.addr == null
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
                      text: _orderModel!.addr!.name,
                      style: AppTextStyle.generate(15 * 2.sp),
                      children: [
                    TextSpan(
                        text: "   ${_orderModel!.addr!.mobile}",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.grey))
                  ])),
              Container(
                margin: EdgeInsets.only(top: 8 * 2.sp),
                child: Text(
                  TextUtils.isEmpty(_orderModel!.addr!.address)
                      ? "空地址"
                      : _orderModel!.addr!.province! +
                          _orderModel!.addr!.city! +
                          _orderModel!.addr!.district! +
                          _orderModel!.addr!.address!,
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

  _otherTiles() {
    return Container(
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: 0.rw),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[

          _tileInput("买家留言", "选填"),
        ],
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
              "合计:￥${_orderModel!.total!.toStringAsFixed(2)}",'共$totalNum件',subTitleColor: Color(0xFF999999),
              rightTitleColor: Colors.black),
          Container(
            height: 10,
          ),
        ],
      ),
    );
  }

  _titleRow(title, subTitle, rightTitle,rlTitle,
      {titleColor,
      subTitleColor,
      rightTitleColor,
      Function(bool)? switchChange,
      bool switchValue = false,
      bool switchEnable = false}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // height: 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              child: Text(
                title,
                style: titleColor != null
                    ? AppTextStyle.generate(27.sp,
                        color: titleColor, fontWeight: FontWeight.w400)
                    : AppTextStyle.generate(27.sp, fontWeight: FontWeight.w400),
              )),
          Expanded(
            child: Text(
              subTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                rlTitle,
                style: TextStyle(
                    fontSize: 11.rsp,

                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999)),
              )),
          10.wb,
          Container(
              child: Text(
            rightTitle,
            style: rightTitleColor != null
                ? TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w400,
                    color: rightTitleColor)
                : TextStyle(
                    fontSize: 27.sp,
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



  Container _bottomBar(BuildContext context) {

    Container bottomWidget = Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10.rw,right: 10.rw,bottom: 5.rw,top: 5.rw),
            child: SafeArea(
              bottom: true,
              child: Row(

                children: <Widget>[
                  // RichText(
                  //   text: TextSpan(
                  //
                  //       style: AppTextStyle.generate(14 * 2.sp,
                  //           color: Colors.grey[600]),
                  //       children: [
                  //         TextSpan(
                  //             text: "实付款: ",
                  //             style: AppTextStyle.generate(
                  //               14 * 2.sp,color: Color(0xFF333333)
                  //             )),
                  //         TextSpan(
                  //             text:
                  //             "￥",
                  //             style: AppTextStyle.generate(
                  //               14 * 2.sp,
                  //               color: Color(0xFFC92219),
                  //             )),
                  //         TextSpan(
                  //             text:
                  //                 "￥${_orderModel.total.toStringAsFixed(2)}",
                  //             style: AppTextStyle.generate(
                  //               22 * 2.sp,
                  //               color: Color(0xFFC92219),
                  //             )),
                  //       ]),
                  // ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: rSize(14)),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                              gradient: const LinearGradient(colors: [
                                      Color(0xFFE05346),
                                    Color(0xFFDB1E1E),
                                    ])),
                    child: CustomImageButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.rw, horizontal:25.rw),
                      title: "提交订单",
                      color: Colors.white,
                      disabledColor: Colors.grey[600],
                      fontSize: 16 * 2.sp,
                      onPressed:() {
                                _submit(context);},
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

      return Container(
        height: kToolbarHeight + 50.rw + ScreenUtil().bottomBarHeight,
        child: Column(
          children: <Widget>[
            Container(
              height: 50.rw,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15.rw,right: 15.rw,top: 5.rw,bottom: 5.rw),
              color: Color(0xFFF3E3E4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '温馨提示:1、提交订单后，物流费将由平台跟供应商确认并反馈',
                    style: TextStyle(color: Color(0xFFD5101A), fontSize: 12 * 2.sp),
                  ),
                  Text(

                      '                 2、节假日期间批发业务暂不处理。',
                    style: TextStyle(color: Color(0xFFD5101A), fontSize: 12 * 2.sp),
                  ),
                ],
              ),
            ),
            bottomWidget,
          ],
        ),
      );

  }


  Future _changeOrder(int? addressId,int? previewId,String message) async{
    final cancel = ReToast.loading();
    ResultData result = await (WholesaleFunc.updateOrder(addressId, previewId, message));
    cancel();
    if(!result.result){
      ReToast.err(text: result.msg);
      return;
    }

    _buyerMessage = message;
    setState(() {});

  }


  _submit(BuildContext context) async {
    final cancel = ReToast.loading();
    HttpResultModel<OrderPrepayModel?> resultModel = await _presenterImpl
        .submitOrder(_orderModel!.previewId, UserManager.instance!.user.info!.id);
    cancel();
    if (!resultModel.result) {
      ReToast.err(text: resultModel.msg);
      return;
    }
    UserManager.instance!.refreshShoppingCart.value = true;
    UserManager.instance!.refreshShoppingCartNumber.value = true;


    AppRouter.pushAndReplaced(
        globalContext!, RouteName.ORDER_DETAIL,
        arguments:
        OrderDetailPage.setArguments(resultModel.data!.data!.id,true));

    // AppRouter.pushAndReplaced(context, RouteName.ORDER_PREPAY_PAGE,
    //     arguments: OrderPrepayPage.setArguments(
    //       resultModel.data,
    //       goToOrder: true,
    //       canUseBalance: true,
    //       isPifa: true
    //     ));
  }

  _customer(){
    return GestureDetector(
      onTap: () async{
        // WholesaleCustomerModel? model = await
        // WholesaleFunc.getCustomerInfo();
        //
        // Get.to(()=>WholesaleCustomerPage(model: model,));
        if (UserManager.instance!.user.info!.id == 0) {
          AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
          Toast.showError('请先登录...');
          return;
        }
        BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");

      },
      child: Container(
        width: 46.rw,
        height: 46.rw,
        decoration: BoxDecoration(
          color: Color(0xFF000000).withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(23.rw)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_CUSTOMER_PNG,width: 20.rw,height: 20.rw,),
            5.hb,
            Text('客服',style: TextStyle(color: Colors.white,fontSize: 10.rw),)
          ],
        ),
      ),
    );
  }
}
