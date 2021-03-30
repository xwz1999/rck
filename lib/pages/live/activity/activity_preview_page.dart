import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:oktoast/oktoast.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/live/models/activity_list_model.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/sub_page/topic_page.dart';
import 'package:recook/pages/live/widget/live_user_bar.dart';
import 'package:recook/pages/live/widget/network_file_video.dart';
import 'package:recook/pages/live/widget/review_child_cards.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_like_button.dart';

class ActivityPreviewPage extends StatefulWidget {
  final ActivityListModel model;
  final LiveBaseInfoModel userModel;
  final PageController controller;
  final int page;
  ActivityPreviewPage({
    Key key,
    @required this.model,
    @required this.userModel,
    this.controller, this.page,
  }) : super(key: key);

  @override
  _ActivityPreviewPageState createState() => _ActivityPreviewPageState();
}

class _ActivityPreviewPageState extends State<ActivityPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: widget.model.trendType == 1 ? _buildImages() : _buildVideo(),
          ),

          ///bottom bar
          Positioned(
            bottom: rSize(15),
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: rSize(15),
              ),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      AppRouter.push(context, RouteName.COMMODITY_PAGE,
                          arguments: CommodityDetailPage.setArguments(
                              widget.model.goods.id));
                    },
                    child: Container(
                      width: rSize(110),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(rSize(4)),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Material(
                                      color: AppColor.frenchColor,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                        image: Api.getImgUrl(
                                          widget.model.goods.mainPhotoURL,
                                        ),
                                        width: rSize(110),
                                        height: rSize(110),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: rSize(8)),
                                        child: Text(
                                          widget.model.goods.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          rHBox(3),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¥',
                                style: TextStyle(
                                  fontSize: rSP(10),
                                  color: Color(0xFFC92219),
                                ),
                              ),
                              Text(
                                widget.model.goods.price,
                                style: TextStyle(
                                  fontSize: rSP(14),
                                  color: Color(0xFFC92219),
                                ),
                              ),
                            ],
                          ),
                          rHBox(3),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(rSize(4)),
                      ),
                    ),
                  ),
                  // CustomImageButton(
                  //   onPressed: () {},
                  //   child: Image.asset(
                  //     R.ASSETS_LIVE_VIDEO_SHARE_PNG,
                  //     height: rSize(20),
                  //     width: rSize(20),
                  //   ),
                  // ),
                  // rWBox(22),
                  rWBox(15),
                  Expanded(
                    child: Container(
                      height: rSize(130),
                      child: ExtendedText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.model.content,
                              style: TextStyle(
                                color: Color(0xFFE4E4E4),
                                fontSize: rSP(14),
                              ),
                            ),
                            ExtendedWidgetSpan(
                              child: InkWell(
                                onTap: () {
                                  CRoute.push(
                                      context,
                                      TopicPage(
                                          topicId: widget.model.topicId,
                                          initAttention: false));
                                },
                                child: TextUtil.isEmpty(widget.model.topicName)
                                    ? SizedBox()
                                    : Text(
                                        '#${widget.model.topicName}',
                                        style: TextStyle(
                                          color: Color(0xFFEB8A49),
                                          fontSize: rSP(14),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  rWBox(15),
                  Column(
                    children: [
                      CustomImageButton(
                        onPressed: () {
                          if (UserManager.instance.haveLogin)
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.55),
                              barrierLabel: '',
                              transitionBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final value = Curves.easeInOutCubic
                                    .transform(animation.value);
                                return Transform.translate(
                                  offset: Offset(0, (1 - value) * 400),
                                  child: child,
                                );
                              },
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return ReviewChildCards(
                                    trendId: widget.model.id);
                              },
                            );
                          else {
                            showToast('未登陆，请先登陆');
                            CRoute.push(context, UserPage());
                          }
                        },
                        child: Image.asset(
                          R.ASSETS_LIVE_VIDEO_COMMENT_PNG,
                          height: rSize(20),
                          width: rSize(20),
                        ),
                      ),
                      rHBox(22),
                      RecookLikeButton(
                        initValue: widget.model.isPraise == 1,
                        likePath: R.ASSETS_LIVE_VIDEO_LIKE_PNG,
                        size: rSize(20),
                        onChange: (oldState) {
                          if (UserManager.instance.haveLogin)
                            HttpManager.post(
                              oldState
                                  ? LiveAPI.dislikeActivity
                                  : LiveAPI.likeActivity,
                              {'trendId': widget.model.id},
                            );
                          else {
                            showToast('未登陆，请先登陆');
                            CRoute.push(context, UserPage());
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + rSize(15),
            left: rSize(15),
            right: rSize(15),
            child: Row(
              children: [
                LiveUserBar(
                  initAttention: widget.userModel.userId ==
                          UserManager.instance.user.info.id
                      ? true
                      : widget.model.isFollow == 1,
                  onAttention: () {
                    HttpManager.post(
                      LiveAPI.addFollow,
                      {'followUserId': widget.userModel.userId},
                    );
                    showToast('关注成功');
                  },
                  title: widget.userModel.nickname,
                  subTitle: '点赞数 ${widget.userModel.praise}',
                  avatar: widget.userModel.headImgUrl,
                ),
                Spacer(),
                CustomImageButton(
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: rSize(18),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo() {
    return NetworkFileVideo(
      path: widget.model.short.mediaUrl,
      pageController: widget.controller,
      page: widget.page,
    );
  }

  _buildImages() {
    return PageView.builder(
      itemBuilder: (context, index) {
        return FadeInImage.assetNetwork(
          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
          image: Api.getImgUrl(widget.model.imgList[index].url),
        );
      },
      itemCount: widget.model.imgList.length,
    );
  }
}
