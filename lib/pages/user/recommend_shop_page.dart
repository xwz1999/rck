import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/daos/user_dao.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/pages/user/recommend_records_page.dart';
import 'package:jingyaoyun/pages/user/widget/recook_check_box.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/image_picker.dart';
import 'package:jingyaoyun/widgets/image_selected_view.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:photo/photo.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:jingyaoyun/widgets/text_button.dart' as TButton;
import 'package:image_picker/image_picker.dart' as flutterImagePicker;

import 'package:async/async.dart';

import 'package:jingyaoyun/manager/http_manager.dart';


class RecommendShopPage extends StatefulWidget {
  RecommendShopPage({
    Key key,
  }) : super(key: key);

  @override
  _RecommendShopPageState createState() => _RecommendShopPageState();
}


class _RecommendShopPageState extends State<RecommendShopPage>{
  TextEditingController _textEditController;
  String phoneText = '';
  String address = '';

  bool isYun = false;
  bool isEntity = false;

  TextEditingController _smsCodeController;

  TextEditingController _addressCodeController;

  FocusNode _smsCodeNode;
  FocusNode _phoneNode;

  FocusNode _addressCodeNode;
  String _errorMsg = "";
  Timer _timer;
  String _countDownStr = "???????????????";
  int _countDownNum = 59;
  bool _getCodeEnable = false;
  bool _cantSelected = false;
  bool _sendEnable = false;
  List<MediaModel> _licenseFiles = [];
  String _licenseImages = '';

  List<MediaModel> _storeFiles = [];
  String _storeImages = '';

  @override
  void initState() {
    super.initState();
    _textEditController = TextEditingController();
    _smsCodeController = TextEditingController();
    _addressCodeController = TextEditingController();
    _addressCodeNode = FocusNode();
    _smsCodeNode = FocusNode();
    _phoneNode = FocusNode();
}

  @override
  void dispose() {
    _textEditController.dispose();
    _smsCodeController.dispose();
    _addressCodeController.dispose();
    _phoneNode.dispose();
    _smsCodeNode.dispose();
    _addressCodeNode.dispose();
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
          "????????????",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
        actions: [
          CustomImageButton(
            title: "????????????",
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: 14 * 2.sp,
            onPressed: () async {
                Get.to(RecommendRecordsPage());
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.rw,right: 20.rw),
        child: _bodyWidget(),
      ),
    );
  }


