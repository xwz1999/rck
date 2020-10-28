import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/agreements/live_agreement_page.dart';
import 'package:recook/pages/live/live_stream/live_page.dart';
import 'package:recook/pages/live/models/live_resume_model.dart';
import 'package:recook/pages/live/widget/live_attention_button.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/alert.dart';

checkStartLive(BuildContext context, BuildContext fatherContext) {
  if (!UserManager.instance.user.info.realInfoStatus) {
    showToast('未实名，请先实名');
    AppRouter.push(
      context,
      RouteName.USER_VERIFY,
      arguments: {},
    );
  } else {
    PermissionTool.haveCameraPermission().then((value) {
      PermissionTool.haveAudioPermission().then((value) {
        GSDialog.of(context).showLoadingDialog(context, '加载中');
        HttpManager.post(LiveAPI.getLiveInfo, {}).then((resultData) {
          GSDialog.of(context).dismiss(context);
          LiveResumeModel model =
              LiveResumeModel.fromJson(resultData.data['data']);
          //第一次直播
          if (model.isFirst == 1) {
            showDialog(
                context: context,
                child: NormalContentDialog(
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
                            onTap: () {
                              CRoute.push(context, LiveAgreementPage());
                            },
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
                    Navigator.pop(context);
                    HttpManager.post(LiveAPI.liveAgree, {}).then((result) {
                      print(result);
                    });
                    CRoute.pushReplace(context, LivePage());
                  },
                  listener: (index) {
                    switch (index) {
                      case 0:
                        Navigator.pop(context);
                        break;
                    }
                  },
                ));
          } else if (model.liveItemId == 0)
            CRoute.pushReplace(context, LivePage());
          else {
            Navigator.pop(context);
            showDialog(
              context: context,
              child: NormalTextDialog(
                title: '有未完成的直播间',
                content: '',
                items: ['结束直播', '继续直播', '开始新直播'],
                listener: (index) {
                  Navigator.pop(fatherContext);
                  switch (index) {
                    case 0:
                      HttpManager.post(LiveAPI.exitLive, {
                        'liveItemId': model.liveItemId,
                      });
                      break;
                    case 1:
                      CRoute.push(
                          fatherContext,
                          LivePage(
                            resumeLive: true,
                            model: model,
                          ));
                      break;
                    case 2:
                      HttpManager.post(LiveAPI.exitLive, {
                        'liveItemId': model.liveItemId,
                      }).then((_) {
                        CRoute.pushReplace(context, LivePage());
                      });
                      break;
                  }
                },
              ),
            );
          }
        });
      });
    });
  }
}

showLiveChild(
  BuildContext context, {
  @required String title,
  @required String headImg,
  @required num fans,
  @required num follows,
  @required int id,
  @required bool initAttention,
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
