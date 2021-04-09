

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class PhotosFailBarcodePage extends StatefulWidget{
  final Map arguments;

  const PhotosFailBarcodePage({Key key, this.arguments}) : super(key: key);
  
  static setArguments(String code, String message, File image){
    return {
      "code": code,
      "message": message,
      "image": image,
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _PhotosFailBarcodePageState();
  }
}

class _PhotosFailBarcodePageState extends BaseStoreState<PhotosFailBarcodePage>{
  String _code;
  String _message;
  File _image;
  @override
  void initState() { 
    super.initState();
    if (widget.arguments != null) {
      _code = widget.arguments["code"];
      _message = widget.arguments["message"];
      _image = widget.arguments["image"];
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "识别失败",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        appBackground: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget(){
    double width = MediaQuery.of(context).size.width;
    Color buttonColor = Color(0xffE98787);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: ScreenAdapterUtils.setHeight(150),
            width: MediaQuery.of(context).size.width,
            child: Image.file(_image, fit: BoxFit.contain,),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            padding: EdgeInsets.only(left: 30, top: 20),
            child: Text(_message==null?"商品未录入":_message, style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(22)),),
          ),
          _codeWidget(),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 100,),
            child: CustomImageButton(
              height: ScreenAdapterUtils.setHeight(36),
              backgroundColor: AppColor.themeColor,
              title: "重新上传",
              color: Colors.white,
              fontSize: 16,
              onPressed: () async {
                var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                File cropFile = await ImageUtils.cropImage(image);
                if (cropFile == null) {
                  return;
                }
                File imageFile = cropFile;
                final rest = await FlutterQrReader.imgScan(imageFile);
                onScan(rest, image: imageFile);
                },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CustomImageButton(
                    height: ScreenAdapterUtils.setHeight(36),
                    title: "切换扫描",
                    color: buttonColor,
                    border: Border.all(
                      color: buttonColor,
                    ),
                    fontSize: 16,
                    onPressed: (){
                      AppRouter.pushAndReplaced(context, RouteName.BARCODE_SCAN);
                    },
                  ),
                ),
                Container(width: 30,),
                Expanded(
                  child: CustomImageButton(
                    height: ScreenAdapterUtils.setHeight(36),
                    title: "返回首页",
                    color: buttonColor,
                    border: Border.all(
                      color: buttonColor,
                    ),
                    fontSize: 16,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  _codeWidget(){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                // height: 60,
                alignment: Alignment.center,
                child: Text("扫码结果", style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),),
              ),
              Container(width: 15,),
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Text(_code, style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: ScreenAdapterUtils.setSp(15)),),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: AppColor.frenchColor,
          )
        ],
      )
    );
  }

  Future onScan(String data, {File image}) async{
    if (!TextUtils.isEmpty(data)){
      _getGoodsWithCode(data, (goodsId){
        AppRouter.pushAndReplaced(globalContext, RouteName.COMMODITY_PAGE, arguments: CommodityDetailPage.setArguments(int.parse(goodsId)));
        return;
      }, image: image);
    }else{
      showError("图片识别失败...");
    }
  }

  _getGoodsWithCode(String code, Function callBack, {File image}) async {
    
    ResultData resultData = await HttpManager.post(GoodsApi.goods_code_search, {
      "code":code,
    });
    if (!resultData.result) {
      _refreshState(code, resultData.msg, image);
      // pushToFailPage(code, resultData.msg, image);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      _refreshState(code, model.msg, image);
      // pushToFailPage(code, model.msg, image);
      return;
    }
    String goodsId = resultData.data['data']['goodsId'].toString();
    if (TextUtils.isEmpty(goodsId)) {
      return;
    }
    callBack(goodsId);
    return;
  }

  _refreshState(code, message, image){
    _code = code;
    _message = message;
    _image = image;
    setState(() {});
  }
  
}
