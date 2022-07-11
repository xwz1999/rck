import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/birth_flower_model.dart';
import 'package:recook/models/life_service/zodiac_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/car_date_picker.dart';
import 'package:recook/widgets/recook_back_button.dart';

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
  late ZodiacModel zodiacModel;

  @override
  void initState() {
    super.initState();
    zodiacModel = ZodiacModel(
      name: '丑牛',fw: '东南，东北方',sc:'吉：蓝、红、紫色；忌：白、绿色',sz: '吉：一、九；凶：三、四',xyh: '郁金香、万年青、桃花',
      ys: '丑年生人，性诚实，富有忍耐心，对事多固执，乏其交际，女人多信他人甜言以致失败，后悔不入及，应该谨慎之，此人沉默寡言，不被人重用，但内心温和，作事勤勉，活动独立，热心坚实，性向钱财等，早离乡白手成家，少年有福，中年交来多少苦劳与精神的麻烦与苦恼，晚景天禀赐福的荣幸，有婚姻上的麻烦等。',
      sy: '事业发展得心应手，个人的努力和勤奋也大有可为。需要提防的是当心有小人的嫉妒和从中作梗，学会应变求存来克服可能出现的不利因素。',
        aq:'感情丰富而爱憎分明，宜中庸求得平衡。爱情生活中时有风波曲折，特别是女性寄情于外面世界的娱乐，造成家庭中的意见，须克服，情侣间要排除猜疑。<br>大吉婚配：鼠(子)、蛇(已)、鸡(酉)<br>忌婚配：龙(辰)、狗(戌)、羊(午)',
     xg: '肖牛者最大的优点就是责任感强、脚踏实地， 凡事都经过深思熟虑才作决定。其性格正直倔强， 也是个尊重传统的保守主义者。然而，肖牛的人往往比较呆板， 也不会圆滑处理事物，一旦发脾气就将事情搞得不可收拾。',
        yd:'做事谨慎小心，脚踏实地行动缓慢，有稳扎稳打的习性。不轻易受他人或环境的影响，依照自已意念和能力做事。在采取行动之前，早有一番深思熟虑，而且有始有终拥有坚强的信念和强壮的体力。有牛脾气，明辨是非按部就班，事业心强最具耐力。内心有强烈的自我表现欲，故不适合作默默无闻的工作，天生优秀领导人物。女性持家有方，是传统的贤内助，非常重视子女教育。虽然婚姻方面不太协调，却能以旺盛的精力投入事业中成为有成就的企业家。有耐性肯上进，所以能达成自已所设定的目标。温厚老实是终生天性，对国家有强烈的热爱，有理想有抱负，重视工作与家庭，是尊重传统的保守者。',
        qd:'女性较缺乏娇柔，如果能意识到自己的不足，改变一下拘谨冷漠的态度积极表现自已则在感情上亦能称心如意。因任劳任怨加上个性固执不听劝告，时常忘了准特进餐，而有肠问题。如顽石般不知变通且毫无情趣。口才木讷不善交际应酬。为人不太相信别人多执己见，沈默寡言。喜欢我行我素，固执己见，不善沟通。'
    );
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(zodiacModel.name??'',
                                        style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.rsp,
                                        )),
                                    Image.asset(_getIcon(zodiacModel.name??''),width: 24.rw,height: 24.rw,),

                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 0.5.rw,
                            color: Color(0xFFE8E8E8),
                          ),
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

}
