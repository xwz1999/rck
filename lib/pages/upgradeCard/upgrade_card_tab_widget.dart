import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/upgrade_card_model.dart';
import 'package:recook/models/user_role_upgrade_model.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_send_user_list_page.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UpgardeCardWidgetModel {
  String code;
  bool isUpCode;
  String codeId;

  UpgardeCardWidgetModel({this.code = "", this.isUpCode = true, this.codeId = ""});
}

class UpgradeCardTabWidget extends StatefulWidget {
  final bool used;
  UpgradeCardTabWidget({Key key, this.used = false}) : super(key: key);
  @override
  _UpgradeCardTabWidgetState createState() => _UpgradeCardTabWidgetState();
}

class _UpgradeCardTabWidgetState extends BaseStoreState<UpgradeCardTabWidget> {
  String up_bg = "assets/upgrade_page_upgrade_card_bg.png";
  String renew_bg = "assets/upgrade_page_renewal_card_bg.png";
  String up_used_bg = "assets/upgrade_page_upgrade_used_card_bg.png";
  String renew_used_bg = "assets/upgrade_page_renewal_used_card_bg.png";
  Color redColor = Color(0xffdd2c4e);
  Color blueColor = Color(0xff3151e1);
  Color greyColor = Color(0xff999999);

  // 数据列表
  List<UpgardeCardWidgetModel> _dataList;
  UpgradeCardModel _upgradeCardModel;

  GSRefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _dataList = [];
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 1,
            color: AppColor.frenchColor,
          ),
          Expanded(
            child: RefreshWidget(
              color: Colors.black,
              controller: _refreshController,
              releaseText: "松开更新数据",
              idleText: "下拉更新数据",
              refreshingText: "正在更新数据...",
              onRefresh: () {
                _getUpCode();
              },
              body: _dataList != null && _dataList.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _dataList.length,
                      itemBuilder: (context, index) {
                        UpgardeCardWidgetModel model = _dataList[index];
                        return _itemWidget(
                            isUpgrade: model.isUpCode,
                            isUsed: widget.used,
                            code: model.code,
                            codeId: model.codeId);
                      },
                    )
                  : _noDataWidget("暂无晋升卡可赠送,快去邀请吧~"),
            ),
          )
        ],
      ),
    );
  }

  _noDataWidget(title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Image.asset(
            "assets/shop_upgrade_code_page_nodata.png",
            width: 99,
            height: 60,
          ),
          Container(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(color: Color(0xff666666), fontSize: 13),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

  _itemWidget({bool isUpgrade = true, bool isUsed = false, String code = "", String codeId=""}) {
    UserRoleLevel nextRoleLevel = UserRoleLevel.Vip;
    UserRoleLevel roleLevel = UserLevelTool.currentRoleLevelEnum();
    nextRoleLevel = roleLevel == UserRoleLevel.Vip?UserRoleLevel.Master:roleLevel==UserRoleLevel.Master?UserRoleLevel.Silver:roleLevel==UserRoleLevel.Silver?UserRoleLevel.Gold:roleLevel==UserRoleLevel.Gold?UserRoleLevel.Diamond:UserRoleLevel.None;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 30;
    double cardHeight = 190 * (345 / cardWidth);
    Color textColor = isUsed ? greyColor : isUpgrade ? redColor : blueColor;
    Container con = Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: <Widget>[
            isUpgrade
                ? Image.asset(
                    isUsed ? up_used_bg : up_bg,
                    fit: BoxFit.fill,
                    width: cardWidth,
                    height: cardHeight,
                  )
                : Image.asset(
                    isUsed ? renew_used_bg : renew_bg,
                    fit: BoxFit.fill,
                    width: cardWidth,
                    height: cardHeight,
                  ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, top: 15, bottom: 20, right: 15),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isUpgrade ? "晋升卡" : "保障卡",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        isUpgrade ? "Upgrade Card" : "Renewal Card",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UserLevelTool.currentUserLevelEnum() == UserLevel.First || UserLevelTool.currentUserLevelEnum() == UserLevel.Second
                        ? CustomImageButton(
                        onPressed: () {
                          // 会员不能送也不能保级
                          if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip) {
                            Alert.show(context, NormalTextDialog(
                              title: isUpgrade ? "晋升卡" : "保障卡",
                              content: isUpgrade ? "会员角色无法使用晋升卡" : "会员角色无法使用保障卡",
                              items: ["确认"],
                              listener: (index){
                                Alert.dismiss(context);
                              },
                            ));
                            return;
                          }
                          // 店主不能用保障卡
                          if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master && !isUpgrade) {
                            Alert.show(context, NormalTextDialog(
                              title:"保障卡",
                              content: "店主无须使用保障卡",
                              items: ["确认"],
                              listener: (index){
                                Alert.dismiss(context);
                              },
                            ));
                            return;
                          }
                          // 黄金店铺不能用晋升卡
                          if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold && isUpgrade) {
                            Alert.show(context, NormalTextDialog(
                              title:"晋升卡",
                              content: "黄金店铺无法使用晋升卡",
                              items: ["确认"],
                              listener: (index){
                                Alert.dismiss(context);
                              },
                            ));
                            return;
                          }
                          // 对自己使用
                          Alert.show(
                            context,
                            NormalContentDialog(
                              type: NormalTextDialogType.delete,
                              title: "提示",
                              content: Text.rich(
                                isUpgrade?TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 15,),
                                  children: [
                                    TextSpan(text:'使用晋升卡您将由\n',),
                                    TextSpan(text: "【${UserLevelTool.roleLevelWithEnum(roleLevel)}】", style: TextStyle(color: Colors.red)),
                                    TextSpan(text:'升至',),
                                    TextSpan(text: "【${UserLevelTool.roleLevelWithEnum(nextRoleLevel)}】", style: TextStyle(color: Colors.red)),
                                  ]
                                )
                                : TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 15,),
                                  children: [
                                    TextSpan(text:'使用保障卡您的',),
                                    TextSpan(text: "【${UserLevelTool.roleLevelWithEnum(roleLevel)}】\n", style: TextStyle(color: Colors.red)),
                                    TextSpan(text:'考核期将会延至',),
                                    TextSpan(text: _upgradeCardModel.data.nextAssessTime, style: TextStyle(color: Colors.red)),
                                  ]
                                ),
                                textAlign: TextAlign.center,
                              ),
                              items: ["确认"],
                              listener: (index) {
                                Alert.dismiss(context);
                                if (isUpgrade) {
                                  _upgradeByCode(int.parse(codeId));
                                }else{
                                  _keepByCode(int.parse(codeId));
                                }
                              },
                              deleteItem: "取消",
                              deleteListener: () {
                                Alert.dismiss(context);
                              },
                            ));
                        },
                        width: 80,
                        height: 33,
                        title: isUsed ? "已使用" : "使用",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(17),
                      ) : Container(),
                      Container(
                        height: UserLevelTool.currentUserLevelEnum() == UserLevel.Top
                                  || UserLevelTool.currentUserLevelEnum() == UserLevel.First ? 6 : 0,
                      ),
                      UserLevelTool.currentUserLevelEnum() == UserLevel.Top 
                      || UserLevelTool.currentUserLevelEnum() == UserLevel.First 
                          ? CustomImageButton(
                              onPressed: () {
                                AppRouter.push(context,
                                    RouteName.UPGRADE_CARD_SEND_USER_LIST_PAGE,
                                    arguments: UpgradeCardSendUserListPage
                                        .setArguments(
                                            isUpCard: isUpgrade, code: codeId)).then((onValue){
                                              if (onValue != null && onValue is bool && onValue) {
                                                _refreshController.requestRefresh();
                                              }
                                            });
                              },
                              width: 80,
                              height: 33,
                              title: isUsed ? "已赠送" : "赠送",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(17),
                            )
                            : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 15,
              bottom: 20,
              child: Container(
                child: Text(
                  TextUtils.isEmpty(code) ? "" : code,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    wordSpacing: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return IgnorePointer(
      ignoring: isUsed,
      child: con,
    );
  }

  _getUpCode() async {
    ResultData resultData = await HttpManager.post(UserApi.query_up_code, {
      "userId": UserManager.instance.user.info.id,
      "isUsed": widget.used ? "yes" : "no",
    });
    _refreshController.refreshCompleted();

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    UpgradeCardModel model = UpgradeCardModel.fromJson(resultData.data);
    // BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    _upgradeCardModel = model;
    _dataList = [];
    if (widget.used) {
      if (model.data.upCode.usedCode != null) {
        for (UnusedCode codeModel in model.data.upCode.usedCode) {
          _dataList.add(UpgardeCardWidgetModel(isUpCode: true, code: codeModel.code, codeId: codeModel.id.toString()));
        }
      }
      if (model.data.keepCode.usedCode != null) {
        for (UnusedCode codeModel in model.data.keepCode.usedCode) {
          _dataList.add(UpgardeCardWidgetModel(isUpCode: false, code: codeModel.code, codeId: codeModel.id.toString()));
        }
      }
    } else {
      if (model.data.upCode.unusedCode != null) {
        for (UnusedCode codeModel in model.data.upCode.unusedCode) {
          _dataList.add(UpgardeCardWidgetModel(isUpCode: true, code: codeModel.code, codeId: codeModel.id.toString()));
        }
      }
      if (model.data.keepCode.unusedCode != null) {
        for (UnusedCode codeModel in model.data.keepCode.unusedCode) {
          _dataList.add(UpgardeCardWidgetModel(isUpCode: false, code: codeModel.code, codeId: codeModel.id.toString()));
        }
      }
    }
    setState(() {});
  }

  _keepByCode(num codeId,) async {
    ResultData resultData = await HttpManager.post(UserApi.keep_by_code, {
      "userId": UserManager.instance.user.info.id,
      "codeId": codeId,
      "keepUserId": UserManager.instance.user.info.id,
    });

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    // success
    _refreshController.requestRefresh();
  }

  _upgradeByCode(num codeId,) async {
    ResultData resultData = await HttpManager.post(UserApi.upgrade_by_code, {
      "userId": UserManager.instance.user.info.id,
      "introCodeId": codeId,
      "upgradeUserId": UserManager.instance.user.info.id,
    });

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    UserRoleUpgradeModel model = UserRoleUpgradeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    // success
    _refreshController.requestRefresh();
    UserLevelTool.showUpgradeWidget(model, globalContext, getStore());
  }

  @override
  bool get wantKeepAlive => true;
}
