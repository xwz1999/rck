/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-15  14:52 
 * remark    : 
 * ====================================================
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:extended_text/extended_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/order_return_status_model.dart';
import 'package:jingyaoyun/pages/user/order/after_sales_log_page.dart';
import 'package:jingyaoyun/pages/user/order/order_return_address_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_bubble_widget.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/nine_grid_view.dart';
import 'package:jingyaoyun/widgets/pic_swiper.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class OrderReturnStatusPage extends StatefulWidget {
  final Map arguments;

  const OrderReturnStatusPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int orderGoodsId, int afterSalesGoodsId) {
    return {
      "orderGoodsId": orderGoodsId,
      "afterSalesGoodsId": afterSalesGoodsId
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderReturnStatusPageState();
  }
}

class _OrderReturnStatusPageState
    extends BaseStoreState<OrderReturnStatusPage> {
  int _orderGoodsId;
  int _afterSalesGoodsId;
  int _returnStatus;
  OrderReturnStatusModel _statusModel;
  DateTime _residueDateTime = DateTime(0, 0, 0, 24, 0, 0);
  TextStyle textStyle = TextStyle(color: Colors.grey[500], fontSize: 12 * 2.sp);

  bool _isLoading = true;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _returnStatus = widget.arguments['returnStatus'];
    _orderGoodsId = widget.arguments['orderGoodsId'];
    _afterSalesGoodsId = widget.arguments['afterSalesGoodsId'];
    _getOrderDetail().then((value) {
      //TODO???????????????????????????????????????????????????
      _residueDateTime = DateTime(0, 0, 0, _statusModel.data.residueHour, 0, 0);
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _residueDateTime = _residueDateTime.subtract(Duration(seconds: 1));
        if (_residueDateTime.millisecondsSinceEpoch <
            DateTime(0, 0, 0, 0, 0, 0, 0, 0).millisecondsSinceEpoch) {
          timer.cancel();
          _residueDateTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _getOrderDetail() async {
    ResultData resultData =
        await HttpManager.post(OrderApi.after_sales_goods_detail, {
      'orderGoodsId': _orderGoodsId,
      "afterSalesGoodsId": _afterSalesGoodsId,
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return;
    }
    OrderReturnStatusModel model =
        OrderReturnStatusModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    _statusModel = model;
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        title: "????????????",
        themeData: AppThemes.themeDataMain.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            title: "????????????",
            color: Colors.white,
            fontSize: 14 * 2.sp,
            onPressed: _statusModel == null
                ? null
                : () {
                    AppRouter.push(context, RouteName.AFTER_SALES_LOG_PAGE,
                        arguments: AfterSalesLogPage.setArguments(
                            _statusModel.data.asId));
                  },
          ),
          SizedBox(
            width: rSize(8),
          ),
        ],
        // actions: <Widget>[
        //   CustomImageButton(
        //     padding: EdgeInsets.only(top: rSize(8),right: rSize(10),left: rSize(8)),
        //     color: Colors.black,
        //   )
        // ],
      ),
      backgroundColor: AppColor.frenchColor,
      body: _isLoading ? _loading() : _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        _statusModel == null ? Container() : _statusTitleWidget(),
        _statusModel == null ? Container() : _popWidget(),
        _statusModel == null ? Container() : _returnAmountWidget(),
        _statusModel == null ? Container() : _infoWidget(),
        // _returnInfoWidget(),
        _statusModel != null && _statusModel.data.returnStatus == 3
            ? _buttonWidget()
            : Container(),
        SafeArea(
          child: SizedBox(
            height: rSize(10),
          ),
          bottom: true,
        )
      ],
    );
  }

  _infoWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: rSize(10), vertical: 10 * 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            _goodsListView(),
            Container(
              margin: EdgeInsets.only(
                  bottom: 6 * 2.h, left: rSize(10), right: rSize(10)),
              height: 1,
              width: double.infinity,
              color: Color(0xffeeeeee),
            ),
            _orderInfoWidget(),
          ],
        ),
      ),
    );
  }

  _orderInfoWidget() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10 * 2.h,
      ),
      // height: 120*2.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _tile('????????????', _statusModel.data.createdAt, needCopy: false),
          _tile('????????????', _statusModel.data.orderId.toString(), needCopy: true),
          _tile('????????????', _statusModel.data.asId.toString(), needCopy: true),
          _tile(
            '????????????',
            (_statusModel.data.refundAmount + _statusModel.data.refundCoin)
                .toStringAsFixed(2),
          ),
          _tile(
            '????????????',
            _statusModel.data.quantity.toString(),
          ),
          _tile(
            '????????????',
            _statusModel.data.reasonContent,
          ),
          _tileImage(
            '????????????',
            _statusModel.data.reasonImg,
          ),
        ],
      ),
    );
  }

  _tileImage(
    String title,
    String images,
  ) {
    List imageList = [];
    if (!TextUtils.isEmpty(images)) {
      List resList = images.split(",");
      for (String url in resList) {
        if (!TextUtils.isEmpty(url)) imageList.add(url);
      }
    }
    if (imageList == null || imageList.length == 0) return Container();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3 * 2.h),
      margin: EdgeInsets.only(left: rSize(8), top: rSize(2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: Text(
                "$title:",
                style:
                    AppTextStyle.generate(14 * 2.sp, color: Color(0xff999999)),
              )),
          Expanded(
            child: NineGridView(
              builder: (context, index) {
                return CustomCacheImage(
                    imageClick: () {
                      List<PicSwiperItem> picSwiperItem = [];
                      for (String photo in imageList) {
                        picSwiperItem.add(PicSwiperItem(Api.getImgUrl(photo)));
                      }
                      AppRouter.fade(
                        context,
                        RouteName.PIC_SWIPER,
                        arguments: PicSwiper.setArguments(
                          index: index,
                          pics: picSwiperItem,
                        ),
                      );
                    },
                    imageUrl: Api.getResizeImgUrl(imageList[index], 300),
                    placeholder: AppImageName.placeholder_1x1,
                    fit: imageList.length != 1
                        ? BoxFit.cover
                        : BoxFit.scaleDown);
              },
              type: GridType.weChat,
              itemCount: imageList.length,
            ),
          )
        ],
      ),
    );
  }

  _tile(String title, String value, {bool needCopy = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3 * 2.h),
      margin: EdgeInsets.only(left: rSize(8), top: rSize(2)),
      child: Row(
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: Text(
                "$title:",
                style:
                    AppTextStyle.generate(14 * 2.sp, color: Color(0xff999999)),
              )),
          GestureDetector(
            onTap: () {
              if (!needCopy) {
                return;
              }
              ClipboardData data = new ClipboardData(text: value);
              Clipboard.setData(data);
              Toast.showSuccess('$title:' + value + ' -- ????????????????????????');
            },
            child: Text(
              "$value",
              style: AppTextStyle.generate(14 * 2.sp, color: Color(0xff666666)),
            ),
          ),
          needCopy
              ? GestureDetector(
                  onTap: () {
                    if (!needCopy) {
                      return;
                    }
                    ClipboardData data = new ClipboardData(text: value);
                    Clipboard.setData(data);
                    Toast.showSuccess('$title:' + value + ' -- ????????????????????????');
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: AppColor.frenchColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '??????',
                      style:
                          AppTextStyle.generate(10 * 2.sp, color: Colors.grey),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _returnAmountWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(rSize(10)),
      margin: EdgeInsets.only(left: rSize(10), right: rSize(10), top: 10 * 2.h),
      child: Column(
        children: <Widget>[
          _statusModel.data.refundAmount > 0
              ? Container(
                  height: 25 * 2.h,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '????????????',
                        style:
                            TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
                      ),
                      Spacer(),
                      Text(
                        '??? ${_statusModel.data.refundAmount}',
                        style: TextStyle(
                            color: AppColor.themeColor, fontSize: 16 * 2.sp),
                      )
                    ],
                  ),
                )
              : Container(),
          _statusModel.data.refundCoin > 0
              ? Container(
                  height: 25 * 2.h,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '????????????',
                        style:
                            TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
                      ),
                      Spacer(),
                      Text(
                        '${_statusModel.data.refundCoin}',
                        style: TextStyle(
                            color: AppColor.themeColor, fontSize: 16 * 2.sp),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _buttonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40 * 2.h),
      padding: EdgeInsets.symmetric(horizontal: rSize(20)),
      height: 40 * 2.h,
      child: FlatButton(
        onPressed: () {
          AppRouter.push(context, RouteName.ORDER_RETURN_ADDRESS,
                  arguments: OrderReturnAddressPage.setArguments(_statusModel))
              .then((status) {
            if (status as bool && status) {
              _getOrderDetail();
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.themeColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          child: Text(
            '??????????????????',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 18 * 2.sp),
          ),
        ),
      ),
    );
  }

  _popWidget() {
    return Container(
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: rSize(10), right: rSize(10), bottom: 10 * 2.h),
      color: AppColor.themeColor,
      child: CustomBubbleWidget(
        child: _popInfoWidget(),
        arrowLeftPadding: _statusModel.data.statusTile == 0
            ? rSize(130) / 2
            : ScreenUtil().screenWidth - rSize(45) - (rSize(80)) / 2,
      ),
      // ScreenUtil().screenWidth-rSize(90),
    );
  }

  _statusTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(35), vertical: 5 * 2.h),
      color: AppColor.themeColor,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: rSize(29)),
            height: 40 * 2.h,
            child: Row(
              children: <Widget>[
                Container(
                  width: rSize(22),
                  height: rSize(22),
                  child: Image.asset(_statusModel.data.statusTile == 0
                      ? R.ASSETS_AFTER_SALES_STATUS_PASS_PNG
                      : R.ASSETS_AFTER_SALES_STATUS_NORMAL_PNG),
                ),
                Expanded(
                    child: Container(
                  color: Colors.white.withAlpha(140),
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                )),
                Container(
                  width: rSize(22),
                  height: rSize(22),
                  child: Image.asset(_statusModel.data.statusTile == 1
                      ? R.ASSETS_AFTER_SALES_STATUS_PASS_PNG
                      : _statusModel.data.statusTile == 2
                          ? R.ASSETS_AFTER_SALES_STATUS_NO_PASS_PNG
                          : R.ASSETS_AFTER_SALES_STATUS_NORMAL_PNG),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  _statusModel.data.title,
                  style: TextStyle(color: Colors.white, fontSize: 14 * 2.sp),
                ),
                width: rSize(80),
              ),
              Spacer(),
              Container(
                alignment: Alignment.center,
                child: Text(
                  _statusModel.data.rightTile,
                  style: TextStyle(color: Colors.white, fontSize: 14 * 2.sp),
                ),
                width: rSize(80),
              )
            ],
          )
        ],
      ),
    );
  }

  _getReturnStatus() {
    // 1????????? 2??????????????? 3???????????? 4????????????????????????????????? 5????????????????????????????????? 6???????????????
    switch (_statusModel.data.returnStatus) {
      case 1:
        return '?????????';
      case 2:
        return '???????????????';
      case 3:
        return '????????????';
      case 4:
        return '?????????????????????????????????';
      case 5:
        return '?????????????????????????????????';
      case 6:
        return '???????????????';
      default:
        return '';
    }
  }

  _getReturnSubStatus() {
    // 1????????? 2??????????????? 3???????????? 4????????????????????????????????? 5????????????????????????????????? 6???????????????
    switch (_returnStatus) {
      case 1:
        return '???????????????????????????';
      case 2:
        return '???????????????';
      case 3:
        return '????????????';
      case 4:
        return '?????????????????????????????????';
      case 5:
        return '?????????????????????????????????';
      case 6:
        return '???????????????';
      default:
        return '';
    }
  }

  Container _goodsListView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _statusModel == null
              ? Container()
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return _goodsItem();
                    },
                  ),
                ),
        ],
      ),
    );
  }

  _goodsItem() {
    return CustomImageButton(
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // margin: EdgeInsets.symmetric(horizontal: rSize(4)),
              child: CustomCacheImage(
                width: rSize(80),
                height: rSize(80),
                imageUrl:
                    Api.getResizeImgUrl(_statusModel.data.mainPhotoUrl, 100),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _statusModel.data.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(
                        14 * 2.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color(0xffeff1f6),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 6),
                      child: Text(_statusModel.data.skuName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11 * 2.sp,
                          )),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "????????????:",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "???${(_statusModel.data.refundAmount + _statusModel.data.refundCoin).toStringAsFixed(2)}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.black),
                        ),
                        Container(
                          width: 20,
                        ),
                        Text(
                          "???????????? ",
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "${_statusModel.data.quantity.toString()}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.black),
                        )
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

  _loading() {
    return _isLoading == true
        ? Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(getCurrentThemeColor()),
                strokeWidth: 1.0,
              ),
            ),
          )
        : Text('');
  }

  _popInfoWidget() {
    TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: 16 * 2.sp);
    TextStyle blackStyle = TextStyle(
        color: Colors.black, fontSize: 14 * 2.sp, fontWeight: FontWeight.w600);
    TextStyle redStyle = TextStyle(color: Colors.red, fontSize: 14 * 2.sp);
    TextStyle greyStyle =
        TextStyle(color: Color(0xff666666), fontSize: 14 * 2.sp);
    if (_statusModel.data.status == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
              Text("    ??????", style: blackStyle),
              Text(
                  "${_residueDateTime.hour}??????${_residueDateTime.minute}??????${_residueDateTime.second}???",
                  style: redStyle)
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "????????????????????????,?????????????????????????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          )
        ],
      );
    }
    if (_statusModel.data.status == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "??????????????????????????????????????????????????????????????????????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              TextUtils.isEmpty(_statusModel.data.address)
                  ? ""
                  : _statusModel.data.address,
              style: blackStyle,
              maxLines: 3,
            ),
          )
        ],
      );
    }
    if (_statusModel.data.status == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "??????????????????,???????????????,???????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    if (_statusModel.data.status == 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "?????????????????????????????????????????????????????????????????????????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "???????????????????????????????????????????????????????????????????????????????????????????????????????????????",
              style: redStyle,
              maxLines: 2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              TextUtils.isEmpty(_statusModel.data.address)
                  ? ""
                  : _statusModel.data.address,
              style: blackStyle,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    if (_statusModel.data.status == 5) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
              Text(
                "    " + _statusModel.data.createdAt,
                style: TextStyle(color: Color(0xff999999), fontSize: 14 * 2.sp),
              ),
            ],
          ),
          _statusModel.data.refundCoin == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(text: "???????????? ", style: greyStyle),
                    TextSpan(
                        text: _statusModel.data.refundCoin.toString(),
                        style: blackStyle),
                    TextSpan(text: " ??????????????????", style: greyStyle),
                    TextSpan(text: "????????????", style: blackStyle),
                    TextSpan(text: "?????????????????????", style: greyStyle),
                  ]))),
          _statusModel.data.refundAmount == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(text: "???????????? ", style: greyStyle),
                    TextSpan(
                        text: '??' + _statusModel.data.refundAmount.toString(),
                        style: blackStyle),
                    TextSpan(text: " ????????????????????????", style: greyStyle),
                    TextSpan(text: "????????????", style: blackStyle),
                    TextSpan(text: "?????????????????????????????????", style: greyStyle),
                  ]))),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Color(0xfff8f8f8),
              borderRadius: BorderRadius.circular(4),
            ),
            padding:
                EdgeInsets.symmetric(horizontal: rSize(10), vertical: 5 * 2.h),
            child: Text(
              "???3????????????????????????????????????????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    if (_statusModel.data.status == 6) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "?????????????????????????????????????????????????????????????????????",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    if (_statusModel.data.status == 7) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                _statusModel.data.subtitle,
                style: titleStyle,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "?????????????????????????????????????????????${_statusModel.data.rejectReason}",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
