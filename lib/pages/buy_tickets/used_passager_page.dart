import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'airplane_reserve_page.dart';

class UsedPassagerPage extends StatefulWidget {
  UsedPassagerPage({Key key}) : super(key: key);

  @override
  _UsedPassagerPageState createState() => _UsedPassagerPageState();
}

class _UsedPassagerPageState extends State<UsedPassagerPage> {
  List<Item> _passengerList = [];

  @override
  void initState() {
    super.initState();
    _passengerList
        .add(Item(item: '张伟', choice: false, num: '12345678901234567890'));
    _passengerList
        .add(Item(item: '欧阳青青', choice: false, num: '12345678901234567'));
    _passengerList
        .add(Item(item: '小星星', choice: false, num: '12345678901234567890'));
    _passengerList
        .add(Item(item: '吕小树', choice: false, num: '12345678901234567890'));
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
      body: _passengerList.length != 0
          ? _bulidBody()
          : NoDataView(
              title: '抱歉，您还没有添加任何常用旅客信息',
            ),
    );
  }

  _bulidBody() {
    return ListView.separated(
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
              onPressed: () {
                Get.to(
                    AddUsedPassagerPage(type: 2, item: _passengerList[index]));
              },
              child: _ticketsItem(_passengerList[index]));
        });
  }

  _ticketsItem(Item item) {
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
                  item.item,
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
      onPressed: () {
        Get.to(AddUsedPassagerPage(
          type: 1,
        ));
      },
    );
  }
}
