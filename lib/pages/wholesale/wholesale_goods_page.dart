

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

import 'package:jingyaoyun/pages/home/classify/goods_service_guarantee.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:jingyaoyun/pages/home/model/address_model.dart';
import 'package:jingyaoyun/pages/home/widget/goods_image_page_view.dart';
import 'package:jingyaoyun/pages/shopping_cart/mvp/shopping_cart_model_impl.dart';
import 'package:jingyaoyun/pages/user/address/mvp/address_model_impl.dart';
import 'package:jingyaoyun/pages/user/address/receiving_address_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholeasale_detail_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_good_price_view.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_goods_param_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_order_preview_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_selected_list.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_sku_choose_page.dart';
import 'package:jingyaoyun/utils/file_utils.dart';
import 'package:jingyaoyun/utils/image_utils.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
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
import 'package:permission_handler/permission_handler.dart';

import 'func/wholesale_func.dart';
import 'models/goods_dto.dart';
import 'models/wholesale_detail_model.dart';
import 'models/wholesale_order_preview_model.dart';


typedef ScrollListener = Function(ScrollUpdateNotification notification);

class MyGlobals {
  GlobalKey _scaffoldKey;

  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }

  GlobalKey get scaffoldKey => _scaffoldKey;
}

class WholesaleGoodsPage extends StatefulWidget {
  final ScrollListener onScroll;
  final WholesaleDetailModel goodsDetail;
  final int goodsId;
  final ValueNotifier<bool> openSkuChoosePage;
  final bool isWholesale;

