import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/models/life_service/joke_model.dart';
import 'package:recook/pages/life_service/hw_calculator_result_page.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

class SoulSootherPage extends StatefulWidget {
  SoulSootherPage({
    Key? key,
  }) : super(key: key);

  @override
  _SoulSootherPageState createState() => _SoulSootherPageState();
}

class _SoulSootherPageState extends State<SoulSootherPage>
    with TickerProviderStateMixin {

  String soul = '';
  int index = 0;

  @override
  void initState() {
    super.initState();
    soul = '无论有多困难，都坚强地抬头挺胸，人生是一场醒悟，不要昨天，不要明天，只要今天活在当下，放眼未来。人生是一种态度，心静自然天地宽。不一样的你我，不一样的心态，不一样的人生。';
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
        title: Text('每日心灵鸡汤语录',
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12.rw),
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 90.rw),
          padding: EdgeInsets.all(24.rw),
          height: 600.rw,
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
          child: Stack(
            children: [
              Positioned(child: Image.asset(Assets.imgFuhaozuo.path,width: 60.rw,height: 60.rw,),left: 0,top: 0,),
              Positioned(child: Image.asset(Assets.imgFuhaoyou.path,width: 60.rw,height: 60.rw,),right: 0,bottom: 0,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:  EdgeInsets.only(top: 30.rw,left: 5.rw),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(soul,style: TextStyle(fontSize: 16.rsp,color: Color(0xFF333333),),maxLines: 50,softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
