/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-29  16:24 
 * remark    : 
 * ====================================================
 */

import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as flutterImagePicker;
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/pages/user/order/publish_evaluation_page.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/image_picker.dart';
import 'package:jingyaoyun/widgets/image_selected_view.dart';
import 'package:jingyaoyun/widgets/input_view.dart';
import 'package:photo/photo.dart';

class EvaluationItem extends StatefulWidget {
  final EvaluationModel evaluationModel;
  final int maxSelectImage;
  const EvaluationItem({Key key, this.evaluationModel, this.maxSelectImage = 9})
      : super(key: key);

  @override
  _EvaluationItemState createState() => _EvaluationItemState();
}

class _EvaluationItemState extends BaseStoreState<EvaluationItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _buildContainer();
  }

  _buildContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          _topTitle(),
          _input(),
          ImageSelectedView<Uint8List>(
            maxImages: widget.maxSelectImage,
            padding: EdgeInsets.all(rSize(10)),
            images: widget.evaluationModel.imageFiles.map((MediaModel media) {
              return media.thumbData;
            }).toList(),
            deleteListener: (index) {
              if (widget.evaluationModel.imageFiles.length > index) {
                widget.evaluationModel.imageFiles.removeAt(index);
                setState(() {});
              }
            },
            addListener: () {
              ActionSheet.show(context, items: ['拍照', '从手机相册选择'],
                  listener: (index) {
                ActionSheet.dismiss(context);
                if (index == 0) {
                  ImagePicker.builder()
                      .pickImage(
                          source: flutterImagePicker.ImageSource.camera,
                          cropImage: false)
                      .then((MediaModel media) {
                    if (media == null) {
                      return;
                    }
                    if (widget.evaluationModel.imageFiles.length < 9) {
                      widget.evaluationModel.imageFiles.add(media);
                    } else {
                      widget.evaluationModel.imageFiles.removeAt(0);
                      widget.evaluationModel.imageFiles.add(media);
                    }
                    setState(() {});
                  });
                }
                if (index == 1) {
                  ImagePicker.builder(
                          maxSelected: widget.maxSelectImage -
                              widget.evaluationModel.imageFiles.length,
                          pickType: PickType.onlyImage)
                      .pickAsset(globalContext)
                      .then((List<MediaModel> medias) {
                    if (medias.length == 0) return;
                    // _imageFiles = medias;
                    widget.evaluationModel.imageFiles.addAll(medias);
                    while (widget.evaluationModel.imageFiles.length >
                        widget.maxSelectImage) {
                      widget.evaluationModel.imageFiles.removeAt(0);
                    }
                    setState(() {});
                  });
                }
              });
              // ImagePicker.builder(maxSelected: widget.maxSelectImage).pickAsset(globalContext).then((List<MediaModel> medias) {
              //   if (medias.length == 0) return;
              //   setState(() {
              //     widget.evaluationModel.imageFiles = medias;
              //   });
              // });
            },
            itemBuilder: (int index, dynamic item) {
              return ExtendedImage.memory(
                item,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          Container(
            height: rSize(8),
            color: AppColor.tableViewGrayColor,
          )
        ],
      ),
    );
  }

  Container _topTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(10)),
      height: rSize(56),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey[400], width: 0.4 * 2.w),
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomCacheImage(
            width: rSize(35),
            height: rSize(35),
            imageUrl: Api.getImgUrl(widget.evaluationModel.goods.mainPhotoUrl),
          ),
          SizedBox(
            width: rSize(8),
          ),
          Expanded(
            child: Text(
              widget.evaluationModel.goods.goodsName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.generate(14 * 2.sp),
            ),
          ),
        ],
      ),
    );
  }

  _input() {
    return Container(
      height: rSize(100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: InputView(
              padding: EdgeInsets.symmetric(
                  vertical: rSize(7), horizontal: rSize(7)),
              maxLines: 5,
              textStyle: AppTextStyle.generate(14 * 2.sp),
              hintStyle:
                  AppTextStyle.generate(14 * 2.sp, color: Colors.grey[300]),
              hint: "请输入评价",
              onValueChanged: (text) {
                widget.evaluationModel.content = text;
              },
            ),
          ),
        ],
      ),
    );
  }
}
