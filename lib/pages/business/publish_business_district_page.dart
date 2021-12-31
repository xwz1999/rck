/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  4:15 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image_picker/image_picker.dart' as flutterImagePicker;
import 'package:photo/photo.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/image_picker.dart';
import 'package:jingyaoyun/widgets/image_selected_view.dart';
import 'package:jingyaoyun/widgets/input_view.dart';

class PublishBusinessDistrictPage extends StatefulWidget {
  final Map arguments;
  PublishBusinessDistrictPage({Key key, this.arguments}) : super(key: key);
  static setArguments({int goodsId}) {
    return {"goodsId": goodsId};
  }

  @override
  State<StatefulWidget> createState() {
    return _PublishBusinessDistrictPageState();
  }
}

class _PublishBusinessDistrictPageState
    extends BaseStoreState<PublishBusinessDistrictPage> {
  String _contentText = "";
  List<MediaModel> _imageFiles = [];
//  GoodsDetailModelImpl _presenter;

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "发布素材",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        leading: CustomImageButton(
          title: "取消",
          fontSize: 16,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            title: "发布",
            color: AppColor.themeColor,
            fontSize: 16,
            onPressed: () {
              _publish();
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (_, index) {
            return Column(
              children: <Widget>[
                _input(),
                _imageSelect(),
              ],
            );
          }),
    );
  }

  _publish() async {
    showLoading("发布中...");
    await _uploadImages();
    Map<String, dynamic> params = {
      "userId": UserManager.instance.user.info.id,
      "goodsId": widget.arguments["goodsId"],
      "text": _contentText == null ? "" : _contentText,
    };
    List<Map<String, dynamic>> images = [];
    for (MediaModel media in _imageFiles) {
      if (TextUtils.isEmpty(media.result.url)) {
        showError("第${_imageFiles.indexOf(media) + 1}图片${media.result.msg}");
        return;
      }
      images.add({
        "path": media.result.url,
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
        .then((HttpResultModel<BaseModel> resultModel) {
      if (!resultModel.result) {
        showError(resultModel.msg);
        return;
      }
      showSuccess("图文发布成功，等待平台审核").then((value) {
        Navigator.pop(context);
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
      height: rSize(100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: InputView(
              maxLength: 200,
              padding: EdgeInsets.symmetric(
                  vertical: rSize(7), horizontal: rSize(7)),
              maxLines: 5,
              textStyle: AppTextStyle.generate(14 * 2.sp),
              hintStyle:
                  AppTextStyle.generate(14 * 2.sp, color: Colors.grey[300]),
              hint: "请输入评价",
              onValueChanged: (text) {
                _contentText = text;
              },
            ),
          ),
        ],
      ),
    );
  }

  _imageSelect() {
    return ImageSelectedView<Uint8List>(
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
        ActionSheet.show(context, items: ['拍照', '从手机相册选择'], listener: (index) {
          ActionSheet.dismiss(context);
          if (index == 0) {
            ImagePicker.builder()
                .pickImage(
              source: flutterImagePicker.ImageSource.camera,
              cropImage: false,
            )
                .then((MediaModel media) {
              if (media == null) {
                return;
              }
              if (_imageFiles.length < 9) {
                _imageFiles.add(media);
              } else {
                _imageFiles.removeAt(0);
                _imageFiles.add(media);
              }
              setState(() {});
            });
          }
          if (index == 1) {
            ImagePicker.builder(
                    maxSelected: 9 - _imageFiles.length,
                    pickType: PickType.onlyImage)
                .pickAsset(globalContext)
                .then((List<MediaModel> medias) {
              if (medias.length == 0) return;
              // _imageFiles = medias;
              _imageFiles.addAll(medias);
              while (_imageFiles.length > 9) {
                _imageFiles.removeAt(0);
              }
              setState(() {});
            });
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
}
