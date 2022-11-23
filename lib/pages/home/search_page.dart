
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:recook/pages/home/classify/mvp/goods_list_presenter_impl.dart';
import 'package:recook/pages/home/function/home_fuc.dart';
import 'package:recook/pages/home/items/item_brand_detail_grid.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_floating_action_button_location.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/progress/loading_dialog.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:power_logger/power_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchPage extends StatefulWidget {
  final int? countryId;
  final int? jdType;
  final String? keyWords;//1为京东商品 空为非jd

  const SearchPage({Key? key, this.countryId, this.jdType, this.keyWords}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends BaseStoreState<SearchPage>
    with MvpListViewDelegate<GoodsSimple>, TickerProviderStateMixin {
  String _searchText = "";
  FocusNode _contentFocusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = false;//默认排列方式改为瀑布流

  late FilterToolBarController _filterController;

  GoodsListPresenterImpl? _presenter;

  MvpListViewController<GoodsSimple>? _listViewController;
  TextEditingController? _textEditController;

  List<String> _searchHistory = [];

  List<KeyWordModel> _recommendWords = [];//推荐分词
  List<bool> _barBool = [false, false, false];
  bool _startSearch = false;

  SortType _sortType = SortType.comprehensive;
  int _filterIndex = 0;

  GSRefreshController _refreshController = GSRefreshController();
  GoodsHotSellListModel? _listModel;
  GifController? _gifController;

  _getGoodsHotSellList() async {
    ResultData resultData = await HttpManager.post(HomeApi.hot_sell_list, {});
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
    if (mounted) setState(() {});
  }

  int _jDType = 0; // 0 默认数据 1传回全部JD数据 2为JD自营数据 3为JD pop数据
  String _jdTypeText = '全部';
  bool showFab = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   _recommendWords = await HomeFuc.recommendWords(widget.keyWords);
    // });
    _scrollController.addListener(() {
      print(_scrollController.offset);//滚动位置
      if(_scrollController.offset < 600 && showFab){
        setState(() {
          showFab = false;
        });
      }else if(_scrollController.offset >= 600 && showFab == false){
        setState(() {
          showFab = true;
        });
      }
    });
    if (widget.jdType == 1) {
      _jDType = 1;
      _sortType = SortType.priceAsc;
      _barBool = [false, false];
    }
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    getSearchListFromSharedPreferences();
    _textEditController = TextEditingController(text: widget.keyWords);
    _filterController = FilterToolBarController();
    super.initState();
    _presenter = GoodsListPresenterImpl();
    _listViewController = MvpListViewController(controller: _refreshController);
    _getPromotionList();
  }

  @override
  void dispose() {
    _gifController!.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _customer(){
    return GestureDetector(
      onTap: () async{
      if(_listViewController!.getData().length>4)
        _scrollController.jumpTo(0);
      },
      child: Container(
        width: 46.rw,
        height: 46.rw,
        decoration: BoxDecoration(
          color: Color(0xFF000000).withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(23.rw)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.totop.path,width: 30.rw,height: 30.rw,color: Colors.white,),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      floatingActionButton:  !TextUtils.isEmpty(_textEditController!.text) &&
          _startSearch? showFab? _customer():SizedBox():SizedBox(),
      floatingActionButtonLocation:CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endDocked, 0, -70.rw),
      appBar: CustomAppBar(
        elevation: 0,
        title: _buildTitle(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: TextUtils.isEmpty(_textEditController!.text)
            ? <Widget>[
                Container(
                  width: 10,
                )
              ]
            : _rightActions(getStore()),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              child: FilterToolBarResultContainer(
                controller: _filterController,
                body: Column(
                  children: <Widget>[

                    _filterToolBar(context),
                    Offstage(
                        offstage: !(_listViewController!.getData().length==0),
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.only(top: 5.rw),
                              child: Column(
                                children: <Widget>[
                                  _recommendWidget(),
                                ],
                              )),
                        )),
                    Expanded(child: _buildList(context)),
                  ],
                ),
              ),
            ),
            Positioned(
                child: Offstage(
                    offstage: !TextUtils.isEmpty(_textEditController!.text) &&
                        _startSearch,
                    child: Container(
                      color: Colors.white,
                      child: Container(
                          child: ListView(
                        children: <Widget>[
                          _searchHistoryWidget(),
                        ],
                      )),
                    ))),
          ],
        ),
      ),
    );
  }

  _filterToolBar(BuildContext context) {
    return FilterToolBar(
      controller: _filterController,
      height: rSize(40),
      fontSize: 13 * 2.sp,
      titles: widget.jdType == 1
          ? [
              FilterItemModel(
                  type: FilterItemType.double,
                  title: "价格",
                  selectedList: _barBool),
              FilterItemModel(
                  type: FilterItemType.double,
                  title: "销量",
                  selectedList: _barBool),
            ]
          : [
              FilterItemModel(
                  type: FilterItemType.normal,
                  title: "综合",
                  selectedList: _barBool),
              FilterItemModel(
                  type: FilterItemType.double,
                  title: "价格",
                  selectedList: _barBool),
              FilterItemModel(
                  type: FilterItemType.double,
                  title: "销量",
                  selectedList: _barBool),
//        FilterItemModel(type: FilterItemType.normal, title: "特卖优先")
            ],
      trialing: _displayIcon(),
      startWidget: widget.jdType==1? _jdTypeWidget():null,
      selectedColor: Theme.of(context).primaryColor,
      listener: (index, item) {
        if (widget.jdType != 1) {
          if ((index != 1 && index != 2) && _filterIndex == index) {
            return;
          }
        } else {
          if ((index != 1 && index != 2 && index != 0) &&
              _filterIndex == index) {
            return;
          }
        }
        // if (index != 1 && _filterIndex == index) {
        //   return;
        // }
        _filterIndex = index!;
        if (widget.jdType == 1) {
          switch (index) {
            case 0:
              print(item!.topSelected);
              if (item.topSelected) {
                _sortType = SortType.priceAsc;
              } else {
                _sortType = SortType.priceDesc;
              }
              break;
            case 1:
              print(item!.topSelected);
              if (item.topSelected) {
                _sortType = SortType.salesAsc;
              } else {
                _sortType = SortType.salesDesc;
              }
              // _sortType = SortType.sales;
              break;
//          case 3:
//            print("特卖优先");
//            break;
          }
        } else {
          switch (index) {
            case 0:
              _sortType = SortType.comprehensive;
              break;
            case 1:
              if (item!.topSelected) {
                _sortType = SortType.priceAsc;
              } else {
                _sortType = SortType.priceDesc;
              }
              break;
            case 2:
              if (item!.topSelected) {
                _sortType = SortType.salesAsc;
              } else {
                _sortType = SortType.salesDesc;
              }
              // _sortType = SortType.sales;
              break;
//          case 3:
//            print("特卖优先");
//            break;
          }
        }
        // _presenter.fetchList(widget.category.id, 0, _sortType);
        // _presenter.fetchList(_category.id, 0, _sortType);
       // _listViewController!.stopRefresh();
        _listViewController!.requestRefresh();
      },
    );
  }

  /// 切换排列按钮
  Container _displayIcon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _displayList = !_displayList;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 1,
              height: 15,
              margin: EdgeInsets.only(right: 8),
              color: Colors.grey[700],
            ),
            Text(
              "排列",
              style: AppTextStyle.generate(13 * 2.sp,
                  color: Colors.grey[700], fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(
                _displayList
                    ? AppIcons.icon_list_collection
                    : AppIcons.icon_list_normal,
                color: Colors.grey[700],
                size: 20 * 2.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jdTypeWidget() {
    return PopupMenuButton(
        offset: Offset(0, 10),
        color: Colors.white,
        child: Row(
          children: [
            Text(_jdTypeText,
                style: TextStyle(
                  fontSize: 14.rsp,
                  color: Color(0xFFD5101A),
                )),
            Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFD5101A),
            ),
          ],
        ),
        onSelected: (String value) {
          setState(() {
            _jdTypeText = value;
            if (value == '全部') {
              _jDType = 1;
            } else if (value == '京东自营') {
              _jDType = 2;
            } else if (value == '京东POP') {
              _jDType = 3;
            }
            print(value);
            setState(() {});
            _listViewController!.stopRefresh();
            _listViewController!.requestRefresh();
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem(
                  value: "全部",
                  child: Text("全部",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
              PopupMenuItem(
                  value: "京东自营",
                  child: Text("京东自营",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
              PopupMenuItem(
                  value: "京东POP",
                  child: Text("京东POP",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
            ]);
  }

  _buildList(BuildContext context) {
    return MvpListView<GoodsSimple>(
      noDataView: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: NoDataView(
              title: "换个关键词搜索一下吧~",
              height: 200,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: rSize(40), bottom: rSize(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: rSize(2),
                    color: Color(0xFFB8B8B8),
                    width: rSize(40),
                  ),
                  rWBox(10),
                  Text(
                    '猜你喜欢',
                    style: TextStyle(
                      fontSize: rSP(15),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  rWBox(10),
                  Container(
                    height: rSize(2),
                    color: Color(0xFFB8B8B8),
                    width: rSize(40),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                PromotionGoodsModel model = _promotionGoodsList[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  color: AppColor.frenchColor,
                  child: GoodsItemWidget.rowGoods(
                    gifController: _gifController,
                    isSingleDayGoods: false,
                    onBrandClick: () {
                      AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                          arguments: BrandGoodsListPage.setArguments(
                              model.brandId as int?, model.brandName));
                    },
                    model: model,
                    buyClick: () {
                      AppRouter.push(context, RouteName.COMMODITY_PAGE,
                          arguments:
                              CommodityDetailPage.setArguments(model.goodsId));
                    },
                  ),
                );
              },
              itemCount: _promotionGoodsList.length,
            ),
          ),
        ],
      ),
      autoRefresh: false,
      delegate: this,
//      padding: EdgeInsets.all(_displayList ? 0 : 10.0),
      controller: _listViewController,
      type: ListViewType.grid,
      refreshCallback: () {
        if (TextUtils.isEmpty(_searchText)) {
          refreshSuccess([]);
          return;
        }
        // _presenter.fetchSearchList(
        //   _searchText,
        //   0,
        // );
        _presenter!.fetchList(-99, 0, _sortType, widget.countryId,
            keyword: _searchText, JDType: _jDType);
        setState(() {

        });
      },
      loadMoreCallback: (int page) {
        // _presenter.fetchSearchList(
        //   _searchText,
        //   page,
        // );
        _presenter!.fetchList(
          -99,
          page,
          _sortType,
          widget.countryId,
          keyword: _searchText,
          JDType: _jDType,
          onLoadDone: () {
            Future.delayed(Duration(milliseconds: 100), () {
              if (mounted) setState(() {});
            });
          },
        );
      },
      gridViewBuilder: () => _buildNewGridView(),
    );
  }

//copy from home_page.dart()

  List<Promotion>? _promotionList = [];
  List<dynamic> _promotionGoodsList = [];

  _getPromotionList() async {
    ResultData resultData = await HttpManager.post(HomeApi.promotion_list, {});

    if (!resultData.result) {
      showError(resultData.msg??'');
      return;
    }
    PromotionListModel model = PromotionListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg??'');
      return;
    }
    _promotionList = model.data;
    if (_promotionList == null || _promotionList!.length == 0) {
      _promotionGoodsList = [];
      setState(() {});
      return;
    }
    int _index = 0;
    for (Promotion item in _promotionList!) {
      PromotionStatus processStatus = PromotionTimeTool.getPromotionStatus(
          item.startTime, item.getTrueEndTime());
      // DateTime time = DateTime.parse("2020-03-18 23:00:00");
      DateTime time = DateTime.now();
      if (time.hour >= 22 &&
          DateTime.parse(item.startTime!).hour == 20 &&
          time.day == DateTime.parse(item.startTime!).day) {
        //10点以后定位到8点
        _index = _promotionList!.indexOf(item);
      } else if (processStatus == PromotionStatus.start) {
        _index = _promotionList!.indexOf(item);
      }
    }
    _getPromotionGoodsList(_promotionList![_index].id);
  }

  _getPromotionGoodsList(int? promotionId) async {
    ResultData resultData =
        await HttpManager.post(HomeApi.promotion_goods_list, {
      "timeItemID": promotionId,
    });
    if (!resultData.result) {
      showError(resultData.msg??'');
      return;
    }
    PromotionGoodsListModel model =
        PromotionGoodsListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg??'');
      return;
    }
    List<dynamic> array = [];
    //List array = [];
    if (model.data!.goodsList == null) {
      model.data!.goodsList = [];
    } else {
      array.addAll(model.data!.goodsList!);
    }
    // if (model.data.activityList != null && model.data.activityList.length > 0) {
    //   if (array.length > 3) {
    //     array.insert(3, model.data.activityList.first);
    //   } else {
    //     array.add(model.data.activityList.first);
    //   }
    // }
    //_promotionGoodsList = model.data.goodsList;
    _promotionGoodsList = array;
    if (mounted) setState(() {});
  }

  _buildNewGridView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverWaterfallFlow(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              GoodsSimple goods = _listViewController!.getData()[index];
              return MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    AppRouter.push(context, RouteName.COMMODITY_PAGE,
                        arguments: CommodityDetailPage.setArguments(goods.id as int?));
                  },
                  child: _displayList
                      // ? BrandDetailListItem(goods: goods)
                      // ? NormalGoodsItem(model: goods, buildCtx: context,)
                      ? GoodsItemWidget.normalGoodsItem(
                          gifController: _gifController,
                          onBrandClick: () {
                            AppRouter.push(
                                context, RouteName.BRANDGOODS_LIST_PAGE,
                                arguments: BrandGoodsListPage.setArguments(
                                    goods.brandId as int?, goods.brandName));
                          },
                          buildCtx: context,
                          model: goods,
                          type: widget.jdType == 1?3:0,
                        )
                      : BrandDetailGridItem(goods: goods));
            },
            childCount: _listViewController!.getData().length,
          ),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: _displayList ? 1 : 2,
            crossAxisSpacing: _displayList ? 5 : 10,
            mainAxisSpacing: _displayList ? 5 : 10,
          ),
          // ItemTagWidget.getSliverGridDelegate(_displayList, context),
        ),
        SliverToBoxAdapter(
          child: _refreshController.isNoData
              ? Padding(
                  padding: EdgeInsets.only(top: rSize(40), bottom: rSize(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: rSize(2),
                        color: Color(0xFFB8B8B8),
                        width: rSize(40),
                      ),
                      rWBox(10),
                      Text(
                        '猜你喜欢',
                        style: TextStyle(
                          fontSize: rSP(15),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      rWBox(10),
                      Container(
                        height: rSize(2),
                        color: Color(0xFFB8B8B8),
                        width: rSize(40),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ),
        SliverToBoxAdapter(
            child: _refreshController.isNoData
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      PromotionGoodsModel model = _promotionGoodsList[index];
                      return Container(
                        padding: EdgeInsets.only(bottom: 5),
                        color: AppColor.frenchColor,
                        child: GoodsItemWidget.rowGoods(
                          gifController: _gifController,
                          isSingleDayGoods: false,
                          onBrandClick: () {
                            AppRouter.push(
                                context, RouteName.BRANDGOODS_LIST_PAGE,
                                arguments: BrandGoodsListPage.setArguments(
                                    model.brandId as int?, model.brandName));
                          },
                          model: model,
                          buyClick: () {
                            AppRouter.push(context, RouteName.COMMODITY_PAGE,
                                arguments: CommodityDetailPage.setArguments(
                                    model.goodsId));
                          },
                        ),
                      );
                    },
                    itemCount: _promotionGoodsList.length,
                  )
                : SizedBox()),
      ],
    );
  }

  _buildGridView() {
    return GridView.builder(
        padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight!),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _listViewController!.getData().length,
        gridDelegate:
            ItemTagWidget.getSliverGridDelegate(_displayList, context),
        itemBuilder: (context, index) {
          GoodsSimple goods = _listViewController!.getData()[index];
          return MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(goods.id as int?));
              },
              child: _displayList
                  // ? BrandDetailListItem(goods: goods)
                  // ? NormalGoodsItem(model: goods, buildCtx: context,)
                  ? GoodsItemWidget.normalGoodsItem(
                      gifController: GifController(vsync: this)
                        ..repeat(
                          min: 0,
                          max: 20,
                          period: Duration(milliseconds: 700),
                        ),
                      onBrandClick: () {
                        AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                            arguments: BrandGoodsListPage.setArguments(
                                goods.brandId as int?, goods.brandName));
                      },
                      buildCtx: context,
                      model: goods,
                    )
                  : BrandDetailGridItem(goods: goods));
        });
  }

  Future _callRefresh() async {
    final cancel = ReToast.raw(Container(
      margin: EdgeInsets.only(top: 48),
      color: Color(0xFFAAAAAA),
      alignment: Alignment.center,
      child: LoadingDialog(
        //调用对话框
        text: '马上就好，请稍等～',
      ),
    ));
    _listViewController!.replaceData([]);

    await _presenter!.fetchList(
      -99,
      0,
      _sortType,
      widget.countryId,
      keyword: _searchText,
      JDType: _jDType,
    );

    _recommendWords = await HomeFuc.recommendWords(_searchText);

    cancel();
    _startSearch = true;
    if(_listViewController!.getData().isNotEmpty){
      _scrollController.jumpTo(0.0);
    }

    setState(() {});
  }

  List<Widget> _rightActions(store) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(right: rSize(10), left: rSize(10)),
        child: CustomImageButton(
          title: "搜索",
          // buttonSize: 60,
          color: TextUtils.isEmpty(_searchText) ? Colors.grey : Colors.black,
          fontSize: 15 * 2.sp,
          onPressed: () async {
            if (TextUtils.isEmpty(_searchText)) return;
            _contentFocusNode.unfocus();
            await _callRefresh();
          },
        ),
      )
    ];
  }

  Widget _buildTitle() {
    return Container(
        // margin: EdgeInsets.only(right: rSize(10)),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                controller: _textEditController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_submitted) async {
                  _callRefresh();
                  _contentFocusNode.unfocus();
                },
                focusNode: _contentFocusNode,
                onChanged: (text) {
                  _startSearch = false;
                  _searchText = text;
                  if(text=='1281228557'){
                    UserManager.instance!.getLoggerData = !UserManager.instance!.getLoggerData;
                    PowerLogger.start(context, debug:UserManager.instance!.getLoggerData);
                  }



                },
                placeholder: "请输入想要搜索的内容...",
                placeholderStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
                style: TextStyle(
                    color: Colors.black,
                    textBaseline: TextBaseline.ideographic),
              ),
            )
          ],
        )
        // child: TextField(
        //   controller: _textEditController,
        //   textInputAction: TextInputAction.search,
        //   onSubmitted: (_submitted){
        //     _contentFocusNode.unfocus();
        //     _presenter.fetchSearchList(_searchText, 0);
        //   },
        //   focusNode: _contentFocusNode,
        //   onChanged: (text){
        //     _searchText = text;
        //     setState(() {});
        //   },
        //   decoration: InputDecoration(
        //       prefixIcon: Icon(
        //             Icons.search,
        //             size: 20,
        //             color: Colors.grey,
        //           ),
        //       contentPadding: EdgeInsets.only(top: 8,),
        //       border: InputBorder.none,
        //       hintText: "请输入想要搜索的内容...",
        //       hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w300),
        //       fillColor: Colors.black),
        //   style: TextStyle(color: Colors.black, textBaseline: TextBaseline.ideographic),
        //   // cursorColor: getCurrentThemeColor(),
        // ),
        );
  }

  @override
  MvpListViewPresenterI<GoodsSimple, MvpView, MvpModel>? getPresenter() {
    return _presenter;
  }

  @override
  refreshSuccess(List<GoodsSimple> data) {
    super.refreshSuccess(data);
    if (data.length > 0) {
      if (_searchHistory.contains(_searchText)) {
        _searchHistory.remove(_searchText);
        List<String> list = [_searchText];
        list.addAll(_searchHistory);
        _searchHistory = list;
      } else {
        List<String> list = [_searchText];
        list.addAll(_searchHistory);
        _searchHistory = list;
        while (_searchHistory.length > 15) {
          _searchHistory.removeLast();
        }
      }
      saveSearchListToSharedPreferences(_searchHistory);
      setState(() {});
    }
  }

  _searchHistoryWidget() {
    List<Widget> choiceChipList = [];
    if (_searchHistory != null && _searchHistory.length > 0) {
      for (var text in _searchHistory) {
        choiceChipList.add(Padding(
          padding: EdgeInsets.only(right: 10, bottom: 5),
          child: ChoiceChip(
            backgroundColor: AppColor.frenchColor,
            // disabledColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 15 * 2.sp, color: Colors.black),
            labelPadding: EdgeInsets.only(left: 20, right: 20),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (bool value) async {
              _searchText = text;
              _textEditController!.text = text;
              FocusManager.instance.primaryFocus!.unfocus();
              _callRefresh();
              setState(() {});
            },
            label: Text(text),
            selected: false,
          ),
        ));
      }
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '历史搜索',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16 * 2.sp,
                      ),
                    ),
                    Spacer()
                  ],
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              children: choiceChipList,
            ),
          ),
          // Spacer()
        ],
      ),
    );
  }

  _keyWordsTitle(){
    return Container(
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 5,right: 10),
          child:
          Text(
            '没找到相关宝贝，试试',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14 * 2.sp,
            ),
          ),
        ));
  }

  _recommendWidget() {
    List<Widget> keyWordList = [];
    int leg = 0;
    if (_recommendWords.length > 0) {
      for (int i=0;i<_recommendWords.length;i++) {
        keyWordList.add(Padding(
          padding: EdgeInsets.only(right: 10, bottom: 5),
          child: ChoiceChip(
            backgroundColor: AppColor.frenchColor,
            // disabledColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 15 * 2.sp, color: Colors.black),
            labelPadding: EdgeInsets.only(left: 20, right: 20),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (bool value) async {
              _searchText = _recommendWords[i].token??'';
              _textEditController!.text = _recommendWords[i].token!;
              FocusManager.instance.primaryFocus!.unfocus();
              _callRefresh();
              setState(() {});
            },
            label: Text(_recommendWords[i].token!),
            selected: false,
          ),
        ));
      }
      keyWordList.insert(0, _keyWordsTitle());
    }



    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              children: keyWordList,
            ),
          ),
          // Spacer()
        ],
      ),
    );
  }


  getSearchListFromSharedPreferences() async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    if (UserManager.instance!.haveLogin) {
      _searchHistory = prefs.getStringList(
          UserManager.instance!.user.info!.id.toString() + "userSearhHistory")??[];
      if (_searchHistory == null) {
        _searchHistory = [];
      }
      setState(() {});
    }
  }

  saveSearchListToSharedPreferences(List<String> value) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        UserManager.instance!.user.info!.id.toString() + "userSearhHistory",
        value);
  }
}
