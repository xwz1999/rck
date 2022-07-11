import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/ConstellationModel.dart';
import 'package:recook/models/life_service/birth_flower_model.dart';
import 'package:recook/models/life_service/zodiac_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/pick/car_date_picker.dart';
import 'package:recook/widgets/recook_back_button.dart';

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
  late ConstellationModel constellationModel;

  @override
  void initState() {
    super.initState();
    constellationModel = ConstellationModel(
      name: '金牛座',
      range: '4.20-5.20',
      zxtd: '稳健固执',
      sssx: '土',
      zggw: '第二宫',
      yysx: '阴性',
      zdtz: '财富',
      zgxx: '金星',
      xyys: '粉色',
      jssw: '翡翠、玉',
      xyhm: '6',
      kyjs: '木',
      bx: '稳定、务实、享受',
      yd: '沉稳踏实，重视特质，观察力敏锐',
      qd: '顽固，太过实际，依赖心强',
      jbtz:
          '太阳位于金牛座的人给人的感觉稳重、务实，追求稳定与和谐，害怕变动，属于享受派。喜欢安定，最怕没有安全感。但有时显得固执己见，对钱财看得很重。',
      jttz:
          '牡羊座是黄道十二宫的第一个星座，这让你有着孩童般的纯真、坦率，同样，也有着与生俱来的创造力，表现出强烈的领导欲望及企图心。太阳落在牡羊座的人是个急先锋，以自我为中心，想到就出发，不爱犹豫；非常享受快节奏的生活步调，冲在最前面才最有优越感。牡羊座的主宰行星是火星，在火星的主导之下，羊族人活力充沛，不畏艰险；力争前茅，惟有竞争才能让你感觉到存在的价值；非常乐观，不畏挫折，在人生的舞台上积极追求成功。太阳落在金牛座的人追求舒适的生活环境，向往高品质的生活，乐于追求金钱，对美好的物质享受充满欲望。稳定和安全感是你衡量事物的唯一标准，是你执着的追求。做任何事若感觉仍有不确定因素存在，不会轻易地涉入，但一旦决心已定，将全力以赴，九头牛也拉你不动。另外，你对于和身体相关的事物都很感兴趣，包括性爱、饮食、运动等，欣赏一切美丽的事物。敏锐的洞察力也让你很能了解他人的心思，是重感情的人。',
      xsfg:
          '你思虑周全，行事谨慎，拟定计划是你的强项。在行动前就会考虑到前因后果，分析利弊，而后才会择机小心翼翼地投入，要你打没把握的仗比登天还难。',
      gxmd:
          '你的赚钱欲望强烈，也易赚到钱，但也是一个十足的拜金主义者，易给人铁公鸡一毛不拔的印象，别把钱财看得太重；你行事过于谨慎，易错过良机，应加强行动力，思虑太多易将动力消磨殆尽；有时显得倔强，发起牛脾气来还挺吓人，稍加控制情绪，你的人际关系会更加圆融，提升贵人助力。',
      zj: '金牛座很保守，喜欢稳定，一旦有什么变动就会觉得心里不踏实，性格也比较慢热，但你是理财高手，对于投资理财都有着独特的见解。金牛男的性格有点儿自我，而金牛女就喜欢投资自己，想要过得更好。',
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
                    text: '输入日期或星座名称(如：2022-01-01或金牛座)',
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
              autofocus: true,
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
            onPressed: () {
              if (content.isNotEmpty) {
                _show = true;
                setState(() {});
              } else {
                BotToast.showText(text: '请先输入日期');
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(20.rw),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(constellationModel.name ?? '',
                                          style: TextStyle(
                                            color: AppColor.themeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.rsp,
                                          )),
                                      20.hb,
                                      Text(constellationModel.range ?? '',
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
                                _getIcon(constellationModel.name ?? ''),
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
                                      Text(constellationModel.zxtd ?? '',
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
                                      Text(constellationModel.jssw ?? '',
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
                                      Text(constellationModel.zggw ?? '',
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
                                      Text(constellationModel.xyys ?? '',
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
                                      Text(constellationModel.zdtz ?? '',
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
                                      Text(constellationModel.zgxx ?? '',
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
                                      Text(constellationModel.yysx ?? '',
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
                                      Text(constellationModel.kyjs ?? '',
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
                                            constellationModel.xyhm ?? '',
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
                                      Text(constellationModel.kyjs ?? '',
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
                                  constellationModel.bx ?? '',
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
                                  constellationModel.yd ?? '',
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
                                  constellationModel.qd ?? '',
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
                                        constellationModel.name ?? '',
                                        constellationModel.jbtz ?? '',
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
                                        constellationModel.name ?? '',
                                        constellationModel.jttz ?? '',
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
                                        constellationModel.name ?? '',
                                        constellationModel.xsfg ?? '',
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
                                        constellationModel.name ?? '',
                                        constellationModel.gxmd ?? '',
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
                                        constellationModel.name ?? '',
                                        constellationModel.zj ?? '',
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
