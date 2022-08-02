import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/birth_flower_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
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
  BirthFlowerModel? birthFlowerModel;

  @override
  void initState() {
    super.initState();
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
            onPressed: ()async {
              _show = false;
              if (content.isNotEmpty) {
                birthFlowerModel = await LifeFunc.getBirthFlower(content);
                if(birthFlowerModel!=null)
                _show = true;

                if (mounted) setState(() {});
              } else {
                BotToast.showText(text: '请先选择生日');
              }
            },
          ),
          100.hb,
          !_show
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
                                    birthFlowerModel!.name ?? '',
                                    '${birthFlowerModel!.nameDes!.split('<\/p>')[0].split('<p>')[1]}',
                                    '生日花含义',
                                    '${birthFlowerModel!.nameDes!.split('<\/p>')[1].split('<p>')[1]}',
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
                                      Text(birthFlowerModel!.name ?? '',
                                          style: TextStyle(
                                            color: Color(0xFFDB2D2D),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.rsp,
                                          )),
                                    ],
                                  ),
                                  10.hb,
                                  Text(
                                      '${birthFlowerModel!.nameDes!.split('<\/p>')[0].split('<p>')[1]}',
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
                                        child:  Image.asset(Assets.life.icSanjiaoHui.path,width: 20.rw,height: 20.rw,),
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
                                          birthFlowerModel!.lang ?? '',
                                          '花语',
                                          '花语含义',
                                          '${birthFlowerModel!.langDes!.split('<\/p>')[0].split('<p>')[1]}',
                                        ));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(20.rw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(birthFlowerModel!.lang ?? '',
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
                                              padding: EdgeInsets.only(top: 3.rw),
                                              child:  Image.asset(Assets.life.icSanjiaoHui.path,width: 20.rw,height: 20.rw,),
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
                                          birthFlowerModel!.stone ?? '',
                                          '诞生石',
                                          '诞生石含义',
                                          '${birthFlowerModel!.stoneDes!.split('<\/p>')[0].split('<p>')[1]}',
                                          text5: '诞生石传说',
                                          text6:
                                              '${birthFlowerModel!.legend!.split('<\/p>')[0].split('<p>')[1]}',
                                        ));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.all(20.rw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(birthFlowerModel!.stone ?? '',
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
                                              padding: EdgeInsets.only(top: 3.rw),
                                              child:  Image.asset(Assets.life.icSanjiaoHui.path,width: 20.rw,height: 20.rw,),
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
