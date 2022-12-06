import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
class HealthResultDXPage extends StatefulWidget {
  final int sex;
  final num height;
  final num weight;
  final int age;
  final String result;

  const HealthResultDXPage(
      {Key? key, required this.sex,required this.height,required this.weight,required this.age, required this.result,
})
      : super(key: key);

  @override
  _HealthResultDXPageState createState() => _HealthResultDXPageState();
}

class _HealthResultDXPageState extends State<HealthResultDXPage> {

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
                    Text('基础代谢率BMR(大卡)',
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
              )
            ],
          ),
        ),
      ],
    );
  }

}
