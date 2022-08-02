import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/pages/life_service/hw_calculator_result_page.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

class HWCalculatorPage extends StatefulWidget {
  HWCalculatorPage({
    Key? key,
  }) : super(key: key);

  @override
  _HWCalculatorPageState createState() => _HWCalculatorPageState();
}

class _HWCalculatorPageState extends State<HWCalculatorPage>
    with TickerProviderStateMixin {
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();

  String sex = '男';///性别
  int sexId = 1; ///默认为男 1
  String type = '中国';///国家
  int typeId = 1; ///默认为中国 1
  double height = 0;///身高
  double weight = 0;///体重

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _contentFocusNode.dispose();
    _weightFocusNode.dispose();
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
        title: Text('标准身高体重计算器',
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
          Text(
            '性别',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () {
              ActionSheet.show(context, items: ["男", "女"],
                  listener: (int index) {
                if (index == 0) {
                  sex = '男';
                  sexId = 1;
                } else if (index == 1) {
                  sex = '女';
                  sexId = 2;
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
                    sex,
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
          64.hb,
          Text(
            '计算标准',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () {
              ActionSheet.show(context, items: ["中国", "亚洲", '国际'],
                  listener: (int index) {
                if (index == 0) {
                  type = '中国';
                  typeId = 1;
                } else if (index == 1) {
                  type = '亚洲';
                  typeId = 2;
                } else if (index == 2) {
                  type = '国际';
                  typeId = 3;
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
                    type,
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
          64.hb,
          RichText(
            text: TextSpan(
                text: '身高(CM)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  支持最多1位小数，如178.2',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF999999),
                      ))
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _contentFocusNode.unfocus();
              },
              focusNode: _contentFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) height = double.parse(text);
                else
                  height = 0;
              },

              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
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
          64.hb,
          RichText(
            text: TextSpan(
                text: '体重(KG)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  支持最多1位小数，如67.8',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF999999),
                      ))
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _weightFocusNode.unfocus();
              },
              focusNode: _weightFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) weight = double.parse(text);
                else
                  weight = 0;
              },
              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
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
          100.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始计算",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: ()async{
              FocusManager.instance.primaryFocus!.unfocus();
              print(height);
              print(weight);
              if ((height > 100 && height < 300) &&
                  (weight > 20 && weight < 250)) {

                HwCalculatorModel? hwCalculatorModel  = await LifeFunc.getHwCalculatorModel(sexId,typeId,height,weight)??null;

                if(hwCalculatorModel!=null){
                  Get.to(() => HWCalculatorResultPage(
                    hwCalculatorModel: hwCalculatorModel,
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
