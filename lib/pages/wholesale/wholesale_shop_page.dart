import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/banner_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_detail_grid.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_goods_widget.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/banner.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:jingyaoyun/widgets/webView.dart';
import 'package:velocity_x/velocity_x.dart';

import 'func/wholesale_func.dart';
import 'models/wholesale_banner_model.dart';

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
  GSRefreshController _refreshController;
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
        actions: [
          CustomImageButton(
            title: "购物车",
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: 14 * 2.sp,
            onPressed: () async {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 12.rw, right: 12.rw),
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        CupertinoTextField(
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.search,
          controller: _textEditController,
          onChanged: (text) async {
            phoneText = text;
            setState(() {});
          },
          placeholder: "厨房小工具",
          suffix: GestureDetector(
            child: Container(
              width: 60.rw,
              height: 32.rw,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFD5101A),
                borderRadius: BorderRadius.all(Radius.circular(14.rw)),
              ),
              child: '搜索'.text.size(16.rsp).color(Colors.white).make(),
            ),
          ),
          prefix: Container(
            padding: EdgeInsets.only(left: 10.rw),
            child: Icon(
              Icons.search,
              size: 20,
              color: Colors.grey,
            ),
          ),
          placeholderStyle: TextStyle(
              color: Color(0xFF999999),
              fontSize: 14.rsp,
              fontWeight: FontWeight.w300),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.rw)),
              border: Border.all(color: Color(0xFFD5101A), width: 1.rw)),
          style: TextStyle(color: Colors.black, fontSize: 16.rsp),
        ),
        16.hb,

        Flexible(
          child: RefreshWidget(
            controller: _refreshController,
            onRefresh: () async {
              _getBannerList();
              setState(() {

              });
              _refreshController.refreshCompleted();
            },
            body:ListView(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                _bannerView(),
                8.hb,
                _goodsItem(),
                _goodsItem(),
                _goodsItem(),
                _goodsItem(),
              ],
            ),
          )




        ),
      ],
    );


  }

  _bannerView() {
    double screenWidth = MediaQuery.of(context).size.width;
    Widget banner =
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      _bannerState = setState;
      if (_bannerList == null || _bannerList.length == 0) {
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

                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(
                        (wholesaleBannerModel as BannerModel).goodsId));

            },
            child: ExtendedImage.network(Api.getImgUrl(wholesaleBannerModel.photo),
                fit: BoxFit.fill, enableLoadState: true),
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
            child: _bannerList == null ? Container() : banner,
          )
        ],
      ),
    );
  }

  _goodsItem() {
    return Column(
      children: [
        25.hb,
        Row(
          children: [
            '柴米油盐'.text.size(18.rsp).color(Color(0xFF111111)).make(),
            Spacer(),
            '更多商品'.text.size(12.rsp).color(Color(0xFF666666)).make(),
            8.wb,
            Icon(
              CupertinoIcons.chevron_forward,
              size: 24.w,
              color: Color(0xFF999999),
            ),
          ],
        ),
        11.hb,
        Container(
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
              return Container(
                width: 140.rw,
                // color: Colors.white,
                child: Builder(
                  builder: (context) {
                    return WholesaleGoodsWidget();
                  },
                ),
              );
            },
            itemCount: 6,
          ),
        ),
      ],
    );
  }

  _getBannerList() async {
    _bannerList = await WholesaleFunc.getBannerList();
    // ResultData resultData = await HttpManager.post(APIV2.wholesaleAPI.getBannerList, {});
    // if (!resultData.result) {
    //   Toast.showError(resultData.msg);
    //   return;
    // }
    // WholesaleBannerModel model = WholesaleBannerModel.fromJson(resultData.data['data']);
    // if (resultData.code != HttpStatus.SUCCESS) {
    //   Toast.showError(resultData.msg);
    //   return;
    // }
    _bannerState(() {

    });
  }
}
