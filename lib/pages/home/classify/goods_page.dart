

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/daos/home_dao.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/address_list_model.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/goods_detail_images_model.dart';
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/models/province_city_model.dart';
import 'package:jingyaoyun/pages/home/classify/evaluation_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/goods_param_page.dart';
import 'package:jingyaoyun/pages/home/classify/goods_service_guarantee.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/classify/order_preview_page.dart';
import 'package:jingyaoyun/pages/home/classify/sku_choose_page.dart';
import 'package:jingyaoyun/pages/home/items/item_user_comment.dart';
import 'package:jingyaoyun/pages/home/model/address_model.dart';
import 'package:jingyaoyun/pages/home/widget/good_price_view.dart';
import 'package:jingyaoyun/pages/home/widget/goods_image_page_view.dart';
import 'package:jingyaoyun/pages/shopping_cart/mvp/shopping_cart_model_impl.dart';
import 'package:jingyaoyun/pages/user/address/mvp/address_model_impl.dart';
import 'package:jingyaoyun/pages/user/address/receiving_address_page.dart';
import 'package:jingyaoyun/utils/file_utils.dart';
import 'package:jingyaoyun/utils/image_utils.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/address_selector.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/empty_view.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/selected_list.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:jingyaoyun/widgets/video_view.dart';

import 'commodity_detail_page.dart';

typedef ScrollListener = Function(ScrollUpdateNotification notification);

class MyGlobals {
  GlobalKey _scaffoldKey;

  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }

  GlobalKey get scaffoldKey => _scaffoldKey;
}

class GoodsPage extends StatefulWidget {
  final ScrollListener onScroll;
  final GoodsDetailModel goodsDetail;
  final int goodsId;
  final ValueNotifier<bool> openSkuChoosePage;
  final void Function() openbrandList; //??????????????????
  final bool isWholesale;

  const GoodsPage({
    Key key,
    this.onScroll,
    this.goodsId,
    this.openSkuChoosePage,
    this.goodsDetail,
    this.openbrandList, this.isWholesale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsPageState();
  }
}

class _GoodsPageState extends BaseStoreState<GoodsPage> {
  MyGlobals myGlobals = MyGlobals();

//  GoodsDetailModel widget.goodsDetail;
  double width = DeviceInfo.screenWidth;
  List<SelectedListItemModel> _itemModels;
  StateSetter _stateSetter;
  BuildContext _context;
  ShoppingCartModelImpl _shoppingCartModelImpl;
  GoodsDetailImagesModel _model;

  ProvinceCityModel _overseaCityModel;

  ProvinceCityModel _cityModel;

  Address _address = Address.empty();

  Address _cityAddress = Address.empty();
  List<AddressDefaultModel> _addressList = [];
  AddressDefaultModel _addressModel;
  String _defaltAddress;
  int _jDHaveGoods = -1;
  // int _seckillStatus = 0;//???????????? 0???????????? 1?????????
  String guige = '???????????????';
  bool isWholesale = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if(widget.isWholesale!=null){
      isWholesale = widget.isWholesale;
    }
    //??????????????????????????????????????????
    if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000|| widget.goodsDetail.data.vendorId == 3000) {
      Future.delayed(Duration.zero, () async {
        _addressList = await _getDefaultAddress();
        if (_addressList != null) {
          _addressList.forEach((element) {
            if (element.isDefault == 1) _addressModel = element;
            if (_addressModel != null) {
              _defaltAddress = _addressModel.province +
                  _addressModel.city +
                  _addressModel.district;
              if (_defaltAddress != null) {
                Future.delayed(Duration.zero, () async {
                  _jDHaveGoods =
                  await HomeDao.getJDStock(widget.goodsDetail.data.sku.first.id, _defaltAddress);
                  print(_jDHaveGoods);
                  setState(() {});
                });
              }
            }
          });
        }
      });

    }
    //goodsDetail.data.vendorId???1800??????2000


