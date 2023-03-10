import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/live/activity/activity_preview_page.dart';
import 'package:jingyaoyun/pages/live/functions/user_live_func.dart';
import 'package:jingyaoyun/pages/live/models/activity_list_model.dart';
import 'package:jingyaoyun/pages/live/models/live_base_info_model.dart';
import 'package:jingyaoyun/pages/live/widget/review_child_cards.dart';
import 'package:jingyaoyun/pages/live/widget/user_base_card.dart';
import 'package:jingyaoyun/pages/user/user_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/utils/date/recook_date_util.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/recook/recook_like_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:oktoast/oktoast.dart';

class UserActivityCard extends StatefulWidget {
  final ActivityListModel model;
  final LiveBaseInfoModel userModel;
  final bool initAttention;
  final GSRefreshController controller;
  UserActivityCard({
    Key key,
    @required this.model,
    @required this.userModel,
    @required this.initAttention,
    this.controller,
  }) : super(key: key);

  @override
  _UserActivityCardState createState() => _UserActivityCardState();
}

class _UserActivityCardState extends State<UserActivityCard> {
  int get imgSize {
    if (widget.model.imgList == null) {
      return 0;
    } else {
      return widget.model.imgList.length;
    }
  }

  int get axisCount {
    if (imgSize == 1)
      return 1;
    else if (imgSize <= 4)
      return 2;
    else
      return 3;
  }

  @override
  Widget build(BuildContext context) {
    final recookDateUtil = RecookDateUtil.fromString(widget.model.updatedAt);

    return UserBaseCard(
      date: recookDateUtil.prefixDay,
      detailDate: recookDateUtil.detailDate,
      children: [
        Container(
          padding: EdgeInsets.only(top: 3.rw),
          child: Row(
            children: [
              Spacer(),
              widget.model.passStatus == 0
                  ? Text(
                      '???????????????',
                      style: TextStyle(
                        color: Color(0xFFFF6F00),
                        fontSize: rSP(14),
                      ),
                    )
                  : widget.model.passStatus == 1
                      ? Text(
                          '????????????',
                          style: TextStyle(
                            color: Color(0xFF12B631),
                            fontSize: rSP(14),
                          ),
                        )
                      : widget.model.passStatus == 2
                          ? GestureDetector(
                              onTap: () {
                                Alert.show(
                                    context,
                                    NormalTextDialog(
                                      title: '??????',
                                      content: widget.model.trendType == 1
                                          ? '??????????????????????????????????????????????????????'
                                          : '?????????????????????????????????????????????????????????',
                                      items: ["??????"],
                                      type: NormalTextDialogType.remind,
                                      listener: (index) {
                                        Alert.dismiss(context);
                                      },
                                    ));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '????????????',
                                    style: TextStyle(
                                      color: Color(0xFFCF3D35),
                                      fontSize: rSP(14),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 3.rw),
                                    child: Icon(
                                      Icons.help_outline,
                                      size: 10.rw,
                                      color: Color(0xFFCF3D35),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Text(
                              '???????????????',
                              style: TextStyle(
                                color: Color(0xFFFF6F00),
                                fontSize: rSP(14),
                              ),
                            ),
              20.wb,
            ],
          ),
        ),
        SizedBox(height: rSize(35)),
        GestureDetector(
          onTap: () {
            CRoute.push(
              context,
              ActivityPreviewPage(
                model: widget.model,
                userModel: widget.userModel,
              ),
            );
          },
          child: Builder(builder: (context) {
            if (widget.model.trendType == 1)
              return widget.model.imgList.isEmpty
                  ? SizedBox()
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: axisCount,
                        crossAxisSpacing: rSize(9),
                        mainAxisSpacing: rSize(9),
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      children: widget.model.imgList
                          .map((e) => FadeInImage.assetNetwork(
                                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                image: Api.getImgUrl(e.url),
                              ))
                          .toList(),
                      shrinkWrap: true,
                    );
            else if (widget.model.trendType == 2)
              return Stack(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                    image: Api.getImgUrl(widget.model.short.coverUrl),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      alignment: Alignment.center,
                      child: Image.asset(
                        R.ASSETS_LIVE_VIDEO_PLAY_PNG,
                        height: rSize(34),
                        width: rSize(34),
                      ),
                    ),
                  ),
                ],
              );
            else
              return SizedBox();
          }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: rSize(10),
          ),
          child: Text(
            widget.model.content,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
            ),
          ),
        ),
        Container(
          color: Color(0xFFF2F4F7),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(widget.model.goods.mainPhotoURL),
                height: rSize(48),
                width: rSize(48),
              ),
              SizedBox(width: rSize(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.goods.name,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Text(
                      '??${widget.model.goods.price}',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                  ],
                ),
              ),
              CustomImageButton(
                child: Image.asset(
                  R.ASSETS_HOME_PAGE_ROW_SHARE_ICON_PNG,
                  width: rSize(18),
                  height: rSize(18),
                ),
                onPressed: () {},
              ),
              SizedBox(width: rSize(10)),
            ],
          ),
        ),
        Row(
          children: [
            CustomImageButton(
              padding: EdgeInsets.only(top: rSize(10)),
              child: Container(
                width: 40.rw,
                height: 18.rw,
                alignment: Alignment.center,
                child: Container(
                  //padding: EdgeInsets.only(bottom: 5.rw),
                  child: Text(
                    '??????',
                    style: TextStyle(
                        color: Color(0xFFDB2D2D),
                        fontSize: 12.rsp,
                        height: 1.2),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.rw)),
                  border: Border.all(color: Color(0xFFDB2D2D), width: 1.rw),
                ),
              ),
              onPressed: () {
                Alert.show(
                    context,
                    NormalTextDialog(
                      title: '??????',
                      content: '????????????????????????',
                      items: ["??????"],
                      type: NormalTextDialogType.delete,
                      deleteItem: '??????',
                      deleteListener: () async {
                        Alert.dismiss(context);
                        String code =
                            await UserLiveFunc.delImageOrVideo(widget.model.id);
                        if (code == 'SUCCESS') {
                          ReToast.success(text: '????????????');
                          widget.controller.requestRefresh();
                        } else {
                          ReToast.success(text: '????????????');
                        }
                      },
                      listener: (index) {
                        Alert.dismiss(context);
                      },
                    ));
              },
            ),
            Spacer(),
            CustomImageButton(
              padding: EdgeInsets.only(top: rSize(10)),
              child: Image.asset(
                R.ASSETS_LIVE_REVIEW_PNG,
                width: rSize(18),
                height: rSize(18),
              ),
              onPressed: _showReviewDialog,
            ),
            SizedBox(width: rSize(10)),
            Padding(
              padding: EdgeInsets.only(top: rSize(10)),
              child: RecookLikeButton(
                initValue: widget.model.isPraise == 1,
                size: 18,
                onChange: (oldState) {
                  if (UserManager.instance.haveLogin)
                    HttpManager.post(
                      oldState ? LiveAPI.dislikeActivity : LiveAPI.likeActivity,
                      {'trendId': widget.model.id},
                    );
                  else {
                    showToast('????????????????????????');
                    CRoute.push(context, UserPage());
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  _showReviewDialog() {
    if (UserManager.instance.haveLogin)
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.55),
        barrierLabel: '',
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final value = Curves.easeInOutCubic.transform(animation.value);
          return Transform.translate(
            offset: Offset(0, (1 - value) * 400),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ReviewChildCards(trendId: widget.model.id);
        },
      );
    else {
      showToast('????????????????????????');
      CRoute.push(context, UserPage());
    }
  }
}
