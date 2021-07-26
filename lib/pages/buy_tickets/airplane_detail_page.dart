import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

class AirplaneDetailPage extends StatefulWidget {
  AirplaneDetailPage({Key key}) : super(key: key);

  @override
  _AirplaneDetailPageState createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  List<Item> _passengerList = [];
  List<Item> _ChoosePassengerList = [];
  String _contactNum = '';

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
    _passengerList
        .add(Item(item: '吕小树', choice: false, num: '12345678901234567890'));
    _passengerList
        .add(Item(item: '吕小树', choice: false, num: '12345678901234567890'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        elevation: 0,
        title: '上海-北京',
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD5101A),
            Color(0x03FE2E39),
          ],
          stops: [0.0, 0.5],
        )),
        child: _bodyWidget(),
      ),
      bottomNavigationBar: SafeArea(child: _bottomTool(true)),
    );
  }

  _bodyWidget() {
    return Container(
      child: Column(
        children: [
          _information(),
          _choosePassenger(),
        ],
      ),
    );
  }

  _bottomTool(bool bottom) {
    return Container(
      height: 50.rw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              30.wb,
              Text(
                "订单金额",
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
              Container(
                padding: EdgeInsets.only(top: 3.rw),
                child: Text(
                  "￥",
                  style: TextStyle(fontSize: 10.rsp, color: Color(0xFFD5101A)),
                ),
              ),
              Text(
                "0",
                style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A)),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  bottom ? Get.bottomSheet(_bottomSheet()) : Get.back();
                },
                child: Row(
                  children: [
                    Text(
                      "明细",
                      style:
                          TextStyle(fontSize: 14.rsp, color: Color(0xFF999999)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.rw),
                      child: !bottom
                          ? Icon(CupertinoIcons.chevron_down,
                              size: 16.rw, color: Color(0xFF999999))
                          : Icon(CupertinoIcons.chevron_up,
                              size: 16.rw, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              20.wb,
              CustomImageButton(
                height: 34.rw,
                width: 99.rw,
                title: "提交订单",
                boxDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFF37211),
                      Color(0xFFF84A06),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(22.rw)),
                ),
                backgroundColor: Color(0xFFC92219),
                color: Colors.white,
                fontSize: 14.rsp,
                onPressed: () {
                  //Get.to(AirplaneDetailPage());
                },
              ),
              30.wb
            ],
          )
        ],
      ),
    );
  }

  _bottomSheet() {
    return Container(
      height: 205.rw,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.rw), topRight: Radius.circular(22.rw)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.rw, vertical: 20.rw),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "明细",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "¥400 * 3张",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
                39.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "基建",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "¥50",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
                39.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "燃油",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                    Text(
                      "¥0",
                      style:
                          TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _bottomTool(false)
        ],
      ),
    );
  }

  _contract() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
        color: Colors.white,
      ),
      height: 42.rw,
      child: Row(
        children: [
          20.wb,
          Container(
            child: CustomCacheImage(
              borderRadius: BorderRadius.circular(5),
              width: 10.rw,
              height: 10.rw,
              imageUrl: R.ASSETS_ORDER_ALERT_PNG,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "联系电话",
            style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
          ),
          20.wb,
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10.rw, left: 20.rw),
              hintText: '用于接受取票信息',
              border: InputBorder.none,
              hintStyle:
                  AppTextStyle.generate(14 * 2.sp, color: Color(0xff666666)),
            ),
            style: AppTextStyle.generate(14 * 2.sp),
            maxLength: 15,
            maxLines: 1,
            onChanged: (text) {
              _contactNum = text;
            },
          ).expand(),
        ],
      ),
    );
  }

  _information() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw, left: 10.rw, right: 10.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
        color: Colors.white,
      ),
      height: 177.rw,
      child: Column(
        children: [
          20.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "06月23日 后天",
                  style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                ),
              )
            ],
          ),
          20.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "21.00",
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    "浦东T1",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
              40.wb,
              Container(
                //height: 53.rw,
                margin: EdgeInsets.only(bottom: 25.rw),
                child: Column(
                  children: [
                    Text(
                      "2h25m",
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                    ),
                    10.hb,
                    Container(
                      width: 68.rw,
                      height: 7.rw,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              40.wb,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "23.00",
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    "大兴西北",
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
            ],
          ),
          10.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CustomCacheImage(
                  borderRadius: BorderRadius.circular(5),
                  width: 10.rw,
                  height: 10.rw,
                  imageUrl: R.ASSETS_ORDER_ALERT_PNG,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                "东方航空CA8685",
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
              ),
              20.wb,
              Text(
                "波音747-aaaa (中)",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF666666)),
              ),
            ],
          ),
          30.hb,
          Divider(
            color: Color(0x80DEE4E7),
            height: 1.rw,
            thickness: rSize(0.5),
            indent: 15.rw,
            endIndent: 15.rw,
          ),
          30.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "成人¥700,",
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              Text(
                "机建+燃油 ¥700",
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              20.wb,
              Container(
                child: CustomCacheImage(
                  borderRadius: BorderRadius.circular(5),
                  width: 10.rw,
                  height: 10.rw,
                  imageUrl: R.ASSETS_ORDER_ALERT_PNG,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _choosePassenger() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      padding: EdgeInsets.symmetric(horizontal: 10.rw),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.rw),
            height: 148.rw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.rw)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _choosePassenger1(),
              ],
            ),
          ),
          _contract(),
        ],
      ),
    ).expand();
  }

  Widget _getItemContainer(
      Item item, index, VoidCallback onPressed, bool selected) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: 68.rw,
          height: 38.rw,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(3.rw)),
              border: Border.all(
                  color: selected ? Color(0xFFD5101A) : Color(0xFF999999),
                  width: 0.5.rw)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.item,
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF666666)),
              ),
              selected
                  ? Container(
                      alignment: Alignment.bottomRight,
                      width: 68.rw,
                      child: Container(
                        alignment: Alignment.center,
                        width: 14.rw,
                        height: 10.rw,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5101A),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.rw),
                              bottomRight: Radius.circular(3.rw)),
                        ),
                        child: Icon(CupertinoIcons.check_mark,
                            size: 20, color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }

  _getPassengerItem(Item item, index, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.only(top: 10.rw),
      child: Row(
        children: [
          Container(
            width: 80.rw,
            child: Text(
              item.item,
              style: TextStyle(
                  fontSize: 16.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
          ),
          20.wb,
          Container(
            width: 200.rw,
            child: Text(
              _getCardId(item.num),
              style: TextStyle(fontSize: 16.rsp, color: Color(0xFF666666)),
            ),
          ),
          30.wb,
          Icon(CupertinoIcons.check_mark, size: 20, color: Colors.blue),
        ],
      ),
    );
  }

  _choosePassenger1() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 10.rw),
            alignment: Alignment.centerLeft,
            child: Text(
              "选择乘客",
              style: TextStyle(
                  fontSize: 16.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(child: 20.hb),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return _getItemContainer(_passengerList[index], index, () {
                setState(() {
                  _passengerList[index].choice = !_passengerList[index].choice;
                  for (var i = 0; i < _passengerList.length; i++) {
                    if (_passengerList[i].choice) {
                      _ChoosePassengerList.add(_passengerList[i]);
                    }
                  }
                });
              }, _passengerList[index].choice);
            }, childCount: _passengerList.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.rw,
              mainAxisSpacing: 10.rw,
              childAspectRatio: 1.789,
            )),
        SliverToBoxAdapter(child: 20.hb),
        SliverList(
          delegate: SliverChildBuilderDelegate((content, index) {
            return _getPassengerItem(_passengerList[index], index, () {
              setState(() {
                _passengerList[index].choice = !_passengerList[index].choice;
                for (var i = 0; i < _passengerList.length; i++) {
                  if (_passengerList[i].choice) {
                    _ChoosePassengerList.add(_passengerList[i]);
                  }
                }
              });
            });
          }, childCount: 3),
        ),
        SliverToBoxAdapter(child: 20.hb),
      ],
    ).expand();
  }

  _getCardId(String id) {
    String hear = id.substring(0, 4);
    String foot = id.substring(id.length - 3);
    String newId = '';
    if (id.length > 7) {
      for (var i = 0; i < id.length - 7; i++) {
        newId += '*';
      }
    }
    return hear + newId + foot;
  }
}

class Item {
  String item;
  bool choice;
  String num;
  Item({
    this.item,
    this.choice,
    this.num,
  });
}
