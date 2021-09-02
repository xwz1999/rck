import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/pages/buy_tickets/functions/passager_func.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class RechargeHistoryPage extends StatefulWidget {
  RechargeHistoryPage({Key key}) : super(key: key);

  @override
  _RechargeHistoryPageState createState() => _RechargeHistoryPageState();
}

class _RechargeHistoryPageState extends State<RechargeHistoryPage> {
  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);
  //List<Item> _passengerList = [];
  // PassagerModel _passagerModel;
  List<PassagerModel> _passengerList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        appBar: CustomAppBar(
          appBackground: Color(0xFFF9F9FB),
          elevation: 0,
          title: '常用旅客',
          themeData: AppThemes.themeDataGrey.appBarTheme,
        ),
        body: _bulidBody()
      // _passengerList.length != 0
      //     ? _bulidBody()
      //     : NoDataView(
      //         title: '抱歉，您还没有添加任何常用旅客信息',
      //       ),
    );
  }

  _bulidBody() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _passengerList = await PassagerFunc.getPassagerList(
            UserManager.instance.user.info.id);
        setState(() {});
        _refreshController.refreshCompleted();
      },
      body: ListView.separated(
          padding: EdgeInsets.only(top: 10.rw),
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xFFEEEEEE),
              height: 0.5.rw,
              thickness: rSize(0.5),
              indent: 15.rw,
            );
          },
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 5,//_passengerList.length,
          itemBuilder: (context, index) {
            return MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  // String back = await Get.to(AddUsedPassagerPage(
                  //     type: 2, item: _passengerList[index]));
                  // if (back == 'SUCCESS') {
                  //   _refreshController.requestRefresh();
                  // }
                },
                child: _ticketsItem());
          }),
    );
  }

  _ticketsItem() {
    return Container(
      color: Colors.white,
      height: 62.rw,
      padding: EdgeInsets.symmetric(horizontal: 15.rw),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '话费充值',
                  style: TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                ),
                Text(
                  '¥49.00',
                  style: TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                ),
              ],
            ),
            10.hb,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '2021-08-31 17:00',
                  style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
                ),
                Text(
                  '充值话费¥50.00',
                  style: TextStyle(fontSize: 12.rsp, color: Color(0xFF999999)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
