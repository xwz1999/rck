import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'OilPriceModel.dart';

class OilPriceInquiryPage extends StatefulWidget {
  final List<OilPriceModel> oilList;
  OilPriceInquiryPage({
    Key? key, required this.oilList,
  }) : super(key: key);

  @override
  _OilPriceInquiryPageState createState() => _OilPriceInquiryPageState();
}

class _OilPriceInquiryPageState extends State<OilPriceInquiryPage>
    with TickerProviderStateMixin {

  String city = '请选择';
  bool _show = false;
  List<OilPriceModel> oilList = [];
  late OilPriceModel chooseOilPriceModel;

  @override
  void initState() {
    super.initState();
    oilList = widget.oilList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,

      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,

        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('国内油价查询',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rw),
      child: ListView(
        shrinkWrap: true,
        children: [
          64.hb,
          Text(
            '省份',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              city =  (await ListPickBody.listPicker([
                '北京','上海','天津','重庆','福建','甘肃','广东','广西','贵州','海南','河北','河南','湖北','湖南','吉林','江苏','江西','辽宁','内蒙古','安徽','宁夏',
                '青海','山东','陕西','陕西','四川','西藏','黑龙江','新疆','云南','浙江','深圳',
              ], '选择城市'))??'请选择';
              setState(() {
              });
            },
            child: Container(
              height: 50.rw,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.rw),
              decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(24.rw))),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Text(
                    city,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: city=='请选择'? Color(0xFFD8D8D8):Color(0xFF333333),
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black38,
                    size: 28 * 2.sp,
                  ),
                ],
              ),
            ),
          ),


          100.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: () {
              if (city!='请选择') {

                print(city);
                for(int i=0;i<oilList.length;i++){
                  if(oilList[i].city == city){
                    print('111111');
                    chooseOilPriceModel = oilList[i];
                    _show = true;
                    break;
                  }else{
                    _show = false;
                  }
                }

                setState(() {

                });
              } else {
                BotToast.showText(text: '请输入正确的数据');
              }
            },
          ),
          100.hb,
          _show?Row(
            children: [
              Text('查询结果',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12.rsp,
                  )),
            ],
          ):SizedBox(),
         _show? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(12.rw),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rw),
                    border:
                    Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('92号汽油',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text('¥'+(chooseOilPriceModel.s92h??''),
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('95号汽油',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text('¥'+(chooseOilPriceModel.s95h??''),
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('98号汽油',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text('¥'+(chooseOilPriceModel.s98h??''),
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('0号柴油',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text('¥'+(chooseOilPriceModel.s0h??''),
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ):SizedBox(),
          100.hb,
        ],
      ),
    );
  }


  _getIcon(String name) {
    switch (name) {
      case '白羊':
        return Assets.life.imgBaiyang.path;
      case '金牛':
        return Assets.life.imgJinniu.path;
      case '双子':
        return Assets.life.imgShuangzi.path;
      case '巨蟹':
        return Assets.life.imgJuxie.path;
      case '狮子':
        return Assets.life.imgShizi.path;
      case '处女':
        return Assets.life.imgChunv.path;
      case '天秤':
        return Assets.life.imgTiancheng.path;
      case '天蝎':
        return Assets.life.imgTianxie.path;
      case '射手':
        return Assets.life.imgSheshou.path;
      case '摩羯':
        return Assets.life.imgMoxie.path;
      case '水平':
        return Assets.life.imgShuiping.path;
      case '双鱼':
        return Assets.life.imgShuangyu.path;
    }
  }
  Future<bool?> show(BuildContext context, Widget widget) async {
    return await showDialog(
      context: context,
      builder: (context) => widget,
      barrierDismissible: false,
    );
  }

  _dialog(
      String text1,
      String text2,
      String text3,
      ) {
    return Center(
      child: Container(
        width: 327.rw,
        height: 490.rw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rw),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(horizontal: rSize(36)),
        child: Material(
          color: Colors.transparent,
          child: ListView(
            children: [
              Row(
                children: [
                  24.wb,
                  Text(text1,
                      style: TextStyle(
                        color: Color(0xFFDB2D2D),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.rsp,
                      )),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black38,
                        size: 20 * 2.sp,
                      ),
                      onPressed: () {
                        Get.back();
                      })
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                child: Text(text2,
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
              ),
              20.hb,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                child: Text(text3,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.rsp,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
