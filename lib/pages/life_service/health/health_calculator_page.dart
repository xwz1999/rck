import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/bfr_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'health_result_dx_page.dart';
import 'health_result_kll_page.dart';
import 'health_result_tz_page.dart';
import 'health_result_xx_page.dart';

class HealthCalculatorPage extends StatefulWidget {
  HealthCalculatorPage({
    Key? key,
  }) : super(key: key);

  @override
  _HealthCalculatorPageState createState() => _HealthCalculatorPageState();
}

class _HealthCalculatorPageState extends State<HealthCalculatorPage>
    with TickerProviderStateMixin {
  FocusNode _heightFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();
  FocusNode _waistFocusNode = FocusNode();

  ///0 基础代谢 1 每日热量 2体脂率 3子女血型预测
  int get type {
    if (typeTitle == '基础代谢(BMR)') {
      return 0;
    } else if (typeTitle == '每日热量/卡路里消耗') {
      return 1;
    } else if (typeTitle == '体脂率(BFR)') {
      return 2;
    } else {
      return 3;
    }
  }

  List ageList = [];

  String typeTitle = '基础代谢(BMR)';

  /// 1男 2女
  int? get sex {
    if (sexString == '男') {
      return 1;
    } else if (sexString == '女') {
      return 2;
    } else {
      return null;
    }
  }

  String sexString = '请选择';

  num height = 0;
  num weight = 0;
  num waistline = 0;

  int? age;
  String ageString = '请选择';

  ///1-5
  int? get level {
    if (leverString == '等级五') {
      return 5;
    } else if (leverString == '等级二') {
      return 2;
    } else if (leverString == '等级三') {
      return 3;
    } else if (leverString == '等级四') {
      return 4;
    } else if (leverString == '等级一') {
      return 1;
    } else {
      return null;
    }
  }

  String leverString = '请选择';

  ///父亲血型
  String pType = '请选择';

  ///母亲血型
  String mType = '请选择';

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < 121; i++) {
      ageList.add(i.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _heightFocusNode.dispose();
    _weightFocusNode.dispose();
    _waistFocusNode.dispose();
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
        title: Text('基础健康指数计算器',
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
            '计算类型',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              typeTitle = (await ListPickBody.listPicker(
                      ['基础代谢(BMR)', '每日热量/卡路里消耗', '体脂率(BFR)', '子女血型预测'],
                      '计算类型')) ??
                  (typeTitle != '请选择' ? typeTitle : '基础代谢(BMR)');
              setState(() {});
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
                    typeTitle,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: typeTitle=='请选择'?Color(0xFFD8D8D8): Color(0xFF333333),
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
          type == 3 ? SizedBox() : 64.hb,
          type == 3
              ? SizedBox()
              : Text(
                  '性别',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold),
                ),
          type == 3 ? SizedBox() : 24.hb,
          type == 3
              ? SizedBox()
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    sexString =
                        (await ListPickBody.listPicker(['男', '女'], '性别')) ??
                            '请选择';
                    setState(() {});
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
                          sexString,
                          style: TextStyle(
                              fontSize: 14.rsp,
                              color: sexString=='请选择'?Color(0xFFD8D8D8): Color(0xFF333333),
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
          type == 3 || type == 2 ? SizedBox() : 64.hb,
          type == 3 || type == 2
              ? SizedBox()
              : RichText(
                  text: TextSpan(
                      text: '身高(CM)',
                      style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' 请输入整数，如：168,不可大于300',
                            style: TextStyle(
                                fontSize: 12.rsp,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.normal))
                      ]),
                ),
          type == 3 || type == 2 ? SizedBox() : 24.hb,
          type == 3 || type == 2
              ? SizedBox()
              : Container(
                  height: 50.rw,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: (_submitted) async {
                      _heightFocusNode.unfocus();
                    },
                    focusNode: _heightFocusNode,
                    onChanged: (text) {
                      if (text.isNotEmpty)
                        height = num.parse(text);
                      else
                        height = 0;
                    },
                    style: TextStyle(
                        color: Colors.black,
                        textBaseline: TextBaseline.ideographic),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 25.rw),
                      filled: true,
                      fillColor: Color(0xFFF9F9F9),
                      hintText: '请输入身高',
                      hintStyle: TextStyle(
                          color: Color(0xFFD8D8D8),
                          fontSize: 14.rsp,
                          fontWeight: FontWeight.bold),
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
          type == 3 ? SizedBox() : 64.hb,
          type == 3
              ? SizedBox()
              : RichText(
                  text: TextSpan(
                      text: '体重(KG)',
                      style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: '支持最多1位小数，如67.8',
                            style: TextStyle(
                                fontSize: 12.rsp,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.normal))
                      ]),
                ),
          type == 3 ? SizedBox() : 24.hb,
          type == 3
              ? SizedBox()
              : Container(
                  height: 50.rw,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: (_submitted) async {
                      _weightFocusNode.unfocus();
                    },
                    focusNode: _weightFocusNode,
                    onChanged: (text) {
                      if (text.isNotEmpty)
                        weight = num.parse(text);
                      else
                        weight = 0;
                    },
                    style: TextStyle(
                        color: Colors.black,
                        textBaseline: TextBaseline.ideographic),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 25.rw),
                      filled: true,
                      fillColor: Color(0xFFF9F9F9),
                      hintText: '请输入体重',
                      hintStyle: TextStyle(
                          color: Color(0xFFD8D8D8),
                          fontSize: 14.rsp,
                          fontWeight: FontWeight.bold),
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
          type == 2 || type == 3 ? SizedBox() : 64.hb,
          type == 2 || type == 3
              ? SizedBox()
              : Text(
                  '年龄',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold),
                ),
          type == 2 || type == 3 ? SizedBox() : 24.hb,
          type == 2 || type == 3
              ? SizedBox()
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    ageString =
                        (await ListPickBody.listPicker(ageList, '选择年龄')) ??
                            '请选择';
                    age = int.parse(ageString);
                    setState(() {});
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
                          ageString,
                          style: TextStyle(
                              fontSize: 14.rsp,
                              color:ageString=='请选择'?Color(0xFFD8D8D8): Color(0xFF333333),
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
          type == 3 || type == 2 || type == 0 ? SizedBox() : 64.hb,
          type == 3 || type == 2 || type == 0
              ? SizedBox()
              : Text(
                  '运动量等级',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold),
                ),
          type == 3 || type == 2 || type == 0 ? SizedBox() : 24.hb,
          type == 3 || type == 2 || type == 0
              ? SizedBox()
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    ActionSheet.show(context, items: [
                      "等级一",
                      "等级二",
                      '等级三',
                      '等级四',
                      '等级五'
                    ], subTitles: [
                      '无运动习惯者/久坐族',
                      '轻度运动者/每周1至3天运动',
                      '中度运动者/每周3至5天运动',
                      '激烈运动者/每周6至7天运动',
                      '超激烈运动者/体力活工作/每天训练2次'
                    ], listener: (int index) {
                      if (index == 0) {
                        leverString = '等级一';
                      } else if (index == 1) {
                        leverString = '等级二';
                      } else if (index == 2) {
                        leverString = '等级三';
                      } else if (index == 3) {
                        leverString = '等级四';
                      } else if (index == 4) {
                        leverString = '等级五';
                      }
                      setState(() {});
                      Get.back();
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
                          leverString,
                          style: TextStyle(
                              fontSize: 14.rsp,
                              color: Color(0xFF333333),
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
          type == 0 || type == 3 || type == 1 ? SizedBox() : 64.hb,
          type == 0 || type == 3 || type == 1
              ? SizedBox()
              : RichText(
                  text: TextSpan(
                      text: '腰围(CM)',
                      style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' 支持最多1位小数，如30.3',
                            style: TextStyle(
                                fontSize: 12.rsp,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.normal))
                      ]),
                ),
          type == 0 || type == 3 || type == 1 ? SizedBox() : 24.hb,
          type == 0 || type == 3 || type == 1
              ? SizedBox()
              : Container(
                  height: 50.rw,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: (_submitted) async {
                      _waistFocusNode.unfocus();
                    },
                    focusNode: _waistFocusNode,
                    onChanged: (text) {
                      if (text.isNotEmpty)
                        waistline = num.parse(text);
                      else
                        waistline = 0;
                    },
                    style: TextStyle(
                        color: Colors.black,
                        textBaseline: TextBaseline.ideographic),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 25.rw),
                      filled: true,
                      fillColor: Color(0xFFF9F9F9),
                      hintText: '请输入腰围',
                      hintStyle: TextStyle(
                          color: Color(0xFFD8D8D8),
                          fontSize: 14.rsp,
                          fontWeight: FontWeight.bold),
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
          type == 1 || type == 2 || type == 0 ? SizedBox() : 64.hb,
          type == 1 || type == 2 || type == 0
              ? SizedBox()
              : Text(
                  '父亲血型',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold),
                ),
          type == 1 || type == 2 || type == 0 ? SizedBox() : 24.hb,
          type == 1 || type == 2 || type == 0
              ? SizedBox()
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    pType = (await ListPickBody.listPicker(
                            ['A', 'B', 'O', 'AB'], '父亲血型')) ??
                        '请选择';
                    setState(() {});
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
                          pType,
                          style: TextStyle(
                              fontSize: 14.rsp,
                              color: pType=='请选择'?Color(0xFFD8D8D8): Color(0xFF333333),
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
          type == 1 || type == 2 || type == 0 ? SizedBox() : 64.hb,
          type == 1 || type == 2 || type == 0
              ? SizedBox()
              : Text(
                  '母亲血型',
                  style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold),
                ),
          type == 1 || type == 2 || type == 0 ? SizedBox() : 24.hb,
          type == 1 || type == 2 || type == 0
              ? SizedBox()
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    mType = (await ListPickBody.listPicker(
                            ['A', 'B', 'O', 'AB'], '母亲血型')) ??
                        '请选择';
                    setState(() {});
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
                          mType,
                          style: TextStyle(
                              fontSize: 14.rsp,
                              color:  mType=='请选择'?Color(0xFFD8D8D8): Color(0xFF333333),
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
            onPressed: () async {
              FocusManager.instance.primaryFocus!.unfocus();
              if (type == 0) {
                if (sex != null &&
                    age != null &&
                    height > 100 &&
                    height < 250 &&
                    weight > 20 &&
                    weight < 300) {
                  String result =
                      (await LifeFunc.getBMR(sex!, age!, height, weight)) ?? '';

                  if (result.isNotEmpty)
                    Get.to(HealthResultDXPage(
                      result: result,
                      weight: weight,
                      height: height,
                      sex: sex!,
                      age: age!,
                    ));
                } else {
                  BotToast.showText(text: '请输入正确的数据');
                }
              } else if (type == 1) {
                if (sex != null &&
                    age != null &&
                    height > 100 &&
                    height < 250 &&
                    weight > 20 &&
                    weight < 300 &&
                    level != null) {
                  String result = (await LifeFunc.getKLL(
                          sex!, age!, height, weight, level!)) ??
                      '';

                  if (result.isNotEmpty)
                    Get.to(HealthResultKLLPage(
                      result: result,
                      weight: weight,
                      height: height,
                      sex: sex!,
                      age: age!,
                      level: level!,
                    ));
                } else {
                  BotToast.showText(text: '请输入正确的数据');
                }
              } else if (type == 2) {
                if (sex != null &&
                    waistline > 0 &&
                    waistline < 100 &&
                    weight > 20 &&
                    weight < 300 &&
                    level != null) {
                  BFRModel? result =
                      (await LifeFunc.getBFR(sex!, waistline, weight)) ?? null;

                  if (result != null)
                    Get.to(HealthResultTZPage(
                      weight: weight,
                      sex: sex!,
                      remark: result.remark ?? '',
                      bfr: '${result.bfr}%',
                      waistline: waistline,
                    ));
                } else {
                  BotToast.showText(text: '请输入正确的数据');
                }
              } else if (type == 3) {
                if (pType!='请选择'&& mType!='请选择') {
                  String result = (await LifeFunc.getBlood(pType, mType)) ?? '';

                  if (result.isNotEmpty)
                    Get.to(HealthResultXXPage(
                      mType: mType,
                      remark: result,
                      pType: pType,
                    ));
                }
              } else {
                BotToast.showText(text: '请输入正确的数据');
              }
            },
          )
        ],
      ),
    );
  }
}
