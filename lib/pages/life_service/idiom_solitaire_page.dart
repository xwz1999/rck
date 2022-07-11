import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

///成语接龙
class IdiomSolitairePage extends StatefulWidget {
  IdiomSolitairePage({
    Key? key,
  }) : super(key: key);

  @override
  _IdiomSolitairePageState createState() => _IdiomSolitairePageState();
}

class _IdiomSolitairePageState extends State<IdiomSolitairePage>
    with TickerProviderStateMixin {
  FocusNode _contentFocusNode = FocusNode();

  String content = '';///输入的内容
  List idiom = [
    '意义深长','意想不到','意得志满','意气风发','意广才疏','意二三四'
  ];
  bool _show = false;///显示查询结果

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
        title: Text('成语接龙',
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
                text: '查询的成语',
                style: TextStyle(
                    fontSize: 14.rsp,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '  输入成语或成语最后一个字，如一心一意',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Color(0xFF999999),
                      ))
                ]),
          ),
          24.hb,
          Container(
            height: 50.rw,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.text,
              onSubmitted: (_submitted) async {
                _contentFocusNode.unfocus();
              },
              focusNode: _contentFocusNode,
              onChanged: (text) {
                if (text.isNotEmpty) content = text;
                else _show = false;
                setState(() {

                });
              },

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
                setState(() {

                });
              } else {
                BotToast.showText(text: '请先输入成语');
              }
            },
          ),
          100.hb,

          _show?Text('查询结果',
              style: TextStyle(
                color: Color(0xFF999999),
                fontWeight: FontWeight.bold,
                fontSize: 14.rsp,
              )):SizedBox(),
          _show?ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: idiom.length,
            padding: EdgeInsets.only(top: 0.rw,bottom: 20.rw),
            itemBuilder: (BuildContext context, int index) =>
                _itemWidget(idiom[index]),
          ):SizedBox(),

        ],
      ),
    );
  }

  _itemWidget(String text){
    return Container(
      height: 48.rw,
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.rw),
      padding: EdgeInsets.symmetric(horizontal: 24.rw),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(24.rw))),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 14.rsp,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }





}
