import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/constellation_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'life_func.dart';

///星座查询
class ConstellationPage extends StatefulWidget {
  ConstellationPage({
    Key? key,
  }) : super(key: key);

  @override
  _ConstellationPageState createState() => _ConstellationPageState();
}

class _ConstellationPageState extends State<ConstellationPage>
    with TickerProviderStateMixin {
  String content = '';

  ///输入的内容
  bool _show = false;

  ///显示查询结果
  DateTime? currentTime = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  ConstellationModel? constellationModel;
  FocusNode _contentFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _contentFocusNode.dispose();
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
        title: Text('星座查询',
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
                text: '关键字',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '  输入日期或星座名称(如：2022-01-01或金牛座)',
                    style: TextStyle(
                      fontSize: 12.rsp,
                      color: Color(0xFF999999),
                    ),
                  ),
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              onChanged: (text) {
                content = text;
                if(content.isEmpty)
                  _show = false;
                setState(() {

                });
              },
              onSubmitted: (_submitted) async {
                _contentFocusNode.unfocus();
              },
              focusNode: _contentFocusNode,
              keyboardType: TextInputType.text,
              controller: _textEditingController,
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
          48.hb,
          CustomImageButton(
            height: 42.rw,
            title: "开始查询",
            backgroundColor: AppColor.themeColor,
            color: Colors.white,
            fontSize: 14.rsp,
            borderRadius: BorderRadius.all(Radius.circular(21.rw)),
            onPressed: ()async{
              _contentFocusNode.unfocus();
              _show = false;
              if (content.isNotEmpty) {

                constellationModel = await LifeFunc.getConstellationModel(content);
                if(constellationModel!=null)
                  _show = true;
                setState(() {});
              } else {
                BotToast.showText(text: '请先输入生日或星座');
              }
            },
          ),
          100.hb,
          !_show
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(constellationModel!.name ?? '',
                                          style: TextStyle(
                                            color: AppColor.themeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.rsp,
                                          )),
                                      20.hb,
                                      Text(constellationModel!.range ?? '',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.rsp,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Image.asset(
                                _getIcon(constellationModel!.name ?? ''),
                                width: 48.rw,
                                height: 48.rw,
                              ),
                              40.wb,
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
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('特点',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.zxtd ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('珠宝',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.jssw ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('掌管宫位',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.zggw ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('颜色',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.xyys ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('最大特征',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.zdtz ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('主管星',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.zgxx ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('阴阳性',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.yysx ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('属性',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.kyjs ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('幸运号',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.rw),
                                        child: Text(
                                            constellationModel!.xyhm ?? '',
                                            style: TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: 14.rsp,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('金属',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      16.hb,
                                      Text(constellationModel!.kyjs ?? '',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 14.rsp,
                                              fontWeight: FontWeight.bold)),
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
                                Text('表现',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 14.rsp,
                                    )),
                                16.hb,
                                Text(
                                  constellationModel!.bx ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.rsp,
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
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
                                Text('优点',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 14.rsp,
                                    )),
                                16.hb,
                                Text(
                                  constellationModel!.yd ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.rsp,
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
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
                                Text('缺点',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 14.rsp,
                                    )),
                                16.hb,
                                Text(
                                  constellationModel!.qd ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.rsp,
                                  ),
                                  maxLines: 3,
                                ),
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
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  show(
                                      context,
                                      _dialog(
                                        '基本特质',
                                        constellationModel!.name ?? '',
                                        constellationModel!.jbtz ?? '',
                                      ));
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('基',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('本',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('特',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('质',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  show(
                                      context,
                                      _dialog(
                                        '具体特质',
                                        constellationModel!.name ?? '',
                                        constellationModel!.jttz ?? '',
                                      ));
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('具',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('体',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('特',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('质',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  show(
                                      context,
                                      _dialog(
                                        '行事风格',
                                        constellationModel!.name ?? '',
                                        constellationModel!.xsfg ?? '',
                                      ));
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('行',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('事',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('风',
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
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  show(
                                      context,
                                      _dialog(
                                        '个性缺点',
                                        constellationModel!.name ?? '',
                                        constellationModel!.gxmd ?? '',
                                      ));
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('个',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('性',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
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
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  show(
                                      context,
                                      _dialog(
                                        '总体评价',
                                        constellationModel!.name ?? '',
                                        constellationModel!.zj ?? '',
                                      ));
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 19.rw),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE8E8E8),
                                              width: 0.5.rw))),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('总',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('体',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('评',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      Text('价',
                                          style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14.rsp,
                                          )),
                                      5.hb,
                                      Image.asset(
                                        Assets.life.icSanjiaoHong.path,
                                        width: 20.rw,
                                        height: 20.rw,
                                      ),
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
                ),
          100.hb,
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

  _getIcon(String name) {
    switch (name) {
      case '白羊座':
        return Assets.life.imgBaiyang.path;
      case '金牛座':
        return Assets.life.imgJinniu.path;
      case '双子座':
        return Assets.life.imgShuangzi.path;
      case '巨蟹座':
        return Assets.life.imgJuxie.path;
      case '狮子座':
        return Assets.life.imgShizi.path;
      case '处女座':
        return Assets.life.imgChunv.path;
      case '天秤座':
        return Assets.life.imgTiancheng.path;
      case '天蝎座':
        return Assets.life.imgTianxie.path;
      case '射手座':
        return Assets.life.imgSheshou.path;
      case '摩羯座':
        return Assets.life.imgMoxie.path;
      case '水平座':
        return Assets.life.imgShuiping.path;
      case '双鱼座':
        return Assets.life.imgShuangyu.path;
    }
  }
}
