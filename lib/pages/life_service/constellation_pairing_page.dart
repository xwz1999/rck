import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/constellation_pairing_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/list_pick_body.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'life_func.dart';

class ConstellationPairingPage extends StatefulWidget {
  ConstellationPairingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ConstellationPairingPageState createState() => _ConstellationPairingPageState();
}

class _ConstellationPairingPageState extends State<ConstellationPairingPage>
    with TickerProviderStateMixin {

  String constellationM = '请选择';
  String constellationW = '请选择';
  bool _show = false;
  ConstellationPairingModel? constellationPairingModel;

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
        title: Text('星座配对',
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
            '男方星座',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              constellationM =  (await ListPickBody.listPicker([
                '白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手','摩羯','水瓶','双鱼'
              ], '男方星座'))??'请选择';
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
                    constellationM,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: constellationM=='请选择'?  Color(0xFFD8D8D8):Color(0xFF333333),
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
            '女方星座',
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold),
          ),
          24.hb,
          GestureDetector(
            onTap: () async{
              constellationW =  (await ListPickBody.listPicker([
                '白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手','摩羯','水瓶','双鱼'
              ], '女方星座'))??'请选择';
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
                    constellationW,
                    style: TextStyle(
                        fontSize: 14.rsp,
                        color: constellationW=='请选择'?  Color(0xFFD8D8D8):Color(0xFF333333),
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
            onPressed: ()async {
              _show = false;
              if (constellationW!='请选择'&&constellationM!='请选择') {
                constellationPairingModel = await LifeFunc.getConstellationPairingModel(constellationM,constellationW);
                if(constellationPairingModel!=null)
                  _show = true;

                if (mounted) setState(() {});
              } else {
                BotToast.showText(text: '请输入正确的数据');
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
                                Text('配对指数',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(constellationPairingModel!.zhishu??"",
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Row(
                              children: [
                                Image.asset(
                                  _getIcon(constellationPairingModel!.men??''),
                                  width: 48.rw,
                                  height: 48.rw,
                                ),
                                24.wb,
                                Image.asset(
                                  _getIcon(constellationPairingModel!.women ?? ''),
                                  width: 48.rw,
                                  height: 48.rw,
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
                                Text('配对比重',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(constellationPairingModel!.bizhong??'',
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
                                Text('两情相悦指数',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(constellationPairingModel!.xiangyue??'',
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
                                Text('天长地久指数',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(constellationPairingModel!.tcdj??'',
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
                                Text('配对描述',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(constellationPairingModel!.jieguo??'',
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
                          child: GestureDetector(
                            onTap: (){
                              show(
                                  context,
                                  _dialog(
                                    '恋爱建议',
                                    (constellationPairingModel!.men ?? '')+'座与'+(constellationPairingModel!.women ?? '')+'座',
                                    constellationPairingModel!.lianai ?? '',
                                  ));
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(20.rw),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('恋爱建议',
                                      style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 12.rsp,
                                      )),
                                  10.hb,
                                  Row(
                                    children: [
                                      Text('详情',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.rsp,
                                          )),
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              show(
                                  context,
                                  _dialog(
                                    '注意事项',
                                    (constellationPairingModel!.men ?? '')+'座与'+(constellationPairingModel!.women ?? '')+'座',
                                    constellationPairingModel!.zhuyi ?? '',
                                  ));
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(20.rw),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('注意事项',
                                      style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 12.rsp,
                                      )),
                                  10.hb,
                                  Row(
                                    children: [
                                      Text('详情',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.rsp,
                                          )),
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ):SizedBox(),
          100.hb,
        ],
      ),
    );
  }


  _getIcon(String name) {
    switch (name) {
      case '白羊':
        return Assets.life.imgBaiyang.path;
      case '金牛':
        return Assets.life.imgJinniu.path;
      case '双子':
        return Assets.life.imgShuangzi.path;
      case '巨蟹':
        return Assets.life.imgJuxie.path;
      case '狮子':
        return Assets.life.imgShizi.path;
      case '处女':
        return Assets.life.imgChunv.path;
      case '天秤':
        return Assets.life.imgTiancheng.path;
      case '天蝎':
        return Assets.life.imgTianxie.path;
      case '射手':
        return Assets.life.imgSheshou.path;
      case '摩羯':
        return Assets.life.imgMoxie.path;
      case '水平':
        return Assets.life.imgShuiping.path;
      case '双鱼':
        return Assets.life.imgShuangyu.path;
    }
  }
  Future<bool?> show(BuildContext context, Widget widget) async {
    return await showDialog(
      context: context,
      builder: (context) => widget,
      barrierDismissible: false,
    );
  }

  _dialog(
      String text1,
      String text2,
      String text3,
      ) {
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
            ],
          ),
        ),
      ),
    );
  }
}
