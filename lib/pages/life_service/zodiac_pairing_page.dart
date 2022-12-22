import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/zodiac_pairing_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'life_func.dart';

class ZodiacPairingPage extends StatefulWidget {
  ZodiacPairingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ZodiacPairingPageState createState() => _ZodiacPairingPageState();
}

class _ZodiacPairingPageState extends State<ZodiacPairingPage>
    with TickerProviderStateMixin {

  String zodiacPairingM = '请选择';
  String zodiacPairingW = '请选择';
  bool _show = false;
  ZodiacPairingModel? zodiacPairingModel;

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
        title: Text('生肖配对',
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
            '男方生肖',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              zodiacPairingM =  (await ListPickBody.listPicker([
                '鼠','牛','羊','虎','兔','龙','蛇','马','羊','猴','鸡','狗','猪'
              ], '男方生肖'))??'请选择';
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
                    zodiacPairingM,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: zodiacPairingM=='请选择'? Color(0xFFD8D8D8):Color(0xFF333333),
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
            '女方生肖',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              zodiacPairingW =  (await ListPickBody.listPicker([
                '鼠','牛','羊','虎','兔','龙','蛇','马','羊','猴','鸡','狗','猪'
              ], '女方生肖'))??'请选择';
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
                    zodiacPairingW,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color:zodiacPairingW=='请选择'? Color(0xFFD8D8D8):Color(0xFF333333),
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
            onPressed: () async{
              _show = false;
              if (zodiacPairingW!='请选择'&&zodiacPairingM!='请选择') {

                zodiacPairingModel = await LifeFunc.getZodiacPairingModel(zodiacPairingM,zodiacPairingW);
                if(zodiacPairingModel!=null)
                  _show = true;

                if (mounted) setState(() {});
                _show = true;
                setState(() {

                });
              } else {
                BotToast.showText(text: '请先选择生肖');
              }
            },
          ),
          100.hb,
          _show?Row(
            children: [
              Text('查询结果',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12.rsp,
                  )),
            ],
          ):SizedBox(),
         _show? Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16.rw),
                padding: EdgeInsets.all(12.rw),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rw),
                    border:
                    Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('配对描述',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12.rsp,
                        )),
                    10.hb,
                    Text(zodiacPairingModel!.data??"",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.rsp,
                        )),
                  ]
                ),
              )
            ],
          ):SizedBox(),
          100.hb,
        ],
      ),
    );
  }

}
