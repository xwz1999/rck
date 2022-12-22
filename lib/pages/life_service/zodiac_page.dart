import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/zodiac_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/car_date_picker.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'life_func.dart';

///生日花语
class ZodiacPage extends StatefulWidget {
  ZodiacPage({
    Key? key,
  }) : super(key: key);

  @override
  _ZodiacPageState createState() => _ZodiacPageState();
}

class _ZodiacPageState extends State<ZodiacPage>
    with TickerProviderStateMixin {
  String content = '';

  ///输入的内容
  bool _show = false;

  ///显示查询结果
  DateTime? currentTime = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  ZodiacModel? zodiacModel;

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
        title: Text('生肖查询',
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
            onTap: ()async {
              currentTime =   await CarDatePicker.yearPicker(DateTime.now());
              if(currentTime!=null){
                content = currentTime.toString().substring(0, 4);
                print(currentTime.toString().substring(0, 4));
                _textEditingController.text = content;
                setState(() {});
              }

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
            onPressed: () async{
              _show = false;
              if (content.isNotEmpty) {

                zodiacModel = await LifeFunc.getZodiacModel(content);
                if(zodiacModel!=null)
                  _show = true;
                setState(() {});
              } else {
                BotToast.showText(text: '请先选择生日');
              }
            },
          ),
          100.hb,
          !_show||zodiacModel==null
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  padding:EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(zodiacModel!.name??'',
                                          style: TextStyle(
                                            color: AppColor.themeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.rsp,
                                          )),
                                      25.hb,

                                      Image.asset(_getIcon(zodiacModel!.name??''),width: 24.rw,height: 24.rw,),

                                    ],
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('吉祥方位',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(zodiacModel!.fw??'',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.rsp,
                                          ),maxLines: 3,),

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  padding:EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('吉忌颜色',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                                              border: Border.all(color: AppColor.themeColor,width: 1.rw)
                                            ),
                                            width: 20.rw,
                                            height: 20.rw,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '吉',style: TextStyle(color: AppColor.themeColor,fontSize: 10.rsp),
                                            ),
                                          ),
                                          8.wb,
                                          Text('${(zodiacModel!.sc??'').split('；')[0].split('：')[1]}',
                                              style: TextStyle(
                                                color: AppColor.themeColor,
                                                fontSize: 12.rsp,
                                                fontWeight: FontWeight.bold
                                              )),
                                        ],
                                      ),
                                      16.hb,
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                                                border: Border.all(color: Color(0xFF333333),width: 1.rw)
                                            ),
                                            width: 20.rw,
                                            height: 20.rw,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '忌',style: TextStyle(color:  Color(0xFF333333),fontSize: 10.rsp),
                                            ),
                                          ),
                                          8.wb,
                                          Text('${(zodiacModel!.sc??'').split('；')[1].split('：')[1]}',
                                              style: TextStyle(
                                                  color:  Color(0xFF333333),
                                                  fontSize: 12.rsp,
                                                  fontWeight: FontWeight.bold
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  padding:EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('吉忌数字',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                                                border: Border.all(color: AppColor.themeColor,width: 1.rw)
                                            ),
                                            width: 20.rw,
                                            height: 20.rw,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '吉',style: TextStyle(color: AppColor.themeColor,fontSize: 10.rsp),
                                            ),
                                          ),
                                          8.wb,
                                          Text('${(zodiacModel!.sz??'').split('；')[0].split('：')[1]}',
                                              style: TextStyle(
                                                  color: AppColor.themeColor,
                                                  fontSize: 12.rsp,
                                                  fontWeight: FontWeight.bold
                                              )),
                                        ],
                                      ),
                                      16.hb,
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                                                border: Border.all(color: Color(0xFF333333),width: 1.rw)
                                            ),
                                            width: 20.rw,
                                            height: 20.rw,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '凶',style: TextStyle(color:  Color(0xFF333333),fontSize: 10.rsp),
                                            ),
                                          ),
                                          8.wb,
                                          Text('${(zodiacModel!.sz??'').split('；')[1].split('：')[1]}',
                                              style: TextStyle(
                                                  color:  Color(0xFF333333),
                                                  fontSize: 12.rsp,
                                                  fontWeight: FontWeight.bold
                                              )),
                                        ],
                                      ),
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
                          Padding(
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('幸运花',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 14.rsp,
                                    )),
                                16.hb,
                                Text(zodiacModel!.xyh??'',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.rsp,
                                  ),maxLines: 3,),

                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 0.5.rw,
                            color: Color(0xFFE8E8E8),
                          ),
                          Row(
                            children: [
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                        '运势',
                                         zodiacModel!.name??'',
                                        zodiacModel!.ys??'',
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('运',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('势',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                        '事业',
                                        zodiacModel!.name??'',
                                        zodiacModel!.sy??'',
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('事',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('业',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                        '爱情',
                                        zodiacModel!.name??'',
                                        zodiacModel!.aq??'',
                                        bottom:_aiQing()
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('爱',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('情',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                          '性格',
                                          zodiacModel!.name??'',
                                          zodiacModel!.xg??''
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('性',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('格',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                          '优点',
                                          zodiacModel!.name??'',
                                          zodiacModel!.yd??''
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('优',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('点',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(child: GestureDetector(
                                onTap: (){
                                  show(
                                      context,
                                      _dialog(
                                          '缺点',
                                          zodiacModel!.name??'',
                                          zodiacModel!.qd??''
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('缺',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('点',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(Assets.life.icSanjiaoHong.path,width: 20.rw,height: 20.rw,),
                                    ],
                                  ),
                                ),
                              )),
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

  _dialog(String text1, String text2, String text3,
      { Widget? bottom}) {
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

              bottom??40.hb
              ,
            ],
          ),
        ),
      ),
    );
  }

  _getIcon(String name){
    switch(name){
      case '子鼠':
        return Assets.life.icShu.path;
      case '丑牛':
        return Assets.life.icNiu.path;
      case '寅虎':
        return Assets.life.icHu.path;
      case '卯兔':
        return Assets.life.icTu.path;
      case '辰龙':
        return Assets.life.icLong.path;
      case '巳蛇':
        return Assets.life.icShe.path;
      case '午马':
        return Assets.life.icMa.path;
      case '未羊':
        return Assets.life.icYang.path;
      case '申猴':
        return Assets.life.icHou.path;
      case '酉鸡':
        return Assets.life.icJi.path;
      case '戌狗':
        return Assets.life.icGou.path;
      case '亥猪':
        return Assets.life.icZhu.path;
    }
  }

  _aiQing(){
    return Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color:Color(0xFFE8E8E8),width: 0.5.rw ))
      ),
      padding:EdgeInsets.all(16.rw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('婚配',
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14.rsp,
              )),
          16.hb,
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                    border: Border.all(color: AppColor.themeColor,width: 1.rw)
                ),
                width: 20.rw,
                height: 20.rw,
                alignment: Alignment.center,
                child: Text(
                  '吉',style: TextStyle(color: AppColor.themeColor,fontSize: 10.rsp),
                ),
              ),
              8.wb,
              Text('${(zodiacModel!.aq??'').split('<br>大吉婚配：')[1].split('<br>忌婚配：')[0]}',
                  style: TextStyle(
                      color: AppColor.themeColor,
                      fontSize: 12.rsp,
                      fontWeight: FontWeight.bold
                  )),
            ],
          ),
          16.hb,
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.rw)),
                    border: Border.all(color: Color(0xFF333333),width: 1.rw)
                ),
                width: 20.rw,
                height: 20.rw,
                alignment: Alignment.center,
                child: Text(
                  '忌',style: TextStyle(color:  Color(0xFF333333),fontSize: 10.rsp),
                ),
              ),
              8.wb,
              Text('${(zodiacModel!.aq??'').split('<br>忌婚配：')[1]}',
                  style: TextStyle(
                      color:  Color(0xFF333333),
                      fontSize: 12.rsp,
                      fontWeight: FontWeight.bold
                  )),
            ],
          ),
        ],
      ),
    );
  }

}
