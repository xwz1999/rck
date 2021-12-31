import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/shop_summary_model.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';

//TODO CLEAN BOTTOM CODES.
@Deprecated("member_benefits_page deprecated.")
class MemberBenefitsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberBenefitsPageState();
  }
}

class _MemberBenefitsPageState extends BaseStoreState<MemberBenefitsPage> {
  bool _hasLoading = false;
  int _inviteCount = 0;
  GSRefreshController _gsRefreshController =
      GSRefreshController(initialRefresh: true);
  @override
  void initState() {
    super.initState();
  }

  _getData() {
    _getInviteCount();
    _getShopSummary();
  }

  _getShopSummary() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_index, {
      "userId": UserManager.instance.user.info.id,
    });
    if (_gsRefreshController.isRefresh()) {
      _gsRefreshController.refreshCompleted();
    }
    if (!resultData.result) {
      if (mounted) showError(resultData.msg);
      return;
    }
    ShopSummaryModel model = ShopSummaryModel.fromJson(resultData.data);
    // String jsonString = jsonEncode(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      if (mounted) showError(model.msg);
      return;
    }
    if (UserManager.instance.user.info.roleLevel != model.data.roleLevel) {
      UserManager.instance.user.info.roleLevel = model.data.roleLevel;
      UserManager.instance.refreshUserRole.value =
          !UserManager.instance.refreshUserRole.value;
      UserManager.updateUserInfo(getStore());
    }
    setState(() {});
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Container(),
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: '会员权益',
      ),
      // body: !_hasLoading ? _loading() :
      body: RefreshWidget(
        controller: _gsRefreshController,
        onRefresh: () {
          _getData();
        },
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: _bodyListWidget(context),
        ),
      ),
    );
  }

  List<Widget> _bodyListWidget(context) {
    List<Widget> listWidget = [];
    if (_inviteCount > 0) {
      listWidget.add(_hasInviteTitleWidget());
      listWidget.add(_hasInviteContentWidget());
      listWidget.add(GestureDetector(
        onTap: () {
          ShareTool().inviteShare(context, customTitle: Container());
        },
        child: _hasInviteButtonWidget(),
      ));
    }
    if (_inviteCount == 0) {
      // listWidget.add(_imageBgWidgetS());
      listWidget.add(_imageBgWidget());
      listWidget.add(GestureDetector(
        onTap: () {
          ShareTool().inviteShare(context, customTitle: Container());
        },
        child: _buttonWidget(),
      ));
    }
    return listWidget;
  }

  // _imageBgWidgetS() {
  //   double width = MediaQuery.of(context).size.width;
  //   return Stack(
  //     children: [
  //       Positioned(
  //         top: rSize(1148),
  //         // right: 0,
  //         left: rSize(120),
  //         child: FlatButton(
  //           onPressed: () {
  //             showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return Column(
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.fromLTRB(
  //                             rSize(28), rSize(36), rSize(28), 0),
  //                         child: Image.asset(
  //                           'assets/memberBenefitsPage_dialog.jpg',
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                       rHBox(10),
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: Icon(
  //                           CupertinoIcons.clear_circled,
  //                           color: Colors.grey,
  //                           size: rSize(40),
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 });
  //           },
  //           child: Text(''),
  //           minWidth: rSize(150),
  //           height: rSize(35),
  //         ),
  //       ),
  //       Positioned(
  //           left: rSize(40),
  //           top: rSize(1200),
  //           child: FlatButton(
  //             onPressed: () {
  //               ShareTool().inviteShare(context, customTitle: Container());
  //             },
  //             child: Text(''),
  //             minWidth: rSize(300),
  //             height: rSize(70),
  //           ))
  //     ],
  //   );
  // }

