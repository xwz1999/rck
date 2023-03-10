import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/live/models/live_base_info_model.dart';
import 'package:jingyaoyun/pages/live/num_tool/live_num_tool.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_attention_page.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_fans_page.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_home/user_activity_view.dart';
import 'package:jingyaoyun/pages/live/sub_page/user_support_page.dart';
import 'package:jingyaoyun/pages/live/widget/live_attention_button.dart';
import 'package:jingyaoyun/pages/live/widget/sliver_bottom_persistent_delegate.dart';
import 'package:jingyaoyun/pages/user/user_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/recook_indicator.dart';
import 'package:oktoast/oktoast.dart';

class UserHomePage extends StatefulWidget {
  final int userId;
  final bool initAttention;
  UserHomePage({Key key, @required this.userId, this.initAttention = false})
      : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  LiveBaseInfoModel model = LiveBaseInfoModel.zero();
  bool get selfFlag => widget.userId == UserManager.instance.user.info.id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    HttpManager.post(LiveAPI.baseInfo, {
      'findUserId': widget.userId,
    }).then((resultData) {
      if (resultData?.data['data'] != null) {
        setState(() {
          model = LiveBaseInfoModel.fromJson(resultData.data['data']);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, isScroll) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              leading: RecookBackButton(),
              centerTitle: true,
              title: Text(
                selfFlag ? '????????????' : 'TA?????????',
                style: TextStyle(
                  color: Color(0xFF333333),
                ),
              ),
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: rSize(162.0 + 44),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Padding(
                  padding: EdgeInsets.fromLTRB(
                      rSize(15), rSize(80), rSize(15), rSize(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(rSize(54 / 2.0)),
                            child: FadeInImage.assetNetwork(
                              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                              image: Api.getImgUrl(model.headImgUrl),
                              height: rSize(54),
                              width: rSize(54),
                            ),
                          ),
                          SizedBox(width: rSize(10)),
                          Expanded(
                            child: Text(
                              model.nickname,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: rSP(18),
                              ),
                            ),
                          ),
                         LiveAttentionButton(
                                  filled: true,
                                  rounded: false,
                                  initAttention: widget.initAttention,
                                  width: rSize(68),
                                  height: rSize(30),
                                  onAttention: (bool oldState) {
                                    if (UserManager.instance.haveLogin)
                                      HttpManager.post(
                                        oldState
                                            ? LiveAPI.cancelFollow
                                            : LiveAPI.addFollow,
                                        {'followUserId': model.userId},
                                      );
                                    else {
                                      showToast('????????????????????????');
                                      CRoute.push(context, UserPage());
                                    }
                                  },
                                ),
                        ],
                      ),
                      rHBox(20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rSize(70),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildVerticalView(
                              '??????',
                              model.follows,
                              onTap: () => CRoute.push(
                                context,
                                UserAttentionPage(id: widget.userId),
                              ),
                            ),
                            _buildVerticalView(
                              '??????',
                              model.fans,
                              onTap: () {
                                Get.to(UserFansPage(id: widget.userId));
                              },
                            ),
                            _buildVerticalView(
                              '??????',
                              model.praise,
                              onTap: () {
                                Get.to(UserSupportPage(id: widget.userId));

                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 0,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverBottomPersistentDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF333333),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.symmetric(
                    horizontal: rSize(18),
                  ),
                  indicator: RecookIndicator(
                      borderSide: BorderSide(
                    color: Color(0xFFDB2D2D),
                    width: rSize(3),
                  )),
                  tabs: [
                    Tab(text: '??????'),
                    Tab(text: '????????????'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Material(
          color: Colors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              UserActivityView(
                id: widget.userId,
                userModel: model,
                initAttention: selfFlag ? true : widget.initAttention,
                onRefresh: () {
                  HttpManager.post(LiveAPI.baseInfo, {
                    'findUserId': widget.userId,
                  }).then((resultData) {
                    if (resultData?.data['data'] != null) {
                      setState(() {
                        model =
                            LiveBaseInfoModel.fromJson(resultData.data['data']);
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalView(String title, int number, {VoidCallback onTap}) {
    return CustomImageButton(
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            getParseNum(number),
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: rSize(6)),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: rSP(12),
            ),
          ),
        ],
      ),
    );
  }
}
