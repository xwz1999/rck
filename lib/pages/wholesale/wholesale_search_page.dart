

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:recook/pages/home/function/home_fuc.dart';
import 'package:recook/pages/wholesale/wholeasale_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/progress/loading_dialog.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'func/wholesale_func.dart';
import 'models/wholesale_good_model.dart';
import 'more_goods/whoesale_goods_grid.dart';
import 'more_goods/whoesale_goods_normal.dart';

class WholesaleSearchPage extends StatefulWidget {

  final int? jdType;
  final String? keyWords;//1为京东商品 空为非jd

  const WholesaleSearchPage({Key? key,  this.jdType, this.keyWords}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleSearchPageState();
  }
}

class _WholesaleSearchPageState extends BaseStoreState<WholesaleSearchPage>
    with  TickerProviderStateMixin {
  String? _searchText = "";
  FocusNode _contentFocusNode = FocusNode();

  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = false;//默认排列方式改为瀑布流

  late FilterToolBarController _filterController;

  late MvpListViewController<GoodsSimple> _listViewController;
  TextEditingController? _textEditController;

  List<String?>? _searchHistory = [];

  List<KeyWordModel> _recommendWords = [];//推荐分词
  List<bool> _barBool = [false, false, false];
  bool _startSearch = false;

  SortType _sortType = SortType.comprehensive;
  int _filterIndex = 0;

  GSRefreshController _refreshController = GSRefreshController();
  GoodsHotSellListModel? _listModel;
  late GifController _gifController;
  int _page = 0;

  int _jDType = 0; // 0 默认数据 1传回全部JD数据 2为JD自营数据 3为JD pop数据
  String _jdTypeText = '全部';
  bool isNodata = false;
  ScrollController _scrollController = ScrollController();

  ///商品列表
  List<WholesaleGood> _goodsList = [];

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   _recommendWords = await HomeFuc.recommendWords(widget.keyWords);
    // });

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

    _listViewController = MvpListViewController(controller: _refreshController);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      // appBar: CustomAppBar(title: "搜索"),
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
                        offstage: !(_listViewController.getData().length==0),
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
                    Expanded(child: _buildList()),
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

  _buildGridView() {
    return WaterfallFlow.builder(
        padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight!),
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _goodsList.length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: _displayList ? 1 : 2,
          crossAxisSpacing: _displayList ? 5 : 7,
          mainAxisSpacing: _displayList ? 0 : 0,
        ),
        itemBuilder: (context, index) {
          WholesaleGood goods = _goodsList[index];
          return MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.to(()=>WholesaleDetailPage(goodsId: goods.id as int?,));
              },
              child: _displayList
              // ? BrandDetailListItem(goods: goods)
                  ? WholesaleGoodsItem.normalGoodsItem(
                model: _goodsList[index],
                buildCtx: context,
              ) : WholesaleGoodsGrid(goods: goods));
        });
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
        _listViewController.stopRefresh();
        _listViewController.requestRefresh();
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


  _buildList(){
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _page = 0;
        WholesaleFunc.getGoodsList(_page,_sortType,keyword:_searchText ).then((value) {
          setState(() {
            _goodsList = value;
          });
          saveKerWord(_goodsList);
          if(_goodsList.isEmpty){
            isNodata = true;
          }else{
            isNodata = false;
          }
          // if (value.isEmpty)
          //   _refreshController.isNoData;
          // else
          if(_goodsList.isNotEmpty){
            _scrollController.jumpTo(0.0);
          }

          _refreshController.refreshCompleted();
        });

      },
      onLoadMore: () async{
        _page++;
        WholesaleFunc.getGoodsList(_page,_sortType,keyword: _searchText).then((value) {
          setState(() {
            _goodsList.addAll(value);
          });
          if(_goodsList.isEmpty){
            isNodata = true;
          }else{
            isNodata = false;
          }
          if (value.isEmpty)
            _refreshController.loadNoData();
          else
            _refreshController.loadComplete();
        });
      },
      body:isNodata? NoDataView(
        title: "换个关键词搜索一下吧~",
      ):  _goodsList.isNotEmpty?
      _buildGridView():SizedBox(),

    );
  }

  saveKerWord(List<WholesaleGood> data) {

    if (data.length > 0) {
      if (_searchHistory!.contains(_searchText)) {
        _searchHistory!.remove(_searchText);
        List<String?> list = [_searchText];
        list.addAll(_searchHistory!);
        _searchHistory = list;
      } else {
        List<String?> list = [_searchText];
        list.addAll(_searchHistory!);
        _searchHistory = list;
        while (_searchHistory!.length > 15) {
          _searchHistory!.removeLast();
        }
      }
      saveSearchListToSharedPreferences(_searchHistory!);
      setState(() {});
    }
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
            _listViewController.stopRefresh();
            _listViewController.requestRefresh();
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


//copy from home_page.dart()


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
    _refreshController.requestRefresh();


    _recommendWords = await HomeFuc.recommendWords(_searchText);

    cancel();
    _startSearch = true;
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
                  _listViewController.replaceData([]);
                  setState(() {});
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

        );
  }




  _searchHistoryWidget() {
    List<Widget> choiceChipList = [];
    if (_searchHistory != null && _searchHistory!.length > 0) {
      for (var text in _searchHistory!) {
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
              _textEditController!.text = text!;
              FocusManager.instance.primaryFocus!.unfocus();
              _callRefresh();
              setState(() {});
            },
            label: Text(text!),
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
              _searchText = _recommendWords[i].token;
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
          UserManager.instance!.user.info!.id.toString() + "userSearhWholesaleHistory");
      if (_searchHistory == null) {
        _searchHistory = [];
      }
      setState(() {});
    }
  }

  saveSearchListToSharedPreferences(List<String?> value) async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        UserManager.instance!.user.info!.id.toString() + "userSearhWholesaleHistory",
        value as List<String>);
  }
}
