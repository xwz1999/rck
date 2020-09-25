/*
 * ====================================================
 * package   : pages.home.classify
 * author    : Created by nansi.
 * time      : 2019/5/22  9:42 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_images_model.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/pages/home/classify/coupon_list_page.dart';
import 'package:recook/pages/home/classify/evaluation_list_page.dart';
import 'package:recook/pages/home/classify/goods_param_page.dart';
import 'package:recook/pages/home/classify/goods_service_guarantee.dart';
import 'package:recook/pages/home/classify/order_preview_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/classify/sku_choose_page.dart';
import 'package:recook/pages/home/items/item_user_comment.dart';
import 'package:recook/pages/home/items/item_users_like.dart';
import 'package:recook/pages/home/widget/good_price_view.dart';
import 'package:recook/pages/home/widget/goods_image_page_view.dart';
import 'package:recook/pages/shopping_cart/mvp/shopping_cart_model_impl.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/aspect_ratio_image.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/empty_view.dart';
import 'package:recook/widgets/pic_swiper.dart';
import 'package:recook/widgets/selected_list.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/video_view.dart';

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
  const GoodsPage(
      {Key key,
      this.onScroll,
      this.goodsId,
      this.openSkuChoosePage,
      this.goodsDetail,
      this.openbrandList})
      : super(key: key);

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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
        child: Container(
          color: AppColor.frenchColor,
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (widget.onScroll != null) {
                widget.onScroll(notification);
              }
              return true;
            },
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: _detailListWidget(),
            ),
          ),
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

    double width = DeviceInfo.screenWidth;
    List<Widget> children = _model.data.list.map((Images image) {
      double height = image.height * (width / image.width);
      // String placeHolder;
      // if (width > height) {
      //   placeHolder = AppImageName.placeholder_2x1;
      // } else if (width == height) {
      //   placeHolder = AppImageName.placeholder_1x1;
      // } else {
      //   placeHolder = AppImageName.placeholder_1x2;
      // }
      return Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(width: 0.0),
        ),
        child: GestureDetector(
          onLongPress: () {
            _saveImageWithUrl(image.url);
          },
          child: FadeInImage.assetNetwork(
            image: Api.getImgUrl(image.url),
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          ),
        ),
      );
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
              child: CustomCacheImage(
                imageUrl: Api.getImgUrl(widget.goodsDetail.data.brand.firstImg),
                width: width,
                fit: BoxFit.fill,
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
          child: CustomCacheImage(
            imageUrl: Api.getImgUrl(widget.goodsDetail.data.brand.lastImg),
            width: width,
            fit: BoxFit.fill,
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
        success ? showSuccess("保存完成!") : showError("保存失败!!");
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
                ShareTool().goodsShare(context,
                    goodsPrice: widget.goodsDetail.data.getPriceString(),
                    goodsName: widget.goodsDetail.data.goodsName,
                    goodsDescription: widget.goodsDetail.data.description,
                    miniPicurl: widget.goodsDetail.data.mainPhotos.length > 0
                        ? widget.goodsDetail.data.mainPhotos[0].url
                        : "",
                    miniTitle:
                        "￥${widget.goodsDetail.data.getPriceString()} | ${widget.goodsDetail.data.goodsName} | ${widget.goodsDetail.data.description}",
                    amount:
                        widget.goodsDetail.data.price.min.commission.toString(),
                    goodsId: widget.goodsDetail.data.id.toString());
              },
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 13),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: _discountContent(context),
      ),
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
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 13, bottom: 1),
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          child: _storeName(),
          onTap: () {
            if (widget.openbrandList != null) widget.openbrandList();
          },
        ),
      ),
      Container(
        //  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
        color: Colors.white,
        child: _recommendsWidget(),
      ),
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
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.goodsDetail.data.coupons.length == 0
              ? null
              : () {
                  if (UserManager.instance.user.info.id == 0) {
                    AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                    Toast.showError('请先登录...');
                    return;
                  }
                  showCustomModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CouponListPage(
                          brandId: widget.goodsDetail.data.brandId,
                        );
                      });
                },
          child: Row(children: _coupons()),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: () {
              _showSkuChoosePage(context);
            },
            child: StatefulBuilder(
              builder: (BuildContext context, partSetState) {
                _stateSetter = partSetState;
                return Row(
                  children: <Widget>[
                    Text(
                      "规格",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                          color: Color(0xff828282),
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        child: Text(
                      _selectedSkuDes(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                          color: Color(0xff373737)),
                    )),
                    Icon(
                      AppIcons.icon_next,
                      color: Colors.grey[400],
                      size: ScreenAdapterUtils.setSp(16),
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
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                    color: Color(0xff828282), fontWeight: FontWeight.w300),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                  child: Text(
                "品牌 工艺...",
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                    color: Color(0xff373737)),
              )),
              Icon(
                AppIcons.icon_next,
                color: Colors.grey[400],
                size: ScreenAdapterUtils.setSp(16),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: GestureDetector(
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
                      "服务",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                          color: Color(0xff828282),
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Text(
                          "正品保证",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(13),
                              color: Color(0xff373737)),
                        ),
                        Text(
                          " | ",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(13),
                              color: Colors.grey.withOpacity(0.3)),
                        ),
                        Text(
                          "售后无忧",
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(13),
                              color: Color(0xff373737)),
                        ),
                      ],
                    )),
                    Icon(
                      AppIcons.icon_next,
                      color: Colors.grey[400],
                      size: ScreenAdapterUtils.setSp(16),
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
        //           style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
        //               color: Color(0xff828282), fontWeight: FontWeight.w300),),
        //         Container(width: 20,),
        //         Expanded(
        //           child: Text(
        //             "查看授权",
        //             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13), color: Color(0xff373737)),
        //             )),
        //         Icon(
        //           AppIcons.icon_next,
        //           color: Colors.grey[400],
        //           size: ScreenAdapterUtils.setSp(16),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  _showAuthImage() {
    if (widget.goodsDetail == null ||
        TextUtils.isEmpty(widget.goodsDetail.data.brand.showUrl)) return;
    AppRouter.fade(
      context,
      RouteName.PIC_SWIPER,
      arguments: PicSwiper.setArguments(
        index: 0,
        pics: [
          PicSwiperItem(Api.getImgUrl(widget.goodsDetail.data.brand.showUrl))
        ],
      ),
    );
  }

  List _coupons() {
    List<Widget> coupons = [
      Text(
        "领券",
        style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
            color: Color(0xff828282), fontWeight: FontWeight.w300),
      ),
      Container(
        width: 20,
      ),
    ];

    if (widget.goodsDetail.data.coupons.length == 0) {
      coupons.add(
        Text(
          "暂无优惠劵",
          maxLines: 1,
          style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
              color: Color(0xff373737)),
          // style: AppTextStyle.generate(
          //   ScreenAdapterUtils.setSp(11),
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
        padding:
            EdgeInsets.symmetric(vertical: ScreenAdapterUtils.setWidth(1.5)),
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
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(12),
                    color: Colors.white),
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
        size: ScreenAdapterUtils.setSp(16),
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
              "用户评价",
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                  fontWeight: FontWeight.w500, color: Color(0xff333333)),
            ),
            Text(
              " (${widget.goodsDetail.data.evaluations.total})",
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                  color: Color(0xffb5b5b5)),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                push(RouteName.EVALUATION_LIST_PAGE,
                    arguments: EvaluationListPage.setArguments(
                        goodsId: widget.goodsId));
              },
              child: Text(
                "查看全部",
                textAlign: TextAlign.end,
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
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

  //大家都在买 推荐商品
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
            child: Text('为你推荐',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenAdapterUtils.setSp(16))),
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
                      '￥',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenAdapterUtils.setSp(13)),
                    ),
                  ),
                  Text(
                    '${recommends.price}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenAdapterUtils.setSp(17)),
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
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CustomCacheImage(
              height: rSize(80),
              width: rSize(80),
              fit: BoxFit.cover,
              imageUrl: Api.getImgUrl(widget.goodsDetail.data.brand.logoUrl)),
        ),
        Container(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.goodsDetail.data.brand.name,
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(18),
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 16,
              ),
              Text(
                "全部商品： ${widget.goodsDetail.data.brand.goodsCount}",
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                    color: Colors.grey[700]),
              )
            ],
          ),
        ),
        CustomImageButton(
          title: "进入品牌",
          style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
              color: Colors.grey[700]),
          onPressed: () {
            if (widget.openbrandList != null) widget.openbrandList();
          },
        ),
        // Text(
        //   "进入品牌",
        //   style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15), color: Colors.grey[700]),
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

  _usersLikeGrid() {
    return Container(
      height: 180,
      color: Colors.white,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (detail) {
          return true;
        },
        child: GridView.builder(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10, crossAxisCount: 1, childAspectRatio: 1.6),
            itemBuilder: (context, index) {
              return UsersLikeItem();
            }),
      ),
    );
  }

  _shareTitle(String amount) {
    if (TextUtils.isEmpty(amount)) {
      return Container();
    } else {
      return Container(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: <TextSpan>[
            TextSpan(text: '\n'),
            TextSpan(
                text: '赚 ',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            TextSpan(
                text: amount,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenAdapterUtils.setSp(35),
                    fontWeight: FontWeight.w500)),
            TextSpan(text: '\n'),
            TextSpan(
                text: '分享后好友至少能赚$amount',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenAdapterUtils.setSp(12))),
          ]),
        ),
      );
    }
  }

  void _showSkuChoosePage(BuildContext context) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return SkuChoosePage(
            model: widget.goodsDetail,
            results: _validSkuResult,
            itemModels: _itemModels,
            listener: (SkuChooseModel skuModel) {
              if (UserManager.instance.user.info.id == 0) {
                AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                Toast.showError('请先登录...');
                return;
              }
              print("${skuModel.sku.id} -- ${skuModel.des} -- ${skuModel.num}");
              if (skuModel.num > 50) {
                skuModel.num = 50;
              }
              if (skuModel.selectedIndex == 1) {
                GSDialog.of(context).showLoadingDialog(context, "");
                _createOrder(skuModel, context);
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
                GSDialog.of(context).showLoadingDialog(context, "");
                _addToShoppingCart(context, skuModel);
              }
            },
          );
        }).then((value) {
      widget.openSkuChoosePage.value = false;
      if (_stateSetter != null) {
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
    Navigator.pop(context);
    GSDialog.of(myGlobals.scaffoldKey.currentContext).dismiss(context);
    if (!resultData.result) {
      GSDialog.of(myGlobals.scaffoldKey.currentContext)
          .showError(context, resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      // GSDialog.of(myGlobals.scaffoldKey.currentContext).showError(context, model.msg);
      return;
    }
    UserManager.instance.refreshShoppingCart.value = true;
    UserManager.instance.refreshShoppingCartNumber.value = true;
    UserManager.instance.refreshShoppingCartNumberWithPage.value = true;
    // GSDialog.of(context).showSuccess(context, model.msg);
    GSDialog.of(myGlobals.scaffoldKey.currentContext)
        .showSuccess(myGlobals.scaffoldKey.currentContext, model.msg);
  }

  Future<dynamic> _createOrder(
      SkuChooseModel skuModel, BuildContext context) async {
    OrderPreviewModel order = await GoodsDetailModelImpl.createOrderPreview(
        UserManager.instance.user.info.id,
        skuModel.sku.id,
        skuModel.des,
        skuModel.num);
    GSDialog.of(context).dismiss(context);
    Navigator.pop(context);
    if (order.code != HttpStatus.SUCCESS) {
      // Toast.showError(order.msg);
      Toast.showInfo(order.msg, color: Colors.black87);
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
      }
    });
    return hasSelected ? stringBuffer.toString() : "请选择规格";
  }
}
