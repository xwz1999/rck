import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/wholesale/more_goods/whoesale_goods_normal.dart';
import 'package:recook/widgets/goods_item.dart';

class GoodsHighCommissionListPage extends StatefulWidget {

  const GoodsHighCommissionListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsHighCommissionListPageState();
  }
}

class _GoodsHighCommissionListPageState extends BaseStoreState<GoodsHighCommissionListPage>
    with TickerProviderStateMixin {
  GoodsHotSellListModel? _listModel;

  @override
  void initState() {
    super.initState();
    //player.setDataSource('https://testcdn.reecook.cn/static/video/20210727/56baf9fd537e83f7584209528e2bb3ef.mp4', autoPlay: true);
    _getGoodsHotSellList();
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
              R.ASSETS_GOODS_HIGH_COMMISSON_LIST_TITLE_BG_PNG,
              fit: BoxFit.fitWidth,
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
    Widget? lead;
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
              // AppRouter.push(context, RouteName.COMMODITY_PAGE,
              //     arguments: CommodityDetailPage.setArguments(
              //         _listModel.data[index].id));
              // print('222222222222222');
            },
            child: _itemWidget(_listModel!.data![index]),
          );
        },
        itemCount: _listModel!.data!.length,
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
          UserManager.instance!.isWholesale?
          WholesaleGoodsItem.hotList(
            buildCtx: context,
            data: data,
          ):
          GoodsItemWidget.hotList(
            gifController: GifController(vsync: this)
              ..repeat(
                min: 0,
                max: 20,
                period: Duration(milliseconds: 700),
              ),
            notShowAmount: true,
            onBrandClick: () {
              AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                  arguments: BrandGoodsListPage.setArguments(
                      data.brandId as int?, data.brandName));
              print('12312321930-8120-938210-3912-039');
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
                  (data.index! + 1).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12 * 2.sp),
                ),
              )),
        ],
      ),
    );

  }


  _getGoodsHotSellList() async {
    Map<String, dynamic> data = {};

    data.putIfAbsent('status', () => 1);
    data.putIfAbsent('user_id', () => UserManager.instance!.user.info!.id);
    if (UserManager.instance!.isWholesale) {
      data.putIfAbsent('is_sale', () => true);
    }
    ResultData resultData = await HttpManager.post(
        HomeApi.preferentialList, data);
    if (!resultData.result) {
      showError(resultData.msg??'');
      return;
    }
    GoodsHotSellListModel model =
    GoodsHotSellListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg??'');
      return;
    }
    for (Data data in model.data!) {
      data.index = model.data!.indexOf(data);
    }
    _listModel = model;
    setState(() {});
  }
}
