import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/income_list_model.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserBillingDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserBillingDetailsState();
  }
}

class _UserBillingDetailsState extends BaseStoreState<UserBillingDetails> {
  int _page = 0;
  List<Data> _listData = [];
  GSRefreshController _gsRefreshController;
  String _selectValue = "";
  DateTime _dateTime;
  // DateTime _selectDateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _selectValue =
        '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}';
    _gsRefreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0.5,
        title: '自购明细',
      ),
      body: Column(
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
                  Container(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTimePickerBottomSheet();
                    },
                    child: Container(
                      child: Text(_selectValue,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdapterUtils.setSp(12))),
                    ),
                  ),
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

  _refreshWidget() {
    return RefreshWidget(
      isInNest: true,
      controller: _gsRefreshController,
      onRefresh: () {
        _page = 0;
        _getListModel();
      },
      onLoadMore: _listData == null || _listData.length < (_page + 1) * 20
          ? null
          : () {
              _page++;
              _getListModel();
            },
      body: _listData == null || _listData.length == 0
          ? noDataView('没有数据...')
          : ListView.builder(
              itemBuilder: (_, index) {
                return _itemWidget(_listData[index]);
              },
              itemCount: _listData.length,
            ),
    );
  }

  _getListModel() async {
    ResultData resultData =
        await HttpManager.post(UserApi.income_unaccounted_list, {
      "userId": UserManager.instance.user.info.id,
      "page": _page,
      "date": _selectValue,
    });
    if (_gsRefreshController.isRefresh())
      _gsRefreshController.refreshCompleted();
    if (_gsRefreshController.isLoading()) _gsRefreshController.loadComplete();

    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    IncomeListModel model = IncomeListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    // _model = model;
    if (_page == 0) {
      _listData = model.data;
    } else {
      _listData.addAll(model.data);
    }
    setState(() {});
  }

  _itemWidget(Data data) {
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
                  data.amount > 0
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
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width - 60,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        height: 35,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 35,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                data.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenAdapterUtils.setSp(15)),
                              ),
                            )),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        right: 10,
                        height: 35,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            data.amount > 0
                                ? '+' + data.amount.toString()
                                : data.amount.toString(),
                            style: TextStyle(
                                color:
                                    data.amount > 0 ? Colors.red : Colors.green,
                                fontSize: ScreenAdapterUtils.setSp(18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.comment,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: ScreenAdapterUtils.setSp(12)),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.orderTime,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: ScreenAdapterUtils.setSp(12)),
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

  _showTimePickerBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: (time, type) {
                Navigator.maybePop(context);
                _dateTime = time;
                if (type == BottomTimePickerType.BottomTimePickerMonth) {
                  _selectValue =
                      '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}';
                } else {
                  _selectValue = '${_dateTime.year}';
                }
                setState(() {});
                _gsRefreshController.requestRefresh();
              },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }
}