  const WholesaleGoodsPage({
    Key key,
    this.onScroll,
    this.goodsId,
    this.openSkuChoosePage,
    this.goodsDetail, this.isWholesale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleGoodsPageState();
  }
}

class _WholesaleGoodsPageState extends BaseStoreState<WholesaleGoodsPage> {
  MyGlobals myGlobals = MyGlobals();

//  GoodsDetailModel widget.goodsDetail;
  double width = DeviceInfo.screenWidth;
  List<SelectedItemModel> _itemModels;
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
  bool isWholesale = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if(widget.isWholesale!=null){
      isWholesale = widget.isWholesale;
    }
    //获取默认地址并且判断有无货源

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
                if (widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000|| widget.goodsDetail.vendorId == 3000) {
                  Future.delayed(Duration.zero, () async {
                    _jDHaveGoods =
                    await HomeDao.getJDStock(
                        widget.goodsDetail.sku.first.id, _defaltAddress);
                    print(_jDHaveGoods);
                    setState(() {});
                  });
                }
              }
            }
          });
        }
      });



    //goodsDetail.vendorId为1800或者2000


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

      if(!widget.openSkuChoosePage.value){
        if (_defaltAddress != null) {
          Future.delayed(Duration.zero, () async {
            // _jDHaveGoods =
            // await HomeDao.getJDStock(_sku., _defaltAddress);
            print(_jDHaveGoods);
            setState(() {});
          });
        }
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

    if (widget.goodsDetail.video != null) {
      children.insert(
          0,
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 16 * 9,
            child: VideoView(
              videoUrl: Api.getImgUrl(widget.goodsDetail.video.url),
            ),
          ));
    }

    if (widget.goodsDetail.brand != null &&
        !TextUtils.isEmpty(widget.goodsDetail.brand.firstImg)) {
      children.insert(
          0,
          Container(
            width: width,
            child: GestureDetector(
              onLongPress: () {
                _saveImageWithUrl(widget.goodsDetail.brand.firstImg);
              },
              child: FadeInImage.assetNetwork(
                image: Api.getImgUrl(widget.goodsDetail.brand.firstImg),
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              ),
            ),
          ));
    }
    if (widget.goodsDetail.brand != null &&
        !TextUtils.isEmpty(widget.goodsDetail.brand.lastImg)) {
      children.add(Container(
        width: width,
        child: GestureDetector(
          onLongPress: () {
            _saveImageWithUrl(widget.goodsDetail.brand.lastImg);
          },
          child: FadeInImage.assetNetwork(
            image: Api.getImgUrl(widget.goodsDetail.brand.lastImg),
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
    //                 "继续上拉查看发圈素材",
    //                 style:
    //                     AppTextStyle.generate(15, color: Colors.grey, fontWeight: FontWeight.w300),
    //               )
    //             ],
    //           ),
    //         ));
    insertFirst() {
      if (widget.goodsDetail.notice.img!=null)
        for(int i=0;i<widget.goodsDetail.notice.img.length;i++){
          children.insert(
            0,

            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
              image: Api.getImgUrl(widget.goodsDetail.notice.img[i]),
            ),
          );
        }

    }

    insertLast() {
      if (widget.goodsDetail.notice.img!=null)
        for(int i=0;i<widget.goodsDetail.notice.img.length;i++){
        children.add(
          FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
            image: Api.getImgUrl(widget.goodsDetail.notice.img[i]),
          ),
        );
        }
    }

    if (widget?.goodsDetail?.notice?.type == 1) insertFirst();
    if (widget?.goodsDetail?.notice?.type == 2) insertLast();
    if (widget?.goodsDetail?.notice?.type == 3) {
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
        success ? showSuccess("保存完成!") : Alert.show(
          context,
          NormalContentDialog(
            title: '提示',
            content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
            items: ["取消"],
            listener: (index) {
              Alert.dismiss(context);
            },
            deleteItem: "确认",
            deleteListener: () async{

              Alert.dismiss(context);
              bool isOpened = await openAppSettings();
            },
            type: NormalTextDialogType.delete,
          ),
        );;
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
            WholesaleGoodPriceView(
              detailModel: widget.goodsDetail,
              shareCallback: () {
                String img = '';
                int length = widget.goodsDetail.mainPhotos.length;
                if (length >= 2)
                  img = widget.goodsDetail.mainPhotos[0].url;
                if (length >= 1)
                  img = widget.goodsDetail.mainPhotos[0].url;
                ShareTool().goodsShare(
                  context,
                  goodsPrice: widget.goodsDetail.getPriceString(),
                  goodsName: widget.goodsDetail.goodsName,
                  goodsDescription: widget.goodsDetail.description,
                  miniPicurl: img,
                  miniTitle:
                      "￥${widget.goodsDetail.getPriceString()} | ${widget.goodsDetail.goodsName} | ${widget.goodsDetail.description}",
                  amount:
                      widget.goodsDetail.price.min.commission.toString(),
                  goodsId: widget.goodsDetail.id.toString(),
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
      widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000||  widget.goodsDetail.vendorId == 3000
          ? Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _addressContent(context),
      )
          : SizedBox(),
      Container(
        margin: EdgeInsets.only(bottom: 13),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _goodsInfoWidget(context),
      ),
//            _usersLikeGrid(),
    ];
  }

  _headPageView() {
    List images = [];
    // if (widget.goodsDetail.video != null) {
    //   images.add(widget.goodsDetail.video);
    // }
    images.addAll(widget.goodsDetail.mainPhotos);
    return ImagePageView(
        images: images,
        onScrolled: (index) {});
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
      if (widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000 || widget.goodsDetail.vendorId == 3000) {
                if (_defaltAddress == null) {

                  await  Get.to(ReceivingAddressPage());

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
                                await HomeDao.getJDStock(widget.goodsDetail.sku.first.id, _defaltAddress);
                                print(_jDHaveGoods);
                                setState(() {});
                              });
                            }
                          }
                        });
                      }
                    });
                } else {
                  _showSkuChoosePage(context);

                }
              }
      else{
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
                          style: AppTextStyle.generate(13 * 2.sp,
                            color: Color(0xFFA4A4A4),),
                        ),
                        Container(
                          width: 10,
                        ),

                        ...widget.goodsDetail.sku.mapIndexed((currentValue, index) {
                          return index<6? Container(
                            clipBehavior:Clip.antiAlias,
                            margin: EdgeInsets.only(right:8.rw ),
                            width: 32.rw,
                            height: 32.rw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.rw),

                            ),
                            child:     FadeInImage.assetNetwork(
                              placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                              image: Api.getImgUrl(currentValue.picUrl) ,
                            ),
                          ):SizedBox();
                        } ).toList(),

                        Container(

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.rw),
                              color: Color(0xFFF9F9F9)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 3.rw,horizontal: 6.rw),
                          child: Text(
                            '共${widget.goodsDetail.sku.length}款',
                            style: TextStyle(color: Color(0xFF666666),fontSize: 12.rsp),

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
                              (guige!='请选择规格'?'已选：':'')+guige,
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

        // Toast.showInfo('请先添加地址');
        await  Get.to(ReceivingAddressPage());
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
                      await HomeDao.getJDStock(widget.goodsDetail.sku.first.id, _defaltAddress);
                      print(_jDHaveGoods);
                      setState(() {});
                    });
                  }

                }
              });
            }
          });

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
                            '您还没有配置地址',
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
                Row(
                  children: [
                    Container(
                      width: 46.rw,
                    ),
                    Text(
                      _jDHaveGoods == 1
                          ? '有货'
                          : _jDHaveGoods == 0
                          ? '无货'
                          : '',
                      style: TextStyle(
                        color: Color(0xFF525252),
                        fontSize: rSP(13),
                      ),
                    ),
                  ],
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
                  return WholesaleGoodsParamPage(
                      // skus: widget.goodsDetail.sku,
                      model: widget.goodsDetail);
                });
          },
          child: Container(
            color: Colors.white,
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
                    child: Row(
                      children: [
                        Text(
                          '品牌',
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
                        ),
                        Text(
                          " | ",
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Colors.grey.withOpacity(0.3)),
                        ),
                        Text(
                          '起批量',
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
                        ),
                        Text(
                          " | ",
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Colors.grey.withOpacity(0.3)),
                        ),
                        Text(
                          '规格',
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
                        ),
                        Text(
                          " | ",
                          style: AppTextStyle.generate(13 * 2.sp,
                              color: Colors.grey.withOpacity(0.3)),
                        ),
                        Text(
                          '条形码',
                          style:
                          AppTextStyle.generate(13 * 2.sp, color: Color(0xff373737)),
                        )
                      ],
                    )
                   ),
                Icon(
                  AppIcons.icon_next,
                  color: Color(0xFF333333),
                  size: 13 * 2.sp,
                )
              ],
            ),
          ),
        ),
        24.hb,

        GestureDetector(
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
                  margin: EdgeInsets.only(top: 10.rw),
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
                          widget.goodsDetail.vendorId == 1800
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
                                color: Colors.grey.withOpacity(0.3)),
                          ),
                          Text(
                            "售后无忧",
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

      ],
    );
  }

  // _showAuthImage() {
  //   if (widget.goodsDetail == null ||
  //       TextUtils.isEmpty(widget.goodsDetail.brand.showUrl)) return;
  //   AppRouter.fade(
  //     context,
  //     RouteName.PIC_SWIPER,
  //     arguments: PicSwiper.setArguments(
  //       index: 0,
  //       pics: [
  //         PicSwiperItem(Api.getImgUrl(widget.goodsDetail.brand.showUrl))
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
        widget.goodsDetail.isFerme == 1
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
        widget.goodsDetail.isFerme == 1 ? rWBox(10) : SizedBox(),
        widget.goodsDetail.isFerme == 1
            ? Text(
                '预计¥${widget.goodsDetail.price.min.ferme.toStringAsFixed(2)}由左家右厨承担',
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
                        switch (widget.goodsDetail.storehouse) {
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
                        switch (widget.goodsDetail.storehouse) {
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



  void _showSkuChoosePage(BuildContext context) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return WholesaleSkuChoosePage(
            model: widget.goodsDetail,
            results: _validSkuResult,
            itemModels: _itemModels,
            listener:  (WholesaleSkuChooseModel skuModel) async {

              if (UserManager.instance.user.info.id == 0) {
                AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                Toast.showError('请先登录...');
                return;
              }
              print("${skuModel.sku.id} -- ${skuModel.des} -- ${skuModel.num}");


                 if (_defaltAddress == null) {
                   widget.openSkuChoosePage.value = false;
                   Toast.showInfo('请先添加地址');

                   await  Get.to(ReceivingAddressPage());

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
                               if (widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000 || widget.goodsDetail.vendorId == 3000) {
                               Future.delayed(Duration.zero, () async {
                                 _jDHaveGoods =
                                 await HomeDao.getJDStock(
                                     widget.goodsDetail.sku.first.id,
                                     _defaltAddress);
                                 print(_jDHaveGoods);
                                 setState(() {});
                               });
                             }
                             }
                           }
                         });
                       }
                     });


                   return;
                 }else{

                   if (widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000 || widget.goodsDetail.vendorId == 3000) {
                     _jDHaveGoods =
                     await HomeDao.getJDStock(skuModel.sku.id, _defaltAddress);
                     if (mounted) {
                       setState(() {

                       });
                     }


                     if (_jDHaveGoods != 1) {
                       if (skuModel.selectedIndex != 2) Toast.showInfo(
                           '本地区无货，请选择其他商品');
                       _selectedSkuDes();
                       if (mounted) {
                         setState(() {

                         });
                       }

                       return;
                     }
                   }
                 }


              if (skuModel.selectedIndex == 1) {
                //ReToast.loading(text: '');
                _createOrder(
                  skuModel,
                );
                return;
              } else if(skuModel.selectedIndex == 0){
                //ReToast.loading(text: '');
                List<GoodsDTO> list = [];
                list.add(GoodsDTO(skuId:skuModel.sku.id,quantity:skuModel.num));
                WholesaleFunc.addToShoppingCart(list);
                //_addToShoppingCart(context, skuModel);
              }else{

              }
            },
          );
        }).then((value) {
      widget.openSkuChoosePage.value = false;
      if (_stateSetter != null) {
        guige = '请选择规格';
        _selectedSkuDes();
        _stateSetter(() {

        });
      }
    });
  }


  Future<dynamic> _createOrder(WholesaleSkuChooseModel skuModel) async {
    List<GoodsDTO> list = [];
    list.add(GoodsDTO(skuId:skuModel.sku.id,quantity:skuModel.num));
    WholesaleOrderPreviewModel order = await WholesaleFunc.createOrderPreview(
      list,
      0,
    );
    if (order==null) {
      //Toast.showError(order.msg);
      print('21312312312');
      Get.back();
      if(_defaltAddress.isEmpty){
        Get.to(ReceivingAddressPage());
      }
      return;
    }else
    {
      Get.back();///关闭规格选择弹窗
      AppRouter.push(context, RouteName.WHOLESALE_GOODS_ORDER_PAGE,
          arguments: WholesaleGoodsOrderPage.setArguments(order)).then((value) {
      });

     // Get.to(()=>WholesaleGoodsOrderPage(model: order,));
    }

  }

  _chooseValues() {
    return widget.goodsDetail.sku.map((WholesaleSku sku) {
      return SelectedItemModel(
          sku:sku,
        );
    }).toList();
  }

  /*
  根据有货的sku 进行组合
  */
  List<String> _validSkuResult = [];
  var temp = [];

  _skuCombinations() {
    widget.goodsDetail.sku.forEach((WholesaleSku sku) {
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


    DPrint.printf(_itemModels.length);
    _itemModels.forEach((SelectedItemModel model)  {
      if (model.selected) {
        stringBuffer.write(" ");
        stringBuffer.write("\“${model.sku.name}\”");
        if(guige == '请选择规格'){
          guige = model.sku.name;
        }else{
          guige += ('+'+model.sku.name);
        }


      }
    });

    // widget.goodsDetail.sku.forEach((WholesaleSku sku) {
    //   if (sku.name == guige) {
    //     if (widget.goodsDetail.vendorId == 1800 || widget.goodsDetail.vendorId == 2000 || widget.goodsDetail.vendorId == 3000) {
    //       Future.delayed(Duration.zero, () async {
    //         _jDHaveGoods =
    //         await HomeDao.getJDStock(sku.id, _defaltAddress);
    //         setState(() {});
    //       });
    //       setState(() {
    //       });
    //     }
    //   }
    // });





  }
}