  _bodyWidget() {
    return ListView(
      children: [
        50.hb,
        '?????????????????????'.text.size(16.rsp).color(Color(0xFF333333)).make(),
        30.hb,
        _phoneText(),
        30.hb,
        '?????????'.text.size(16.rsp).color(Color(0xFF333333)).make(),
        30.hb,
        Row(
          children: [
            GestureDetector(
              child: Container(
                child: Row(
                  children: [
                    RecookCheckBox(state: isYun,),
                    5.wb,
                    '?????????'.text.size(14.rsp).color(Color(0xFF333333)).make(),
                  ],
                ),
                color: Colors.transparent,

              ),
              onTap: (){
                isYun = !isYun;
                isEntity = false;
                setState(() {

                });
              },
            ),
            200.wb,

            UserLevelTool.currentRoleLevelEnum() ==UserRoleLevel.physical?GestureDetector(
              child: Container(
                child: Row(
                  children: [
                    RecookCheckBox(state: isEntity,),
                    5.wb,
                    '????????????'.text.size(14.rsp).color(Color(0xFF333333)).make(),
                  ],
                ),
                color: Colors.transparent,

              ),
              onTap: (){
                isEntity = !isEntity;
                isYun = false;
                setState(() {

                });
              },
            ):SizedBox()
          ],
        ),
        30.hb,
        isEntity?'????????????'.text.size(16.rsp).color(Color(0xFF333333)).make():SizedBox(),
        isEntity?30.hb:SizedBox(),
        isEntity?_addressText():SizedBox(),
        isEntity?30.hb:SizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '?????????'.text.size(16.rsp).color(Color(0xFF333333)).make(),
            24.hb,
            _smsCode(),
          ],
        ),
        isEntity?30.hb:SizedBox(),
        isEntity?'????????????'.text.size(16.rsp).color(Color(0xFF333333)).make():SizedBox(),
        isEntity?30.hb:SizedBox(),
        isEntity?_imageSelect(_licenseFiles):SizedBox(),
        isEntity?30.hb:SizedBox(),
        isEntity?'????????????'.text.size(16.rsp).color(Color(0xFF333333)).make():SizedBox(),
        isEntity?30.hb:SizedBox(),
        isEntity?_imageSelect(_storeFiles):SizedBox(),




        100.hb,
        TButton.TextButton(
          height: 40.rw,
          title: " ???????????? ",
          textColor: Colors.white,
          unableBackgroundColor: Colors.grey[300],
          font: 17 * 2.sp,
          enable: _sendEnable,
         // margin: EdgeInsets.symmetric(horizontal: 20.rw),
          padding: EdgeInsets.symmetric(vertical: rSize(7.rw)),
          radius: BorderRadius.all(Radius.circular(18.rw)),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            if(RegexUtil.isMobileSimple(phoneText)&&(isEntity||isYun)){
              Alert.show(
                context,
                NormalContentDialog(
                  title: '????????????',
                  content:'??????????????????{$phoneText}???'.richText.withTextSpanChildren([
                    (isEntity?'[????????????]':'[?????????]').textSpan.color(Color(0xFFD5101A)).make(),
                  ]).size(14.rsp).color(Color(0xFF333333)).make(),
                  items: ["??????"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "??????",
                  deleteListener: () async{

                    Alert.dismiss(context);
                    _publish();
                  },
                  type: NormalTextDialogType.delete,
                ),
              );
            }else{

              if(!(isEntity||isYun)){
                ReToast.warning(text:'????????????????????????');
              }else{
                ReToast.warning(text:'?????????????????????');
              }

            }
          },
        ),



      ],

    );
  }

  Container _phoneText() {
    return Container(
      // margin:
      // EdgeInsets.only(top: 10.rw, right: 20.rw, left: 20.rw),
      height: 40.rw,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3.rw))),
      child: TextField(
        controller: _textEditController,
        focusNode: _phoneNode,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
        inputFormatters: [
          LengthLimitingTextInputFormatter(11),
        ],

        cursorColor: Colors.black,
        onChanged: (String phone) {
          setState(() {
            phoneText = phone;
            if (phone.length >= 11) {
              _getCodeEnable = true;
              _sendEnable = _verifyLoginEnable();
            } else {
              _errorMsg = "";
              _getCodeEnable = false;
              _sendEnable = false;
            }
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: 10.rw,top: 5.rw, bottom: _phoneNode.hasFocus?5.rw:15.rw),
            border: InputBorder.none,
            hintText: "??????????????????",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14 * 2.sp),
            suffixIcon: _clearButton(_textEditController, _phoneNode)),
      ),
    );
  }

  ///????????????
  Container _addressText() {
    return Container(
      // margin:
      // EdgeInsets.only(top: 10.rw, right: 20.rw, left: 20.rw),
      height: 40.rw,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3.rw))),
      child: TextField(
        controller: _addressCodeController,
        focusNode: _addressCodeNode,

        style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),

        cursorColor: Colors.black,
        onChanged: (String text) {
          setState(() {
            address = text;
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: 10.rw,top: 5.rw, bottom: _addressCodeNode.hasFocus?5.rw:15.rw),
            border: InputBorder.none,
            hintText: "???????????????????????????",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14 * 2.sp),
            suffixIcon: _clearButton(_addressCodeController, _addressCodeNode)),
      ),
    );
  }


  /// ?????????
  Container _smsCode() {
    return Container(
      height: 40.rw,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (text) {
                setState(() {
                  _sendEnable = _verifyLoginEnable();
                });
              },
              controller: _smsCodeController,
              focusNode: _smsCodeNode,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: 10.rw,top: 5.rw, bottom: _smsCodeNode.hasFocus?5.rw:15.rw),
                  border: InputBorder.none,
                  hintText: "??????????????????",
                  hintStyle:
                  TextStyle(color: Colors.grey[400], fontSize: 14 * 2.sp),
                  suffixIcon: _clearButton(_smsCodeController, _smsCodeNode)),
            ),
          ),
          TButton.TextButton(
            title: _countDownStr,
            width: rSize(120),
            textColor: Color(0xFFD5101A),
            enable: _getCodeEnable,
            font: 15 * 2.sp,
            unableTextColor: Color(0xFFBBBBBB),
            highlightTextColor: Color(0xFFD5101A),
            border: Border(left: BorderSide(color: Colors.grey[500])),
            onTap: () {

                if (!TextUtils.verifyPhone(_textEditController.text)) {
                  Toast.showError("???????????????????????????!");
                  return;
                }
                if (_cantSelected) return;
                _cantSelected = true;
                Future.delayed(Duration(seconds: 2), () {
                  _cantSelected = false;
                });
                GSDialog.of(context).showLoadingDialog(context, "????????????..");
                _getSmsCode(context);

            },
          ),
        ],
      ),
    );
  }

  IconButton _clearButton(TextEditingController controller, FocusNode node) {
    return node.hasFocus
        ? IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          AppIcons.icon_clear,
          size: 17 * 2.sp,
          color: Colors.grey[300],
        ),
        onPressed: () {
          controller.clear();
        })
        : null;
  }

  _beginCountDown() {
    setState(() {
      _getCodeEnable = false;
      _countDownStr = "????????????($_countDownNum)";
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer == null || !mounted) {
        return;
      }
      setState(() {
        if (_countDownNum == 0) {
          _countDownNum = 59;
          _countDownStr = "???????????????";
          _getCodeEnable = true;
          _timer.cancel();
          _timer = null;
          return;
        }
        _countDownStr = "????????????(${_countDownNum--})";
      });
    });
  }

  _verifyLoginEnable() {
    if (!TextUtils.verifyPhone(_textEditController.text)) {
      setState(() {
        _errorMsg = "????????????????????????,?????????";
      });
      return false;
    }
    return _smsCodeController.text.length == 4;
  }

  /*
    ???????????????
   */
  _getSmsCode(_content) {
    UserDao.sendCode(phoneText, success: (data, code, msg) {
      GSDialog.of(_content).dismiss(_content);
      Toast.showSuccess("???????????????????????????????????????");
      _beginCountDown();
      FocusScope.of(_content).requestFocus(_smsCodeNode);
    }, failure: (code, error) {
      GSDialog.of(_content).dismiss(_content);
      Toast.showError(error);
    });
  }


  _imageSelect(List<MediaModel> list) {
    return ImageSelectedView<Uint8List>(
      padding: EdgeInsets.only(right: 50.rw),
      maxImages: 3,
      crossAxisCount: 3,
      crossAxisSpacing: 8.rw,
      images: list.map((MediaModel model) {
        return model.thumbData;
      }).toList(),
      deleteListener: (index) {
        if (list.length > index) {
          list.removeAt(index);
          setState(() {});
        }
      },
      addListener: () {
        ActionSheet.show(context, items: ['??????', '?????????????????????'], listener: (index) {
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
              if (list.length < 3) {
                list.add(media);
              } else {
                list.removeAt(0);
                list.add(media);
              }
              setState(() {});
            });
          }
          if (index == 1) {
            ImagePicker.builder(
                maxSelected: 3 - list.length,
                pickType: PickType.onlyImage)
                .pickAsset(context)
                .then((List<MediaModel> medias) {
              if (medias.length == 0) return;
              // _imageFiles = medias;
              list.addAll(medias);
              while (list.length > 3) {
                list.removeAt(0);
              }
              setState(() {});
            });
          }
        });
      },
      itemBuilder: (int index, dynamic item) {
        return Container(
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(8.rw)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ExtendedImage.memory(

            item,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,

          ),
        );
      },
    );
  }





  _publish() async {
    final cancel =  ReToast.loading(text:'?????????...');

    ResultData result ;
    if(isEntity){
      await _uploadLicenseImages();
      await _uploadStoreImages();

      for (MediaModel media in _licenseFiles) {
        if (TextUtils.isEmpty(media.result.url)) {
          ReToast.err(text:"???${_licenseFiles.indexOf(media) + 1}??????${media.result.msg}");
          return;
        }
        if(media !=_licenseFiles[_licenseFiles.length
            -1]){
          _licenseImages+=(media.result.url+';');
        }else{
          _licenseImages+=(media.result.url);
        }

      }

      for (MediaModel media in _storeFiles) {
        if (TextUtils.isEmpty(media.result.url)) {
          ReToast.err(text:"???${_storeFiles.indexOf(media) + 1}??????${media.result.msg}");
          return;
        }
        if(media !=_storeFiles[_storeFiles.length
            -1]){
          _storeImages+=(media.result.url+';');
        }else{
          _storeImages+=(media.result.url);
        }
      }
      result  =   await   WholesaleFunc.recommendUser(2,phoneText,address,_licenseImages,_storeImages,_smsCodeController.text);
    }else{
      result  =   await   WholesaleFunc.recommendUser(1,phoneText,'','','',_smsCodeController.text);
    }

    cancel();
    if(result.data['code']!='FAIL'){
      ReToast.success(text:'????????????');
      _smsCodeController.text = '';
      _textEditController.text = '';
      _addressCodeController.text = '';
      _phoneNode.unfocus();
      _addressCodeNode.unfocus();
      _smsCodeNode.unfocus();
       isYun = false;
       isEntity = false;
      _licenseFiles = [];
       _licenseImages = '';
      _storeFiles = [];
       _storeImages = '';
      setState(() {

      });
      Get.to(RecommendRecordsPage());
    }else{
      ReToast.err(text:result.data['msg']);
    }
  }

  _uploadLicenseImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _licenseFiles));
    group.close();
    return group.future;
  }

  _uploadStoreImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _storeFiles));
    group.close();
    return group.future;
  }


}