
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';

import 'package:recook/widgets/custom_app_bar.dart';

import 'package:recook/widgets/recook_back_button.dart';

class HWCalculatorResultPage extends StatelessWidget {
  final HwCalculatorModel hwCalculatorModel;

  HWCalculatorResultPage({
    Key? key,
    required this.hwCalculatorModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
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
          20.hb,
          Container(
            height: 216.rw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.rw),
              border: Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 20.rw),
                  color: Color(0xFFF5F5F5),
                  blurRadius: 40.rw,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                30.hb,
                Text("${hwCalculatorModel.bmi}",
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.rsp,
                    )),
                16.hb,
                Text("您的BMI指数",
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
                32.hb,

                Row(
                  children: [
                    130.wb,
                    Text("18.5",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("24.0",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("28.0",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("35.0",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                  ],
                ),
                6.hb,

                Container(
                  height: 8.rw,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 8.rw,
                        width: 64.rw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(4.rw)),
                          color: Color(0xFF30D9E6),
                        ),
                      ),
                      Container(
                        height: 8.rw,
                        width: 64.rw,
                        color: Color(0xFF39D29D),
                      ),
                      Container(
                        height: 8.rw,
                        width: 64.rw,
                        color: Color(0xFFFFCC41),
                      ),
                      Container(
                        height: 8.rw,
                        width: 64.rw,
                        color: Color(0xFFFF8457),
                      ),
                      Container(
                        height: 8.rw,
                        width: 64.rw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(4.rw)),
                          color: Color(0xFFFF4359),
                        ),
                      ),
                    ],
                  ),
                ),
                6.hb,
                Row(
                  children: [
                    70.wb,
                    Text("偏廋",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("正常",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("偏胖",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("肥胖",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    80.wb,
                    Text("极胖",
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                  ],
                ),
                32.hb,
                Divider(
                  height: 0.5.rw,
                  color: Color(0xFFE8E8E8),
                  thickness: 0.5.rw,
                  indent: 15.rw,
                  endIndent: 15.rw,
                ),
                26.hb,
                Row(
                  children: [
                    Expanded(
                      child: Container(

                        child: Column(
                          children: [
                            Text(
                              hwCalculatorModel.levelMsg??'',
                              style: TextStyle(color: Color(0xFF333333),fontSize: 16.rsp,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '等级',
                              style: TextStyle(color: Color(0xFF999999),fontSize: 12.rsp),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        padding: EdgeInsets.only(left: 50.rw),
                      ),
                    ),
                    Container(
                      height: 36.rw,
                      width: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 60.rw),
                        child: Column(
                          children: [
                            Text(
                              "${hwCalculatorModel.idealWeight}",
                              style: TextStyle(color: Color(0xFF333333),fontSize: 16.rsp,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '标准体重(KG)',
                              style: TextStyle(color: Color(0xFF999999),fontSize: 12.rsp),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ),
                  ],
                )




              ],
            ),
          ),
          80.hb,
          Row(
            children: [
              Image.asset(Assets.icZctz.path,width: 36.rw,height: 36.rw,),
              Text(' 正常体重范围(KG)',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14.rsp,
                  )),
              Spacer(),
              Text('${hwCalculatorModel.normalWeight}',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.rsp,
                  )),
              24.wb,
            ],
          ),
          56.hb,
          Row(
            children: [
              Image.asset(Assets.icXgjb.path,width: 36.rw,height: 36.rw,),
              Text(' 相关疾病发病危险',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14.rsp,
                  )),
              Spacer(),
              Container(
                width: 150.rw,

                child: Text('${hwCalculatorModel.danger}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.rsp,
                    )),
              ),
              24.wb,
            ],
          ),
        ],
      ),
    );
  }
}
