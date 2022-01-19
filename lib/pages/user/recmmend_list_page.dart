import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/cache_tab_bar_view.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:velocity_x/velocity_x.dart';

import 'model/recommend_user_model.dart';

class RecommendListPage extends StatefulWidget {
  final int state;

  RecommendListPage({
    Key key,
    this.state,
  }) : super(key: key);

  @override
  _RecommendListPageState createState() => _RecommendListPageState();
}

class _RecommendListPageState extends State<RecommendListPage> {
  GSRefreshController _refreshController;
  int lastId;
  int size = 9;
  int state = 0; //0全部 1审核 2驳回
  List<RecommendUserModel> _recommendUserList = [];

  @override
  void initState() {
    super.initState();
    state = widget.state;
    _refreshController = GSRefreshController(initialRefresh: true);

  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _recommendUserList =
            await WholesaleFunc.getRecommendUserList(0, size, state);

        if (_recommendUserList.isNotEmpty) {
          lastId = _recommendUserList[_recommendUserList.length - 1].id;
        } else {
          lastId = 0;
        }
        setState(() {

        });
        _refreshController.refreshCompleted();
      },
      onLoadMore: () async {
        _recommendUserList =
            await WholesaleFunc.getRecommendUserList(lastId, size, state);
        setState(() {

        });
        _refreshController.loadComplete();
      },
      body: _recommendUserList.isNotEmpty?
      ListView.builder(
        itemBuilder: (context, index) {
          return _recommendItem(_recommendUserList[index]);
        },
        itemCount: _recommendUserList.length,
      ):noDataView('没有申请记录...'),
    );
  }

  _recommendItem(RecommendUserModel item) {
    return Container(
      height: 142.rw,
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.rw, left: 12.rw, right: 12.rw),
      padding: EdgeInsets.all(16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(rSize(8.rw))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              '${item.kindStr}推荐'
                  .text
                  .size(16.rsp)
                  .fontWeight(FontWeight.bold)
                  .color(Color(0xFF333333))
                  .make(),
              Spacer(),
              '${item.stateStr}'
                  .text
                  .size(14.rsp)
                  .fontWeight(FontWeight.bold)
                  .color(item.state == 1
                      ? Color(0xFFFF731E)
                      : item.state == 2
                          ? Color(0xFF13AC3E)
                          : item.state == 3
                              ? Color(0xFFD5101A)
                              : Color(0xFFFF731E))
                  .make(),
            ],
          ),
          20.hb,
          Row(
            children: [
              '被推荐人手机号：'.text.size(14.rsp).color(Color(0xFF666666)).make(),
              '${item.mobile}'
                  .text
                  .size(14.rsp)
                  .color(Color(0xFF333333))
                  .make(),
            ],
          ),
          20.hb,
          Row(
            children: [
              '推荐时间：'.text.size(14.rsp).color(Color(0xFF333333)).make(),
              '${item.createdAt}'
                  .text
                  .size(14.rsp)
                  .color(Color(0xFF333333))
                  .make(),
            ],
          ),
          20.hb,
          Row(
            children: [
              '审核时间：'.text.size(14.rsp).color(Color(0xFF333333)).make(),
              item.processTime == null
                  ? ('-'.text.size(14.rsp).color(Color(0xFF333333)).make())
                  : '${item.processTime}'
                      .text
                      .size(14.rsp)
                      .color(Color(0xFF333333))
                      .make(),
            ],
          ),
          item.state == 3 ? 20.hb : SizedBox(),
          item.state == 3
              ? Row(
                  children: [
                    '驳回原因：'.text.size(14.rsp).color(Color(0xFF333333)).make(),
                    '${item.reason}'
                        .text
                        .size(14.rsp)
                        .color(Color(0xFF333333))
                        .make(),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
  noDataView(String text, {Widget icon}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ??
              Image.asset(
                R.ASSETS_NODATA_PNG,
                width: rSize(80),
                height: rSize(80),
              ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
          SizedBox(
            height: rSize(30),
          )
        ],
      ),
    );
  }
}
