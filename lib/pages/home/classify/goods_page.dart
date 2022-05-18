import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/home_dao.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/address_list_model.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_images_model.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/models/province_city_model.dart';
import 'package:recook/pages/home/classify/goods_param_page.dart';
import 'package:recook/pages/home/classify/goods_service_guarantee.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/classify/order_preview_page.dart';
import 'package:recook/pages/home/classify/sku_choose_page.dart';
import 'package:recook/pages/home/model/address_model.dart';
import 'package:recook/pages/home/widget/good_price_view.dart';
import 'package:recook/pages/home/widget/goods_image_page_view.dart';
import 'package:recook/pages/shopping_cart/mvp/shopping_cart_model_impl.dart';
import 'package:recook/pages/user/address/mvp/address_model_impl.dart';
import 'package:recook/pages/user/address/receiving_address_page.dart';
import 'package:recook/utils/file_utils.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/bottom_sheet/address_selector.dart';
import 'package:recook/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/empty_view.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/selected_list.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/video_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

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
  final void Function() openbrandList; //打开商家页面
  final String invite;

  const GoodsPage({
    Key key,
    this.onScroll,
    this.goodsId,
    this.openSkuChoosePage,
    this.goodsDetail,
    this.openbrandList,
    this.invite,
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

  // int _seckillStatus = 0;//秒杀状态 0为未开始 1为开始
  String guige = '请选择规格';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //获取默认地址并且判断有无货源
    if (widget.goodsDetail.data.vendorId == 1800 ||
        widget.goodsDetail.data.vendorId == 2000 ||
        widget.goodsDetail.data.vendorId == 3000) {
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
                  _jDHaveGoods = await HomeDao.getJDStock(
                      widget.goodsDetail.data.sku.first.id, _defaltAddress);
                  print(_jDHaveGoods);
                  setState(() {});
                });
              }
            }
          });
        }
      });
    }
    //goodsDetail.data.vendorId为1800或者2000

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
                  //ListView 子项不销毁
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
      return (GestureDetector(
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
          child: Text("图文详情",
              style: AppTextStyle.generate(14.rsp,
                  fontWeight: FontWeight.bold, color: Color(0xFF111111))),
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
    //                 "继续上拉查看发圈素材",
    //                 style:
    //                     AppTextStyle.generate(15, color: Colors.grey, fontWeight: FontWeight.w300),
    //               )
    //             ],
    //           ),
    //         ));
    insertFirst() {
      if (widget.goodsDetail.data.notice.img != null)
        for (int i = 0; i < widget.goodsDetail.data.notice.img.length; i++) {
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
      if (widget.goodsDetail.data.notice.img != null)
        for (int i = 0; i < widget.goodsDetail.data.notice.img.length; i++) {
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
    ActionSheet.show(context, items: ['保存到相册'], listener: (index) {
      ActionSheet.dismiss(context);
      showLoading("保存图片中...");
      List<String> urls = [Api.getImgUrl(imageUrl)];
      ImageUtils.saveNetworkImagesToPhoto(
          urls, (index) => DPrint.printf("保存好了---$index"), (success) {
        dismissLoading();
        success
            ? showSuccess("保存完成!")
            : Alert.show(
                context,
                NormalContentDialog(
                  title: '提示',
                  content: Text(
                    '图片保存失败，请前往应用权限页，设置存储权限为始终允许',
                    style:
                        TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
                  ),
                  items: ["取消"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "确认",
                  deleteListener: () async {
                    Alert.dismiss(context);
                    bool isOpened = await openAppSettings();
                  },
                  type: NormalTextDialogType.delete,
                ),
              );
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
                      "￥${widget.goodsDetail.data.getPriceString()} | ${widget.goodsDetail.data.goodsName} | ${widget.goodsDetail.data.description}",
                  amount:
                      widget.goodsDetail.data.price.min.commission.toString(),
                  goodsId: widget.goodsDetail.data.id.toString(),
                );
              },
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
      widget.goodsDetail.data.vendorId == 1800 ||
              widget.goodsDetail.data.vendorId == 2000 ||
              widget.goodsDetail.data.vendorId == 3000
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: _addressContent(context),
            )
          : SizedBox(),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _goodsInfoWidget(context),
      ),
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
              margin: EdgeInsets.only(bottom: 13.rw),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.white,
              child: _buildOverseaCityPicker(),
            )
          : SizedBox(),

      AppConfig.getShowCommission()
          ? Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 8.rw, bottom: 8.rw),
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
    return ImagePageView(images: images, onScrolled: (index) {});
  }

  /// 优惠券  规格等
  Column _discountContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: GestureDetector(
            onTap: () async {
              if (UserManager.instance.user.info.id == 0) {
                AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                Toast.showError('请先登录...');
                return;
              }

              if (widget.goodsDetail.data.vendorId == 1800 ||
                  widget.goodsDetail.data.vendorId == 2000 ||
                  widget.goodsDetail.data.vendorId == 3000) {
                if (_defaltAddress == null) {
                  final Map<String, dynamic> results = <String, dynamic>{
                    'canBack': true,
                  };

                  Address address = await Get.to(() => ReceivingAddressPage(
                        arguments: results,
                      ));


                  if (address == null) {
                    if (widget.goodsDetail.data.vendorId == 1800 ||
                        widget.goodsDetail.data.vendorId == 2000 ||
                        widget.goodsDetail.data.vendorId == 3000) {
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
                                  _jDHaveGoods = await HomeDao.getJDStock(
                                      widget.goodsDetail.data.sku.first.id,
                                      _defaltAddress);
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
                    if (widget.goodsDetail.data.vendorId == 1800 ||
                        widget.goodsDetail.data.vendorId == 2000 ||
                        widget.goodsDetail.data.vendorId == 3000) {
                      _defaltAddress =
                          address.province + address.city + address.district;
                      if (_defaltAddress != null) {
                        Future.delayed(Duration.zero, () async {
                          _jDHaveGoods = await HomeDao.getJDStock(
                              widget.goodsDetail.data.sku.first.id,
                              _defaltAddress);

                          setState(() {});
                        });
                      }
                    }
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
                return Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          '规格',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(
                            13 * 2.sp,
                            color: Color(0xFFA4A4A4),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                        ...widget.goodsDetail.data.sku
                            .mapIndexed((currentValue, index) {
                          return index < 6
                              ? Container(
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.only(right: 8.rw),
                                  width: 32.rw,
                                  height: 32.rw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.rw),
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                                    image: currentValue.picUrl,
                                  ),
                                )
                              : SizedBox();
                        }).toList(),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.rw),
                              color: Color(0xFFF9F9F9)),
                          padding: EdgeInsets.symmetric(
                              vertical: 3.rw, horizontal: 6.rw),
                          child: Text(
                            '共${widget.goodsDetail.data.sku.length}款',
                            style: TextStyle(
                                color: Color(0xFF666666), fontSize: 12.rsp),
                          ),
                        )
                      ],
                    ),
                    24.hb,
                    Row(
                      children: [
                        Text(
                          '规格',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Colors.transparent),
                        ),
                        Container(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          (guige != '请选择规格' ? '已选：' : '') + guige,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Color(0xff373737)),
                        )),
                        Icon(
                          AppIcons.icon_next,
                          color: Color(0xFF333333),
                          size: 13 * 2.sp,
                        )
                      ],
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
        if (UserManager.instance.user.info.id == 0) {
          AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
          Toast.showError('请先登录...');
          return;
        }

        final Map<String, dynamic> results = <String, dynamic>{
          'canBack': true,
        };

        Address address = await Get.to(() => ReceivingAddressPage(
              arguments: results,
            ));

        if (address == null) {
          if (widget.goodsDetail.data.vendorId == 1800 ||
              widget.goodsDetail.data.vendorId == 2000 ||
              widget.goodsDetail.data.vendorId == 3000) {
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
                        _jDHaveGoods = await HomeDao.getJDStock(
                            widget.goodsDetail.data.sku.first.id,
                            _defaltAddress);
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
          if (widget.goodsDetail.data.vendorId == 1800 ||
              widget.goodsDetail.data.vendorId == 2000 ||
              widget.goodsDetail.data.vendorId == 3000) {
            _addressModel = AddressDefaultModel(
                id: address.id,
                name: address.name,
                mobile: address.mobile,
                province: address.province,
                city: address.city,
                district:address.district,
                address: address.address,
                isDefault:address.isDefault,
            );
            _defaltAddress = address.province + address.city + address.district;
            if (_defaltAddress != null) {
              Future.delayed(Duration.zero, () async {
                _jDHaveGoods = await HomeDao.getJDStock(
                    widget.goodsDetail.data.sku.first.id, _defaltAddress);

                if(mounted)
                setState(() {});
              });
            }
          }
        }

      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '地址',
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
                            width: 250.rw,
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
                            '您还没有配置地址',
                            style: TextStyle(
                              color: Color(0xFF525252),
                              fontSize: rSP(13),
                            ),
                          )
                    : Container(
                        width: 250.rw,
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
                Text(
                  _jDHaveGoods == 1
                      ? '有货'
                      : _jDHaveGoods == 0
                          ? '无货'
                          : '',
                  style: TextStyle(
                    color: Color(0xFFD5101A),
                    fontSize: 13.rsp,
                  ),
                ),
                10.wb,
                Icon(
                  AppIcons.icon_next,
                  color: Color(0xFF333333),
                  size: 13 * 2.sp,
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
                "参数",
                style: AppTextStyle.generate(13 * 2.sp,
                    color: Color(0xff828282), fontWeight: FontWeight.w300),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                  child: Text(
                "品牌 工艺...",
                style:
                    AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
              )),
              Icon(
                AppIcons.icon_next,
                color: Color(0xFF333333),
                size: 13 * 2.sp,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.rw),
          child: widget.goodsDetail.data.isImport == 1
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "服务",
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
                                  "跨境商品不支持开发票",
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
                                "不支持7天无理由退换货",
                                style: AppTextStyle.generate(13 * 2.sp,
                                    color: Color(0xff373737)),
                              ),
                              (widget.goodsDetail.data.storehouse == 2 ||
                                      widget.goodsDetail.data.storehouse == 3)
                                  ? Text(
                                      "｜ 不支持开发票",
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
                          return GoodsServiceGuarantee(
                            model: widget.goodsDetail,
                          );
                        });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "服务",
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
                                    "京东仓发货 | ",
                                    style: AppTextStyle.generate(13 * 2.sp,
                                        color: Color(0xff373737)),
                                  )
                                : SizedBox(),
                            Text(
                              "正品保证",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Color(0xff373737)),
                            ),
                            Text(
                              " | ",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Color(0xff373737)),
                            ),
                            Text(
                              widget.goodsDetail.data.isAllow
                                  ? '支持七天无理由退换货'
                                  : "售后无忧",
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Color(0xff373737)),
                            ),
                          ],
                        )),
                        Icon(
                          AppIcons.icon_next,
                          color: Color(0xFF333333),
                          size: 13 * 2.sp,
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
        //           "品牌授权",
        //           style: AppTextStyle.generate(13*2.sp,
        //               color: Color(0xff828282), fontWeight: FontWeight.w300),),
        //         Container(width: 20,),
        //         Expanded(
        //           child: Text(
        //             "查看授权",
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
          '进口税',
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
                  '包税',
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
                '预计¥${widget.goodsDetail.data.price.min.ferme.toStringAsFixed(2)}由瑞库客承担',
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
                  '送至',
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
                          '请选择',
                          style: TextStyle(
                            color: Color(0xFFCC1B4F),
                            fontSize: rSP(13),
                          ),
                        ),
                        Text(
                          '收货地址',
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
                  color: Color(0xFF333333),
                  size: 13 * 2.sp,
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
                      '正品保障',
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
                            text = '国内仓';
                            break;
                          case 2:
                            text = '海外直邮';
                            break;
                          case 3:
                            text = '保税仓';
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
        "领券",
        style: AppTextStyle.generate(13 * 2.sp,
            color: Color(0xff828282), fontWeight: FontWeight.w300),
      ),
      Container(
        width: 20,
      ),
    ];

    if (widget.goodsDetail.data.coupons.length == 0 ||
        (widget.goodsDetail.data.secKill != null
            ? widget.goodsDetail.data.secKill.secKill == 1
            : false)) {
      //秒杀中的商品都没有优惠券
      coupons.add(
        Text(
          "暂无优惠劵",
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
        color: Color(0xFF333333),
        size: 13 * 2.sp,
      )
    ]);
    return coupons;
  }

  //大家都在买 推荐商品
  _recommendsWidget() {
    return Container(
      height: 200.rw,
      // padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            height: 50,
            child: Text('为你推荐',
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
              itemCount: widget.goodsDetail.data.recommends == null
                  ? 0
                  : widget.goodsDetail.data.recommends.length,
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
            height: 13,
            color: AppColor.frenchColor,
          ),
        ],
      ),
    );
  }

  _recommendsItemWidget(Recommends recommends) {
    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 10.rw),
      width: 80.rw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.rw,
            height: 80.rw,
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
              style: TextStyle(color: Color(0xff828282), fontSize: 10.rsp),
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
                      '￥',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12 * 2.sp),
                    ),
                  ),
                  Text(
                    '${recommends.price}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12 * 2.sp),
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.goodsDetail.data.brand.name,
                style: AppTextStyle.generate(14 * 2.sp,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 10.rw,
              ),
              Text(
                "商品数量： ${widget.goodsDetail.data.brand.goodsCount}",
                style:
                    AppTextStyle.generate(12 * 2.sp, color: Color(0xFF666666)),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.openbrandList != null) widget.openbrandList();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFDB1E1E),
              borderRadius: BorderRadius.circular(14.5.rw),
            ),
            padding: EdgeInsets.symmetric(vertical: 4.rw, horizontal: 12.rw),
            child: Text(
              '进入',
              style: AppTextStyle.generate(12 * 2.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.rw, horizontal: 12.rw),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.brandBg.path), fit: BoxFit.fill)),
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
            listener: (SkuChooseModel skuModel) async {
              if (UserManager.instance.user.info.id == 0) {
                AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                Toast.showError('请先登录...');
                return;
              }
              print("${skuModel.sku.id} -- ${skuModel.des} -- ${skuModel.num}");
              if (widget.goodsDetail.data.vendorId == 1800 ||
                  widget.goodsDetail.data.vendorId == 2000 ||
                  widget.goodsDetail.data.vendorId == 3000) {
                if (_defaltAddress == null) {
                  widget.openSkuChoosePage.value = false;
                  Toast.showInfo('请先添加地址');
                  final Map<String, dynamic> results = <String, dynamic>{
                    'canBack': true,
                  };

                  Address address = await Get.to(() => ReceivingAddressPage(
                    arguments: results,
                  ));

                  if (address == null) {
                    if (widget.goodsDetail.data.vendorId == 1800 ||
                        widget.goodsDetail.data.vendorId == 2000 ||
                        widget.goodsDetail.data.vendorId == 3000) {
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
                                  _jDHaveGoods = await HomeDao.getJDStock(
                                      widget.goodsDetail.data.sku.first.id,
                                      _defaltAddress);
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
                    if (widget.goodsDetail.data.vendorId == 1800 ||
                        widget.goodsDetail.data.vendorId == 2000 ||
                        widget.goodsDetail.data.vendorId == 3000) {
                      _addressModel = AddressDefaultModel(
                        id: address.id,
                        name: address.name,
                        mobile: address.mobile,
                        province: address.province,
                        city: address.city,
                        district:address.district,
                        address: address.address,
                        isDefault:address.isDefault,
                      );
                      _defaltAddress = address.province + address.city + address.district;
                      if (_defaltAddress != null) {
                        Future.delayed(Duration.zero, () async {
                          _jDHaveGoods = await HomeDao.getJDStock(
                              widget.goodsDetail.data.sku.first.id, _defaltAddress);

                          if(mounted)
                            setState(() {});
                        });
                      }
                    }
                  }


                  return;
                } else {
                  _jDHaveGoods =
                      await HomeDao.getJDStock(skuModel.sku.id, _defaltAddress);
                  setState(() {});

                  if (_jDHaveGoods != 1) {
                    Toast.showInfo('本地区无货，请选择其他商品');
                    _selectedSkuDes();
                    setState(() {});
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
                // 现在未到开枪时间也能开抢
                // if (detailModel.data.promotion!=null && detailModel.data.promotion.id > 0) {
                //   if (PromotionTimeTool.getPromotionStatusWithGoodDetailModel(detailModel) == PromotionStatus.ready){
                //     showError('未到开抢时间，无法加入购物车');
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
        guige = '请选择规格';
        _selectedSkuDes();
        _stateSetter(() {});
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
    ReToast.success(text: '加入成功');
    Get.back();
    Get.back();
  }

  Future<dynamic> _createOrder(
      SkuChooseModel skuModel, BuildContext context) async {
    OrderPreviewModel order = await GoodsDetailModelImpl.createOrderPreview(
      UserManager.instance.user.info.id,
      skuModel.sku.id,
      skuModel.des,
      skuModel.num,
      invite: widget.invite,
    );
    if (order.code != HttpStatus.SUCCESS) {
      // Toast.showError(order.msg);
      Toast.showInfo(order.msg, color: Colors.black87);
      Get.back();
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
  根据有货的sku 进行组合
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
      // 插入第i个值
      temp.add(arr[i]);
      // 复制数组
      var copy = [];
      copy.addAll(arr);
      // 删除复制数组中的第i个值，用于递归
      copy.removeAt(i);
      if (copy.length == 0) {
        // 如果复制数组长度为0了，则打印变量
        temp.sort();
        if (!_validSkuResult.contains(temp.join("-"))) {
          _validSkuResult.add(temp.join("-"));
        }
      } else {
        // 否则进行递归
        _listCombination(copy);
      }
      // 递归完了之后删除最后一个元素，保证下一次插入的时候没有上一次的元素
      temp.clear();
    }
  }

  _selectedSkuDes() {
    StringBuffer stringBuffer = StringBuffer("已选:");
    bool hasSelected = false;

    DPrint.printf(_itemModels.length);
    _itemModels.forEach((SelectedListItemModel model) {
      if (model.selectedIndex != null) {
        hasSelected = true;
        stringBuffer.write(" ");
        stringBuffer.write("\“${model.items[model.selectedIndex].itemTitle}\”");
        if (guige == '请选择规格') {
          guige = model.items[model.selectedIndex].itemTitle;
        } else {
          guige += ('+' + model.items[model.selectedIndex].itemTitle);
        }
      }
    });

    widget.goodsDetail.data.sku.forEach((Sku sku) {
      if (sku.name == guige) {
        if (widget.goodsDetail.data.vendorId == 1800 ||
            widget.goodsDetail.data.vendorId == 2000 ||
            widget.goodsDetail.data.vendorId == 3000) {
          Future.delayed(Duration.zero, () async {
            _jDHaveGoods = await HomeDao.getJDStock(sku.id, _defaltAddress);
            setState(() {});
          });
          setState(() {});
        }
      }
    });
  }
}
