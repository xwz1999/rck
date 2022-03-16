import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';


import 'package:velocity_x/velocity_x.dart';

class MessageCenterPage extends StatefulWidget {
  MessageCenterPage({
    Key key,
  }) : super(key: key);

  @override
  _MessageCenterPageState createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage> {
  List<MessageModel> messageList = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    messageList = [
      MessageModel(
          picPath: Assets.icMsgOrder.path,
          title: '订单通知',
          tip: '商家已录入运输费，请及时付款>>>',
          date: '07:12',
          isRead: false),
      MessageModel(
          picPath: Assets.icMsgBet.path,
          title: '收益到账',
          tip: '您的批发收益已到账，立即查看>>>',
          date: '01-03 07:12',
          isRead: false),
      MessageModel(
          picPath: Assets.icMsgBet.path,
          title: '收益到账',
          tip: '您的店铺补贴已到账，立即查看>>>',
          date: '2021-12-23 07:12',
          isRead: false),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: _bodyWidget());
  }

  _bodyWidget() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20.rw),
          color: Colors.transparent,
          height: MediaQuery.of(context).padding.top + kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              24.wb,
              Text('消息',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 20.rsp,
                  )),
              Text('(2)',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 16.rsp,
                  )),
              GestureDetector(
                onTap: () {
                  messageList.forEach((element) {
                    element.isRead = true;
                    setState(() {

                    });
                  });

                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      16.wb,
                      Image.asset(
                        Assets.icMessageClear.path,
                        width: 16.rw,
                        height: 16.rw,
                      ),
                      Text('清除未读',
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 14.rsp,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: double.infinity,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.rw)),
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 12.rw),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                _getItem(messageList[index]),

            separatorBuilder: (context, index) => Divider(
              indent: 50.rw,
              endIndent: 0.rw,
              color: Color(0xFFEEEEEE),
              height: 0.5.rw,
              thickness: 1.rw,
            ),
            itemCount: messageList.length,
          ),
        ),
      ],
    );
  }
  
  _getItem(MessageModel item){
    return GestureDetector(
      onTap: (){
        item.isRead = true;
        setState(() {

        });
      },
      child: Container(
        width: double.infinity,
        //height: 72.rw,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.rw),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(item.picPath,width: 48.rw,height: 48.rw,),
            16.wb,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 295.rw,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(item.title,
                          style: TextStyle(
                            color: Color(0xFF961B1B),
                            fontSize: 16.rsp,
                          )),
                      Spacer(),

                      Text(item.date,
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 14.rsp,
                          )),
                    ],
                  ),
                ),
                15.hb,

                SizedBox(
                  width: 295.rw,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(item.tip,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14.rsp,
                            )),
                      ),
                      item.isRead?SizedBox(width: 8.rw,):Container(
                        width: 8.rw,height: 8.rw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.rw)),
                          color: Color(0xFFD5101A)
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class MessageModel {
  String picPath;
  String title;
  String tip;
  String date;
  bool isRead;

  MessageModel({
    this.picPath,
    this.title,
    this.tip,
    this.date,
    this.isRead,
  });
}
