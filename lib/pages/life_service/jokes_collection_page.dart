import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/joke_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/recook_back_button.dart';

import 'life_func.dart';

class JokesCollectionPage extends StatefulWidget {
  final  List<JokeModel> jokes;
  JokesCollectionPage({
    Key? key, required this.jokes,
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
    _jokes = widget.jokes;

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
        title: Text('笑话大全',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _jokes.isEmpty
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      )
          : _bodyWidget(),
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
                title: index+1>=_jokes.length?'获取更多': "下一个",
                backgroundColor: AppColor.themeColor,
                color: Colors.white,
                fontSize: 14.rsp,
                borderRadius: BorderRadius.all(Radius.circular(21.rw)),
                onPressed: () async{
                  if(_jokes.isNotEmpty){
                    if(index+1>=_jokes.length){
                      //BotToast.showText(text: '没有更多了');

                       await LifeFunc.getJokeList().then((value) => _jokes.addAll(value!));
                       setState(() {

                       });
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
