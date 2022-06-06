import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/commission_income_model.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/progress/sc_dialog.dart';
import 'package:recook/widgets/refresh_widget.dart';

class CommissionIncomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommissionIncomeWidgetState();
  }
}

class _CommissionIncomeWidgetState extends State<CommissionIncomeWidget> {
  int _page = 0;
  CommissionIncomeModel? _model;
  List<IncomeList>? _listData = [];
  GSRefreshController? _gsRefreshController;
  List<String> _dateList = [];
  var _selectValue;

  @override
  void initState() {
    super.initState();
    // _gsRefreshController = GSRefreshController();
    _gsRefreshController = GSRefreshController(initialRefresh: true);
    _getDateTime();
    _selectValue = _dateList.first;
  }

  @override
  Widget build(BuildContext context, {store}) {
    return Container(
      child: Column(
        children: <Widget>[
          _titleWidget(),
          Expanded(
            child: _refreshWidget(),
          )
        ],
      ),
    );
  }

  _titleWidget() {
    return Container(
      height: 60,
      color: AppColor.tableViewGrayColor,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(left: 15),
              width: 90,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
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
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
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

  _popupMenuWidget() {
    return PopupMenuButton(
      color: Colors.white,
      offset: Offset(0, 100),
      child: Text(
        _selectValue,
        style: TextStyle(color: Colors.black),
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
        _gsRefreshController!.requestRefresh();
        _page = 0;
        setState(() {});
      },
    );
  }

  _refreshWidget() {
    return RefreshWidget(
      isInNest: true,
      controller: _gsRefreshController,
      onRefresh: () {
        _page = 0;
        _getListModel();
      },
      onLoadMore: _listData == null || _listData!.length < (_page + 1) * 20
          ? null
          : () {
              _page++;
              _getListModel();
            },
      body: _listData == null || _listData!.length == 0
          ? NoDataView(title: '没有数据...')
          : ListView.builder(
              itemBuilder: (_, index) {
                return _itemWidget(_listData![index]);
              },
              itemCount: _listData!.length,
            ),
    );
  }

  _getListModel() async {
    ResultData resultData =
        await HttpManager.post(ShopApi.income_sales_sum_list, {
      "userId": UserManager.instance!.user.info!.id,
      "page": _page,
      "date": _selectValue,
    });
    _gsRefreshController!.isRefresh()
        ? _gsRefreshController!.refreshCompleted()
        : null;
    _gsRefreshController!.isLoading()
        ? _gsRefreshController!.loadComplete()
        : null;

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    CommissionIncomeModel model =
        CommissionIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    _model = model;
    if (_page == 0) {
      _listData = model.data!.list;
    } else {
      _listData!.addAll(model.data!.list!);
    }
    setState(() {});
  }

  _itemWidget(IncomeList data) {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 10,
                ),
                Image.asset(
                  data.amount! > 0
                      ? 'assets/icon_income_in.png'
                      : 'assets/icon_income_out.png',
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Container(
                          height: 35,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            data.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black, fontSize: 15 * 2.sp),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.amount! > 0
                            ? '+' + data.amount.toString()
                            : data.amount.toString(),
                        style: TextStyle(
                            color: data.amount! > 0 ? Colors.red : Colors.green,
                            fontSize: 18 * 2.sp),
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.comment!,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12 * 2.sp),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.orderTime != null ? data.orderTime! : "",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12 * 2.sp),
                    )),
                Spacer(),
                Container(
                  height: 0.3,
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getDateTime() {
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;
    // _dateList.add("$year-$month");
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
}
