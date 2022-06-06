/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-22  17:14 
 * remark    : 
 * ====================================================
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/media_model.dart';
import 'package:recook/pages/store/modify_info_page.dart';
import 'package:recook/pages/user/mvp/user_presenter_impl.dart';
import 'package:recook/utils/image_utils.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/sc_tile.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
// import 'package:photo/photo.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserInfoPageState();
  }
}

class _UserInfoPageState extends BaseStoreState<UserInfoPage> {
  late UserPresenterImpl _presenter;
  List<MediaModel> _imageFiles = [];

  @override
  Widget buildContext(BuildContext context, {store}) {
    DPrint.printf("---------------------------------------- ");
    return Scaffold(
      appBar: CustomAppBar(
        title: "个人信息",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _listView(),
      backgroundColor: AppColor.frenchColor,
    );
  }

  @override
  void initState() {
    super.initState();
    _presenter = UserPresenterImpl();
  }

  _listView() {
    String gender;
    final String verified =
        UserManager.instance!.user.info!.realInfoStatus! ? "已经认证" : "未认证";
    if (UserManager.instance!.user.info!.gender == 0) {
      gender = "未填写";
    } else {
      gender = UserManager.instance!.user.info!.gender == 1 ? "男" : "女";
    }
    return ListView(
      children: <Widget>[
        SCTile.normalTile("头像",
            margin: EdgeInsets.symmetric(vertical: rSize(10)),
            trailing:
            ClipRRect(
              borderRadius: BorderRadius.circular(30.rw),
              child: FadeInImage.assetNetwork(
                height: 60.rw,
                width: 60.rw,
                placeholder: Assets.icon.icLauncherPlaystore.path,
                image: TextUtils.isEmpty(
                    UserManager.instance!.user.info!.headImgUrl)
                    ? ""
                    : Api.getImgUrl(
                    UserManager.instance!.user.info!.headImgUrl)!,
              ),
            ),
           listener: () {
          _chooseHeader();
        }),
        SCTile.normalTile("昵称",
            value: UserManager.instance!.user.info!.nickname,
            needDivide: true, listener: () {

            push(RouteName.MODIFY_DETAIL_PAGE,
                arguments: ModifyInfoPage.setArguments(
                    "修改昵称", UserManager.instance!.user.info!.nickname,
                    maxLength: 10))
                .then((value) {
              if (value != null) {
                _updateUserNickname(value as String);
              }
            });


        }),
        SCTile.normalTile(
          "用户ID",
          value: UserManager.instance!.indentifier,
          needDivide: true,
          listener: null,
          needArrow: false,
        ),
        SCTile.normalTile("性别", value: gender, needDivide: true, listener: () {
          ActionSheet.show(globalContext!, items: ["男", "女"],
              listener: (int index) {
            pop();
            _updateGender(index + 1);
          });
        }),
        SCTile.normalTile("生日",
            value: TextUtils.isEmpty(UserManager.instance!.user.info!.birthday)
                ? "未选择"
                : UserManager.instance!.user.info!.birthday!.substring(0, 10),
            needDivide: true, listener: () {
          DateTime currentTime = DateTime.now();
          if (!TextUtils.isEmpty(UserManager.instance!.user.info!.birthday)) {
            String birthday = UserManager.instance!.user.info!.birthday!;
            currentTime = DateTime(
                int.parse(birthday.substring(0, 4)),
                int.parse(birthday.substring(5, 7)),
                int.parse(birthday.substring(8, 10)));
          }

          DatePicker.showDatePicker(globalContext!,
              showTitleActions: true,
              theme: DatePickerTheme(
                  cancelStyle:
                      AppTextStyle.generate(15 * 2.sp, color: Colors.grey),
                  doneStyle: AppTextStyle.generate(15 * 2.sp,
                      color: AppColor.themeColor),
                  itemStyle: AppTextStyle.generate(15 * 2.sp)),
              minTime: DateTime(1970, 01, 01),
              maxTime: DateTime.now(),
              currentTime: currentTime,
              locale: LocaleType.zh, onConfirm: (DateTime date) {
            String time = date.toString().split("-").join("");
            _updateBirthday(time.substring(0, 8), date.toString());
          });
        }),
        SCTile.normalTile("实名认证", value: verified, needDivide: true,
            listener: () {
          if (UserManager.instance!.user.info!.realInfoStatus!) {
            return;
          }
          AppRouter.push(
            context,
            RouteName.USER_VERIFY,
          );
        }),
        // SCTile.normalTile("地址", value: UserManager.instance.user.info.addr, needDivide: true,
        //     listener: () {
        //       if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master) {
        //         showError('店主无法修改地址!');
        //         return;
        //       }
        //       push(RouteName.USER_INFO_ADDRESS_PAGE,
        //               arguments:
        //                   UserInfoAddressPage.setArguments("修改地址", UserManager.instance.user.info.addr, maxLength: 300))
        //           .then((value) {
        //         if (value != null) {
        //           _updateAddress(value);
        //         }
        //       });
        // }),
        SCTile.normalTile("手机号",
            value: UserManager.instance!.user.info!.phone,
            needDivide: true, listener: () {
          push(RouteName.MODIFY_DETAIL_PAGE,
                  arguments: ModifyInfoPage.setArguments(
                      "修改手机号", UserManager.instance!.user.info!.phone,
                      maxLength: 11))
              .then((value) {
            if (value != null) {
              _updatePhone(value as String);
            }
          });
        }),
        // SCTile.normalTile("微信号",
        //     value: UserManager.instance.user.info.wechatNo,
        //     needDivide: true, listener: () {
        //   push(RouteName.MODIFY_DETAIL_PAGE,
        //           arguments: ModifyInfoPage.setArguments(
        //               "修改微信号", UserManager.instance.user.info.wechatNo,
        //               maxLength: 100))
        //       .then((value) {
        //     if (value != null) {
        //       _updateWechatNo(value);
        //     }
        //   });
        // }),

        //
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Shop||
            UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical||
            UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary?SCTile.normalTile("我的推广码", needDivide: true, listener: () {
                push(RouteName.USER_INFO_QRCODE_PAGE);
              }):SizedBox(),
             // SCTile.normalTile(
             //    "我的邀请码",
             //    value: UserManager.instance.user.info.invitationNo,
             //    needDivide: true,
             //    needArrow: false,
             //    trailing: Row(
             //      children: [
             //        (UserManager.instance.user.info.invitationNo)
             //            .text
             //            .color(Color(0xFF666666))
             //            .size(14.rsp)
             //            .make(),
             //        5.wb,
             //        Icon(
             //          Icons.copy,
             //          size: 18.rsp,
             //          color: Color(0xFF999999),
             //        ),
             //      ],
             //    ),
             //    listener: () async {
             //      await Clipboard.setData(
             //        ClipboardData(
             //            text: UserManager.instance.user.info.invitationNo),
             //      );
             //      showToast('已经复制到粘贴板');
             //    },
             //  ),
      ],
    );
  }

  _chooseHeader() {
    // ActionSheet.show(context, items: ['拍照', '从手机相册选择'], listener: (index) {
    //   ActionSheet.dismiss(context);
    //   if (index == 0) {
    //     ImagePick.builder()
    //         .pickImage(
    //       source: flutterImagePicker.ImageSource.camera,
    //     )
    //         .then((MediaModel media) {
    //       if (media == null) {
    //         return;
    //       }
    //       _upload(media.file);
    //     });
    //   }
    //   if (index == 1) {
    //     ImagePick.builder(maxSelected: 1, pickType: PickType.onlyImage)
    //         .pickAsset(globalContext)
    //         .then((List<MediaModel> medias) {
    //       if (medias.length > 0) {
    //         _upload(medias[0].file);
    //       }
    //     });
    //   }
    // });


    ActionSheet.show(context, items: ['拍照', '从手机相册选择'], listener: (index) async{
      Get.back();
      if (index == 0) {
        List<AssetEntity?> entitys = [];
        var values = await CameraPicker.pickFromCamera(context);
        entitys.add(values);
        if (entitys == null) {
          return;
        }
        for (var element in entitys) {
          File? file = await element!.file;
          Uint8List? thumbData = await element.thumbData;
          _imageFiles.clear();

          _imageFiles.add(MediaModel(
              width: element.width,
              height: element.height,
              type: element.typeInt == 1 ? MediaType.image : MediaType.video,
              file: file,
              thumbData: thumbData,
            ));

        }
        _upload(_imageFiles[0].file!);



      }
      if (index == 1) {
        var values = await AssetPicker.pickAssets(context, maxAssets: 1);
        List<AssetEntity> entitys = [];
        if (values == null) return;
        entitys.addAll(values);
        for (var element in entitys) {
          File? file = await element.file;
          Uint8List? thumbData = await element.thumbData;
          _imageFiles.clear();
          _imageFiles.add(MediaModel(
            width: element.width,
            height: element.height,
            type: element.typeInt == 1 ? MediaType.image : MediaType.video,
            file: file,
            thumbData: thumbData,
          ));
        }
        _upload(_imageFiles[0].file!);


      }
    });

  }

  _upload(File file) async {
    showLoading("");
    File? cropFile = await ImageUtils.cropImage(file);
    if (cropFile == null) {
      showError("已取消...");
      return;
    }
    UploadResult result = await HttpManager.uploadFile(
        url: CommonApi.upload, file: cropFile, key: "photo");
    if (!result.result) {
      showError(result.msg??'');
      return;
    }
    HttpResultModel resultModel = await _presenter.updateHeaderPic(
        UserManager.instance!.user.info!.id, result.url);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    dismissLoading();
    setState(() {
      UserManager.instance!.user.info!.headImgUrl = result.url;
    });
    print(UserManager.instance!.user.info!.headImgUrl);
    UserManager.updateUserInfo(getStore());
  }

  _updateUserNickname(String nickname) async {
    HttpResultModel resultModel = await _presenter.updateUserNickname(
        UserManager.instance!.user.info!.id, nickname);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.nickname = nickname;
    });
    UserManager.updateUserInfo(getStore());
  }

  _updateBirthday(String birthday, String originBirth) async {
    HttpResultModel resultModel = await _presenter.updateBirthday(
        UserManager.instance!.user.info!.id, birthday);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.birthday = originBirth.substring(0, 10);
    });
    UserManager.updateUserInfo(getStore());
  }

  _updateGender(int gender) async {
    HttpResultModel resultModel = await _presenter.updateGender(
        UserManager.instance!.user.info!.id, gender);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.gender = gender;
    });
    UserManager.updateUserInfo(getStore());
  }

  _updateAddress(String address) async {
    HttpResultModel resultModel = await _presenter.updateAddress(
        UserManager.instance!.user.info!.id, address);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.addr = address;
    });
    UserManager.updateUserInfo(getStore());
  }

  _updateWechatNo(String wechatNo) async {
    HttpResultModel resultModel = await _presenter.updateWechatNo(
        UserManager.instance!.user.info!.id, wechatNo);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.wechatNo = wechatNo;
    });
    UserManager.updateUserInfo(getStore());
  }

  _updatePhone(String phone) async {
    HttpResultModel resultModel =
        await _presenter.updatePhone(UserManager.instance!.user.info!.id, phone);
    if (!resultModel.result) {
      showError(resultModel.msg??'');
      return;
    }
    setState(() {
      UserManager.instance!.user.info!.phone = phone;
    });
    UserManager.updateUserInfo(getStore());
  }
}