    GoodsDetailModelImpl.getDetailImages(widget.goodsId)
        .then((GoodsDetailImagesModel model) {
      if (model.code != HttpStatus.SUCCESS) {
        Toast.showError(model.msg);
        return;
      }
      _model = model;
      setState(() {});
    });
    _shoppingCartModelImpl = ShoppingCartModelImpl();
    widget.openSkuChoosePage.addListener(() {
      print(widget.openSkuChoosePage.value);
      if (_context != null &&
          widget.goodsDetail != null &&
          widget.openSkuChoosePage.value) {
        // if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000) {
        //   if (_jDHaveGoods == 1) {
        //     _showSkuChoosePage(context);
        //   } else {
        //     Toast.showInfo('???????????????????????????????????????');
        //     widget.openSkuChoosePage.value = false;
        //   }
        // } else {
        //   _showSkuChoosePage(context);
        // }
        _showSkuChoosePage(context);
      }
    });


  }

  @override
  void dispose() {
    super.dispose();
    widget.openSkuChoosePage.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    if (widget.goodsDetail != null) {

      _skuCombinations();
      _itemModels = _chooseValues();
    }
    return widget.goodsDetail == null
        ? EmptyView.goodsDetailEmptyView()
        : _buildBody(context);
  }

  MediaQuery _buildBody(BuildContext context) {


    _context = context;
    return MediaQuery.removePadding(
        key: myGlobals.scaffoldKey,
        context: context,
        removeTop: true,
        child: Stack(
          children: [
            Container(
              color: AppColor.frenchColor,
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  if (widget.onScroll != null) {
                    widget.onScroll(notification);
                  }
                  return true;
                },
                child: ListView(
                  //ListView ???????????????
                  cacheExtent: DeviceInfo.screenHeight,
                  physics: BouncingScrollPhysics(),
                  children: _detailListWidget(),
                ),
              ),
            ),
          ],
        ));
  }

  List<Widget> _detailListWidget() {

    List<Widget> children = [];
    children.addAll(_goodHeadDetail());
    children.addAll(_goodDetailImages());
    return children;
  }

  List<Widget> _goodDetailImages() {
    if (_model == null) return [];

    List<Widget> children = _model.data.list.map((Images image) {
      // Rect imageRect = await WidgetUtil.getImageWH(url: "Url");

      // ignore: unnecessary_cast
      return (
          GestureDetector(
        onLongPress: () {
          _saveImageWithUrl(image.url);
        },
        child: Transform.translate(
          offset: Offset(0, 0 - _model.data.list.indexOf(image).toDouble()),
          child: FadeInImage.assetNetwork(
            image: Api.getImgUrl(image.url),
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
            fit: BoxFit.cover,
          ),
        ),
      )) as Widget;
    }).toList();

    if (widget.goodsDetail.data.video != null) {
      children.insert(
          0,
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 16 * 9,
            child: VideoView(
              videoUrl: Api.getImgUrl(widget.goodsDetail.data.video.url),
            ),
          ));
    }

    if (widget.goodsDetail.data.brand != null &&
        !TextUtils.isEmpty(widget.goodsDetail.data.brand.firstImg)) {
      children.insert(
          0,
          Container(
            width: width,
            child: GestureDetector(
              onLongPress: () {
                _saveImageWithUrl(widget.goodsDetail.data.brand.firstImg);
              },
              child: FadeInImage.assetNetwork(
                image: Api.getImgUrl(widget.goodsDetail.data.brand.firstImg),
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              ),
            ),
          ));
    }
    if (widget.goodsDetail.data.brand != null &&
        !TextUtils.isEmpty(widget.goodsDetail.data.brand.lastImg)) {
      children.add(Container(
        width: width,
        child: GestureDetector(
          onLongPress: () {
            _saveImageWithUrl(widget.goodsDetail.data.brand.lastImg);
          },
          child: FadeInImage.assetNetwork(
            image: Api.getImgUrl(widget.goodsDetail.data.brand.lastImg),
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          ),
        ),
      ));
    }

    children.insert(
        0,
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
            top: 15,
          ),
          child: Text("????????????",
              style: AppTextStyle.generate(16,
                  fontWeight: FontWeight.w500, color: Colors.black)),
        ));
    // children.add(Container(
    //           margin: EdgeInsets.only(top: 10),
    //           padding: EdgeInsets.all(8),
    //           color: Colors.white,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Icon(
    //                 AppIcons.icon_pull_up,
    //                 size: 18,
    //                 color: Colors.grey,
    //               ),
    //               Container(
    //                 width: 10,
    //               ),
    //               Text(
    //                 "??????????????????????????????",
    //                 style:
    //                     AppTextStyle.generate(15, color: Colors.grey, fontWeight: FontWeight.w300),
    //               )
    //             ],
    //           ),
    //         ));
    insertFirst() {
      if (widget.goodsDetail.data.notice.img!=null)
        for(int i=0;i<widget.goodsDetail.data.notice.img.length;i++){
          children.insert(
            0,

            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
              image: Api.getImgUrl(widget.goodsDetail.data.notice.img[i]),
            ),
          );
        }

    }

    insertLast() {
      if (widget.goodsDetail.data.notice.img!=null)
        for(int i=0;i<widget.goodsDetail.data.notice.img.length;i++){
        children.add(
          FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
            image: Api.getImgUrl(widget.goodsDetail.data.notice.img[i]),
          ),
        );
        }
    }

    if (widget?.goodsDetail?.data?.notice?.type == 1) insertFirst();
    if (widget?.goodsDetail?.data?.notice?.type == 2) insertLast();
    if (widget?.goodsDetail?.data?.notice?.type == 3) {
      insertFirst();
      insertLast();
    }
    return children;
  }

  _saveImageWithUrl(String imageUrl) {
    ActionSheet.show(context, items: ['???????????????'], listener: (index) {
      ActionSheet.dismiss(context);
      showLoading("???????????????...");
      List<String> urls = [Api.getImgUrl(imageUrl)];
      ImageUtils.saveNetworkImagesToPhoto(
          urls, (index) => DPrint.printf("????????????---$index"), (success) {
        dismissLoading();
        success ? showSuccess("????????????!") : showError("????????????!!");
      });
    });
  }

  List<Widget> _goodHeadDetail() {
    return <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 5),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _headPageView(),
            GoodPriceView(
              detailModel: widget.goodsDetail,
              shareCallback: () {
                String img = '';
                int length = widget.goodsDetail.data.mainPhotos.length;
                if (length >= 2)
                  img = widget.goodsDetail.data.mainPhotos[0].url;
                if (length >= 1)
                  img = widget.goodsDetail.data.mainPhotos[0].url;
                ShareTool().goodsShare(
                  context,
                  goodsPrice: widget.goodsDetail.data.getPriceString(),
                  goodsName: widget.goodsDetail.data.goodsName,
                  goodsDescription: widget.goodsDetail.data.description,
                  miniPicurl: img,
                  miniTitle:
                      "???${widget.goodsDetail.data.getPriceString()} | ${widget.goodsDetail.data.goodsName} | ${widget.goodsDetail.data.description}",
                  amount:
                      widget.goodsDetail.data.price.min.commission.toString(),
                  goodsId: widget.goodsDetail.data.id.toString(),
                );
              },
              isWholesale: isWholesale,
            ),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.only(top: 8.rw),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _discountContent(context),
      ),
      widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000||  widget.goodsDetail.data.vendorId == 3000
          ? Container(
              margin: EdgeInsets.only(bottom: 13),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: _addressContent(context),
            )
          : SizedBox(),
      widget.goodsDetail.data.storehouse == 2 ||
              widget.goodsDetail.data.storehouse == 3
          ? Container(
              margin: EdgeInsets.only(bottom: 13),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: _buildOverseaTax(),
            )
          : SizedBox(),
      widget.goodsDetail.data.isImport == 1
          ? Container(
              margin: EdgeInsets.only(bottom: 13),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: _buildOverseaCityPicker(),
            )
          : SizedBox(),
      Container(
        margin: EdgeInsets.only(bottom: 13),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _goodsInfoWidget(context),
      ),
      Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: _userEvaluation()),
      AppConfig.getShowCommission()
          ? Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 13, bottom: 1),
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                child: _storeName(),
                onTap: () {
                  if (widget.openbrandList != null) widget.openbrandList();
                },
              ),
            )
          : SizedBox(),
      AppConfig.getShowCommission()
          ? Container(
              //  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
              color: Colors.white,
              child: _recommendsWidget(),
            )
          : SizedBox(),
