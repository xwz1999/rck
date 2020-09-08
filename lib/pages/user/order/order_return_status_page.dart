/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-15  14:52 
 * remark    : 
 * ====================================================
 */

import 'dart:async';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/order_return_status_model.dart';
import 'package:recook/pages/user/order/after_sales_log_page.dart';
import 'package:recook/pages/user/order/order_return_address_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_bubble_widget.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/nine_grid_view.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/toast.dart';

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
  TextStyle textStyle = TextStyle(
      color: Colors.grey[500], fontSize: ScreenAdapterUtils.setSp(12));

  bool _isLoading = true;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _returnStatus = widget.arguments['returnStatus'];
    _orderGoodsId = widget.arguments['orderGoodsId'];
    _afterSalesGoodsId = widget.arguments['afterSalesGoodsId'];
    _getOrderDetail().then((value) {
      //TODO：后台借口只有小时，这里模拟倒计时
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
        title: "售后详情",
        themeData: AppThemes.themeDataMain.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            title: "进度明细",
            color: Colors.white,
            fontSize: ScreenAdapterUtils.setSp(14),
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
        margin: EdgeInsets.symmetric(
            horizontal: rSize(10), vertical: ScreenAdapterUtils.setHeight(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            _goodsListView(),
            Container(
              margin: EdgeInsets.only(
                  bottom: ScreenAdapterUtils.setHeight(6),
                  left: rSize(10),
                  right: rSize(10)),
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
        bottom: ScreenAdapterUtils.setHeight(10),
      ),
      // height: ScreenAdapterUtils.setHeight(120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _tile('申请时间', _statusModel.data.createdAt, needCopy: false),
          _tile('订单编号', _statusModel.data.orderId.toString(), needCopy: true),
          _tile('售后编号', _statusModel.data.asId.toString(), needCopy: true),
          _tile(
            '退款金额',
            (_statusModel.data.refundAmount + _statusModel.data.refundCoin)
                .toStringAsFixed(2),
          ),
          _tile(
            '申请件数',
            _statusModel.data.quantity.toString(),
          ),
          _tile(
            '退款原因',
            _statusModel.data.reasonContent,
          ),
          _tileImage(
            '买家凭证',
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
      padding: EdgeInsets.symmetric(vertical: ScreenAdapterUtils.setHeight(3)),
      margin: EdgeInsets.only(left: rSize(8), top: rSize(2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: Text(
                "$title:",
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                    color: Color(0xff999999)),
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
      padding: EdgeInsets.symmetric(vertical: ScreenAdapterUtils.setHeight(3)),
      margin: EdgeInsets.only(left: rSize(8), top: rSize(2)),
      child: Row(
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: Text(
                "$title:",
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                    color: Color(0xff999999)),
              )),
          GestureDetector(
            onTap: () {
              if (!needCopy) {
                return;
              }
              ClipboardData data = new ClipboardData(text: value);
              Clipboard.setData(data);
              Toast.showSuccess('$title:' + value + ' -- 已经保存到剪贴板');
            },
            child: Text(
              "$value",
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                  color: Color(0xff666666)),
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
                    Toast.showSuccess('$title:' + value + ' -- 已经保存到剪贴板');
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: AppColor.frenchColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '复制',
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(10),
                          color: Colors.grey),
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
      margin: EdgeInsets.only(
          left: rSize(10),
          right: rSize(10),
          top: ScreenAdapterUtils.setHeight(10)),
      child: Column(
        children: <Widget>[
          _statusModel.data.refundAmount > 0
              ? Container(
                  height: ScreenAdapterUtils.setHeight(25),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '退款金额',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdapterUtils.setSp(16)),
                      ),
                      Spacer(),
                      Text(
                        '￥ ${_statusModel.data.refundAmount}',
                        style: TextStyle(
                            color: AppColor.themeColor,
                            fontSize: ScreenAdapterUtils.setSp(16)),
                      )
                    ],
                  ),
                )
              : Container(),
          _statusModel.data.refundCoin > 0
              ? Container(
                  height: ScreenAdapterUtils.setHeight(25),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '退回瑞币',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdapterUtils.setSp(16)),
                      ),
                      Spacer(),
                      Text(
                        '${_statusModel.data.refundCoin}',
                        style: TextStyle(
                            color: AppColor.themeColor,
                            fontSize: ScreenAdapterUtils.setSp(16)),
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
      margin: EdgeInsets.only(top: ScreenAdapterUtils.setHeight(40)),
      padding: EdgeInsets.symmetric(horizontal: rSize(20)),
      height: ScreenAdapterUtils.setHeight(40),
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
            '查看退货地址',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: ScreenAdapterUtils.setSp(18)),
          ),
        ),
      ),
    );
  }

  _popWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          left: rSize(10),
          right: rSize(10),
          bottom: ScreenAdapterUtils.setHeight(10)),
      color: AppColor.themeColor,
      child: CustomBubbleWidget(
        child: _popInfoWidget(),
        arrowLeftPadding: _statusModel.data.statusTile == 0
            ? rSize(130) / 2
            : ScreenUtil.screenWidthDp - rSize(45) - (rSize(80)) / 2,
      ),
      // ScreenUtil.screenWidthDp-rSize(90),
    );
  }

  _statusTitleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: rSize(35), vertical: ScreenAdapterUtils.setHeight(5)),
      color: AppColor.themeColor,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: rSize(29)),
            height: ScreenAdapterUtils.setHeight(40),
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdapterUtils.setSp(14)),
                ),
                width: rSize(80),
              ),
              Spacer(),
              Container(
                alignment: Alignment.center,
                child: Text(
                  _statusModel.data.rightTile,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdapterUtils.setSp(14)),
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
    // 1审核中 2审核被拒绝 3审核成功 4买家已填写退货物流信息 5收到退货，确认退款完成 6退货被拒绝
    switch (_statusModel.data.returnStatus) {
      case 1:
        return '审核中';
      case 2:
        return '审核被拒绝';
      case 3:
        return '审核成功';
      case 4:
        return '买家已填写退货物流信息';
      case 5:
        return '收到退货，确认退款完成';
      case 6:
        return '退货被拒绝';
      default:
        return '';
    }
  }

  _getReturnSubStatus() {
    // 1审核中 2审核被拒绝 3审核成功 4买家已填写退货物流信息 5收到退货，确认退款完成 6退货被拒绝
    switch (_returnStatus) {
      case 1:
        return '请耐心等待系统审核';
      case 2:
        return '审核被拒绝';
      case 3:
        return '审核成功';
      case 4:
        return '买家已填写退货物流信息';
      case 5:
        return '收到退货，确认退款完成';
      case 6:
        return '退货被拒绝';
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
                        ScreenAdapterUtils.setSp(14),
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
                            fontSize: ScreenAdapterUtils.setSp(11),
                          )),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "订单金额:",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(14),
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "￥${(_statusModel.data.refundAmount + _statusModel.data.refundCoin).toStringAsFixed(2)}",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(14),
                              color: Colors.black),
                        ),
                        Container(
                          width: 20,
                        ),
                        Text(
                          "购买数量 ",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(13),
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "${_statusModel.data.quantity.toString()}",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(14),
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
    TextStyle titleStyle =
        TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16));
    TextStyle blackStyle = TextStyle(
        color: Colors.black,
        fontSize: ScreenAdapterUtils.setSp(14),
        fontWeight: FontWeight.w600);
    TextStyle redStyle =
        TextStyle(color: Colors.red, fontSize: ScreenAdapterUtils.setSp(14));
    TextStyle greyStyle = TextStyle(
        color: Color(0xff666666), fontSize: ScreenAdapterUtils.setSp(14));
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
              Text("    剩余", style: blackStyle),
              Text(
                  "${_residueDateTime.hour}小时${_residueDateTime.minute}分钟${_residueDateTime.second}秒",
                  style: redStyle)
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "若平台超时未处理,则系统将自动通过该请求",
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
              "若买家超时未填写物流信息，则系统将自动关闭退货请求。",
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
              "等待平台收货,确认无误后,为您退款。",
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
              "若买家超时未填写物流信息，则系统将自动关闭退换货请求。",
              style: greyStyle,
              maxLines: 2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "平台确认收货审核未通过，理由：买家寄来物品与原物品不符，要求买家重新寄回。",
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
                style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: ScreenAdapterUtils.setSp(14)),
              ),
            ],
          ),
          _statusModel.data.refundCoin == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(text: "退回瑞币 ", style: greyStyle),
                    TextSpan(
                        text: _statusModel.data.refundCoin.toString(),
                        style: blackStyle),
                    TextSpan(text: " 已返回至您的", style: greyStyle),
                    TextSpan(text: "瑞币账户", style: blackStyle),
                    TextSpan(text: "，请及时核实。", style: greyStyle),
                  ]))),
          _statusModel.data.refundAmount == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(text: "退款金额 ", style: greyStyle),
                    TextSpan(
                        text: '¥' + _statusModel.data.refundAmount.toString(),
                        style: blackStyle),
                    TextSpan(text: " 将原路退回至您的", style: greyStyle),
                    TextSpan(text: "付款账户", style: blackStyle),
                    TextSpan(text: "，请及时关注到账情况。", style: greyStyle),
                  ]))),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Color(0xfff8f8f8),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: rSize(10),
                vertical: ScreenAdapterUtils.setHeight(5)),
            child: Text(
              "若3天内未收到退款/瑞币，请联系客服咨询。",
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
              "等待拒绝了您的退货申请。如有疑问，请联系客服。",
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
              "平台拒绝了您的退货申请。原因：${_statusModel.data.rejectReason}",
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
