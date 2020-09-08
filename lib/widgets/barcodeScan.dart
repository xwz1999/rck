
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_audio_player/flutter_audio_player.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/home/barcode/fail_barcode_page.dart';
import 'package:recook/pages/home/barcode/photos_fail_barcode_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/text_utils.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScanPage extends StatefulWidget {

  @override
  State<BarcodeScanPage> createState() {
    return _BarcodeScanPageState();
  }
}


class _BarcodeScanPageState extends BaseStoreState<BarcodeScanPage> {
  String barcode = "";
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    num width = MediaQuery.of(context).size.width;
    Color lineColor = Color(0xffe53636).withAlpha(200);
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          QrcodeReaderView(
            key: _key,
            helpWidget: Text("请将条形码置于方框中间"),
            onEdit: (){
              AppRouter.pushAndReplaced(context, RouteName.BARCODE_INPUT);
            },
            onSelectImage: () async {
              _key.currentState.stopScan();
              var image = await ImagePicker.pickImage(source: ImageSource.gallery);
              if (image == null) {
                _key.currentState.startScan();
                return;
              }
              File cropFile = await ImageUtils.cropImage(image);
              if (cropFile == null) {
                _key.currentState.startScan();
                return;
              }
              File imageFile = cropFile;
              final rest = await FlutterQrReader.imgScan(imageFile);
              if (TextUtils.isEmpty(rest)){
                showError("图片识别失败...").then((v){
                  _key.currentState.startScan();
                });
              }else{
                onScan(rest, image: imageFile);
              }
            },
            onScan: onScan,
            headerWidget: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          Positioned(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: lineColor,
                  borderRadius: BorderRadius.circular(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: lineColor,
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      spreadRadius: 1.0
                    ),
                    BoxShadow(
                      color: lineColor,
                      offset: Offset(0, -1),
                      blurRadius: 5,
                      spreadRadius: 1.0
                    ),
                  ],
                ),
                width: width*0.8,
                height: 1.7,
              ),
            )
          ),
        ],
      ),
    );
  }

  Future onScan(String data, {File image}) async{
    if (!TextUtils.isEmpty(data)){
      _playSound();
      _key.currentState.stopScan();
      Future.delayed(Duration(milliseconds: 500 ), (){
        _getGoodsWithCode(data, (goodsId){
          AppRouter.pushAndReplaced(globalContext, RouteName.COMMODITY_PAGE, arguments: CommodityDetailPage.setArguments(int.parse(goodsId)));
          return;
        }, image: image);
      });
    }else{
      _key.currentState.startScan();
    }
  }

   _playSound() async {
    //  AudioPlayer.addSound("assets/sound/recook_scan.mp3");
  }


  _getGoodsWithCode(String code, Function callBack, {File image}) async {
    
    ResultData resultData = await HttpManager.post(GoodsApi.goods_code_search, {
      "code":code,
    });
    if (!resultData.result) {
      pushToFailPage(code, resultData.msg, image);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      pushToFailPage(code, model.msg, image);
      return;
    }
    String goodsId = resultData.data['data']['goodsId'].toString();
    if (TextUtils.isEmpty(goodsId)) {
      return;
    }
    callBack(goodsId);
    return;
  }

  pushToFailPage(String code, String message, File image){
    if (image != null) {
      AppRouter.pushAndReplaced(context, RouteName.BARCODE_PHOTOSFAIL, arguments: PhotosFailBarcodePage.setArguments(code, message, image));
    }else{
      AppRouter.pushAndReplaced(context, RouteName.BARCODE_FAIL, arguments: FailBarcodePage.setArguments(code, message));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

}