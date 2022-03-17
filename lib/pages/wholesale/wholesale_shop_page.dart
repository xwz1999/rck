import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/banner_list_model.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/goods_import_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_detail_grid.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/pages/wholesale/wholeasale_detail_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_goods_list_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_goods_widget.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_search_page.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/banner.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:jingyaoyun/widgets/webView.dart';
import 'package:velocity_x/velocity_x.dart';

import 'func/wholesale_func.dart';
import 'models/wholesale_acitivty_model.dart';
import 'models/wholesale_banner_model.dart';
import 'models/wholesale_good_model.dart';

class WholesaleShopPage extends StatefulWidget {
  WholesaleShopPage({
    Key key,
  }) : super(key: key);

  @override
  _WholesaleShopPageState createState() => _WholesaleShopPageState();
}

class _WholesaleShopPageState extends State<WholesaleShopPage> {
  TextEditingController _textEditController;
  String phoneText = '';
  bool isYun = false;
  bool isEntity = false;
  StateSetter _bannerState;
  double bannerHeight = 160.rw;
  List<WholesaleBannerModel> _bannerList = [];
  List<WholesaleActivityModel> _activityList = [];
  GSRefreshController _refreshController;
  List<dynamic> _goodList = [];
  int _page = 0;

  @override
  void initState() {
    super.initState();
    //_getBannerList();
    _textEditController = TextEditingController();
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF6F6F6),
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "批发商城",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 12.rw, right: 12.rw),
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    List<Widget> widgetList = [

    ];
    for (int i = 0; i < _activityList.length; i++) {
      widgetList.add(
        _goodsItem(_activityList[i], i),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Get.to(()=>WholesaleSearchPage());

          },
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            // height: rSize(30),
            height: 32.rw,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD5101A),width: 1.rw),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 18.rw,
                  height:18.rw,
                  child: Icon(
                    Icons.search,
                    size: 18.rw,
                    color: Color(0xFF333333),
                  ),
                ),
                Container(
                  width: 6,
                ),
                Text(
                  '厨房小工具',
                  style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 13 * 2.sp,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
        16.hb,

        Flexible(
            child: RefreshWidget(
          controller: _refreshController,
          onRefresh: () async {
            _page = 0;
            _getBannerList();
            _getActivityList();
            _refreshController.refreshCompleted();
          },
              // onLoadMore: (){
              //   _page++;
              //   _loadActivityList();
              //   _refreshController.loadComplete();
              // },
          body: ListView(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              _bannerView(),
              8.hb,
              ..._activityList.mapIndexed((currentValue, index) => _goodsItem(_activityList[index], index)),

              // _goodsItem(),
              // _goodsItem(),
              // _goodsItem(),
            ],
          ),
        )),
      ],
    );
  }

  _bannerView() {
    double screenWidth = MediaQuery.of(context).size.width;
    Widget banner =
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      _bannerState = setState;
      if (_bannerList.isEmpty) {
        return Container(
          height: 160.rw,
        );
      }
      BannerListView bannerListView = BannerListView<WholesaleBannerModel>(
        onPageChanged: (index) {},
        margin: EdgeInsets.zero,
        height: 16.rw,
        radius: 10,
        data: _bannerList,
        builder: (context, wholesaleBannerModel) {
          return GestureDetector(
            onTap: () {
              Get.to(()=>WholesaleDetailPage(goodsId:  (wholesaleBannerModel as WholesaleBannerModel).goodsId,));
            },
            child: ExtendedImage.network(
                Api.getImgUrl(wholesaleBannerModel.photo),
                fit: BoxFit.fill,
                enableLoadState: true),
          );
        },
      );
      return bannerListView;
    });
    return Container(
      width: screenWidth,
      height: bannerHeight,
      color: Colors.white.withAlpha(0),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: _bannerList.isEmpty ? Container() : banner,
          )
        ],
      ),
    );
  }

  _goodsItem(WholesaleActivityModel item, int activityIndex) {
    return Column(
      children: [
        25.hb,
        Row(
          children: [
            CustomCacheImage(
                width: 24.rw,
                height: 24.rw,
                placeholder: AppImageName.placeholder_1x1,
                imageUrl:Api.getImgUrl(item.icon) ),
            16.wb,
            item.name.text.size(12.rsp).color(Color(0xFF111111)).make(),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(() => WholesaleGoodsList(
                      title: item.name,
                    ));
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    '更多商品'.text.size(12.rsp).color(Color(0xFF666666)).make(),
                    8.wb,
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 24.w,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        11.hb,
        _goodList.isEmpty?Container(
          height: 255.rw,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 16.w,
              );
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return  Container(
                width: 140.rw,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                child: Image.asset(
                  R.ASSETS_PLACEHOLDER_NEW_1X2_A_PNG,
                  fit: BoxFit.cover,
                ),
              );
            },
            itemCount: 3,
          ),
        ): Container(
          height: 255.rw,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 16.w,
              );
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _goodList.length == _activityList.length
                  ? Container(
                      width: 140.rw,
                      // color: Colors.white,
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: (){
                              Get.to(()=>WholesaleDetailPage(goodsId: _goodList[activityIndex][index].id));
                            },
                              child: WholesaleGoodsWidget(
                            goods: _goodList[activityIndex][index],
                          ));
                        },
                      ),
                    )
                  : Container(
                      width: 140.rw,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        R.ASSETS_PLACEHOLDER_NEW_1X2_A_PNG,
                        fit: BoxFit.cover,
                      ),
                    );
            },
            itemCount: _goodList[activityIndex].length,
          ),
        ),
      ],
    );
  }

  _getBannerList() async {
    _bannerList = await WholesaleFunc.getBannerList();
    if(mounted)
    setState(() {

    });
  }

  _getActivityList() async {
    _activityList = await WholesaleFunc.getActivityList();
    if (_activityList.isNotEmpty) {
      _goodList.clear();

      for(int i=0;i<_activityList.length;i++){
        List<WholesaleGood> list = [];
        list = await WholesaleFunc.getGoodsList(
          _page, SortType.comprehensive,activity_id: _activityList[i].id, );
        _goodList.insert(i, list);
        //_goodList.add(list);
        if (_goodList.length == _activityList.length) {
          if(mounted)
          setState(() {});
        }
      }
      // _activityList.forEach((element) async {
      //
      // });
    }
  }

  // _loadActivityList() async {
  //   _activityList = await WholesaleFunc.getActivityList();
  //   if (_activityList.isNotEmpty) {
  //     // _goodList.clear();
  //     _activityList.forEach((element) async {
  //       List<WholesaleGood> list = [];
  //       list = await WholesaleFunc.getGoodsList(
  //           element.id, _page, SortType.comprehensive);
  //       _goodList.add(list);
  //       if (_goodList.length == _activityList.length) {
  //         setState(() {});
  //       }
  //     });
  //   }
  // }
}
