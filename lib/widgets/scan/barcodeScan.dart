import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/scan_result_model.dart';
import 'package:recook/pages/home/barcode/fail_barcode_page.dart';
import 'package:recook/pages/home/barcode/photos_fail_barcode_page.dart';
import 'package:recook/pages/home/barcode/qr_scaner_result_page.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/utils/text_utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:scan/scan.dart';

import '../alert.dart';


class BarcodeScanPage extends StatefulWidget {
  @override
  State<BarcodeScanPage> createState() {
    return _BarcodeScanPageState();
  }
}

class _BarcodeScanPageState extends BaseStoreState<BarcodeScanPage> {
  String barcode = "";
  // GlobalKey<QrcodeReaderViewState> _key = GlobalKey();

  final player = AudioPlayer();

  final picker = ImagePicker();

  ScanController controller = ScanController();

  String _platformVersion = 'Unknown';

  bool _openLight = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    num width = MediaQuery.of(context).size.width;
    num height = MediaQuery.of(context).size.height;
    Color lineColor = Color(0xffe53636).withAlpha(200);
    return new Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[



          ScanView(
            controller: controller,
            scanAreaScale: .8,
            scanLineColor: Colors.red,
            onCapture: (data) {
              onScan(data);
            },
          ),


          CustomAppBar(

            appBackground: Colors.transparent,
            leading: RecookBackButton(
              white: true,
            ),
            elevation: 0,
          ),

          Positioned(
              top:  height/2  - (width/2),

              child: Text("请将条形码置于方框中间")),

          Positioned(
              bottom: height/2  - 0.8*(width/2),

              child: Center(
            child:   GestureDetector(
              child:Image.asset(!_openLight?Assets.toolFlashlightClose.path: Assets.toolFlashlightOpen.path,color: Colors.white,width: 45.rw,height: 45.rw,),
              onTap: () {
                controller.toggleTorchMode();
                _openLight = !_openLight;
                setState(() {

                });

              },
            ),
          )),


          Positioned(
              bottom: height/2  - (width/2)-150.w,

              child: Center(
                child:   Row(
                  children: [
                    GestureDetector(
                      child:Column(
                        children: [
                          Image.asset(Assets.toolImg.path,color: Colors.white.withOpacity(0.6),width: 30.rw,height: 30.rw,),
                          30.hb,
                          Text('图片',style: TextStyle(
                            color: Colors.white.withOpacity(0.6),fontSize: 14.rsp
                          ),)
                        ],
                      ),
                      onTap: () async{

                        if (Platform.isIOS) {
                          var image =
                              await picker.getImage(source: ImageSource.gallery);
                          if (image == null) {
                            controller.toggleTorchMode();
                            return;
                          }
                          File cropFile = await ImageUtils.cropImage(File(image.path));
                          if (cropFile == null) {
                            controller.toggleTorchMode();
                            return;
                          }
                          File imageFile = cropFile;


                          final rest = await Scan.parse(image.path);

                          if (TextUtils.isEmpty(rest)) {
                            showError("图片识别失败...").then((v) {
                              controller.toggleTorchMode();
                            });
                          } else {
                            onScan(rest, image: imageFile);
                          }
                          return;
                        }
                        bool permission = await Permission.storage.isGranted;
                        if(!permission){
                          Alert.show(
                            context,
                            NormalContentDialog(
                              title: '需要获取相册访问权限',
                              content:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Image.asset(R.ASSETS_LOCATION_PER_PNG,width: 44.rw,height: 44.rw,),
                                  Expanded(
                                    child: Text('允许访问相册图片用来扫码识别商品', style: TextStyle(
                                        color: Color(0xFF666666), fontSize: 14.rsp),),
                                  ),
                                ],
                              ),
                              items: ["残忍拒绝"],
                              listener: (index) {
                                Alert.dismiss(context);
                                controller.toggleTorchMode();

                              },
                              deleteItem: "立即授权",
                              deleteListener: () async {
                                Alert.dismiss(context);

                                bool  canUsePhoto = await PermissionTool.havePhotoPermission();

                                if (!canUsePhoto) {
                                  PermissionTool.showOpenPermissionDialog(
                                      context, "没有访问相册权限,授予权限后才能进入相册");
                                  return;
                                } else {
                                  var image =
                                  await picker.getImage(source: ImageSource.gallery);
                                  if (image == null) {
                                    controller.toggleTorchMode();
                                    return;
                                  }
                                  File cropFile = await ImageUtils.cropImage(File(image.path));
                                  if (cropFile == null) {
                                    controller.toggleTorchMode();
                                    return;
                                  }
                                  File imageFile = cropFile;


                                  final rest = await Scan.parse(image.path);

                                  if (TextUtils.isEmpty(rest)) {
                                    showError("图片识别失败...").then((v) {
                                      controller.toggleTorchMode();
                                    });
                                  } else {
                                    onScan(rest, image: imageFile);
                                  }
                                  return;
                                }
                              },
                              type: NormalTextDialogType.delete,
                            ),
                          );
                        }
                        else{


                          var image =
                              await picker.getImage(source: ImageSource.gallery);
                          if (image == null) {
                            controller.toggleTorchMode();
                            return;
                          }
                          File cropFile = await ImageUtils.cropImage(File(image.path));
                          if (cropFile == null) {
                            controller.toggleTorchMode();
                            return;
                          }


                          File imageFile = cropFile;
                          final rest = await Scan.parse(image.path);

                          if (TextUtils.isEmpty(rest)) {
                            showError("图片识别失败...").then((v) {
                              controller.toggleTorchMode();
                            });
                          } else {
                            onScan(rest, image: imageFile);
                          }
                          return;
                        }


                      },
                    ),
                    200.wb,
                    GestureDetector(
                      child:Column(
                        children: [
                          Image.asset(Assets.toolImgInput.path,color: Colors.white.withOpacity(0.6),width: 30.rw,height: 30.rw,),
                          30.hb,
                          Text('手动输入',style: TextStyle(
                              color: Colors.white.withOpacity(0.6),fontSize: 14.rsp
                          ),)
                        ],
                      ),
                      onTap: () {

                        AppRouter.pushAndReplaced(context, RouteName.BARCODE_INPUT);
                      },
                    ),
                  ],
                ),
              )),



          // Positioned(
          //   bottom: 0,
          //   child: Row(
          //     children: [
          //       ElevatedButton(
          //         child: Text(barcode),
          //         onPressed: () {
          //           controller.toggleTorchMode();
          //         },
          //       ),
          //       ElevatedButton(
          //         child: Text("pause"),
          //         onPressed: () {
          //           controller.pause();
          //         },
          //       ),
          //       ElevatedButton(
          //         child: Text("resume"),
          //         onPressed: () {
          //           controller.resume();
          //         },
          //       ),
          //
          //       ElevatedButton(
          //         child: Text("parse from image"),
          //         onPressed: () async {
          //
          //           if (Platform.isIOS) {
          //             var image =
          //             await picker.getImage(source: ImageSource.gallery);
          //             if (image == null) {
          //               controller.toggleTorchMode();
          //               return;
          //             }
          //             File cropFile = await ImageUtils.cropImage(File(image.path));
          //             if (cropFile == null) {
          //               controller.toggleTorchMode();
          //               return;
          //             }
          //             File imageFile = cropFile;
          //
          //
          //             final rest = await Scan.parse(image.path);
          //
          //             if (TextUtils.isEmpty(rest)) {
          //               showError("图片识别失败...").then((v) {
          //                 controller.toggleTorchMode();
          //               });
          //             } else {
          //               onScan(rest, image: imageFile);
          //             }
          //             return;
          //           }
          //           bool permission = await Permission.storage.isGranted;
          //           if(!permission){
          //             Alert.show(
          //               context,
          //               NormalContentDialog(
          //                 title: '需要获取相册访问权限',
          //                 content:
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     //Image.asset(R.ASSETS_LOCATION_PER_PNG,width: 44.rw,height: 44.rw,),
          //                     Expanded(
          //                       child: Text('允许访问相册图片用来扫码识别商品', style: TextStyle(
          //                           color: Color(0xFF666666), fontSize: 14.rsp),),
          //                     ),
          //                   ],
          //                 ),
          //                 items: ["残忍拒绝"],
          //                 listener: (index) {
          //                   Alert.dismiss(context);
          //                   controller.toggleTorchMode();
          //
          //                 },
          //                 deleteItem: "立即授权",
          //                 deleteListener: () async {
          //                   Alert.dismiss(context);
          //
          //                   bool  canUsePhoto = await PermissionTool.havePhotoPermission();
          //
          //                   if (!canUsePhoto) {
          //                     PermissionTool.showOpenPermissionDialog(
          //                         context, "没有访问相册权限,授予权限后才能进入相册");
          //                     return;
          //                   } else {
          //                     var image =
          //                     await picker.getImage(source: ImageSource.gallery);
          //                     if (image == null) {
          //                       controller.toggleTorchMode();
          //                       return;
          //                     }
          //                     File cropFile = await ImageUtils.cropImage(File(image.path));
          //                     if (cropFile == null) {
          //                       controller.toggleTorchMode();
          //                       return;
          //                     }
          //                     File imageFile = cropFile;
          //
          //
          //                     final rest = await Scan.parse(image.path);
          //
          //                     if (TextUtils.isEmpty(rest)) {
          //                       showError("图片识别失败...").then((v) {
          //                         controller.toggleTorchMode();
          //                       });
          //                     } else {
          //                       onScan(rest, image: imageFile);
          //                     }
          //                     return;
          //                   }
          //                 },
          //                 type: NormalTextDialogType.delete,
          //               ),
          //             );
          //           }
          //           else{
          //
          //
          //             var image =
          //             await picker.getImage(source: ImageSource.gallery);
          //             if (image == null) {
          //               controller.toggleTorchMode();
          //               return;
          //             }
          //             File cropFile = await ImageUtils.cropImage(File(image.path));
          //             if (cropFile == null) {
          //               controller.toggleTorchMode();
          //               return;
          //             }
          //
          //
          //             File imageFile = cropFile;
          //             final rest = await Scan.parse(image.path);
          //
          //             if (TextUtils.isEmpty(rest)) {
          //               showError("图片识别失败...").then((v) {
          //                 controller.toggleTorchMode();
          //               });
          //             } else {
          //               onScan(rest, image: imageFile);
          //             }
          //             return;
          //           }
          //
          //
          //         },
          //       ),
          //     ],
          //   ),
          // ),

          // QrcodeReaderView(
          //   key: _key,
          //   helpWidget: Text("请将条形码置于方框中间"),
          //   onEdit: () {
          //     AppRouter.pushAndReplaced(context, RouteName.BARCODE_INPUT);
          //   },
          //   onSelectImage: () async {
          //     _key.currentState.stopScan();
          //     if (Platform.isIOS) {
          //       var image =
          //       await picker.getImage(source: ImageSource.gallery);
          //       if (image == null) {
          //         _key.currentState.startScan();
          //         return;
          //       }
          //       File cropFile = await ImageUtils.cropImage(File(image.path));
          //       if (cropFile == null) {
          //         _key.currentState.startScan();
          //         return;
          //       }
          //       File imageFile = cropFile;
          //       final rest = await FlutterQrReader.imgScan(imageFile);
          //       if (TextUtils.isEmpty(rest)) {
          //         showError("图片识别失败...").then((v) {
          //           _key.currentState.startScan();
          //         });
          //       } else {
          //         onScan(rest, image: imageFile);
          //       }
          //       return;
          //     }
          //     bool permission = await Permission.storage.isGranted;
          //     if(!permission){
          //       Alert.show(
          //         context,
          //         NormalContentDialog(
          //           title: '需要获取相册访问权限',
          //           content:
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               //Image.asset(R.ASSETS_LOCATION_PER_PNG,width: 44.rw,height: 44.rw,),
          //               Expanded(
          //                 child: Text('允许访问相册图片用来扫码识别商品', style: TextStyle(
          //                     color: Color(0xFF666666), fontSize: 14.rsp),),
          //               ),
          //             ],
          //           ),
          //           items: ["残忍拒绝"],
          //           listener: (index) {
          //             Alert.dismiss(context);
          //             _key.currentState.startScan();
          //
          //           },
          //           deleteItem: "立即授权",
          //           deleteListener: () async {
          //             Alert.dismiss(context);
          //
          //             bool  canUsePhoto = await PermissionTool.havePhotoPermission();
          //
          //             if (!canUsePhoto) {
          //               PermissionTool.showOpenPermissionDialog(
          //                   context, "没有访问相册权限,授予权限后才能进入相册");
          //               return;
          //             } else {
          //               var image =
          //               await picker.getImage(source: ImageSource.gallery);
          //               if (image == null) {
          //                 _key.currentState.startScan();
          //                 return;
          //               }
          //               File cropFile = await ImageUtils.cropImage(File(image.path));
          //               if (cropFile == null) {
          //                 _key.currentState.startScan();
          //                 return;
          //               }
          //               File imageFile = cropFile;
          //               final rest = await FlutterQrReader.imgScan(imageFile);
          //               if (TextUtils.isEmpty(rest)) {
          //                 showError("图片识别失败...").then((v) {
          //                   _key.currentState.startScan();
          //                 });
          //               } else {
          //                 onScan(rest, image: imageFile);
          //               }
          //             }
          //           },
          //           type: NormalTextDialogType.delete,
          //         ),
          //       );
          //     }
          //     else{
          //       var image =
          //       await picker.getImage(source: ImageSource.gallery);
          //       if (image == null) {
          //         _key.currentState.startScan();
          //         return;
          //       }
          //       File cropFile = await ImageUtils.cropImage(File(image.path));
          //       if (cropFile == null) {
          //         _key.currentState.startScan();
          //         return;
          //       }
          //       File imageFile = cropFile;
          //       final rest = await FlutterQrReader.imgScan(imageFile);
          //       if (TextUtils.isEmpty(rest)) {
          //         showError("图片识别失败...").then((v) {
          //           _key.currentState.startScan();
          //         });
          //       } else {
          //         onScan(rest, image: imageFile);
          //       }
          //      }
          //   },
          //   onScan: onScan,
          //   headerWidget: AppBar(
          //     backgroundColor: Colors.transparent,
          //     elevation: 0.0,
          //   ),
          // ),


        ],
      ),
    );
  }

  Future onScan(String data, {File image}) async {
    if (!TextUtils.isEmpty(data)) {
      _playSound();
      //_key.currentState.stopScan();
      Future.delayed(Duration(milliseconds: 500), () async {
        await _getGoodsWithCode(data, image: image);
      });
    } else {
      //_key.currentState.startScan();
    }
  }

  _playSound() async {
    player.setAsset('assets/sound/recook_scan.mp3');
    player.play();
  }

  _getGoodsWithCode(String code, {File image}) async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.getScanResult, {
      "skuCode": code,
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
    // String goodsId = resultData.data['data']['goodsId'].toString();
    // if (TextUtils.isEmpty(goodsId)) {
    //   return;
    // }
    ScanResultModel scanResultModel =
        ScanResultModel.fromMap(resultData.data['data']);
    if (scanResultModel == null) {
      pushToFailPage(code, model.msg, image);
      return;
    }
    Get.off(
      () => QRScarerResultPage(
        model: scanResultModel,
      ),
    );
    return;
  }

  pushToFailPage(String code, String message, File image) {
    if (image != null) {
      AppRouter.pushAndReplaced(context, RouteName.BARCODE_PHOTOSFAIL,
          arguments: PhotosFailBarcodePage.setArguments(code, message, image));
    } else {
      AppRouter.pushAndReplaced(context, RouteName.BARCODE_FAIL,
          arguments: FailBarcodePage.setArguments(code, message));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
