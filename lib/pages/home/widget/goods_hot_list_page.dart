import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_hot_sell_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/brandgoods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/utils/app_router.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/goods_item.dart';

class GoodsHotListPage extends StatefulWidget {
  final bool isHot;

  const GoodsHotListPage({Key key, this.isHot = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsHotListPageState();
  }
}

class _GoodsHotListPageState extends BaseStoreState<GoodsHotListPage>
    with TickerProviderStateMixin {
  GoodsHotSellListModel _listModel;
  GifController _gifController;


  @override
  void initState() {

    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    super.initState();

    _getGoodsHotSellList();
    // _brandPresenter.fetchBrandList(widget.argument["brandId"], 0, SortType.comprehensive);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }


  @override
  Widget buildContext(BuildContext context, {store}) {
    Scaffold scaffold = Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        body: SafeArea(
          top: false,
          bottom: false,
          child:
              // FijkView(
              //   player: player,
              // ),
              _bodyWidget(),
        ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: scaffold,
    );
  }

  _bodyWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: _titleWidget(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.width / 1125 * 350,
            child: _listModel == null ? Container() : _listWidget(),
          )
        ],
      ),
    );
  }

  _titleWidget() {
    //1125 603
    double width = MediaQuery.of(context).size.width;
    double height = width / 1125 * 603;
    return Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Image.asset(
              widget.isHot
                  ? R.ASSETS_GOODS_HOT_LIST_TITLE_BG_PNG_WEBP
                  : R.ASSETS_GOODS_PREFERENTIAL_LIST_TITLE_BG_PNG,
              fit: BoxFit.fill,
            ),
            Navigator.canPop(context)
                ? Positioned(
                    child: _backButton(context),
                    left: 0,
                    top: ScreenUtil().statusBarHeight,
                  )
                : SizedBox(),
          ],
        ));
  }

  _backButton(context) {
    Widget lead;
    if (Navigator.canPop(context)) {
      lead = IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    }
    return lead;
  }

  _listWidget() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(
            left: 0, top: 0, right: 0, bottom: ScreenUtil().bottomBarHeight),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              AppRouter.push(context, RouteName.COMMODITY_PAGE,
                  arguments: CommodityDetailPage.setArguments(
                      _listModel.data[index].id));
            },
            child: _itemWidget(_listModel.data[index]),
          );
        },
        itemCount: _listModel.data.length,
      ),
    );
  }

  _itemWidget(Data data) {
    String iconPath = "assets/hot_sell_icon_more.png";
    if (data.index == 0) {
      iconPath = "assets/hot_sell_icon_one.png";
    }
    if (data.index == 1) {
      iconPath = "assets/hot_sell_icon_two.png";
    }
    if (data.index == 2) {
      iconPath = "assets/hot_sell_icon_three.png";
    }
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      constraints: BoxConstraints(minWidth: 150),
      child: Stack(
        children: <Widget>[
          GoodsItemWidget.hotList(
            gifController: _gifController,
            notShowAmount: true,
            onBrandClick: () {
              AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                  arguments: BrandGoodsListPage.setArguments(
                      data.brandId, data.brandName));
            },
            buildCtx: context,
            data: data,
          ),
          Positioned(
            width: 20,
            height: 23,
            left: 15,
            top: 0,
            child: Image.asset(
              iconPath,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
              width: 20,
              height: 20,
              left: 15,
              top: 0,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  (data.index + 1).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12 * 2.sp),
                ),
              )),
        ],
      ),
    );
    // return Container(
    //   height: 150,
    //   margin: EdgeInsets.only(bottom: 10),
    //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    //   child: Container(
    //       padding: EdgeInsets.all(0),
    //       decoration: BoxDecoration(
    //           color: Colors.white, borderRadius: BorderRadius.circular(5)),
    //       child: Stack(
    //         children: <Widget>[
    //           Row(
    //             children: <Widget>[
    //               Container(
    //                 width: 15,
    //               ),
    //               _imageWidget(data),
    //               Container(
    //                 width: 15,
    //               ),
    //               Expanded(
    //                 child: Column(
    //                   children: <Widget>[
    //                     Container(
    //                       height: 15,
    //                     ),
    //                     Container(
    //                       alignment: Alignment.centerLeft,
    //                       child: Text(
    //                         data.goodsName,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 2,
    //                         style: TextStyle(
    //                             color: Colors.black, fontSize: 16 * 2.sp),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Container(
    //                         alignment: Alignment.centerLeft,
    //                         child: Text(
    //                           data.description,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                               color: Colors.black.withOpacity(0.7),
    //                               fontSize: 13 * 2.sp),
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(
    //                         child: Container(
    //                             child: Row(
    //                       children: <Widget>[
    //                         // TextUtils.isEmpty(data.promotionName)?
    //                         // Container():
    //                         // CustomImageButton(
    //                         //   title: data.promotionName,
    //                         //   pureDisplay: true,
    //                         //   borderRadius: BorderRadius.all(
    //                         //       Radius.circular(
    //                         //           rSize(3))),
    //                         //   color: Colors.red,
    //                         //   fontSize: 11,
    //                         //   backgroundColor: Colors.pink[50],
    //                         //   padding: EdgeInsets.only(
    //                         //       bottom:
    //                         //       1.5*2.w,
    //                         //       left: rSize(4),
    //                         //       right: rSize(4)),
    //                         // ),
    //                       ],
    //                     ))),
    //                     Spacer(),
    //                     Container(
    //                       alignment: Alignment.centerLeft,
    //                       child: RichText(
    //                         text: TextSpan(children: [
    //                           TextSpan(
    //                               text: "￥" + data.discountPrice.toString(),
    //                               style: TextStyle(
    //                                   letterSpacing: -1,
    //                                   fontWeight: FontWeight.w500,
    //                                   fontSize: 15 * 2.sp,
    //                                   color: AppColor.themeColor)),
    //                           TextSpan(
    //                             text: "   ",
    //                           ),
    //                           TextSpan(
    //                               text: data.originalPrice.toString(),
    //                               style: TextStyle(
    //                                 fontSize: 12 * 2.sp,
    //                                 color: Colors.black26,
    //                                 decoration: TextDecoration.lineThrough,
    //                                 decorationColor: Colors.black26,
    //                               )),
    //                         ]),
    //                       ),
    //                     ),
    //                     Container(
    //                       height: 15,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Container(
    //                 width: 15,
    //               ),
    //             ],
    //           ),
    //           Positioned(
    //             width: 20,
    //             height: 23,
    //             left: 15,
    //             top: 0,
    //             child: Image.asset(
    //               iconPath,
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //           Positioned(
    //               width: 20,
    //               height: 20,
    //               left: 15,
    //               top: 0,
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   (data.index + 1).toString(),
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w500,
    //                       color: Colors.white,
    //                       fontSize: 12 * 2.sp),
    //                 ),
    //               )),
    //         ],
    //       )),
    // );
  }

  _imageWidget(Data data) {
    return Stack(children: [
      CustomCacheImage(
        width: rSize(100),
        height: rSize(100),
        imageUrl: Api.getImgUrl(data.mainPhotoUrl),
        fit: BoxFit.cover,
      ),
    ]);
  }

  _getGoodsHotSellList() async {
    Map<String, dynamic> data = {};
    if (!widget.isHot) {
      data.putIfAbsent('status', () => 2);
    }
    data.putIfAbsent('user_id', () => UserManager.instance.user.info.id);
    ResultData resultData = await HttpManager.post(
        widget.isHot ? HomeApi.hot_sell_list : HomeApi.preferentialList, data);
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    GoodsHotSellListModel model =
        GoodsHotSellListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    for (Data data in model.data) {
      data.index = model.data.indexOf(data);
    }
    _listModel = model;
    setState(() {});
  }
}
