import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/utils/image_utils.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:permission_handler/permission_handler.dart';

class WxContactPage extends StatefulWidget {
  WxContactPage({
    Key key,
  }) : super(key: key);

  @override
  _WxContactPageState createState() => _WxContactPageState();
}

class _WxContactPageState extends State<WxContactPage>
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
      backgroundColor: AppColor.frenchColor,
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
        child:
        _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          100.hb,
          RepaintBoundary(
              key: _globalKey,
              child: Image.asset(
                R.ASSETS_SCANCODE_PNG,
                width: 239.rw,
                height: 242.rw,
                fit: BoxFit.fill,
              ),),

          10.hb,
          Text(
            "扫描二维码联系客服",
            style: TextStyle(
              color: Color(0xFFD5101A),
              fontSize: 12.rsp,
            ),
          ),
          50.hb,
          GestureDetector(
            onTap: () {
              ClipboardData data = new ClipboardData(text: 'wmjbbdsj');
              Clipboard.setData(data);
              ReToast.success(text: '复制成功');
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "微信号：wmjbbdsj",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16.rsp,
                    ),
                  ),
                  20.wb,
                  Text(
                    "复制",
                    style: TextStyle(
                      color: Color(0xFF2F82E5),
                      fontSize: 14.rsp,
                    ),
                  ),
                ],

              ),
            ),
          ),
          50.hb,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.rw),
            child: CustomImageButton(
              height: 45.rw,

              //padding: EdgeInsets.symmetric(vertical: 20.w),
              title: "保存二维码到本地",
              backgroundColor: AppColor.themeColor,
              color: Colors.white,
              fontSize: 16.rsp,
              borderRadius: BorderRadius.all(Radius.circular(22.rw)),
              onPressed: () {
                _capturePng();
              },
            ),
          ),
        ],
      ),
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
