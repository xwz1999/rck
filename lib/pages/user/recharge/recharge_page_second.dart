import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as flutterImagePicker;
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/media_model.dart';
import 'package:jingyaoyun/pages/user/functions/user_balance_func.dart';
import 'package:jingyaoyun/pages/user/recharge/recharge_page_third.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_customer_page.dart';
import 'package:jingyaoyun/utils/amount_format.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/action_sheet.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/image_picker.dart';
import 'package:jingyaoyun/widgets/image_selected_view.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:photo/photo.dart';



class RechargePageSecond extends StatefulWidget {
  RechargePageSecond({
    Key key,
  }) : super(key: key);

  @override
  _RechargePageSecondState createState() => _RechargePageSecondState();
}

class _RechargePageSecondState extends State<RechargePageSecond>
    with TickerProviderStateMixin {
  TextEditingController _amountTextEditController;
  FocusNode _amountContentFocusNode = FocusNode();
  List<MediaModel> _licenseFiles = [];
  String _licenseImages = '';
  bool isElectronics = true;
  bool isPaper = false;
  String _amount = '';
  String logistics = '';

  String logisticsNumber = '';

  @override
  void initState() {
    super.initState();
    _amountTextEditController = TextEditingController();

  }

  @override
  void dispose() {
    _amountTextEditController?.dispose();
    _amountContentFocusNode?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF3A3842),
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          appBackground: Color(0xFF3A3842),
          leading: RecookBackButton(
            white: true,
          ),
          elevation: 0,
          title: Text(
            "预存款充值",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.rsp,
            ),
          ),
        ),
        body: _bodyWidget());
  }

  _bodyWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          child: Container(
            padding: EdgeInsets.only(top: 12.rw, bottom: 12.rw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.rw),
                  topRight: Radius.circular(8.rw)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.wb,
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icRechargeRed.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "银行汇款",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGotoRed.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icRechargeRed.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "充值申请",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep3.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "平台审核",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep4.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "打款到账",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                32.wb,
              ],
            ),
          ),
        ),
        Container(
          child: Stack(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: new Container(
                    color: Colors.white.withOpacity(0.1),
                    width: double.infinity,
                    height: 56.rw,
                  ),
                ),
              ),
              Container(
                height: 56.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    32.wb,
                    Text(
                      "如有疑问，点击联系客服",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.rsp,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                        WholesaleCustomerModel model =
                        await WholesaleFunc.getCustomerInfo();

                        Get.to(() => WholesaleCustomerPage(
                          model: model,
                        ));
                      },
                      child: Container(
                        height: 32.rw,
                        width: 32.rw,
                        padding: EdgeInsets.all(7.rw),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.rw)),
                        child: Image.asset(
                          Assets.icKefu.path,
                          width: 18.rw,
                          height: 18.rw,
                        ),
                      ),
                    ),
                    32.wb,
                  ],
                ),
              ),
            ],
          ),
        ),
        20.hb,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Container(
            width: double.infinity,
            height: 136.rw,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw),
                  child: Text(
                    "充值金额",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.rsp,
                    ),
                  ),
                ),
                30.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "¥",
                        style: TextStyle(
                          color: Color(0xFFD5101A),
                          fontSize: 24.rsp,
                        ),
                      ),
                      // Text(
                      //   TextUtils.getCount1(
                      //       (UserManager.instance.userBrief.balance ?? 0.0)),
                      //   style: TextStyle(
                      //     color: Color(0xFFD5101A),
                      //     fontSize: 36.rsp,
                      //   ),
                      // ),
                      Expanded(
                        child: CupertinoTextField(
                          keyboardType:
                              TextInputType.numberWithOptions(signed: true),
                          inputFormatters: [AmountFormat()],
                          controller: _amountTextEditController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_submitted) {
                            _amountContentFocusNode.unfocus();
                            setState(() {});
                          },
                          focusNode: _amountContentFocusNode,
                          onChanged: (text) {
                            _amount = text;
                            setState(() {});
                          },
                          placeholderStyle: TextStyle(
                              color: Color(0xffcccccc),
                              fontSize: 20.rsp,
                              fontWeight: FontWeight.w300),
                          decoration:
                              BoxDecoration(color: Colors.white.withAlpha(0)),
                          style: TextStyle(
                              color: Color(0xFFD5101A),
                              fontSize: 30.rsp,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.ideographic),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Color(0xFFEEEEEE),
                  height: 2.rw,
                  indent: 16.rw,
                  endIndent: 16.rw,
                ),
                20.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw),
                  child: Text(
                    "请与汇款金额填写一致",
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        40.hb,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.rw),
          child: Container(
            width: double.infinity,
            height: 136.rw,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.rw)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw),
                  child: Text(
                    "汇款凭证",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.rsp,
                    ),
                  ),
                ),
                30.hb,
                Padding(
                  padding: EdgeInsets.only(left: 16.rw,right: 16.rw),
                  child:_imageSelect(_licenseFiles),
                ),

              ],
            ),
          ),
        ),


        72.hb,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rw,
          ),
          child: GestureDetector(
            onTap: () async {
              if(_amount.isEmpty){
                ReToast.err(text:'请先输入充值金额');
              } else{
                final cancel =  ReToast.loading(text:'提交中...');
                await _uploadLicenseImages();
                for (MediaModel media in _licenseFiles) {
                  if (TextUtils.isEmpty(media.result.url)) {
                    ReToast.err(text:"第${_licenseFiles.indexOf(media) + 1}图片${media.result.msg}");
                    return;
                  }
                  if(media !=_licenseFiles[_licenseFiles.length
                      -1]){
                    _licenseImages+=(media.result.url+';');
                  }else{
                    _licenseImages+=(media.result.url);
                  }

                }
                ResultData result ;
                result = await UserBalanceFunc.depositRecharge(double.parse(_amount),_licenseImages);
                cancel();

                if(result.data['code']!='FAIL'){
                  ReToast.success(text:'提交成功');
                  Get.back();
                  Get.back();
                  Get.to(()=>RechargePageThird(amount: '¥'+TextUtils.getCount1((double.parse(_amount)  ??
                      0.0)), time: DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd HH:mm:ss'),
                    licenseFiles: _licenseImages,

                  ));
                }else{
                  ReToast.err(text:result.data['msg']);
                }
              }



            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 36.rw,
              decoration: BoxDecoration(
                  color: Color(0xFFD5101A),
                  borderRadius: BorderRadius.circular(18.rw)),
              child: Text(
                '提 交 申 请',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.rsp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _imageSelect(List<MediaModel> list) {
    return ImageSelectedView<Uint8List>(
      padding: EdgeInsets.only(right: 60.rw),
      maxImages: 3,
      crossAxisCount: 3,
      crossAxisSpacing: 10.rw,
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

  _uploadLicenseImages() async {
    FutureGroup group = FutureGroup();
    group.add(HttpManager.uploadFiles(medias: _licenseFiles));
    group.close();
    return group.future;
  }

}
