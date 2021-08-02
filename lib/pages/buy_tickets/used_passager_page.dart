import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'airplane_reserve_page.dart';
import 'functions/passager_func.dart';
import 'models/passager_model.dart';

class UsedPassagerPage extends StatefulWidget {
  UsedPassagerPage({Key key}) : super(key: key);

  @override
  _UsedPassagerPageState createState() => _UsedPassagerPageState();
}

class _UsedPassagerPageState extends State<UsedPassagerPage> {
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
        floatingActionButton: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(bottom: 25.rw),
          width: 345.rw,
          child: _addPassger(),
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
          padding: EdgeInsets.only(bottom: 90.rw),
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xFFEEEEEE),
              height: 0.5.rw,
              thickness: rSize(0.5),
              indent: 15.rw,
            );
          },
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _passengerList.length,
          itemBuilder: (context, index) {
            return MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  String back = await Get.to(AddUsedPassagerPage(
                      type: 2, item: _passengerList[index]));
                  if (back == 'SUCCESS') {
                    _refreshController.requestRefresh();
                  }
                },
                child: _ticketsItem(_passengerList[index]));
          }),
    );
  }

  _ticketsItem(PassagerModel item) {
    return Container(
      color: Colors.white,
      height: 52.rw,
      padding: EdgeInsets.symmetric(horizontal: 15.rw),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                ),
                Icon(AppIcons.icon_next, size: 13.rw, color: Color(0xFF999999)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addPassger() {
    return CustomImageButton(
      height: 48.rw,
      //padding: EdgeInsets.symmetric(vertical: 8),
      title: "添加旅客信息",
      backgroundColor: AppColor.themeColor,
      color: Colors.white,
      fontSize: 16 * 2.sp,
      borderRadius: BorderRadius.all(Radius.circular(4.rw)),
      onPressed: () async {
        String back = await Get.to(AddUsedPassagerPage(type: 1));
        if (back == 'SUCCESS') {
          _refreshController.requestRefresh();
        }
      },
    );
  }
}
