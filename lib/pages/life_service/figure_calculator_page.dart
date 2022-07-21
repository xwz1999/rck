import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/FigureModel.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/pages/life_service/hw_calculator_result_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'loan_result_page.dart';

class FigureCalculatorPage extends StatefulWidget {
  FigureCalculatorPage({
    Key? key,
  }) : super(key: key);

  @override
  _FigureCalculatorPageState createState() => _FigureCalculatorPageState();
}

class _FigureCalculatorPageState extends State<FigureCalculatorPage>
    with TickerProviderStateMixin {
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();
  late FigureModel figureModel;

  String _height = '0';
  String type = '厘米(CM)';
  bool get isCM => type =='厘米(CM)';
  bool _show = false;

  @override
  void initState() {
    super.initState();
    figureModel = FigureModel(
      stw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      xw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      xtw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      xyw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      syw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      dtw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
      tw: Stw(
          cm: "23.7 厘米",
          yc: "9.33 英寸"
      ),
    );
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
        title: Text('女性最佳身材计算器',
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
          RichText(
            text: TextSpan(
                text: '身高(cm)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  请输入整数，如：168，不可大于300',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.normal
                      ))
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _weightFocusNode.unfocus();
              },
              focusNode: _weightFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) _height = text;
                else
                  _height = '0';
              },
              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.rw),
                filled: true,
                fillColor: Color(0xFFF9F9F9),
                hintText: '请输入',
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
          Text(
            '计算单位',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              type =  (await ListPickBody.listPicker([
                '厘米(CM)','英寸(IN)'
              ], '计算单位'))??'';
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

          100.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: () {
              if ((double.parse(_height)< 300&&double.parse(_height)> 0 ) &&
                  (type!='')) {
                _show = true;
                setState(() {

                });
              } else {
                BotToast.showText(text: '请输入正确的数据');
              }
            },
          ),
          100.hb,
          Row(
            children: [
              Text('查询结果',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12.rsp,
                  )),
            ],
          ),
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
                                Text('最佳上臂围',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.stw!.cm!.split('厘米')[0]:figureModel.stw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('最佳臀围',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.tw!.cm!.split('厘米')[0]:figureModel.tw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
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
                                Text('最佳胸围',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.xw!.cm!.split('厘米')[0]:figureModel.xw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('腰围上限',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.syw!.cm!.split('厘米')[0]:figureModel.syw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('腰围下限',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.xyw!.cm!.split('厘米')[0]:figureModel.xyw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
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
                                Text('最佳大腿围',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.dtw!.cm!.split('厘米')[0]:figureModel.dtw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('最佳小腿围',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Row(
                                  children: [
                                    Text((isCM? figureModel.xtw!.cm!.split('厘米')[0]:figureModel.xtw!.yc!.split('英寸')[0]),
                                        style: TextStyle(
                                          color: Color(0xFFDB2D2D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.rsp,
                                        )),
                                    Text((isCM? 'CM':'IN'),
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.rsp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ):SizedBox()
        ],
      ),
    );
  }
}
