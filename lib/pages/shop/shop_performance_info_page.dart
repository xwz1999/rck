import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/performance_info_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';

class ShopPerformanceInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopPerformanceInfoPageState();
  }
}

class _ShopPerformanceInfoPageState
    extends BaseStoreState<ShopPerformanceInfoPage> {
  PerformanceInfoModel _model;
  List<String> _dateList = [];
  var _selectValue;

  @override
  void initState() {
    super.initState();
    _getDateTime();
    _selectValue = _dateList.first;
    _getDataList();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        appBar: CustomAppBar(
          appBackground: Color(0xffFA4D2C),
          elevation: 0,
          // themeData: AppThemes.themeDataGrey.appBarTheme,
          title: "团队业绩",
        ),
        // body: _bodyWidget(),
        body: _model == null
            ? loadingWidget()
            : Stack(
                children: <Widget>[
                  _model == null
                      ? Container()
                      : Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          height: 60 + 130 / 2,
                          child: Container(
                            color: Color(0xffFA4D2C),
                          ),
                        ),
                  Positioned(
                    child: _bodyWidget(),
                  ),
                  // Positioned(
                  //   child: RefreshWidget(
                  //     onRefresh: (){
                  //       _page = 0;
                  //       _getIncomeSalesList();
                  //     },
                  //     onLoadMore:
                  //       _listData == null || _listData.length < (_page+1)*20 ? null : () {
                  //               _page++;
                  //               _getIncomeSalesList();
                  //             },
                  //     controller: _gsRefreshController,
                  //     body: _bodyWidget(),
                  //   ),
                  // ),
                ],
              ));
  }

  _bodyWidget() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: <Widget>[
        _model == null
            ? SliverToBoxAdapter(
                child: Container(
                  height: 0,
                ),
              )
            : SliverToBoxAdapter(
                child: _titleWidget(),
              ),
        _model == null
            ? SliverToBoxAdapter(
                child: Container(
                  height: 0,
                ),
              )
            : SliverToBoxAdapter(
                child: _cardWidget(
                    _model.data.statistics.salesAmount,
                    _model.data.statistics.subIncome,
                    _model.data.statistics.income,
                    _model.data.statistics.ratio,
                    _model.data.statistics.actualIncome),
              ),
        _model == null
            ? SliverToBoxAdapter(
                child: Container(
                  height: 0,
                ),
              )
            : SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  height: 45,
                  alignment: Alignment.centerLeft,
                  color: AppColor.frenchColor,
                  child: Text(
                    _model.data.list != null && _model.data.list.length > 1
                        ? "邀请数量: ${_model.data.list.length - 1}人"
                        : "邀请数量: 0人",
                    style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
                  ),
                ),
              ),
        _model == null || _model.data.list.length == 0
            ? SliverToBoxAdapter(
                child: Container(
                height: 300,
                child: noDataView('没有数据...'),
              ))
            : SliverList(
                delegate: new SliverChildListDelegate(
                    _model.data.list.map<Widget>((PerformanceList data) {
                return _itemWidget(data);
              }).toList())),
        _model == null || _model.data.list.length == 0
            ? SliverToBoxAdapter(child: Container())
            : SliverToBoxAdapter(
                child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  "到底了~",
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              ))
      ],
    );
  }

  _titleWidget() {
    return Container(
      height: 60,
      // color: AppColor.tableViewGrayColor,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15),
            width: 90,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xffFA4D2C),
              // color: AppColor.tableViewGrayColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('  本月', style: TextStyle(color: Colors.black, fontSize: 12*2.sp)),
                Container(
                  width: 10,
                ),
                _popupMenuWidget(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }

  _cardWidget(
      num salesAmount, num subIncome, num income, num ratio, num actualIncome) {
    return Container(
      height: 130,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(3.0, 3.0),
              blurRadius: 10.0,
              spreadRadius: 2.0),
        ], borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: _cardTextItem(
                    '团队销售额(元)',
                    salesAmount.toString(),
                    TextStyle(color: Colors.red, fontSize: 20 * 2.sp),
                    false,
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: _cardTextItem(
                    '店铺分红(元)',
                    actualIncome.toString(),
                    TextStyle(color: Colors.red, fontSize: 20 * 2.sp),
                    false,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: _cardTextItem(
                    '提成比例(%)',
                    ratio.toString(),
                    null,
                    false,
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child:
                      _cardTextItem('团队收入(元)', income.toString(), null, false),
                )),
                Container(
                  alignment: Alignment.center,
                  child: _cardTextItem(
                      '收入下发(元)', subIncome.toString(), null, false),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _cardTextItem(
      String title, String amount, TextStyle amountStyle, bool moneyIconHidden,
      {Alignment titleAligment, Alignment amountAligment}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Container(
            alignment: titleAligment == null ? Alignment.center : titleAligment,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12 * 2.sp,
              ),
            ),
          ),
          Container(
            alignment:
                amountAligment == null ? Alignment.center : amountAligment,
            child: Text(
              amount,
              style: amountStyle != null
                  ? amountStyle
                  : TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16 * 2.sp,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _popupMenuWidget() {
    return PopupMenuButton(
      color: Colors.white,
      offset: Offset(0, 100),
      child: Text(
        _selectValue == null ? '' : _selectValue,
        style: TextStyle(color: Colors.white),
      ),
      padding: EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context) {
        return _dateList.map<PopupMenuItem<String>>((value) {
          return PopupMenuItem<String>(
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
            value: value,
          );
        }).toList();
      },
      onSelected: (String value) {
        _selectValue = value;
        _getDataList();
        setState(() {});
      },
    );
  }

  _getDateTime() {
    DateTime today = DateTime.now();
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String formatted = formatter.format(now);
    // String now = formatDate(DateTime.now(), [yyyy, '-', mm]);
    // String now_1 = formatDate(DateTime.now().add(Duration()), [yyyy, '-', mm]);

    int year = today.year;
    int month = today.month;
    if (month.toString().length == 1) {
      _dateList.add("$year-0$month");
    } else {
      _dateList.add("$year-$month");
    }
    int count = 5;
    while (count > 0) {
      count--;
      if (month == 1) {
        year--;
        month = 12;
      } else {
        month--;
      }
      if (month.toString().length == 1) {
        _dateList.add("$year-0$month");
      } else {
        _dateList.add("$year-$month");
      }
    }
  }

  _itemWidget(PerformanceList data) {
    return Container(
      color: Colors.white,
      height: 70,
      child: Row(
        children: <Widget>[
          Container(
            width: 20,
          ),
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: CustomCacheImage(
                fit: BoxFit.fill,
                width: 90,
                height: 90,
                imageUrl: TextUtils.isEmpty(data.avatarPath)
                    ? ""
                    : Api.getResizeImgUrl(data.avatarPath, 80),
              )),
          Container(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      data.nickname,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16 * 2.sp,
                                      ),
                                    )),
                                data.userId == UserManager.instance.user.info.id
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "  (自己)",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13 * 2.sp,
                                          ),
                                        ))
                                    : Container(),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              alignment: Alignment.centerLeft,
                              child: UserLevelTool.roleLevelWidget(
                                  level: data.role.toString()),
                              // child: UserIconWidget.levelWidget(data.role),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 23,
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "￥",
                                style: TextStyle(
                                    color: data.salesAmount > 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 11 * 2.sp),
                              ),
                            ),
                            Text(
                              data.salesAmount.toString(),
                              style: TextStyle(
                                  color: data.salesAmount > 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 20 * 2.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getDataList() async {
    ResultData resultData = await HttpManager.post(ShopApi.income_team_list, {
      "userId": UserManager.instance.user.info.id,
      "date": _selectValue,
    });

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    PerformanceInfoModel model = PerformanceInfoModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    _model = model;
    setState(() {});
  }
}
