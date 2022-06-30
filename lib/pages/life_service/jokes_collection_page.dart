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

class JokesCollectionPage extends StatefulWidget {
  JokesCollectionPage({
    Key? key,
  }) : super(key: key);

  @override
  _JokesCollectionPageState createState() => _JokesCollectionPageState();
}

class _JokesCollectionPageState extends State<JokesCollectionPage>
    with TickerProviderStateMixin {

  List<JokeModel> _jokes = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _jokes = [
      JokeModel(content: '有一天晚上我俩一起吃西瓜，老大把西瓜籽很整洁的吐在了一张纸上，\r\n过了几天，我从教室回但宿舍看到老大在磕瓜子，\r\n我就问他：老大，你什么时候买的瓜子？\r\n老大说：刚晒好，说着抓了一把要递给我……'),
      JokeModel(content: '我女朋友气跑了＂\r\n＂怎么回事？严重吗？你怎么着她了？＂\r\n＂不严重，我只是很久没用了'),
      JokeModel(content: '还说神马来一场说走就走的旅行，\r\n工作后就连一场说走就走的下班都不行。'),
      JokeModel(content: '高速路上堵车，路边葡萄地里有一哥们竟然在偷葡萄，心想太没素质了吧！\r\n不管了我也去，刚溜进葡萄地，那哥们竟问我干嘛，\r\n我撇了一眼反问道你干嘛呢？\r\n那哥们答道摘葡萄呢！\r\n我答道：我也摘葡萄呢！\r\n哥们郁闷了说我摘我家的你呢？\r\n我顿时脸红，哥你家葡萄咋卖呢？'),
      JokeModel(content: '和老婆在街边散步，我手上捏着一张已揉成一团的传单，\r\n走了好一会终于看到个垃圾桶，我赶紧跑过去想扔掉，\r\n没想到老婆从后边一把拉住我说：老公，那个肯定吃不得了，别捡。\r\n我一愣，发现垃圾桶顶盖上放着半个西瓜。'),
    ];
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
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('笑话大全',
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
                        child: Text(_jokes[index].content??'没有获取到数据'
                          ,style: TextStyle(fontSize: 16.rsp,color: Color(0xFF333333),),maxLines: 50,softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        56.hb,
        Row(
          children: [
            index>0?Expanded(
              child: CustomImageButton(
                height: 42.rw,
                title: "上一个",
                backgroundColor: AppColor.themeColor,
                color: Colors.white,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () {
                  if(_jokes.isNotEmpty){
                    if(index-1<0){
                      BotToast.showText(text: '没有更多了');
                    }else{
                      index--;
                      setState(() {

                      });
                    }
                  }else{
                    BotToast.showText(text: '数据获取失败');
                  }
                },
              ),
            ):SizedBox(),
            index>0?40.wb:SizedBox(),
            Expanded(
              child: CustomImageButton(
                height: 42.rw,
                title: "下一个",
                backgroundColor: AppColor.themeColor,
                color: Colors.white,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () {
                  if(_jokes.isNotEmpty){
                    if(index+1>=_jokes.length){
                      BotToast.showText(text: '没有更多了');
                    }else{
                      index++;
                      setState(() {
                      });
                    }
                  }else{
                    BotToast.showText(text: '没有更多了');
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
