import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/media_model.dart';
import 'package:recook/models/media_model_hv.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/live/models/video_goods_model.dart';
import 'package:recook/pages/live/video/video_goods_page.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/image_selected_view.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook/recook_list_tile.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ReleaseMaterialPage extends StatefulWidget {
  final Map? arguments;
  static final routeName = '/ReleaseMaterialPage';

  ReleaseMaterialPage({Key? key, this.arguments}) : super(key: key);

  static setArguments({int? goodsId}) {
    return {"goodsId": goodsId};
  }

  @override
  State<StatefulWidget> createState() {
    return _ReleaseMaterialPage();
  }
}

class _ReleaseMaterialPage extends BaseStoreState<ReleaseMaterialPage> {
  String _contentText = "";
  List<MediaModel> _imageFiles = [];

  List<dynamic> _imageFilesHv = [];

  VideoGoodsModel? _goodsModel;
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();

    _contentText = HiveStore.modelBox!
            .get('${UserManager.instance!.user.info!.id}contentText') ??
        '';
    if(  HiveStore.modelBox!
        .get('${UserManager.instance!.user.info!.id}imageFiles')!=[]&&
        HiveStore.modelBox!
            .get('${UserManager.instance!.user.info!.id}imageFiles')!=null
    ){

      _imageFilesHv = HiveStore.modelBox!
          .get('${UserManager.instance!.user.info!.id}imageFiles')  ;
    }


    _imageFilesHv.forEach((element) {
      _imageFiles.add(MediaModel(
          width: element.width,
          height: element.height,
          type: element.type == 1 ? MediaType.image : MediaType.video,file: File(element.file!),thumbData: element.thumbData as Uint8List));
    });

    _textEditingController = TextEditingController(text: _contentText);
  }

