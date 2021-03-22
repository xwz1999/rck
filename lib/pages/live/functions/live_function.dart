import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/agreements/live_agreement_page.dart';
import 'package:recook/pages/live/live_stream/live_page.dart';
import 'package:recook/pages/live/models/live_resume_model.dart';
import 'package:recook/pages/live/widget/live_attention_button.dart';
import 'package:recook/pages/user/user_verify.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/progress/re_toast.dart';

Future<bool> _checkLiveAgreement() async {
  return Get.dialog(NormalContentDialog(
    title: '瑞库客直播服务申明',
    type: NormalTextDialogType.delete,
    deleteItem: '同意授权',
    items: ['以后再说'],
    content: ExtendedText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '为更好地维护平台直播环境，维护广大用户的权益，请您在操作前务必审慎阅读并充分理解',
            style: TextStyle(
              color: Color(0xFF333333),
            ),
          ),
          ExtendedWidgetSpan(
            child: InkWell(
              splashColor: Colors.blue.withOpacity(0.2),
              child: Text(
                '《瑞库客直播服务申明》',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onTap: () => Get.to(LiveAgreementPage()),
            ),
          ),
          TextSpan(
            text: '的各项规定。',
            style: TextStyle(
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    ),
    deleteListener: () {
      Get.back(result: true);
    },
    listener: (_) => Get.back(),
  ));
}

checkStartLive() async {
  if (!UserManager.instance.user.info.realInfoStatus) {
    showToast('未实名，请先实名');
    await Get.to(VerifyPage());
    return;
  }

  //check camera and audio permission
  bool cameraPerm = await PermissionTool.haveCameraPermission();
  bool audioPerm = await PermissionTool.haveAudioPermission();
  if (!cameraPerm || !audioPerm) {
    ReToast.err(text: '请打开相机权限或录音权限以开始直播');
    return;
  }
  final cancel = ReToast.loading(text: '加载中');

  //get live info
  ResultData resultData = await HttpManager.post(LiveAPI.getLiveInfo, {});
  cancel();
  LiveResumeModel model = LiveResumeModel.fromJson(resultData.data['data']);
  //第一次直播验证
  if (model.isFirst == 1) {
    bool liveAgreementAgree = await _checkLiveAgreement();
    if (liveAgreementAgree) {
      HttpManager.post(LiveAPI.liveAgree, {});
      Get.to(LivePage());
    }
    return;
  }
  if (model.liveItemId == 0) {
    Get.back();
    Get.to(LivePage());
    return;
  }
  Get.back();
  await Get.dialog(NormalTextDialog(
    title: '有未完成的直播间',
    content: '',
    items: ['结束直播', '继续直播', '开始新直播'],
    listener: (index) {
      Get.back();
      switch (index) {
        case 0:
          HttpManager.post(LiveAPI.exitLive, {
            'liveItemId': model.liveItemId,
          });
          break;
        case 1:
          Get.to(LivePage(
            resumeLive: true,
            model: model,
          ));

          break;
        case 2:
          HttpManager.post(LiveAPI.exitLive, {
            'liveItemId': model.liveItemId,
          }).then((_) {
            Get.to(LivePage());
          });
          break;
      }
    },
  ));
}

showLiveChild(
  BuildContext context, {
  @required String title,
  @required String headImg,
  @required num fans,
  @required num follows,
  @required int id,
  @required bool initAttention,
  Function(bool state) callback,
}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  SizedBox(height: rSize(52), width: rSize(80)),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -rSize(40),
                    child: Container(
                      height: rSize(80),
                      width: rSize(80),
                      padding: EdgeInsets.all(rSize(2)),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(rSize(76)),
                        child: FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(headImg),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(rSize(40)),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: rSP(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              rHBox(8),
              Text(
                '粉丝数 $fans｜关注 $follows',
                style: TextStyle(
                  color: Color(0xB3333333),
                  fontSize: rSP(14),
                ),
              ),
              rHBox(24),
              id == UserManager.instance.user.info.id
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: rSize(33),
                        vertical: rSize(24),
                      ),
                      child: LiveAttentionButton(
                        initAttention: initAttention,
                        filled: true,
                        height: rSize(40),
                        width: rSize(300),
                        onAttention: (oldState) {
                          callback(!oldState);
                          HttpManager.post(
                            oldState ? LiveAPI.cancelFollow : LiveAPI.addFollow,
                            {'followUserId': id},
                          );
                        },
                      ),
                    ),
            ],
          ),
          color: Colors.white,
        );
      });
}
