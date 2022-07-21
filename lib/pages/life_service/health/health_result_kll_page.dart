import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';
class HealthResultKLLPage extends StatefulWidget {
  final int sex;
  final num height;
  final num weight;
  final int age;
  final int level;
  final String result;

  const HealthResultKLLPage(
      {Key? key, required this.sex,required this.height,required this.weight,required this.age, required this.result, required this.level,
})
      : super(key: key);

  @override
  _HealthResultKLLPageState createState() => _HealthResultKLLPageState();
}

class _HealthResultKLLPageState extends State<HealthResultKLLPage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       leading: RecookBackButton(
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
    return  Column(
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
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(20.rw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('每日热量/卡路里消耗(大卡)',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    10.hb,
                    Text(widget.result.split('大卡')[0],
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                          fontSize: 30.rsp,
                          fontWeight: FontWeight.bold
                        )),
                  ],
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
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('性别',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.sex==1?'男':'女',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
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
                          Text('身高(CM)',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.height.toString(),
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
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
                          Text('体重(KG)',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.weight.toString(),
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
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
                          Text('年龄',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.age.toString(),
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
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
                          Text('运动量等级',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(_getLevel(widget.level),
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.rsp,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _getLevel(int type){
    switch(type){
      case 1:
        return '等级一:无运动习惯者/久坐族';
      case 2:
        return '等级二:轻度运动者/每周1至3天运动';
      case 3:
        return '等级三:中度运动者/每周3至5天运动';
      case 4:
        return '等级四:激烈运动者/每周6至7天运动';
      case 5:
        return '等级五:超激烈运动者/体力活工作/每天训练2次';
    }
  }

}
