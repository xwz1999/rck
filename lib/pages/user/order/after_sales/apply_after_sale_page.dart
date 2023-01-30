import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/media_model.dart';
import 'package:recook/pages/user/model/return_reason_model.dart';
import 'package:recook/pages/user/order/after_sales/apply_fail_page.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/image_selected_view.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/numberic_button.dart';
import 'package:recook/widgets/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';


class ApplyAfterSalePage extends StatefulWidget {
  const ApplyAfterSalePage({Key? key}) : super(key: key);

  @override
  _ApplyAfterSalePageState createState() => _ApplyAfterSalePageState();
}

class _ApplyAfterSalePageState extends State<ApplyAfterSalePage> {

  TextEditingController? _reasonController;
  List<MediaModel> _imageFiles = [];
  //ReturnReasonModel? _returnReasonModel;

  List<ReasonModel> _returnReasonList = [];

  List<AfterSaleType> _afterSaleTypeList = [];
  AfterSaleType? _selectAfterSaleType;

  ReasonModel? _selectReasonModel;

  @override
  void initState() {
    super.initState();
    _getReturnReasons();

    _reasonController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "申请售后",
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.only(
                top: rSize(8), right: rSize(10), left: rSize(8)),
            title: "提交",
            color: Colors.black,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _return();
            },
          )
        ],
      ),
      backgroundColor: AppColor.frenchColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        _returnNum(),
        _returnType(),
        _returnReasons(),
        _selectImageWidget(),
        SafeArea(
          child: SizedBox(
            height: rSize(10),
          ),
          bottom: true,
        )
      ],
    );
  }


  _returnNum() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(10)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showSelectType(_selectAfterSaleType);
            },
            child: _numWidget(),
          ),
        ],
      ),
    );
  }

  _numWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "售后数量",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.black)),
                    TextSpan(
                        text: "*",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: AppColor.themeColor)),
                  ]),
                ),
              ),
              Spacer(),
              NumberPickerButton(
                onChange: (int value) {  },
                initValue: 0,

              )


            ]));
  }




  _selectReasonWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "售后原因",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.black)),
                    TextSpan(
                        text: "*",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: AppColor.themeColor)),
                  ]),
                ),
              ),
              Spacer(),
              Text(
                  _selectReasonModel == null
                      ? "选择原因"
                      : _selectReasonModel!.content!,
                  style: AppTextStyle.generate(14 * 2.sp,
                      color: _selectReasonModel != null
                          ? Colors.black
                          : Colors.grey)),
              Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: _selectReasonModel != null ? Colors.black : Colors.grey,
              )
            ]));
  }


  _selectTypeWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "售后类型",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.black)),
                    TextSpan(
                        text: "*",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: AppColor.themeColor)),
                  ]),
                ),
              ),
              Spacer(),
              Text(
                  _selectAfterSaleType == null
                      ? "选择类型"
                      : _selectAfterSaleType!.name!,
                  style: AppTextStyle.generate(14 * 2.sp,
                      color: _selectAfterSaleType != null
                          ? Colors.black
                          : Colors.grey)),
              Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: _selectAfterSaleType != null ? Colors.black : Colors.grey,
              )
            ]));
  }

  Container _reasonView() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 6),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "其他原因",
                    style:
                    AppTextStyle.generate(14 * 2.sp, color: Colors.black)),
                TextSpan(
                    text: "*",
                    style: AppTextStyle.generate(14 * 2.sp,
                        color: AppColor.themeColor)),
                TextSpan(
                    text: ":",
                    style:
                    AppTextStyle.generate(14 * 2.sp, color: Colors.black)),
              ]),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              child: InputView(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                textAlign: TextAlign.start,
                maxLines: 3,
                maxLength: 50,
                hint: "请填写退货原因200字以内",
                controller: _reasonController,
                hintStyle:
                AppTextStyle.generate(14 * 2.sp, color: Colors.grey[400]),
                textStyle: AppTextStyle.generate(
                  14 * 2.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  _getReturnReasons() async {
    ReasonModel otherModel = ReasonModel(id: 0, content: "其他");

    ReasonModel otherModel1 = ReasonModel(id: 1, content: "质量问题");

    _returnReasonList.add(otherModel);
    _returnReasonList.add(otherModel1);

    _afterSaleTypeList.add(AfterSaleType(id: 1,name: '退货'));
    _afterSaleTypeList.add(AfterSaleType(id: 2,name: '申请补偿'));

  }

  _return() async {

    Get.to(()=>ApplyFailPage(
      title: "抱歉，无法发起售后申请，原因："
          "该商品已超过售后期",
      height: 500,
    ),);

    if (_selectReasonModel == null) {
      Toast.showError("请选择退货原因");
      return;
    }
    if (TextUtils.isEmpty(_reasonController!.text) &&
        _selectReasonModel!.id == 0) {
      Toast.showInfo("请填写退货原因");
      return;
    }

    // ReToast.loading(text: '');
    // await _uploadImages();
    // String images = "";
    // for (MediaModel media in _imageFiles) {
    //   if (TextUtils.isEmpty(media.result!.url)) {
    //     BotToast.closeAllLoading();
    //     showError("第${_imageFiles.indexOf(media) + 1}图片${media.result!.msg}");
    //     return;
    //   }
    //   images = images + media.result!.url! + ",";
    // }

  }

  _selectImageWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: rSize(8), left: rSize(8)),
              child: Text(
                "上传凭证",
                style: AppTextStyle.generate(13 * 2.sp,
                    fontWeight: FontWeight.w500),
              )),
          _imageSelect()
        ],
      ),
    );
  }

  _imageSelect() {
    int maxImages = 5;
    return ImageSelectedView<Uint8List?>(
      maxImages: maxImages,
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
        ActionSheet.show(context, items: ['拍照', '从手机相册选择'], listener: (index) async{
          ActionSheet.dismiss(context);
          if (index == 0) {
            List<AssetEntity?> entitys = [];
            var values = await CameraPicker.pickFromCamera(context);
            entitys.add(values);

            for (var element in entitys) {
              File? file = await element!.file;
              Uint8List? thumbData = await element.thumbnailData;
              if (_imageFiles.length < maxImages) {
                _imageFiles.add(MediaModel(
                  width: element.width,
                  height: element.height,
                  type: element.typeInt == 1 ? MediaType.image : MediaType.video,
                  file: file,
                  thumbData: thumbData,
                ));
              } else {
                _imageFiles.removeAt(0);
                _imageFiles.add(MediaModel(
                  width: element.width,
                  height: element.height,
                  type: element.typeInt == 1 ? MediaType.image : MediaType.video,
                  file: file,
                  thumbData: thumbData,
                ));
              }

            }
            setState(() {});
          }
          if (index == 1) {
            var values = await AssetPicker.pickAssets(context, pickerConfig: AssetPickerConfig(
                maxAssets:  maxImages-_imageFiles.length
            ) );
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
            while (_imageFiles.length > maxImages) {
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

  _returnReasons() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(10)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showSelectReason(_selectReasonModel);
            },
            child: _selectReasonWidget(),
          ),
          // _selectReasonWidget(),
          _selectReasonModel != null && _selectReasonModel!.id == 0
              ? Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            color: Colors.grey[300],
            height: 0.5,
          )
              : Container(),
          _selectReasonModel != null && _selectReasonModel!.id == 0
              ? _reasonView()
              : Container()
        ],
      ),
    );
  }

  _showSelectReason(ReasonModel? model) async {
    if (_returnReasonList.isEmpty) {
      await _getReturnReasons();
    }
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              constraints:
              BoxConstraints(maxHeight: DeviceInfo.screenHeight! * 0.3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(rSize(8)))),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          vertical: rSize(8), horizontal: rSize(10)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "请选择退货原因:",
                            style: AppTextStyle.generate(14 * 2.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          CustomImageButton(
                            icon: Icon(
                              AppIcons.icon_delete,
                              size: rSize(18),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _returnReasonList.length,
                        itemBuilder: (_, index) {
                          return CustomImageButton(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 0.5))),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  vertical: rSize(10), horizontal: 10),
                              child: Text(
                                _returnReasonList[index].content!,
                                style: AppTextStyle.generate(rSize(15)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                // _expressCompany = _expressCompanies[index];
                                _selectReasonModel =
                                _returnReasonList[index];
                              });
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }




  _returnType() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(10)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(rSize(8)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showSelectType(_selectAfterSaleType);
            },
            child: _selectTypeWidget(),
          ),
          _selectAfterSaleType != null && _selectAfterSaleType!.id == 0
              ? Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            color: Colors.grey[300],
            height: 0.5,
          )
              : Container(),
        ],
      ),
    );
  }


  _showSelectType(AfterSaleType? model) async {
    if (_returnReasonList.isEmpty) {
      await _getReturnReasons();
    }
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              constraints:
              BoxConstraints(maxHeight: DeviceInfo.screenHeight! * 0.3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(rSize(8)))),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          vertical: rSize(8), horizontal: rSize(10)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "选择类型:",
                            style: AppTextStyle.generate(14 * 2.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          CustomImageButton(
                            icon: Icon(
                              AppIcons.icon_delete,
                              size: rSize(18),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _afterSaleTypeList.length,
                        itemBuilder: (_, index) {
                          return CustomImageButton(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 0.5))),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  vertical: rSize(10), horizontal: 10),
                              child: Text(
                                _afterSaleTypeList[index].name!,
                                style: AppTextStyle.generate(rSize(15)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectAfterSaleType =
                                _afterSaleTypeList[index];
                              });
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }



  _uploadImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _imageFiles));
    group.close();
    return group.future;
  }

}



class AfterSaleType{
  int? id;
  String? name;
  AfterSaleType({this.id, this.name});
}