//  GoodsDetailModelImpl _presenter;

  @override
  Widget buildContext(BuildContext context, {store}) {
    return WillPopScope(
      onWillPop: ()async{
        if (_contentText != '' || _imageFiles.length > 0) {
          Alert.show(
              context,
              NormalTextDialog(
                title: '提示',
                type: NormalTextDialogType.delete,
                content: '是否保留此次编辑',
                items: ["不保留"],
                listener: (index) {
                  Alert.dismiss(context);
                  HiveStore.modelBox!.delete(
                      '${UserManager.instance!.user.info!.id}contentText');
                  HiveStore.modelBox!.delete(
                      '${UserManager.instance!.user.info!.id}imageFiles');
                  Navigator.pop(context);
                },
                deleteItem: "保留",
                deleteListener: () async {
                  Alert.dismiss(context);

                  if (_contentText != '') {
                    HiveStore.modelBox!.put(
                        '${UserManager.instance!.user.info!.id}contentText',
                        _contentText);
                  }
                  _imageFilesHv = [];

                  if (_imageFiles.length > 0) {
                    _imageFiles.forEach((element) {
                      _imageFilesHv.add(MediaModelHv(
                        width: element.width,
                        height: element.height,
                        type: element.type == MediaType.image ? 1 : 2,
                        file: element.file!.path,
                        thumbData: element.thumbData,
                      ));
                    });

                    HiveStore.modelBox!.put(
                        '${UserManager.instance!.user.info!.id}imageFiles',
                        _imageFilesHv);
                  }

                  Navigator.pop(context);
                },
              ));
        } else {
          HiveStore.modelBox!.delete(
              '${UserManager.instance!.user.info!.id}contentText');
          HiveStore.modelBox!.delete(
              '${UserManager.instance!.user.info!.id}imageFiles');
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF9F9FB),
        appBar: CustomAppBar(
          title: "发布素材",
          themeData: AppThemes.themeDataGrey.appBarTheme,
          leading: CustomImageButton(
            title: "取消",
            fontSize: 16,
            onPressed: () {
              if (_contentText != '' || _imageFiles.length > 0) {
                Alert.show(
                    context,
                    NormalTextDialog(
                      title: '提示',
                      type: NormalTextDialogType.delete,
                      content: '是否保留此次编辑',
                      items: ["不保留"],
                      listener: (index) {
                        Alert.dismiss(context);
                        HiveStore.modelBox!.delete(
                            '${UserManager.instance!.user.info!.id}contentText');
                        HiveStore.modelBox!.delete(
                            '${UserManager.instance!.user.info!.id}imageFiles');
                        Navigator.pop(context);
                      },
                      deleteItem: "保留",
                      deleteListener: () async {
                        Alert.dismiss(context);

                        if (_contentText != '') {
                          HiveStore.modelBox!.put(
                              '${UserManager.instance!.user.info!.id}contentText',
                              _contentText);
                        }
                        _imageFilesHv = [];

                        if (_imageFiles.length > 0) {
                          _imageFiles.forEach((element) {
                            _imageFilesHv.add(MediaModelHv(
                              width: element.width,
                              height: element.height,
                              type: element.type == MediaType.image ? 1 : 2,
                              file: element.file!.path,
                              thumbData: element.thumbData,
                            ));
                          });

                          HiveStore.modelBox!.put(
                              '${UserManager.instance!.user.info!.id}imageFiles',
                              _imageFilesHv);
                        }

                        Navigator.pop(context);
                      },
                    ));
              } else {
                HiveStore.modelBox!.delete(
                    '${UserManager.instance!.user.info!.id}contentText');
                HiveStore.modelBox!.delete(
                    '${UserManager.instance!.user.info!.id}imageFiles');
                Navigator.pop(context);
              }
            },
          ),
          actions: <Widget>[
            CustomImageButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              title: "发布",
              color: AppColor.themeColor,
              fontSize: 16,
              onPressed: () {
                if (_contentText.isEmpty) {
                  ReToast.err(text:'请输入您的想法！');
                } else if (_goodsModel == null) {
                  ReToast.err(text:'请添加一个关联产品！');
                } else {
                  _publish();
                }
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (_, index) {
              return Column(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(rSize(8))),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      children: [
                        _input(),
                        _imageSelect(),
                      ],
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(rSize(8))),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                    child: _relationGoods(),
                  ),
                ],
              );
            }),
      ),
    );
  }

  _publish() async {
    showLoading("发布中...");
    await _uploadImages();
    Map<String, dynamic> params = {
      "userId": UserManager.instance!.user.info!.id,
      "goodsId": _goodsModel!.id,
      "text":  _contentText,
    };
    List<Map<String, dynamic>> images = [];
    for (MediaModel media in _imageFiles) {
      if (TextUtils.isEmpty(media.result!.url)) {
        showError("第${_imageFiles.indexOf(media) + 1}图片${media.result!.msg}");
        return;
      }
      images.add({
        "path": media.result!.url,
        "width": media.width,
        "height": media.height
      });
      params.addAll({"images": images});
    }

    // HttpResultModel<BaseModel> resultModel = await _presenter.getDetailMomentsCreate(params);
    // if (!resultModel.result) {
    //   showError(resultModel.msg);
    //   return;
    // }
    // showSuccess("评价成功").then((value) {
    //   Navigator.pop(context);
    // });
    GoodsDetailModelImpl.getDetailMomentsCreate(params)
        .then((HttpResultModel<BaseModel?> resultModel) {
      if (!resultModel.result) {
        showError(resultModel.msg ?? '');
        return;
      }
      showSuccess("图文发布成功，等待平台审核").then((value) {
        HiveStore.modelBox!
            .delete('${UserManager.instance!.user.info!.id}contentText');
        HiveStore.modelBox!
            .delete('${UserManager.instance!.user.info!.id}imageFiles');

        Navigator.pop(context, {'backdata': 'ImageText'});
      });
    });
  }

  _uploadImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _imageFiles));
    group.close();
    return group.future;
  }

  _input() {
    return Container(
      height: rSize(155),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                hintText: '有什么想法就和大家说说吧！',
                border: InputBorder.none,
                counterStyle:
                    AppTextStyle.generate(14 * 2.sp, color: Color(0xff999999)),
                hintStyle:
                    AppTextStyle.generate(14 * 2.sp, color: Color(0xff999999)),
              ),
              style: AppTextStyle.generate(14 * 2.sp),
              maxLength: 500,
              maxLines: 10,
              onChanged: (text) {
                _contentText = text;
              },
            ),
          ),
        ],
      ),
    );
  }

  _imageSelect() {
    return ImageSelectedView<Uint8List?>(
      padding: EdgeInsets.all(rSize(10)),
      images: _imageFiles.map((MediaModel model) {
        return model.thumbData;
      }).toList(),
      deleteListener: (index) {
        if (_imageFiles.length > index) {
          _imageFiles.removeAt(index);
          setState(() {});
        }
      },
      addListener: () {
        ActionSheet.show(context, items: ['拍照', '从手机相册选择'],
            listener: (index) async {
          ActionSheet.dismiss(context);
          if (index == 0) {
            List<AssetEntity?>? entitys = [];
            var values = await CameraPicker.pickFromCamera(context);
            entitys.add(values);

            if (entitys.isEmpty) {
              return;
            }

            for (var element in entitys) {
              File? file = await element!.file;
              Uint8List? thumbData = await element.thumbnailData;
              if (_imageFiles.length < 9) {
                _imageFiles.add(MediaModel(
                  width: element.width,
                  height: element.height,
                  type:
                      element.typeInt == 1 ? MediaType.image : MediaType.video,
                  file: file,
                  thumbData: thumbData,
                ));
              } else {
                _imageFiles.removeAt(0);
                _imageFiles.add(MediaModel(
                  width: element.width,
                  height: element.height,
                  type:
                      element.typeInt == 1 ? MediaType.image : MediaType.video,
                  file: file,
                  thumbData: thumbData,
                ));
              }
            }
            setState(() {});
          }
          if (index == 1) {
            var values = await AssetPicker.pickAssets(context,
                pickerConfig: AssetPickerConfig(
                    maxAssets:  9 - _imageFiles.length
                ));
            List<AssetEntity> entitys = [];
            if (values == null) return;
            entitys.addAll(values);
            for (var element in entitys) {
              File? file = await element.file;
              Uint8List? thumbData = await element.thumbnailData;
              _imageFiles.add(MediaModel(
                width: element.width,
                height: element.height,
                type: element.typeInt == 1 ? MediaType.image : MediaType.video,
                file: file,
                thumbData: thumbData,
              ));
            }
            while (_imageFiles.length > 9) {
              _imageFiles.removeAt(0);
            }
            print(_imageFiles.length);
            setState(() {});
          }
        });
      },
      itemBuilder: (int index, dynamic item) {
        return ExtendedImage.memory(
          item,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }

  _relationGoods() {
    return RecookListTile(
      underline: false,
      title: _goodsModel == null ? '添加关联产品' : _goodsModel!.goodsName,
      prefix: Image.asset(
        R.ASSETS_LIVE_UPLOAD_CART_PNG,
        width: rSize(16),
        height: rSize(16),
      ),
      onTap: () {
        Get.to(
          VideoGoodsPage(
            onPick: (model) {
              _goodsModel = model;
            },
          ),
        )!
            .then((value) {
          setState(() {});
        });
      },
    );
  }
}
