import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'loan_result_page.dart';

class LoanPage extends StatefulWidget {
  LoanPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage>
    with TickerProviderStateMixin {
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();

  String money = '';
  String year = '请选择';
  String active = '';
  String type = '请选择';

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
        title: Text('贷款公积金查询',
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
                text: '贷款总额(万)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  如50表示50万，最多不可超过500万',
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
              keyboardType: TextInputType.number,
              onSubmitted: (_submitted) async {
                _weightFocusNode.unfocus();
              },
              focusNode: _weightFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) money = text;
                else
                  money = '';
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
            '贷款年限(年)',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              FocusManager.instance.primaryFocus!.unfocus();
              year =  (await ListPickBody.listPicker([
                '5','10','15','20','25','30'
              ], '贷款年限'))??'请选择';
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
                    year,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color:year=='请选择'?Color(0xFFD8D8D8):  Color(0xFF333333),
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
            onTap: ()async {
              FocusManager.instance.primaryFocus!.unfocus();
              type =  (await ListPickBody.listPicker([
              '等额本息','等额本金'
              ], '还款方式'))??'请选择';
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
                        color: type=='请选择'?Color(0xFFD8D8D8):  Color(0xFF333333),
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
                text: '贷款利率(%)',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),),
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
                if (text.isNotEmpty) active = text;
                else
                  active = '';
              },

              style: TextStyle(
                  color: Colors.black, textBaseline: TextBaseline.ideographic),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.rw),
                filled: true,
                fillColor: Color(0xFFF9F9F9),
                hintText: '请输入利率',
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
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: () async{
              FocusManager.instance.primaryFocus!.unfocus();
              if ((active.isNotEmpty && money.isNotEmpty&& double.parse(active)< 20 &&  double.parse(money)<500) &&
                  (type!='请选择'&& year!='请选择')) {
                LoanModel? loanModel = (await LifeFunc.getLoanModel(num.parse(money), year, active))??null;
                if(loanModel!=null)
                Get.to(() => LoanResultPage(loanModel: loanModel, year: year, type: type,));

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
