import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart' as flutterImagePicker;
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/pages/user/model/return_reason_model.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/image_picker.dart';
import 'package:jingyaoyun/widgets/image_selected_view.dart';
import 'package:jingyaoyun/widgets/input_view.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:photo/photo.dart';

class RefundGoodsPage extends StatefulWidget {
  final Map arguments;
  RefundGoodsPage({Key key, this.arguments}) : super(key: key);
  static setArguments(List<int> goodsIds, List<Goods> goodsList) {
    return {"goodsIds": goodsIds, "goodsList": goodsList};
  }

  @override
  _RefundGoodsPageState createState() => _RefundGoodsPageState();
}

class _RefundGoodsPageState extends BaseStoreState<RefundGoodsPage> {
  List<Goods> _goodsList;
  List<int> _goodsIds;
  TextEditingController _reasonController;
  //TODO 可能需要不止一个TextField，此页面只有单个TextEditingController
  TextEditingController _ruiCoinController;
  List<MediaModel> _imageFiles = [];
  ReasonModel _selectReasonModel;

  @override
  void initState() {
    super.initState();
    _goodsList = widget.arguments["goodsList"];
    _goodsIds = widget.arguments["goodsIds"];
    _reasonController = TextEditingController();
    _ruiCoinController = TextEditingController(
      text: _goodsList[0].actualAmount.toStringAsFixed(2),
    );
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      bottomNavigationBar: CustomImageButton(
        title: "提交",
        height: 48 * 2.h,
        width: double.infinity,
        style: TextStyle(color: Colors.white, fontSize: 16 * 2.sp),
        backgroundColor: AppColor.themeColor,
        onPressed: () {
          FocusScope.of(globalContext).requestFocus(FocusNode());
          _return();
        },
      ),
      appBar: CustomAppBar(
        title: "订单补偿申请",
        elevation: 0,
        themeData: AppThemes.themeDataMain.appBarTheme,
      ),
      backgroundColor: AppColor.frenchColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(globalContext).requestFocus(FocusNode());
        },
        child: _buildBody(),
      ),
      // body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: <Widget>[
        _goodsListView(),
        _reasonWidget(),
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

  Container _goodsListView() {
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
                "您选择退货的商品:",
                style: AppTextStyle.generate(13 * 2.sp,
                    fontWeight: FontWeight.w500),
              )),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _goodsList.length,
              itemBuilder: (BuildContext context, int index) {
                return _goodsItem(_goodsList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  _goodsItem(Goods goods) {
    return CustomImageButton(
      onPressed: () {
        setState(() {
          goods.selected = !goods.selected;
        });
      },
      child: Container(
        height: rSize(110),
        padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: rSize(4)),
              child: CustomCacheImage(
                width: rSize(90),
                height: rSize(90),
                imageUrl: Api.getResizeImgUrl(goods.mainPhotoUrl, 80),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goods.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(
                        14 * 2.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    20.hb,
                    Container(
                      padding: EdgeInsets.only(left: 6.rw,right: 6.rw,top: 4.w,bottom: 4.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF1F6),
                        borderRadius: BorderRadius.circular(2.rw),
                      ),
                      child: Text(
                        '规格:${goods.skuName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(13 * 2.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          "支付金额",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Color(0xFF333333)),
                        ),
                        Text(
                          "￥${goods.actualAmount}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Color(0xFFDB2D2D),fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _reasonWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: rSize(10),
        right: rSize(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: rSize(10), vertical: 10 * 2.h),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "补偿金额",
                style: TextStyle(color: Colors.black, fontSize: 14 * 2.sp),
              ),
              Spacer(),
              Expanded(
                child: InputView(
                  keyboardType: TextInputType.number,
                  controller: _ruiCoinController,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  hint: '请输入金额～',
                  maxLength: 0,
                  textAlign: TextAlign.end,
                  hintStyle:
                      TextStyle(color: Color(0xff999999), fontSize: 12 * 2.sp),
                  textStyle: TextStyle(
                    color: Color(0xffdb2d2d),
                    fontSize: 14 * 2.sp,
                  ),
                ),
              ),
              // Text(
              //   _goodsList.first.goodsAmount.toStringAsFixed(2),
              //   style: TextStyle(
              //     color: Color(0xffdb2d2d),
              //     fontSize: 14*2.sp,
              //   ),
              // ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe6e6e6))),
            ),
            height: 25 * 2.h,
            child: Row(
              children: <Widget>[
                Text(
                  "实付款返还到付款账户",
                  style:
                      TextStyle(color: Color(0xff999999), fontSize: 12 * 2.sp),
                ),
                Spacer(),
                Text(
                  "最多${_goodsList.first.actualAmount.toStringAsFixed(2)}",
                  style:
                      TextStyle(color: Color(0xff999999), fontSize: 12 * 2.sp),
                ),
                15.wb,
              ],
            ),
          ),
          10.hb,
          Container(
            height: 30 * 2.h,
            child: Row(
              children: <Widget>[
                Text(
                  "补偿原因",
                  style: TextStyle(color: Colors.black, fontSize: 14 * 2.sp),
                ),
                Expanded(
                    child: InputView(
                  controller: _reasonController,
                  hint: "请填写退货原因200字以内",
                  hintStyle:
                      TextStyle(color: Color(0xff999999), fontSize: 12 * 2.sp),
                  textStyle:
                      TextStyle(color: Colors.black, fontSize: 12 * 2.sp),
                  maxLength: 200,
                  keyboardType: TextInputType.text,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  _return() async {
    if (TextUtils.isEmpty(_reasonController.text)) {
      showError("请输入退款原因!");
      return;
    }
    try {
      num rui = num.parse(_ruiCoinController.text);
    } catch (e) {
      showError("请输入正确的需要返还的瑞币");
      return;
    }
    GSDialog.of(globalContext).showLoadingDialog(globalContext, "");
    await _uploadImages();
    String images = "";
    for (MediaModel media in _imageFiles) {
      if (TextUtils.isEmpty(media.result.url)) {
        GSDialog.of(globalContext).dismiss(globalContext);
        showError("第${_imageFiles.indexOf(media) + 1}图片${media.result.msg}");
        return;
      }
      images = images + media.result.url + ",";
    }
    ResultData resultData = await HttpManager.post(OrderApi.order_refund, {
      "userId": UserManager.instance.user.info.id,
      "orderGoodsIDs": _goodsIds,
      "coin": _ruiCoinController.text,
      "reasonContent": _reasonController.text,
      "reasonImg": images
    });
    // ResultData resultData = await HttpManager.post(OrderApi.order_return, {
    //   "userId": UserManager.instance.user.info.id,
    //   "reasonContent": _selectReasonModel.id != 0 ? _selectReasonModel.content : _reasonController.text,
    //   "orderGoodsIds": _goodsIds,
    //   "reasonId": _selectReasonModel.id,
    //   "reasonImg": images,
    // });
    GSDialog.of(globalContext).dismiss(globalContext);
    if (!resultData.result) {
      GSDialog.of(globalContext).showError(globalContext, resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(globalContext).showError(globalContext, model.msg);
      return;
    }
    Toast.showInfo("申请退货成功，请等待商家审核...");
    Navigator.pop(globalContext, true);
    //pop double times
    Navigator.pop(globalContext, true);
    Navigator.pop(globalContext, true);
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
    return ImageSelectedView<Uint8List>(
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
                    maxSelected: maxImages - _imageFiles.length,
                    pickType: PickType.onlyImage)
                .pickAsset(globalContext)
                .then((List<MediaModel> medias) {
              if (medias.length == 0) return;
              // _imageFiles = medias;
              _imageFiles.addAll(medias);
              while (_imageFiles.length > maxImages) {
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

  _uploadImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _imageFiles));
    group.close();
    return group.future;
  }
}
