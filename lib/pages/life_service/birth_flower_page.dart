import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/birth_flower_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

///生日花语
class BirthFlowerPage extends StatefulWidget {
  BirthFlowerPage({
    Key? key,
  }) : super(key: key);

  @override
  _BirthFlowerPageState createState() => _BirthFlowerPageState();
}

class _BirthFlowerPageState extends State<BirthFlowerPage>
    with TickerProviderStateMixin {
  String content = '';

  ///输入的内容
  bool _show = false;

  ///显示查询结果
  DateTime currentTime = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  late BirthFlowerModel birthFlowerModel;

  @override
  void initState() {
    super.initState();
    birthFlowerModel = BirthFlowerModel(
        title: '8月15日生日花语',
        birthday: '08-15',
        name: '黄药子',
        nameDes:
            '<p>庆祝圣母玛利亚升天国之花<\/p><p>自古以来，基督教里就有将圣人与特定花朵连结在一起的习惯，这因循于教会在纪念圣人时，常以盛开的花朵点缀祭坛所致！而在中世纪的天主教修道院内，更是有如园艺中心般的种植着各式各样的花朵，久而久之，教会便将366天的圣人分别和不同的花朵合在一起，形成所谓的花历。当时大部分的修道院都位在南欧地区，而南欧属地中海型气候，极适合栽种花草。黄药子是一种毛莨科圆椎铁线莲属植物，被选来祭祀圣母玛利亚升上天国。这种多年生的爬蔓性植物，原产地在欧洲南部及中东附近。目前英国南部也可以发现黄药子，爱尔兰也有种植。<\/p>',
        lang: '乡愁',
        langDes:
            '<p>黄药子的别名是“旅行者的喜悦”。这种爬蔓植物生长在乡下路旁的篱笆附近，看起来就像灰色的绵线垂挂在道路两旁。旅行者看到这种光景，会想起家乡老母织布的情景。因此它的花语是“乡愁”。凡是受到这种花祝福而生的人，总是把自己的一生视为一段旅程。对于任何事情都不会执着己见。感情方面也看得很淡，禁得起失恋的打击。<\/p>',
        stone: '玛瑙',
        stoneDes:
            '<p>据说，由于玛瑙的原石外形和马脑相似，因此称它为“玛瑙”。不论在旧约圣经或佛教的经典，都有玛瑙的事迹记载。<\/p><p>在东方，它是七宝、七珍之一。玛瑙可分为玉髓和玛瑙。原石颜色不复杂的称为“玉髓”，出现直线平行条纹的原石则称为“条纹玛瑙”(截子玛瑙)。根据原石的颜色，又有缠丝玛瑙、深红玛瑙等称呼。最近，一般都将染色的黑玛瑙统称为玛瑙。<\/p>',
        legend:
            '<p>传说爱和美的的女神阿佛洛狄，躺在树荫下熟睡时，她的儿子爱神厄洛斯，偷偷的把她闪闪发光的指甲剪下来，并欢天喜地拿着指甲飞上了天空。飞到空中的厄洛斯，一不小心把指甲弄掉了，而掉落到地上的指爪变成了石头，就是玛瑙。因此有人认为拥有玛瑙，可以强化爱情，调整自己与爱人之间的感情。在日、本的神话中，玉祖栉明玉命献给天照大神的，就是一块月牙形的绿玛瑙，这也是日、本三种神器之一！<\/p>');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('生日花语',
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
        children: [
          32.hb,
          RichText(
            text: TextSpan(
              text: '选择日期',
              style: TextStyle(
                  fontSize: 14.rsp,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.bold),
            ),
          ),
          24.hb,
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  theme: DatePickerTheme(
                      cancelStyle:
                          AppTextStyle.generate(15 * 2.sp, color: Colors.grey),
                      doneStyle: AppTextStyle.generate(15 * 2.sp,
                          color: AppColor.themeColor),
                      itemStyle: AppTextStyle.generate(15 * 2.sp)),
                  minTime: DateTime(1970, 01, 01),
                  maxTime: DateTime.now(),
                  currentTime: currentTime,
                  locale: LocaleType.zh, onConfirm: (DateTime date) {
                currentTime = date;
                content = date.toString().substring(0, 10);
                print(date.toString().substring(0, 10));
                _textEditingController.text = content;
                setState(() {});
              });
            },
            child: Container(
              height: 50.rw,
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                enabled: false,
                controller: _textEditingController,
                style: TextStyle(
                    color: Colors.black,
                    textBaseline: TextBaseline.ideographic),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25.rw),
                  filled: true,
                  fillColor: Color(0xFFF9F9F9),
                  hintText: '请选择',
                  hintStyle: TextStyle(
                      color: Color(0xFFD8D8D8),
                      fontSize: 14.rsp,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.rw)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
          48.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: () {
              if (content.isNotEmpty) {
                _show = true;
                setState(() {});
              } else {
                BotToast.showText(text: '请先选择生日');
              }
            },
          ),
          100.hb,
          _show
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('查询结果',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.rsp,
                        )),
                    32.hb,
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.rw),
                          border: Border.all(
                              color: Color(0xFFE8E8E8), width: 0.5.rw)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              show(
                                  context,
                                  _dialog(
                                    birthFlowerModel.name ?? '',
                                    '${birthFlowerModel.nameDes!.split('<\/p>')[0].split('<p>')[1]}',
                                    '生日花含义',
                                    '${birthFlowerModel.nameDes!.split('<\/p>')[1].split('<p>')[1]}',
                                  ));
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(20.rw),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(birthFlowerModel.name ?? '',
                                          style: TextStyle(
                                            color: Color(0xFFDB2D2D),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.rsp,
                                          )),
                                    ],
                                  ),
                                  10.hb,
                                  Text(
                                      '${birthFlowerModel.nameDes!.split('<\/p>')[0].split('<p>')[1]}',
                                      style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 12.rsp,
                                      )),
                                  20.hb,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('生日花含义',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.rsp,
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.rw),
                                        child: Icon(
                                          Icons.arrow_right,
                                          color: Colors.black38,
                                          size: 24 * 2.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                                child: GestureDetector(
                                  onTap: () {
                                    show(
                                        context,
                                        _dialog(
                                          birthFlowerModel.lang ?? '',
                                          '花语',
                                          '花语含义',
                                          '${birthFlowerModel.langDes!.split('<\/p>')[0].split('<p>')[1]}',
                                        ));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(20.rw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(birthFlowerModel.lang ?? '',
                                            style: TextStyle(
                                              color: Color(0xFFDB2D2D),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.rsp,
                                            )),
                                        10.hb,
                                        Text('花语',
                                            style: TextStyle(
                                              color: Color(0xFF999999),
                                              fontSize: 12.rsp,
                                            )),
                                        20.hb,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('花语含义',
                                                style: TextStyle(
                                                  color: Color(0xFF999999),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.rsp,
                                                )),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.rw),
                                              child: Icon(
                                                Icons.arrow_right,
                                                color: Colors.black38,
                                                size: 24 * 2.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 0.5.rw,
                                height: 110.rw,
                                color: Color(0xFFE8E8E8),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    show(
                                        context,
                                        _dialog(
                                          birthFlowerModel.stone ?? '',
                                          '诞生石',
                                          '诞生石含义',
                                          '${birthFlowerModel.stoneDes!.split('<\/p>')[0].split('<p>')[1]}',
                                          text5: '诞生石传说',
                                          text6:
                                              '${birthFlowerModel.legend!.split('<\/p>')[0].split('<p>')[1]}',
                                        ));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(20.rw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(birthFlowerModel.stone ?? '',
                                            style: TextStyle(
                                              color: Color(0xFFDB2D2D),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.rsp,
                                            )),
                                        10.hb,
                                        Text('诞生石',
                                            style: TextStyle(
                                              color: Color(0xFF999999),
                                              fontSize: 12.rsp,
                                            )),
                                        20.hb,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('诞生石含义',
                                                style: TextStyle(
                                                  color: Color(0xFF999999),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.rsp,
                                                )),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.rw),
                                              child: Icon(
                                                Icons.arrow_right,
                                                color: Colors.black38,
                                                size: 24 * 2.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Future<bool?> show(BuildContext context, Widget widget) async {
    return await showDialog(
      context: context,
      builder: (context) => widget,
      barrierDismissible: false,
    );
  }

  _dialog(String text1, String text2, String text3, String text4,
      {String text5 = '', String text6 = ''}) {
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
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                    )),
              ),
              10.hb,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                child: Text(text4,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.rsp,
                    )),
              ),
              40.hb,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                child: text5 == ''
                    ? SizedBox()
                    : Text(text5,
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.rsp,
                        )),
              ),
              10.hb,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                child: text6 == ''
                    ? SizedBox()
                    : Text(text6,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14.rsp,
                        )),
              ),
              40.hb,
            ],
          ),
        ),
      ),
    );
  }
}
