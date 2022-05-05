import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/user/banlance/user_balance_page.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_page.dart';
import 'package:jingyaoyun/widgets/no_data_view.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';

import 'message_model.dart';

class MessageCenterPage extends StatefulWidget {
   final bool canback;
  MessageCenterPage({
    Key key, this.canback,
  }) : super(key: key);

  @override
  _MessageCenterPageState createState() => _MessageCenterPageState();
}



class _MessageCenterPageState extends State<MessageCenterPage> {
  List<Message> messageList = [];
  MessageModel messageModel;

  GSRefreshController _refreshController = GSRefreshController(initialRefresh: true);


  int _page = 0;
  bool _onLoad = true;

  num _num = 0;



  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

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

             widget.canback? RecookBackButton(white: false,):SizedBox(),
              Text('消息',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 20.rsp,
                  )),
              Text('($_num)',
                  style: TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 16.rsp,
                  )),
              GestureDetector(
                onTap: () async{
                  // messageList.forEach((element) {
                  //   element.isRead = true;
                  //
                  // });
                  await messageReadAll();

                  _refreshController.requestRefresh();



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
          child:
          RefreshWidget(
            color: Color(0xFF999999),
            controller: _refreshController,
            onRefresh: ()async {
              _page = 0;


              await getMessageList();
              await getMessageNum();
              _refreshController.refreshCompleted();
              getMessageList().then((value) {
                setState(() {
                  messageList = value;
                  _onLoad = false;
                });
                _refreshController.refreshCompleted();
              });

              // getRechargeHistoryList().then((models) {
              //   setState(() {
              //     list = models;
              //     _onLoad = false;
              //   });
              //
              //   _refreshController.refreshCompleted();
              // });
            },

            onLoadMore: () {
              _page++;
              if (messageList.length >=
                  messageModel.total) {
                _refreshController.loadComplete();
                _refreshController.loadNoData();
              }else{
                getMessageList().then((value) {
                  setState(() {
                    messageList.addAll(value);

                  });
                  _refreshController.loadComplete();
                });

              }

            },
            body:
            _onLoad?SizedBox():
            messageList == null ||messageList.length == 0
                ? NoDataView(title:'没有数据哦～' ,):
            ListView.separated(
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

        ),
      ],
    );
  }
  
  _getItem(Message item){
    return GestureDetector(
      onTap: ()async{
        ///订单跳转到付款页面
        ///收益跳转到钱包

        messageRead(item.id);
        _refreshController.requestRefresh();
        if(item.kind==1){
          Get.to(() => UserBalancePage());
        }else{
          AppRouter.push(
              context, RouteName.ORDER_DETAIL,
              arguments: OrderDetailPage.setArguments(item.subId,true));
        }



      },
      child: Container(
        width: double.infinity,
        //height: 72.rw,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.rw),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(item.kind==1?Assets.icMsgBet.path:Assets.icMsgOrder.path,width: 48.rw,height: 48.rw,),
            16.wb,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 295.rw,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(item.kind==1?'收益到账':'订单通知',
                          style: TextStyle(
                            color: Color(0xFF961B1B),
                            fontSize: 16.rsp,
                          )),
                      Spacer(),

                      Text(
                          item.createdAt==null?'':
                          "${DateUtil.formatDate(DateTime.parse("${item.createdAt.substring(0, 19)}"), format: 'yyyy-MM-dd HH:mm')}",
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
                        child: Text(item.message+'>>>',
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

  Future<List<Message>> getMessageList() async {
    ResultData resultData =
    await HttpManager.post(APIV2.userAPI.getMessageList, {
      'page': _page,
      'limit': 10,
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return [];
    }

    if (resultData.data != null) {
      if (resultData.data['data'] != null) {
        if(resultData.data['data']['list'] != null)
          messageModel = MessageModel.fromJson(resultData.data['data']);
        return (resultData.data['data']['list'] as List)
            .map((e) => Message.fromJson(e))
            .toList();
      }else{
        return [];
      }
    }else{
      return [];
    }
  }

  Future getMessageNum() async {
    ResultData resultData =
    await HttpManager.post(APIV2.userAPI.getMessageNum, {
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return '';
    }

    if (resultData.data != null) {
      if (resultData.data['data'] != null) {
        _num =  resultData.data['data']['count'];
      }
    }
  }

  Future<String> messageReadAll() async {
    ResultData resultData =
    await HttpManager.post(APIV2.userAPI.messageReadAll, {
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return '';
    }

    if (resultData.data != null) {
      if (resultData.data['data'] != null) {

      }else{
        return '';
      }
    }else{
      return '';
    }
  }


  Future<String> messageRead(int id) async {
    ResultData resultData =
    await HttpManager.post(APIV2.userAPI.messageRead, {
      'id':id
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return '';
    }

    if (resultData.data != null) {
      if (resultData.data['data'] != null) {

      }else{
        return '';
      }
    }else{
      return '';
    }
  }



}



