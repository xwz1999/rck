import 'package:flutter/material.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/balance_page_model.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends BaseStoreState<BalancePage> {
  BalancePageModel _coinModel;
  List<DataList> _data;
  int _page = 0;
  GSRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GSRefreshController(initialRefresh: false);
    _getData(0);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      body: NestedScrollView(
//        controller: _controller,
        headerSliverBuilder: _headerSliverBuilder,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: _list(),
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(context, isScrolled) {
    return <Widget>[
      SliverAppBar(
        title: Text(
          "余额",
          style: TextStyle(fontSize: rSize(18)),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              AppIcons.icon_back,
              size: 17,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        pinned: true,
        forceElevated: false,
        backgroundColor: AppColor.rgbColor(246, 113, 120),
        // actions: <Widget>[IconButton(icon: Icon(Icons.history), onPressed: () {})],
        expandedHeight: rSize(260),
        flexibleSpace: _flexibleSpaceBar(),
        bottom: PreferredSize(
          child: Container(
            height: rSize(48),
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Text(
                "资金收益明细",
                style: AppTextStyle.generate(16 * 2.sp, color: Colors.black),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(48),
        ),
      ),
    ];
  }

  FlexibleSpaceBar _flexibleSpaceBar() {
    return FlexibleSpaceBar(
      background: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppColor.rgbColor(246, 106, 136),
              AppColor.rgbColor(246, 118, 108),
            ])),
          ),
          Container(
            alignment: Alignment.center,
            // width: rSize(100),
            height: rSize(100),
            // padding: EdgeInsets.all(rSize(20)),
            // decoration: BoxDecoration(
            //     color: AppColor.rgbColor(255, 255, 255, a: 70),
            //     borderRadius: BorderRadius.all(Radius.circular(100))),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: _coinModel == null
                      ? "- -"
                      : _coinModel.data.balance.toDouble().toString(),
                  style: AppTextStyle.generate(25 * 2.sp, color: Colors.white),
                  children: [
                    TextSpan(
                        text: "\n余额(元)",
                        style: AppTextStyle.generate(13 * 2.sp,
                            color: Colors.white))
                  ]),
            ),
          )
        ],
      ),
    );
  }

  _list() {
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        _page = 0;
        _getData(_page);
      },
      onLoadMore: () {
        _page++;
        _getData(_page, lastId: _data.last.id);
      },
      body: _data == null
          ? noDataView("您当前没有余额")
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (_, index) {
                DataList detail = _data[index];
                bool isAdd = detail.amount > 0;
                return Container(
                  padding: EdgeInsets.all(rSize(10)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300], width: 0.6 * 2.w))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              detail.title,
                              style: AppTextStyle.generate(15 * 2.sp),
                            ),
                            SizedBox(
                              height: rSize(2),
                            ),
                            Text(
                              detail.comment,
                              style: AppTextStyle.generate(13 * 2.sp,
                                  color: Colors.grey[600]),
                            ),
                            SizedBox(
                              height: rSize(2),
                            ),
                            Text(
                              detail.createdAt,
                              style: AppTextStyle.generate(12 * 2.sp,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${isAdd ? "+" : ""}${detail.amount}",
                        style: AppTextStyle.generate(20 * 2.sp,
                            color: isAdd ? Colors.red : Colors.green),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  _getData(int page, {int lastId}) async {
    ResultData resultData = await HttpManager.post(UserApi.balance_list,
        {"userId": UserManager.instance.user.info.id, "page": _page});

    if (!resultData.result) {
      showError(resultData.msg);
      _endRefresh(false, null);
      return;
    }
    BalancePageModel model = BalancePageModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      _endRefresh(false, null);
      return;
    }
    _endRefresh(true, model);
  }

  _endRefresh(bool success, BalancePageModel model) {
    if (!success) {
      if (_page == 0) {
        _controller.refreshCompleted();
      } else {
        _controller.loadComplete();
        _page--;
      }
      return;
    }

    _coinModel = model;
    if (_page == 0) {
      _controller.refreshCompleted();
      _data = _coinModel.data.list;
      setState(() {});
    } else {
      if (_coinModel.data.list.length == 0) {
        _controller.loadNoData();
        return;
      }
      _controller.loadComplete();
      _data.addAll(_coinModel.data.list);
      _page++;
      setState(() {});
    }
  }
}
