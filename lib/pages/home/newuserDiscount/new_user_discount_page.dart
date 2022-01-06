import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/newuserDiscount/new_user_discount_model.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class NewUserDiscountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewUserDiscountPageState();
  }
}

class _NewUserDiscountPageState extends BaseStoreState<NewUserDiscountPage> {
  double _width;
  double _height;
  NewUserDiscountModel _detailModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _getDetailModel();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: '新人活动',
      ),
      body: _isLoading
          ? _loading()
          : SafeArea(
              bottom: false,
              top: false,
              child: Container(
                  width: _width,
                  height: _height,
                  color: Color(0xFFFDCEA5),
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: _bodyListWidget(),
                      ))),
            ),
    );
  }

  _bodyListWidget() {
    List<Widget> listWidget = [];
    listWidget.add(_titleWidget());
    listWidget.add(_subTitleWidget());
    // listWidget.add(_goodsListWidget());
    if (_detailModel != null) {
      for (Goods good in _detailModel.data.goodsList) {
        listWidget.add(GestureDetector(
          child: _goodsItemWidget(good),
          onTap: () {
            AppRouter.push(context, RouteName.COMMODITY_PAGE,
                arguments: CommodityDetailPage.setArguments(good.goodsId));
          },
        ));
      }
    }
    return listWidget;
  }

  _titleWidget() {
    double height = _width / 750 * 508;
    Color textColor = Color(0xFFEE5E6A);
    return Container(
      width: _width,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            width: _width,
            height: height,
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/activityImage/newuserdiscount_title_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 90 / 750 * _width,
            top: 145 / 508 * height,
            width: 170 / 750 * _width,
            height: 200 / 508 * height,
            child: Container(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '￥',
                    style: TextStyle(color: textColor, fontSize: 12 * 2.sp),
                  ),
                  TextSpan(
                    text: '${_detailModel.data.cash}',
                    style: TextStyle(
                        letterSpacing: -3,
                        color: textColor,
                        fontSize: 40 * 2.sp),
                  )
                ]),
              ),
            ),
          ),
          Positioned(
            left: 280 / 750 * _width,
            top: 145 / 508 * height,
            width: 400 / 750 * _width,
            height: 200 / 508 * height,
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '新人专享',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 5,
                          color: textColor,
                          fontSize: 23 * 2.sp),
                    ),
                    Container(
                      height: 3,
                    ),
                    Text(
                      '无门槛红包',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: textColor,
                          fontSize: 9 * 2.sp),
                    ),
                  ],
                )),
          ),
          Positioned(
              left: 210 / 750 * _width,
              top: 330 / 508 * height,
              width: 330 / 750 * _width,
              height: 84 / 508 * height,
              child: GestureDetector(
                onTap: () {
                  if (_detailModel.data.status != 0) {
                    return;
                  }
                  if (UserManager.instance.user.info.id == 0) {
                    Toast.showError('请先登录...');
                    AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                    return;
                  }
                  _receiveCoupon();
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: _detailModel.data.status == 0
                        ? [
                            BoxShadow(
                              color: Color.fromARGB(
                                  255, 239, 64, 89), //阴影默认颜色,不能与父容器同时设置color
                              offset: Offset.zero, //延伸的阴影，向右下偏移的距离
                              blurRadius: 6.0, //延伸距离,会有模糊效果
                            ),
                          ]
                        : [],
                    borderRadius: BorderRadius.all(
                        Radius.circular(84 / 508 * height / 2)),
                    color: _detailModel.data.status == 0
                        ? Color.fromARGB(255, 239, 64, 89)
                        : Color.fromARGB(255, 190, 190, 190),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _detailModel.data.status == 0 ? '立即领取' : '已领取',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20 * 2.sp),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _subTitleWidget() {
    double height = _width / 750 * 344;
    return Container(
      width: _width,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            width: _width,
            height: height,
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/activityImage/newuserdiscount_title_bg_sub.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  _goodsItemWidget(Goods goods) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3))),
      margin: EdgeInsets.only(left: rSize(10), right: rSize(10), top: 8 * 2.h),
      padding: EdgeInsets.symmetric(horizontal: rSize(8), vertical: 8 * 2.h),
      height: 123 * 2.h,
      child: Row(
        children: <Widget>[
          Container(
            child: CustomCacheImage(
              width: rSize(110),
              height: rSize(110),
              imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, 110),
            ),
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    goods.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17 * 2.sp,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8 * 2.h),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1 * 2.h, horizontal: rSize(3)),
                    decoration: BoxDecoration(
                        color: Color(0xFFFDCEA5).withAlpha(100),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Text(goods.label,
                        style: TextStyle(
                          color: Color.fromARGB(255, 230, 79, 32),
                          fontSize: 11 * 2.sp,
                        )),
                  ),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Text(
                      '券后价￥${goods.price}  ',
                      style: TextStyle(
                        color: AppColor.themeColor,
                        fontSize: 15 * 2.sp,
                      ),
                    ),
                    Text('${goods.originPrice}',
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12 * 2.sp)),
                  ],
                ),
                Container(
                  height: 5 * 2.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getDetailModel() async {
    ResultData resultData = await HttpManager.post(
        HomeApi.tehui_xinren, {'userId': UserManager.instance.user.info.id});
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    NewUserDiscountModel model = NewUserDiscountModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _detailModel = model;
    _isLoading = false;
    setState(() {});
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

  _receiveCoupon() async {
    showLoading('');
    ResultData resultData = await HttpManager.post(GoodsApi.coupon_receive, {
      "userID": UserManager.instance.user.info.id,
      "couponID": _detailModel.data.couponId
    });
    dismissLoading();
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      // showError(model.msg);
      Toast.showError(model.msg);
      return;
    }
    _showAlertView();
  }

  _showAlertView() {
    Color textColor = Color(0xFFEE5E6A);
    double alertWidth = _width - 40 * 2;
    double alertHeight = alertWidth / 1000 * 1125;

    Alert.show(
        context,
        Dialog(
          backgroundColor: Colors.white.withAlpha(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
              width: alertWidth,
              height: alertHeight + 24 * 2,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    width: alertWidth,
                    height: alertHeight,
                    child: Image.asset(
                      'assets/activityImage/newuserdiscount_icon_alert.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      left: 100 / 1000 * alertWidth,
                      top: 440 / 1125 * alertHeight,
                      width: 250 / 1000 * alertWidth,
                      height: 250 / 1125 * alertHeight,
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  color: textColor, fontSize: 12 * 2.sp),
                            ),
                            TextSpan(
                              text: '${_detailModel.data.cash}',
                              style: TextStyle(
                                  letterSpacing: -3,
                                  color: textColor,
                                  fontSize: 40 * 2.sp),
                            )
                          ]),
                        ),
                      )),
                  Positioned(
                    left: 350 / 1000 * alertWidth,
                    top: 440 / 1125 * alertHeight,
                    width: 560 / 1000 * alertWidth,
                    height: 250 / 1125 * alertHeight,
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '新人专享',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 5,
                                  color: textColor,
                                  fontSize: 23 * 2.sp),
                            ),
                            Container(
                              height: 3,
                            ),
                            Text(
                              '无门槛红包',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0,
                                  color: textColor,
                                  fontSize: 9 * 2.sp),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    top: 900 / 1125 * alertHeight,
                    left: 0,
                    width: alertWidth,
                    height: 150 / 1125 * alertHeight,
                    child: GestureDetector(
                      onTap: () {
                        Alert.dismiss(context);
                        Navigator.maybePop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: alertWidth * 0.15),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 252, 234, 177),
                            borderRadius: BorderRadius.all(
                                Radius.circular(150 / 1125 * alertHeight / 2))),
                        child: Text(
                          '立即使用',
                          style: TextStyle(
                              color: Color(0xFF974902), fontSize: 20 * 2.sp),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
