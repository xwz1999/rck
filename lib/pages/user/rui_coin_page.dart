import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/rui_coin_list_model.dart';
import 'package:recook/pages/user/rui_transfer_to_balance_page.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class RuiCoinPage extends StatefulWidget {
  @override
  _RuiCoinPageState createState() => _RuiCoinPageState();
}

class ClassifyType {
  final String name;
  final String sortType;
  final int index;
  bool isSelect;
  ClassifyType(
      {this.isSelect = false,
      this.name = "",
      this.sortType = "",
      this.index = 0});
}

class _RuiCoinPageState extends BaseStoreState<RuiCoinPage> {
  RuiCoinListModel _listModel;
  List<CoinList> _cellModelList;
  GSRefreshController _refreshController;
  bool _openFilter = false;
  DateTime _selectDateTime;
  String _selectDateString;
  List<ClassifyType> _typeList = [
    ClassifyType(name: '全部', sortType: "", isSelect: true),
    ClassifyType(name: '消费', sortType: "purchase"),
    ClassifyType(name: '转出', sortType: "transfer"),
    ClassifyType(name: '导购收益', sortType: "share"),
    ClassifyType(name: '自购收益', sortType: "shopping"),
    ClassifyType(name: '团队收益', sortType: "team"),
    ClassifyType(name: '瑞币退回', sortType: "coin_refund"),
  ];
  ClassifyType _selectType;
  @override
  void initState() {
    super.initState();
    _selectType = _typeList[0];
    _selectDateTime = DateTime.now();
    _selectDateString = _getDateString(_selectDateTime);
    _refreshController = GSRefreshController(initialRefresh: false);
    _getCoinList();
    _cellModelList = [];
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: <Widget>[_listModel == null ? Container() : _goToBalance()],
        appBackground: Colors.white,
        elevation: 0,
        title: "我的瑞币",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        background: Colors.white,
      ),
      body: _listModel == null
          ? loadingView()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _headInfoWidget(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      RefreshWidget(
                        headerTriggerDistance: rSize(80),
                        color: Colors.black,
                        controller: _refreshController,
                        releaseText: "松开更新数据",
                        idleText: "下拉更新数据",
                        refreshingText: "正在更新数据...",
                        onRefresh: () {
                          _getCoinList();
                        },
                        body: _cellModelList != null &&
                                _cellModelList.length > 0
                            ? ListView.builder(
                                itemCount: _cellModelList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _itemWidget(_cellModelList[index]);
                                },
                              )
                            : noDataView("没有数据..."),
                      ),
                      _openFilter
                          ? _filterWidget()
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _itemWidget(CoinList coinList) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      width: double.infinity,
      height: 60,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 30),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      coinList.typeName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                    Container(
                      height: 3,
                    ),
                    Text(
                      coinList.userCoin.createdAt,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  coinList.userCoin.coinNum > 0
                      ? "+${coinList.userCoin.coinNum}"
                      : coinList.userCoin.coinNum.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          )),
          Container(
            height: 1,
            color: AppColor.frenchColor,
          )
        ],
      ),
    );
  }

  _goToBalance() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: CustomImageButton(
        icon: Image.asset(
          "assets/rui_page_balance.png",
          width: 13,
          height: 13,
        ),
        title: " 转到余额",
        style: TextStyle(color: Colors.black, fontSize: 13),
        direction: Direction.horizontal,
        onPressed: () {
          AppRouter.push(context, RouteName.RUI_TRANSFER_BALANCE_PAGE,
              arguments: RuiCoinTransferToBalancePage.setArguments(
                  _listModel.data.total));
        },
      ),
    );
  }

  _headInfoWidget() {
    return Container(
      height: 110 + 50.0,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 110,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "总瑞币",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        '¥${_listModel.data.total.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Color(0xffd40000),
                            fontSize: 29,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "累计收益",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        '¥${_listModel.data.history.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 29),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Color(0xfff5f5f5),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _openFilter = !_openFilter;
                    setState(() {});
                  },
                  child: _selectWidget(
                    _selectType.name,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _showTimePickerBottomSheet();
                  },
                  child: _selectWidget(
                    _selectDateString,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _selectWidget(
    String title,
  ) {
    return Container(
      height: 32.0,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          Container(
            width: 0,
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: Color(0xff8f8f8f),
          ),
        ],
      ),
    );
  }

  _filterWidget() {
    List<Widget> choiceChipList = [];

    for (ClassifyType type in _typeList) {
      choiceChipList.add(GestureDetector(
        child: Container(
            height: 37,
            width: (MediaQuery.of(context).size.width - 30 - 20) / 3,
            color: type.isSelect ? Color(0xffFFDDDD) : Color(0xfff5f5f5),
            alignment: Alignment.center,
            child: Text(
              type.name,
              style: TextStyle(
                  color: type.isSelect ? Color(0xffFF5B5B) : Colors.black,
                  fontSize: 14),
            )),
        onTap: () {
          for (ClassifyType subType in _typeList) {
            subType.isSelect = false;
          }
          type.isSelect = true;
          _selectType = type;
          _openFilter = false;
          setState(() {});
          _refreshController.requestRefresh();
        },
      ));
    }
    Container con = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: choiceChipList,
            ),
          ),
        ],
      ),
    );
    return GestureDetector(
      child: con,
      onTap: () {
        _openFilter = !_openFilter;
        setState(() {});
      },
    );
  }

  _showTimePickerBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: [BottomTimePickerType.BottomTimePickerMonth],
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: (time, type) {
                Navigator.maybePop(context);
                _selectDateTime = time;
                _selectDateString = _getDateString(_selectDateTime);
                setState(() {});
                _refreshController.requestRefresh();
              },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  _getDateString(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
  }

  _getCoinList() async {
    ResultData resultData = await HttpManager.post(UserApi.rui_coin_list, {
      "userId": UserManager.instance.user.info.id,
      "date": _getDateString(_selectDateTime),
      "coinType": _selectType != null ? _selectType.sortType : ""
    });

    if (!resultData.result) {
      showError(resultData.msg);
      _refreshController.refreshCompleted();
      return;
    }
    RuiCoinListModel model = RuiCoinListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      _refreshController.refreshCompleted();
      return;
    }
    _listModel = model;
    _cellModelList = model.data.list;
    setState(() {});
    _refreshController.refreshCompleted();
  }

  // // 无用
  // List<Widget> _headerSliverBuilder(context, isScrolled) {
  //   return <Widget>[
  //     SliverAppBar(
  //       title: Text(
  //         "我的瑞币",
  //         style: TextStyle(fontSize: rSize(18)),
  //       ),
  //       centerTitle: true,
  //       leading: IconButton(
  //           icon: Icon(
  //             AppIcons.icon_back,
  //             size: 17,
  //             color: Colors.white,
  //           ),
  //           onPressed: () {
  //             Navigator.maybePop(context);
  //           }),
  //       pinned: true,
  //       forceElevated: false,
  //       backgroundColor: AppColor.rgbColor(246, 113, 120),
  //       actions: <Widget>[IconButton(icon: Icon(Icons.history), onPressed: () {})],
  //       expandedHeight: rSize(260),
  //       flexibleSpace: _flexibleSpaceBar(),
  //       bottom: PreferredSize(
  //         child: Container(
  //           height: rSize(48),
  //           width: double.infinity,
  //           color: Colors.white,
  //           child: Center(
  //             child: Text(
  //               "瑞币收支明细",
  //               style: AppTextStyle.generate(ScreenAdapterUtils.setSp(16), color: Colors.black),
  //             ),
  //           ),
  //         ),
  //         preferredSize: Size.fromHeight(48),
  //       ),
  //     ),
  //   ];
  // }

  // FlexibleSpaceBar _flexibleSpaceBar() {
  //   return FlexibleSpaceBar(
  //     background: Stack(
  //       alignment: AlignmentDirectional.center,
  //       children: <Widget>[
  //         Container(
  //           height: double.infinity,
  //           decoration: BoxDecoration(
  //               gradient: LinearGradient(colors: [
  //             AppColor.rgbColor(246, 106, 136),
  //             AppColor.rgbColor(246, 118, 108),
  //           ])),
  //         ),
  //         Container(
  //           alignment: Alignment.center,
  //           // width: rSize(100),
  //           height: rSize(100),
  //           // padding: EdgeInsets.all(rSize(20)),
  //           // decoration: BoxDecoration(
  //           //     color: AppColor.rgbColor(255, 255, 255, a: 70),
  //           //     borderRadius: BorderRadius.all(Radius.circular(100))),
  //           child: RichText(
  //             textAlign: TextAlign.center,
  //             text: TextSpan(
  //                 text: _coinModel == null ? "- -" : _coinModel.data.amount.toInt().toString(),
  //                 style: AppTextStyle.generate(ScreenAdapterUtils.setSp(25), color: Colors.white),
  //                 children: [
  //                   TextSpan(
  //                       text: "\n瑞币",
  //                       style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
  //                           color: Colors.white))
  //                 ]),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // _list() {
  //   return RefreshWidget(
  //     controller: _controller,
  //     onRefresh: () {
  //       _page = 0;
  //       _getData(_page);
  //     },
  //     onLoadMore: () {
  //       _page++;
  //       _getData(_page, lastId: _data.last.id);
  //     },
  //     body: _data == null
  //         ? noDataView("您还没有产生收益")
  //         : ListView.builder(
  //             itemCount: _data.length,
  //             itemBuilder: (_, index) {
  //               Detail detail = _data[index];
  //               bool isAdd = detail.type == 0;
  //               return Container(
  //                 padding: EdgeInsets.all(rSize(10)),
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     border: Border(
  //                         bottom: BorderSide(
  //                             color: Colors.grey[300], width: ScreenAdapterUtils.setWidth(0.6)))),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Text(
  //                             detail.title,
  //                             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15)),
  //                           ),
  //                           SizedBox(height: rSize(2),),
  //                           Text(
  //                             detail.channel,
  //                             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),color: Colors.grey[600]),
  //                           ),
  //                           SizedBox(height: rSize(2),),
  //                           Text(
  //                             detail.createdAt,
  //                             style: AppTextStyle.generate(ScreenAdapterUtils.setSp(12),color: Colors.grey),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Text(
  //                       "${isAdd ? "+" : "-"}${detail.number}",
  //                       style: AppTextStyle.generate(ScreenAdapterUtils.setSp(20),
  //                           color: isAdd ? Colors.red : Colors.green),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //   );
  // }

  // _getData(int page, {int lastId}) async {

  //   ResultData resultData = await HttpManager.post(
  //       UserApi.rui_coin_list, {"userId": UserManager.instance.user.info.id, "lastId": lastId ?? 0});

  //   if (!resultData.result) {
  //     showError(resultData.msg);
  //     _endRefresh(false, null);
  //     return;
  //   }
  //   RuiCoinListModel model = RuiCoinListModel.fromJson(resultData.data);
  //   if (model.code != HttpStatus.SUCCESS) {
  //     showError(model.msg);
  //     _endRefresh(false, null);
  //     return;
  //   }
  //   _endRefresh(true, model);
  // }

  // _endRefresh(bool success, RuiCoinListModel model) {
  //   if (!success) {
  //     if (_page == 0) {
  //       _controller.refreshCompleted();
  //     } else {
  //       _controller.loadComplete();
  //       _page--;
  //     }
  //     return;
  //   }

  //   _coinModel = model;
  //   if (_page == 0) {
  //     _controller.refreshCompleted();
  //     _data = _coinModel.data.detail;
  //     setState(() {});
  //   } else {
  //     if (_coinModel.data.detail.length == 0) {
  //       _controller.loadNoData();
  //       return;
  //     }
  //     _controller.loadComplete();
  //     _data.addAll(_coinModel.data.detail);
  //     _page++;
  //     setState(() {});
  //   }
  // }
}