//TODO CLEAN BOTTOM CODES.
  @Deprecated("member_benefits_page,_imageBgWidget")
  _imageBgWidget() {
    double width = MediaQuery.of(context).size.width;
    double height = width / 750 * 1085;
    return Container(
      width: width,
      height: height,
    );
  }

  _buttonWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 139, 7),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
                spreadRadius: 2.0),
          ],
        ),
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '马上去邀请',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 17 * 2.sp,
            ),
          ),
        ));
  }

  _hasInviteTitleWidget() {
    return Container(
      height: 250,
      color: Color(0xffc20f2f),
      child: Column(
        children: <Widget>[
          _hasInviteUserInfoWidget(),
          _hasInviteProgress(),
        ],
      ),
    );
  }

  _hasInviteUserInfoWidget() {
    String nickname = UserManager.instance.user.info.nickname;
    if (TextUtils.isEmpty(nickname, whiteSpace: true)) {
      String mobile = UserManager.instance.user.info.mobile;
      nickname = "用户${mobile.substring(mobile.length - 4)}";
    }
    return Container(
      height: 125,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: CustomCacheImage(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              imageUrl:
                  TextUtils.isEmpty(UserManager.instance.user.info.headImgUrl)
                      ? ""
                      : Api.getResizeImgUrl(
                          UserManager.instance.user.info.headImgUrl, 80),
            ),
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      nickname,
                      style:
                          TextStyle(color: Colors.white, fontSize: 16 * 2.sp),
                    ),
                    Container(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColor.themeColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '普通会员',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12 * 2.sp),
                      ),
                    ),
                    Spacer(),
                    // Text('已邀请人数:${_inviteCount}', style: TextStyle(color: Colors.white, fontSize: 16*2.sp),),
                  ],
                ),
                Container(
                  child: Text(
                    '已邀请人数:$_inviteCount',
                    style: TextStyle(color: Colors.white, fontSize: 16 * 2.sp),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '邀请码: ${UserManager.instance.user.info.invitationNo}',
                      style:
                          TextStyle(color: Colors.white, fontSize: 12 * 2.sp),
                    ),
                    Container(
                      width: 10,
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: 16,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withAlpha(100),
                            borderRadius: BorderRadius.circular(8)),
                        child: GestureDetector(
                          onTap: () {
                            ClipboardData data = new ClipboardData(
                                text: UserManager
                                    .instance.user.info.invitationNo
                                    .toString());
                            Clipboard.setData(data);
                            Toast.showSuccess('邀请码已经保存到剪贴板');
                          },
                          child: Text(
                            '复制',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10 * 2.sp),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _hasInviteProgress() {
    Color pinkColor = Color.fromARGB(255, 252, 208, 195);
    Color deepPinkColor = Color.fromARGB(255, 250, 98, 101);
    double progressWidth = MediaQuery.of(context).size.width - 20 - 20;
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: 105,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '成长值: $_inviteCount',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6), fontSize: 13 * 2.sp),
            ),
          ),
          Container(
            height: 7,
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 14,
                width: progressWidth,
                decoration: BoxDecoration(
                    color: pinkColor,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
              ),
              Container(
                height: 14,
                width: progressWidth * _progressPercent(),
                decoration: BoxDecoration(
                    color: deepPinkColor,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
              ),
            ],
          ),
          Container(
            height: 5,
          ),
          Container(
            height: 33,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/pink_bottom_arrow.png',
                      width: 14,
                      height: 10,
                    ),
                    Text(
                      '1人',
                      style: TextStyle(color: deepPinkColor),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/pink_bottom_arrow.png',
                      width: 14,
                      height: 10,
                    ),
                    Text(
                      '3人',
                      style: TextStyle(color: deepPinkColor),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/pink_bottom_arrow.png',
                      width: 14,
                      height: 10,
                    ),
                    Text(
                      '5人',
                      style: TextStyle(color: deepPinkColor),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/pink_bottom_arrow.png',
                      width: 14,
                      height: 10,
                    ),
                    Text(
                      '10人以上',
                      style: TextStyle(color: deepPinkColor),
                    )
                  ],
                ),
                Container(
                  width: 7,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _hasInviteContentWidget() {
    double width = MediaQuery.of(context).size.width;
    double height = width / 750 * 578;
    return Container(
      height: height,
      width: width,
    );
  }

  _hasInviteButtonWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 88, 92),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '马上去邀请',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 17 * 2.sp,
            ),
          ),
        ));
  }

  _getInviteCount() async {
    ResultData resultData = await HttpManager.post(
        UserApi.invite_count, {'userId': UserManager.instance.user.info.id});
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _hasLoading = true;
    if (resultData.data['data']['count'] != null &&
        resultData.data['data']['count'] is int) {
      _inviteCount = resultData.data['data']['count'];
    }
    if (resultData.data['data']['role'] != null &&
        resultData.data['data']['role'] is int) {
      // _inviteCount = resultData.data['data']['count'];
      getStore().state.userBrief.roleLevel = resultData.data['data']['role'];
      if (UserManager.instance.user.info.roleLevel !=
          getStore().state.userBrief.roleLevel) {
        UserManager.instance.user.info.roleLevel =
            getStore().state.userBrief.roleLevel;
        UserManager.instance.refreshUserRole.value =
            !UserManager.instance.refreshUserRole.value;
        UserManager.updateUserInfo(getStore());
      }
    }
    setState(() {});
  }

  _progressPercent() {
    switch (_inviteCount) {
      case 0:
        return 0;
        break;
      case 1:
        return .1;
        break;
      case 2:
        return .22;
        break;
      case 3:
        return .35;
        break;
      case 4:
        return .45;
        break;
      case 5:
        return .6;
        break;
      case 6:
        return 0.65;
        break;
      case 7:
        return 0.7;
        break;
      case 8:
        return 0.75;
        break;
      case 9:
        return 0.85;
        break;
      case 10:
        return 1;
        break;
      default:
        return 0;
    }
  }

  _loading() {
    return !_hasLoading
        ? Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(getCurrentThemeColor()),
                strokeWidth: 1.0,
              ),
            ),
          )
        : Container();
  }
}
