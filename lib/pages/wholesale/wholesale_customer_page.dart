import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/wholesale_customer_model.dart';

class WholesaleCustomerPage extends StatefulWidget {
  final WholesaleCustomerModel model;
  WholesaleCustomerPage({
    Key key, this.model,
  }) : super(key: key);

  @override
  _WholesaleCustomerPageState createState() => _WholesaleCustomerPageState();
}

class _WholesaleCustomerPageState extends State<WholesaleCustomerPage>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
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
      backgroundColor: AppColor.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "联系客服",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.rw),
        child:
        _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        40.hb,
        Container(
          padding: EdgeInsets.only(top: 15.rw,left: 24.rw),
          width: double.infinity,
          height:84.rw ,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD5101A),width: 0.5.rw),
            borderRadius: BorderRadius.all(Radius.circular(8.rw))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('方法一:  ',style: TextStyle(color: Color(0xFFD5101A),fontSize: 16.rw),),
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('拨打客服热线',style: TextStyle(color: Color(0xFF666666),fontSize: 16.rw),),
                    20.hb,
                    Row(
                      children: [
                        Text('热线电话：',style: TextStyle(color: Color(0xFF333333),fontSize: 16.rw),),
                        Text(widget.model.mobile,style: TextStyle(color: Color(0xFF111111),fontSize: 16.rw),),
                        10.wb,
                        GestureDetector(
                          onTap: (){
                            launch("tel:${widget.model.mobile}");
                          },
                          child: Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_CALL_PNG,width: 30.rw,height: 30.rw,)
                        )

                      ],
                    )

                  ],
                ),
              )
            ],
          ),
        ),

        40.hb,
        Container(
          padding: EdgeInsets.only(top: 15.rw,left: 24.rw),
          width: double.infinity,
          height:204.rw ,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD5101A),width: 0.5.rw),
              borderRadius: BorderRadius.all(Radius.circular(8.rw))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('方法二：',style: TextStyle(color: Color(0xFFD5101A),fontSize: 16.rw),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('添加客服微信',style: TextStyle(color: Color(0xFF666666),fontSize: 16.rw),),
                  20.hb,
                  Row(
                    children: [
                      Text('微信号：',style: TextStyle(color: Color(0xFF333333),fontSize: 16.rw),),
                      Text(widget.model.wechat,style: TextStyle(color: Color(0xFF111111),fontSize: 16.rw,fontWeight: FontWeight.bold),),
                      5.wb,
                      GestureDetector(
                        onTap: (){
                          ClipboardData data = new ClipboardData(text: widget.model.wechat);
                          Clipboard.setData(data);
                          ReToast.success(text: '复制成功');
                        },
                        child: Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_COPYT_PNG,width: 30.rw,height: 30.rw,)
                      )

                    ],
                  ),
                  30.hb,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(

                        width: 100.rw,
                        height: 100.rw,
                        child: FadeInImage.assetNetwork(
                          image: Api.getImgUrl(widget.model.photo),
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          fit: BoxFit.cover,
                        ),
                      ),
                      10.wb,
                      GestureDetector(
                          onTap: (){
                            List<String> urls = [];
                            urls.add(Api.getImgUrl(widget.model.photo));
                            final cancel = ReToast.loading();
                            ImageUtils.saveNetworkImagesToPhoto(
                                urls,
                                    (index){
                                  DPrint.printf("保存好了---$index");
                                },
                                    (success){
                                      cancel();
                                  success ? ReToast.success(text: '保存完成'): Alert.show(
                                    context,
                                    NormalContentDialog(
                                      title: '提示',
                                      content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
                                      items: ["取消"],
                                      listener: (index) {
                                        Alert.dismiss(context);
                                      },
                                      deleteItem: "确认",
                                      deleteListener: () async{

                                        Alert.dismiss(context);
                                        bool isOpened = await openAppSettings();
                                      },
                                      type: NormalTextDialogType.delete,
                                    ),
                                  );;
                                }
                            );
                          },
                          child: Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_DOWLOAD_PNG,width: 30.rw,height: 30.rw,)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),

        40.hb,

        Container(
          padding: EdgeInsets.only(top: 15.rw,left: 24.rw),
          width: double.infinity,
          height:84.rw ,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD5101A),width: 0.5.rw),
              borderRadius: BorderRadius.all(Radius.circular(8.rw))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('方法三：',style: TextStyle(color: Color(0xFFD5101A),fontSize: 16.rw),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('关注微信公众号并发送消息',style: TextStyle(color: Color(0xFF666666),fontSize: 16.rw),),
                  20.hb,
                  Row(
                    children: [
                      Text('公众号：',style: TextStyle(color: Color(0xFF333333),fontSize: 16.rw),),
                      Text('瑞库客APP',style: TextStyle(color: Color(0xFF111111),fontSize: 16.rw,fontWeight: FontWeight.bold),),
                      5.wb,
                      GestureDetector(
                          onTap: (){
                            ClipboardData data = new ClipboardData(text: '瑞库客APP');
                            Clipboard.setData(data);
                            ReToast.success(text: '复制成功');
                          },
                          child: Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_COPYT_PNG,width: 30.rw,height: 30.rw,)
                      )

                    ],
                  )

                ],
              )
            ],
          ),
        ),

      ],
    );
  }

  _capturePng() async {
    // '保存中...'
    Function cancel = ReToast.loading();
    RenderRepaintBoundary boundary =
    _globalKey.currentContext.findRenderObject();
    ui.Image image =
    await boundary.toImage(pixelRatio: ui.window.devicePixelRatio * 1.2);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    if (pngBytes == null || pngBytes.length == 0) {
      cancel();
      ReToast.err(text: '保存失败');
      return;
    }
    ImageUtils.saveImage([pngBytes], (index) {}, (success) {
      cancel();
      if (success) {
        ReToast.success(text: '保存成功');

      } else {
        Alert.show(
          context,
          NormalContentDialog(
            title: '提示',
            content: Text('图片保存失败，请前往应用权限页，设置存储权限为始终允许',style: TextStyle(color: Color(0xFF333333),fontSize: 14.rsp),),
            items: ["取消"],
            listener: (index) {
              Alert.dismiss(context);
            },
            deleteItem: "确认",
            deleteListener: () async{

              Alert.dismiss(context);
              bool isOpened = await openAppSettings();
            },
            type: NormalTextDialogType.delete,
          ),
        );
      }
    });

    // var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);

    // var savedFile = File.fromUri(Uri.file(filePath));
    // setState(() {
    //   Future<File>.sync(() => savedFile);
    // });
    // // '保存成功'
    // showSuccess("保存成功!");
  }
}