//            _usersLikeGrid(),
    ];
  }

  _headPageView() {
    List images = [];
    // if (widget.goodsDetail.data.video != null) {
    //   images.add(widget.goodsDetail.data.video);
    // }
    images.addAll(widget.goodsDetail.data.mainPhotos);
    return ImagePageView(
        images: images,
        living: widget.goodsDetail.data.living,
        onScrolled: (index) {});
  }

  /// ?????????  ?????????
  Column _discountContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // GestureDetector(
        //   behavior: HitTestBehavior.translucent,
        //   onTap: widget.goodsDetail.data.coupons.length == 0
        //       ? null
        //       : () {
        //           if (UserManager.instance.user.info.id == 0) {
        //             AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
        //             Toast.showError('????????????...');
        //             return;
        //           }
        //           if(widget.goodsDetail.data.secKill!=null?widget.goodsDetail.data.secKill.secKill==0:true)
        //           {
        //             showCustomModalBottomSheet(
        //                 context: context,
        //                 builder: (context) {
        //                   return CouponListPage(
        //                     brandId: widget.goodsDetail.data.brandId,
        //                   );
        //                 });
        //           }
        //
        //         },
        //   child: Row(children: _coupons()),
        // ),
        Container(
          child: GestureDetector(
            onTap: () async {
              if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000 || widget.goodsDetail.data.vendorId == 3000) {
                if (_defaltAddress == null) {

                  await  Get.to(ReceivingAddressPage());


                  if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000|| widget.goodsDetail.data.vendorId == 3000) {
                    Future.delayed(Duration.zero, () async {
                      _addressList = await _getDefaultAddress();
                      if (_addressList != null) {
                        _addressList.forEach((element) {
                          if (element.isDefault == 1) _addressModel = element;
                          if (_addressModel != null) {
                            _defaltAddress = _addressModel.province +
                                _addressModel.city +
                                _addressModel.district;
                            if (_defaltAddress != null) {
                              Future.delayed(Duration.zero, () async {
                                _jDHaveGoods =
                                await HomeDao.getJDStock(widget.goodsDetail.data.sku.first.id, _defaltAddress);
                                print(_jDHaveGoods);
                                setState(() {});
                              });
                            }
                          }
                        });
                      }
                    });

                  }
                } else {
                  _showSkuChoosePage(context);

                }
              } else {
                _showSkuChoosePage(context);

              }
            },
            child: StatefulBuilder(
              builder: (BuildContext context, partSetState) {
                _stateSetter = partSetState;
                return Row(
                  children: <Widget>[
                    Text(
                      "??????",
                      style: AppTextStyle.generate(13 * 2.sp,
                          color: Color(0xff828282),
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        child: Text(
                      guige,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(13 * 2.sp,
                          color: Color(0xff373737)),
                    )),
                    Icon(
                      AppIcons.icon_next,
                      color: Colors.grey[400],
                      size: 16 * 2.sp,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _addressContent(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        // Toast.showInfo('??????????????????');
        await  Get.to(ReceivingAddressPage());
        if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000||widget.goodsDetail.data.vendorId == 3000) {
          Future.delayed(Duration.zero, () async {
            _addressList = await _getDefaultAddress();
            if (_addressList != null) {
              _addressList.forEach((element) {
                if (element.isDefault == 1) _addressModel = element;
                if (_addressModel != null) {
                  _defaltAddress = _addressModel.province +
                      _addressModel.city +
                      _addressModel.district;
                  if (_defaltAddress != null) {
                    Future.delayed(Duration.zero, () async {
                      _jDHaveGoods =
                      await HomeDao.getJDStock(widget.goodsDetail.data.sku.first.id, _defaltAddress);
                      print(_jDHaveGoods);
                      setState(() {});
                    });
                  }
                }
              });
            }
          });

        }



          // //cancel();
          // if (result) {
          //   //_selectCityAddress(context);
          //   // print(_defaltAddress);
          //   _jDHaveGoods =
          //       await HomeDao.getJDStock(widget.goodsDetail.data.sku.first.id, _defaltAddress);
          // }

      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '??????',
                  style: TextStyle(
                    color: Color(0xFFA4A4A4),
                    fontSize: rSP(13),
                  ),
                ),
                Container(
                  width: 20,
                ),
                Image.asset(
                  R.ASSETS_DINGWEI_ICON_PNG,
                  width: 20.w,
                  height: 20.w,
                ),
                6.wb,
                _cityModel == null
                    ? _addressModel != null
                        ? Container(
                            width: 270.rw,
                            child: Text(
                              '${_addressModel.province}-${_addressModel.city}-${_addressModel.district}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF525252),
                                fontSize: rSP(13),
                              ),
                            ),
                          )
                        : Text(
                            '????????????????????????',
                            style: TextStyle(
                              color: Color(0xFF525252),
                              fontSize: rSP(13),
                            ),
                          )
                    : Container(
                        width: 270.rw,
                        child: Text(
                          '${_cityAddress.province}-${_cityAddress.city}-${_cityAddress.district}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF525252),
                            fontSize: rSP(13),
                          ),
                        ),
                      ),
                Spacer(),
                Icon(
                  AppIcons.icon_next,
                  color: Colors.grey[400],
                  size: 16 * 2.sp,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 46.rw,
                ),
                Text(
                  _jDHaveGoods == 1
                      ? '??????'
                      : _jDHaveGoods == 0
                          ? '??????'
                          : '',
                  style: TextStyle(
                    color: Color(0xFF525252),
                    fontSize: rSP(13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _goodsInfoWidget(context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showCustomModalBottomSheet(
                context: context,
                builder: (context) {
                  return GoodsParamPage(
                      // skus: widget.goodsDetail.data.sku,
                      model: widget.goodsDetail);
                });
          },
          child: Row(
            children: <Widget>[
              Text(
                "??????",
                style: AppTextStyle.generate(13 * 2.sp,
                    color: Color(0xff828282), fontWeight: FontWeight.w300),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                  child: Text(
                    !isWholesale?"?????? ??????...":'???????????????????????????????????????',
                style:
                    AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
              )),
              Icon(
                AppIcons.icon_next,
                color: Colors.grey[400],
                size: 16 * 2.sp,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: widget.goodsDetail.data.isImport == 1
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "??????",
                      style: AppTextStyle.generate(13 * 2.sp,
                          color: Color(0xff828282),
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (widget.goodsDetail.data.storehouse == 2 ||
                                  widget.goodsDetail.data.storehouse == 3)
                              ? Text(
                                  "??????????????????????????????",
                                  style: AppTextStyle.generate(13 * 2.sp,
                                      color: Color(0xff373737)),
                                )
                              : SizedBox(),
                          (widget.goodsDetail.data.storehouse == 2 ||
                                  widget.goodsDetail.data.storehouse == 3)
                              ? rHBox(rSize(4))
                              : SizedBox(),
                          Row(
                            children: [
                              Text(
                                "?????????7?????????????????????",
                                style: AppTextStyle.generate(13 * 2.sp,
                                    color: Color(0xff373737)),
                              ),
                              (widget.goodsDetail.data.storehouse == 2 ||
                                      widget.goodsDetail.data.storehouse == 3)
                                  ? Text(
                                      "??? ??????????????????",
                                      style: AppTextStyle.generate(13 * 2.sp,
                                          color: Color(0xff373737)),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    // _showAuthImage();
                    showCustomModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return GoodsServiceGuarantee();
                        });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "??????",
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Color(0xff828282),
                              fontWeight: FontWeight.w300),
                        ),
                        Container(
                          width: 20,
                        ),
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            widget.goodsDetail.data.vendorId == 1800
                                ? Text(
                                    "??????????????? | ",
                                    style: AppTextStyle.generate(13 * 2.sp,
                                        color: Color(0xff373737)),
                                  )
                                : SizedBox(),
                            Text(
                              "????????????",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Color(0xff373737)),
                            ),
                            Text(
                              " | ",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Colors.grey.withOpacity(0.3)),
                            ),
                            Text(
                              "????????????",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Color(0xff373737)),
                            ),
                          ],
                        )),
                        Icon(
                          AppIcons.icon_next,
                          color: Colors.grey[400],
                          size: 16 * 2.sp,
                        )
                      ],
                    ),
                  )),
        ),
        // Container(
        //   margin: EdgeInsets.only(top: 10),
        //   child: GestureDetector(
        //     onTap: (){
        //       _showAuthImage();
        //     },
        //     child: Row(
        //       children: <Widget>[
        //         Text(
        //           "????????????",
        //           style: AppTextStyle.generate(13*2.sp,
        //               color: Color(0xff828282), fontWeight: FontWeight.w300),),
        //         Container(width: 20,),
        //         Expanded(
        //           child: Text(
        //             "????????????",
        //             style: AppTextStyle.generate(13*2.sp, color: Color(0xff373737)),
        //             )),
        //         Icon(
        //           AppIcons.icon_next,
        //           color: Colors.grey[400],
        //           size: 16*2.sp,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // _showAuthImage() {
  //   if (widget.goodsDetail == null ||
  //       TextUtils.isEmpty(widget.goodsDetail.data.brand.showUrl)) return;
  //   AppRouter.fade(
  //     context,
  //     RouteName.PIC_SWIPER,
  //     arguments: PicSwiper.setArguments(
  //       index: 0,
  //       pics: [
  //         PicSwiperItem(Api.getImgUrl(widget.goodsDetail.data.brand.showUrl))
  //       ],
  //     ),
  //   );
  // }

  _buildOverseaTax() {
    return Row(
      children: [
        Text(
          '?????????',
          style: TextStyle(
            color: Color(0xFFA4A4A4),
            fontSize: rSP(13),
          ),
        ),
        rWBox(7),
        widget.goodsDetail.data.isFerme == 1
            ? Container(
                alignment: Alignment.center,
                height: rSize(14),
                width: rSize(32),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE5ED),
                  borderRadius: BorderRadius.circular(rSize(7)),
                ),
                child: Text(
                  '??????',
                  style: TextStyle(
                    color: Color(0xFFCC1B4F),
                    fontSize: rSP(10),
                  ),
                ),
              )
            : SizedBox(),
        widget.goodsDetail.data.isFerme == 1 ? rWBox(10) : SizedBox(),
        widget.goodsDetail.data.isFerme == 1
            ? Text(
                '????????${widget.goodsDetail.data.price.min.ferme.toStringAsFixed(2)}?????????????????????',
                style: TextStyle(
                  fontSize: rSP(13),
                  color: Color(0xFF535353),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Future<bool> _getAddress() async {
    FileOperationResult result =
        await FileUtils.readJSON(AppPaths.path_province_city_json);
    if (result.success &&
        result.data != null &&
        result.data.toString().length > 0) {
      _overseaCityModel = ProvinceCityModel.fromJson(json.decode(result.data));
      return true;
    }
    ResultData res = await AddressModelImpl().fetchWholeProvince();
    if (!res.result) {
      Toast.showError(res.msg);
      return false;
    }
    _overseaCityModel = ProvinceCityModel.fromJson(res.data);
    FileUtils.writeJSON(
        AppPaths.path_province_city_json, json.encode(res.data));
    return true;
  }

  Future<bool> _getCityAddress() async {
    FileOperationResult result =
        await FileUtils.readJSON(AppPaths.path_province_city_json);
    if (result.success &&
        result.data != null &&
        result.data != [] &&
        result.data.toString().length > 0) {

      _cityModel = ProvinceCityModel.fromJson(json.decode(result.data));
      return true;
    }
    ResultData res = await AddressModelImpl().fetchWholeProvince();
    if (!res.result) {
      Toast.showError(res.msg);
      return false;
    }
    _cityModel = ProvinceCityModel.fromJson(res.data);
    FileUtils.writeJSON(
        AppPaths.path_province_city_json, json.encode(res.data));
    return true;
  }

  Future<List<AddressDefaultModel>> _getDefaultAddress() async {
    ResultData res = await HttpManager.post(UserApi.address_list, {
      "userId": UserManager.instance.user.info.id,
    });
    if (res != null) {
      if (res.data != null) {
        print(res.data);
        if (res.data["data"] != null) {
          print(res.data["data"]);
          return (res.data['data'] as List)
              .map((e) => AddressDefaultModel.fromJson(e))
              .toList();
        } else
          return null;
      } else
        return null;
    } else
      return null;
  }

  _selectAddress(BuildContext context) {
    AddressSelectorHelper.show(
      context,
      model: _overseaCityModel,
      city: _address.city,
      province: _address.province,
      district: _address.district,
      callback: (
        String province,
        String city,
        String district,
      ) {
        _address.city = city;
        _address.province = province;
        _address.district = district;
        setState(() {});
      },
    );
  }


  _buildOverseaCityPicker() {
    return GestureDetector(
      onTap: () async {
        if (_overseaCityModel == null) {
          final cancel = ReToast.loading();
          bool result = await _getAddress();
          cancel();
          if (result) {
            _selectAddress(context);
          }
        }
        _selectAddress(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '??????',
                  style: TextStyle(
                    color: Color(0xFFA4A4A4),
                    fontSize: rSP(13),
                  ),
                ),
                Container(
                  width: 20,
                ),
                ..._overseaCityModel == null
                    ? [
                        Text(
                          '?????????',
                          style: TextStyle(
                            color: Color(0xFFCC1B4F),
                            fontSize: rSP(13),
                          ),
                        ),
                        Text(
                          '????????????',
                          style: TextStyle(
                            color: Color(0xFF525252),
                            fontSize: rSP(13),
                          ),
                        ),
                      ]
                    : [
                        Text(
                          '${_address.province}-${_address.city}-${_address.district}',
                          style: TextStyle(
                            color: Color(0xFF525252),
                            fontSize: rSP(13),
                          ),
                        ),
                      ],
                Spacer(),
                Icon(
                  AppIcons.icon_next,
                  color: Colors.grey[400],
                  size: 16 * 2.sp,
                ),
              ],
            ),
            rHBox(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                rWBox(41),
                Column(
                  children: [
                    Image.asset(
                      R.ASSETS_STATIC_OVERSEA_ZHENG_PNG,
                      height: rSize(26),
                      width: rSize(26),
                    ),
                    rHBox(5),
                    Text(
                      '????????????',
                      style: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: rSP(12),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '- - - - - -',
                      style: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: rSP(15),
                        height: 1,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Builder(
                      builder: (context) {
                        String text = '';
                        String text2 = '';
                        switch (widget.goodsDetail.data.storehouse) {
                          case 0:
                            text = '';
                            break;
                          case 1:
                            text = R.ASSETS_STATIC_OVERSEA_BOX_PNG;
                            text2 = R.ASSETS_STATIC_OVERSEA_BOX_ON_PNG;
                            break;
                          case 2:
                            text = R.ASSETS_STATIC_OVERSEA_FLIGHT_PNG;
                            text2 = R.ASSETS_STATIC_OVERSEA_FLIGHT_ON_PNG;
                            break;
                          case 3:
                            text = R.ASSETS_STATIC_OVERSEA_BOX_G_PNG;
                            text2 = R.ASSETS_STATIC_OVERSEA_BOX_G_ON_PNG;
                            break;
                          default:
                            break;
                        }
                        return Image.asset(
                          _address?.city == '' ? text : text2,
                          height: rSize(26),
                          width: rSize(26),
                        );
                      },
                    ),
                    rHBox(5),
                    Builder(
                      builder: (context) {
                        String text = '';
                        switch (widget.goodsDetail.data.storehouse) {
                          case 0:
                            text = '';
                            break;
                          case 1:
                            text = '?????????';
                            break;
                          case 2:
                            text = '????????????';
                            break;
                          case 3:
                            text = '?????????';
                            break;
                          default:
                            break;
                        }
                        return Text(
                          text,
                          style: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: rSP(12),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '- - - - - -',
                      style: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: rSP(15),
                        height: 1,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Image.asset(
                      _address?.city == ''
                          ? R.ASSETS_STATIC_OVERSEA_LOCATION_PNG
                          : R.ASSETS_STATIC_OVERSEA_LOCATION_ON_PNG,
                      height: rSize(26),
                      width: rSize(26),
                    ),
                    rHBox(5),
                    Text(
                      _address.city,
                      style: TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: rSP(12),
                      ),
                    ),
                  ],
                ),
                rWBox(27),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List _coupons() {
    List<Widget> coupons = [
      Text(
        "??????",
        style: AppTextStyle.generate(13 * 2.sp,
            color: Color(0xff828282), fontWeight: FontWeight.w300),
      ),
      Container(
        width: 20,
      ),
    ];

    if (widget.goodsDetail.data.coupons.length == 0||
        (widget.goodsDetail.data.secKill!=null?widget.goodsDetail.data.secKill.secKill==1:false)) {//????????????????????????????????????
      coupons.add(
        Text(
          "???????????????",
          maxLines: 1,
          style: AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
          // style: AppTextStyle.generate(
          //   11*2.sp,
          //   color: Colors.grey[700],
          // ),
        ),
      );
      return coupons;
    }


    for (int i = 0; i < widget.goodsDetail.data.coupons.length; i++) {
      if (i > 2) break;
      Coupons coupon = widget.goodsDetail.data.coupons[i];

      coupons.add(Container(
        height: 26,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(vertical: 1.5 * 2.w),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/goods_page_coupon.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                coupon.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.generate(12 * 2.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ));
    }

    coupons.addAll([
      Expanded(child: Container()),
      Icon(
        AppIcons.icon_next,
        color: Colors.grey,
        size: 16 * 2.sp,
      )
    ]);
    return coupons;
  }

  _userEvaluation() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "????????????",
              style: AppTextStyle.generate(15 * 2.sp,
                  fontWeight: FontWeight.w500, color: Color(0xff333333)),
            ),
            Text(
              " (${widget.goodsDetail.data.evaluations.total})",
              style: AppTextStyle.generate(15 * 2.sp, color: Color(0xffb5b5b5)),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                push(RouteName.EVALUATION_LIST_PAGE,
                    arguments: EvaluationListPage.setArguments(
                        goodsId: widget.goodsId));
              },
              child: Text(
                "????????????",
                textAlign: TextAlign.end,
                style: AppTextStyle.generate(14 * 2.sp,
                    color: AppColor.themeColor, fontWeight: FontWeight.w300),
              ),
            )),
            Container(
              width: 5,
            ),
            Icon(
              AppIcons.icon_next,
              size: rSize(12),
            )
          ],
        ),
        widget.goodsDetail.data.evaluations.children.length == 0
            ? Container()
            : Container(
                height: 90,
                child: GridView.builder(
                    padding: EdgeInsets.only(top: rSize(5)),
//                shrinkWrap: true,
                    itemCount:
                        widget.goodsDetail.data.evaluations.children.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.35,
                        mainAxisSpacing: 10,
                        crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      return UserCommentItem(
                        evaluation:
                            widget.goodsDetail.data.evaluations.children[index],
                      );
                    }),
              )
      ],
    );
  }

  //??????????????? ????????????
  _recommendsWidget() {
    return Container(
      height: 253,
      // padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            height: 50,
            child: Text('????????????',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16 * 2.sp)),
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.goodsDetail.data.recommends.length,
              itemBuilder: (_, index) {
                Recommends recommends =
                    widget.goodsDetail.data.recommends[index];
                return GestureDetector(
                  onTap: () {
                    AppRouter.push(context, RouteName.COMMODITY_PAGE,
                        arguments: CommodityDetailPage.setArguments(
                            recommends.goodsId));
                  },
                  child: _recommendsItemWidget(recommends),
                );
              },
            ),
          ),
          Container(
            height: 20,
            color: Colors.white,
          ),
          Container(
            height: 13,
            color: AppColor.frenchColor,
          ),
        ],
      ),
    );
  }

  _recommendsItemWidget(Recommends recommends) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 110,
            height: 110,
            child: _img(recommends.mainPhotoUrl),
          ),
          Container(
            height: 3,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              recommends.goodsName,
              maxLines: 2,
              style: TextStyle(color: Color(0xff828282), fontSize: 12),
            ),
          )),
          Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 16,
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '???',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13 * 2.sp),
                    ),
                  ),
                  Text(
                    '${recommends.price}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 17 * 2.sp),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  _img(imageUrl) {
    double cir = rSize(8);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cir), topRight: Radius.circular(cir)),
      child: AspectRatio(
        aspectRatio: 2.5,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(rSize(10))),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getResizeImgUrl(
                imageUrl, DeviceInfo.screenWidth.toInt() * 2),
          ),
        ),
      ),
    );
  }

  _storeName() {
    DPrint.printf(Api.getImgUrl(widget.goodsDetail.data.brand.logoUrl));
    Row row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // ClipRRect(
        //   borderRadius: BorderRadius.all(Radius.circular(5)),
        //   child: CustomCacheImage(
        //       height: rSize(80),
        //       width: rSize(80),
        //       fit: BoxFit.cover,
        //       imageUrl: Api.getImgUrl(widget.goodsDetail.data.brand.logoUrl)),
        // ),
        // Container(
        //   width: 10,
        // ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.goodsDetail.data.brand.name,
                style: AppTextStyle.generate(18 * 2.sp,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 16,
              ),
              Text(
                "??????????????? ${widget.goodsDetail.data.brand.goodsCount}",
                style:
                    AppTextStyle.generate(13 * 2.sp, color: Colors.grey[700]),
              )
            ],
          ),
        ),
        CustomImageButton(
          title: "????????????",
          style: AppTextStyle.generate(15 * 2.sp, color: Colors.grey[700]),
          onPressed: () {
            if (widget.openbrandList != null) widget.openbrandList();
          },
        ),
        // Text(
        //   "????????????",
        //   style: AppTextStyle.generate(15*2.sp, color: Colors.grey[700]),
        // ),
        Container(
          width: 5,
        ),
        Icon(
          AppIcons.icon_next,
          color: Colors.grey,
          size: 16,
        )
      ],
    );
    return Container(
      color: Colors.white,
      child: row,
    );
  }



  void _showSkuChoosePage(BuildContext context) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return SkuChoosePage(
            model: widget.goodsDetail,
            results: _validSkuResult,
            itemModels: _itemModels,
            listener:  (SkuChooseModel skuModel) async {
              if (UserManager.instance.user.info.id == 0) {
                AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                Toast.showError('????????????...');
                return;
              }
              print("${skuModel.sku.id} -- ${skuModel.des} -- ${skuModel.num}");
               if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000 || widget.goodsDetail.data.vendorId == 3000) {
                 if (_defaltAddress == null) {
                   widget.openSkuChoosePage.value = false;
                   Toast.showInfo('??????????????????');

                   await  Get.to(ReceivingAddressPage());


                   if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000 || widget.goodsDetail.data.vendorId == 3000) {
                     Future.delayed(Duration.zero, () async {
                       _addressList = await _getDefaultAddress();
                       if (_addressList != null) {
                         _addressList.forEach((element) {
                           if (element.isDefault == 1) _addressModel = element;
                           if (_addressModel != null) {
                             _defaltAddress = _addressModel.province +
                                 _addressModel.city +
                                 _addressModel.district;
                             if (_defaltAddress != null) {
                               Future.delayed(Duration.zero, () async {
                                 _jDHaveGoods =
                                 await HomeDao.getJDStock(widget.goodsDetail.data.sku.first.id, _defaltAddress);
                                 print(_jDHaveGoods);
                                 setState(() {});
                               });
                             }
                           }
                         });
                       }
                     });

                   }

                   return;
                 }else{
                   _jDHaveGoods =
                   await HomeDao.getJDStock(skuModel.sku.id, _defaltAddress);
                   setState(() {

                   });

                   if (_jDHaveGoods != 1) {
                     Toast.showInfo('???????????????????????????????????????');
                     _selectedSkuDes();
                     setState(() {

                     });
                     return;
                   }
                 }

              }

              if (skuModel.num > 50) {
                skuModel.num = 50;
              }

              if (skuModel.selectedIndex == 1) {
                ReToast.loading(text: '');
                if (widget.goodsDetail.data.living.status != 0 ||
                    widget.goodsDetail.data.living.roomId != 0)
                  HttpManager.post(LiveAPI.buyGoodsInform, {
                    "liveItemId": widget.goodsDetail.data.living.roomId,
                    "goodsId": widget.goodsId,
                  });
                _createOrder(
                  skuModel,
                  context,
                );
                return;
              } else {
                GoodsDetailModel detailModel = widget.goodsDetail;
                // ????????????????????????????????????
                // if (detailModel.data.promotion!=null && detailModel.data.promotion.id > 0) {
                //   if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(detailModel) == PromotionStatus.ready){
                //     showError('??????????????????????????????????????????');
                //     return;
                //   }
                // }
                ReToast.loading(text: '');
                _addToShoppingCart(context, skuModel);
              }
            },
          );
        }).then((value) {
      widget.openSkuChoosePage.value = false;
      if (_stateSetter != null) {
        guige = '???????????????';
        _selectedSkuDes();
        _stateSetter(() {

        });
      }
    });
  }

  Future<dynamic> _addToShoppingCart(
      BuildContext context, SkuChooseModel skuModel) async {
    ResultData resultData = await _shoppingCartModelImpl.addToShoppingCart(
        UserManager.instance.user.info.id,
        skuModel.sku.id,
        skuModel.des,
        skuModel.num);
    if (!resultData.result) {
      ReToast.err(text: resultData.msg);
      Get.back();
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      Get.back();
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    UserManager.instance.refreshShoppingCartNumber.value = true;
    UserManager.instance.refreshShoppingCartNumberWithPage.value = true;
    ReToast.success(text: '????????????');
    Get.back();
    Get.back();
  }

  Future<dynamic> _createOrder(SkuChooseModel skuModel, BuildContext context) async {
    OrderPreviewModel order = await GoodsDetailModelImpl.createOrderPreview(
      UserManager.instance.user.info.id,
      skuModel.sku.id,
      skuModel.des,
      skuModel.num,
    );
    if (order.code != HttpStatus.SUCCESS) {
      // Toast.showError(order.msg);
      Toast.showInfo(order.msg, color: Colors.black87);
      Get.back();
      if(_addressList.isEmpty){
        Get.to(ReceivingAddressPage());
      }
      return;
    }
    AppRouter.push(context, RouteName.GOODS_ORDER_PAGE,
        arguments: GoodsOrderPage.setArguments(order));
  }

  _chooseValues() {
    return widget.goodsDetail.data.attributes.map((Attributes attr) {
      return SelectedListItemModel(
          attr.name,
          attr.children
              .map((Children children) => SelectedListItemChildModel(
                  id: children.id,
                  canSelected: _validSkuResult.contains(children.id.toString()),
                  itemTitle: children.value.toString()))
              .toList());
    }).toList();
  }

  /*
  ???????????????sku ????????????
  */
  List<String> _validSkuResult = [];
  var temp = [];

  _skuCombinations() {
    widget.goodsDetail.data.sku.forEach((Sku sku) {
      if (sku.inventory > 0) {
        List ids = sku.combineId.split(",");
        ids.forEach((id) {
          if (!_validSkuResult.contains(id)) {
            _validSkuResult.add(id);
          }
        });
        _listCombination(ids);
      }
    });
  }

  _listCombination(List arr) {
    for (var i = 0; i < arr.length; i++) {
      // ?????????i??????
      temp.add(arr[i]);
      // ????????????
      var copy = [];
      copy.addAll(arr);
      // ???????????????????????????i?????????????????????
      copy.removeAt(i);
      if (copy.length == 0) {
        // ???????????????????????????0?????????????????????
        temp.sort();
        if (!_validSkuResult.contains(temp.join("-"))) {
          _validSkuResult.add(temp.join("-"));
        }
      } else {
        // ??????????????????
        _listCombination(copy);
      }
      // ???????????????????????????????????????????????????????????????????????????????????????????????????
      temp.clear();
    }
  }

  _selectedSkuDes() {
    StringBuffer stringBuffer = StringBuffer("??????:");
    bool hasSelected = false;

    DPrint.printf(_itemModels.length);
    _itemModels.forEach((SelectedListItemModel model)  {
      if (model.selectedIndex != null) {
        hasSelected = true;
        stringBuffer.write(" ");
        stringBuffer.write("\???${model.items[model.selectedIndex].itemTitle}\???");
        if(guige == '???????????????'){
          guige = model.items[model.selectedIndex].itemTitle;
        }else{
          guige += ('+'+model.items[model.selectedIndex].itemTitle);
        }


      }
    });

    widget.goodsDetail.data.sku.forEach((Sku sku) {
      if (sku.name == guige) {
        if (widget.goodsDetail.data.vendorId == 1800 || widget.goodsDetail.data.vendorId == 2000 || widget.goodsDetail.data.vendorId == 3000) {
          Future.delayed(Duration.zero, () async {
            _jDHaveGoods =
            await HomeDao.getJDStock(sku.id, _defaltAddress);
            setState(() {});
          });
          setState(() {
          });
        }
      }
    });





  }
}
