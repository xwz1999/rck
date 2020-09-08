import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/pages/shop/widget/shop_page_line_progress_widget.dart';
import 'package:recook/utils/user_level_tool.dart';

class ShopPageAppbarWidget extends StatefulWidget {
  final ShopSummaryModel shopSummaryModel;
  final Function cumulativeIncome;
  ShopPageAppbarWidget({Key key, this.shopSummaryModel, this.cumulativeIncome})
      : super(key: key);

  @override
  _ShopPageAppbarWidgetState createState() => _ShopPageAppbarWidgetState();
}

class _ShopPageAppbarWidgetState extends BaseStoreState<ShopPageAppbarWidget> {
  Color blackBGColor = Color(0xff3a3943);
  Color nameColor = Color(0xfffffdfd);
  UserRoleLevel _roleLevel;
  GlobalKey<ShopPageLineProgressWidgetState> progressGlobalkey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _roleLevel =
        UserLevelTool.roleLevelEnum(widget.shopSummaryModel.data.roleLevel);
    return Container(
      width: double.infinity,
      color: blackBGColor,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
        child: Column(
          children: <Widget>[
            _headWidget(),
            // _detailWidget(),
          ],
        ),
      ),
    );
  }

  _headWidget() {
    if (_roleLevel == UserRoleLevel.Master &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Others)) {
      return _masterAndOtherHeadWidget();
    } else {
      return _cardHeadWidget();
    }
  }

  _getTeamInTitle(double teamIn) {
    if (teamIn < 10000) {
      return "${teamIn.toStringAsFixed(2)}元";
    }
    return "${(teamIn / 10000).toStringAsFixed(2)}万元";
  }

  _cardHeadWidget() {
    double percent = 0;
    List<String> nodeTitleList = ["", "", "", "", ""];
    int nodeCount = 0;
    if (_roleLevel == UserRoleLevel.Silver ||
        _roleLevel == UserRoleLevel.Gold ||
        _roleLevel == UserRoleLevel.Diamond) {
      nodeCount = 5;
    }
    String camelTitle = "";
    String camelPopTitle = "";
    if (_roleLevel == UserRoleLevel.Master) {
      if (widget.shopSummaryModel.data.card.target.toDouble() <
          widget.shopSummaryModel.data.card.teamIn.toDouble()) {
        camelTitle = "已满足升级标准";
      } else {
        String text = ((widget.shopSummaryModel.data.card.target.toDouble() -
                    widget.shopSummaryModel.data.card.teamIn.toDouble()) /
                10000.0)
            .toStringAsFixed(2);
        camelTitle = "距升级白银店铺还差$text万元";
      }
      camelPopTitle =
          "当前销售额: ${_getTeamInTitle(widget.shopSummaryModel.data.card.teamIn.toDouble())}";
      percent = widget.shopSummaryModel.data.card.teamIn.toDouble() /
          widget.shopSummaryModel.data.card.target.toDouble();
    } else {
      //先判断当前销售额在哪一个节点
      List nodeList = [];
      List<String> titleList = [];
      if (widget.shopSummaryModel.data.card.stand.increaseNum != null &&
          widget.shopSummaryModel.data.card.stand.increaseNum.length == 6) {
        for (var i = 1; i < 6; i++) {
          nodeList.add(widget.shopSummaryModel.data.card.stand.increaseNum[i]);
        }
        for (var i = 0; i < 5; i++) {
          IncreaseNum increase = nodeList[i];
          IncreaseNum rightIncrease;
          IncreaseNum leftIncrease;
          if (i > 0) {
            leftIncrease = nodeList[i - 1];
          }
          if (i < 4) {
            rightIncrease = nodeList[i + 1];
          }
          // 进度条实际应该的比例
          // 0 - 1 -- 2 -- 3 -- 4 -- 5 - 完成
          //  13.33%  18.75%  18.75%  18.75%  18.75%  13.33%
          // 设置进度和骆驼上的文字
          if (i == 4 &&
              widget.shopSummaryModel.data.card.teamIn.toDouble() >=
                  increase.quantity.toDouble()) {
            // 已经完成所有目标
            percent = 0.9;
            camelTitle = "已超越90%的店铺";
          }
          if (i == 0 &&
              widget.shopSummaryModel.data.card.teamIn.toDouble() <=
                  increase.quantity.toDouble()) {
            // 在第一阶段
            String text = ((increase.quantity.toDouble() -
                        widget.shopSummaryModel.data.card.teamIn.toDouble()) /
                    10000)
                .toStringAsFixed(2);
            percent = 0.1333 *
                (widget.shopSummaryModel.data.card.teamIn.toDouble() /
                    increase.quantity.toDouble());
            camelTitle = "距下一节点还差$text万元";
            // }else if (i == 0 && widget.shopSummaryModel.data.card.teamIn.toDouble()<rightIncrease.quantity.toDouble()) {
            //   // 在第一阶段
            //   String text = ((rightIncrease.quantity.toDouble() - widget.shopSummaryModel.data.card.teamIn.toDouble())/10000).toStringAsFixed(2);
            //   percent = 0.1*(widget.shopSummaryModel.data.card.teamIn.toDouble()/rightIncrease.quantity.toDouble());
            //   camelTitle = "距下一节点还差$text万元";
          } else if ((rightIncrease != null &&
                  widget.shopSummaryModel.data.card.teamIn.toDouble() <
                      rightIncrease.quantity.toDouble()) &&
              widget.shopSummaryModel.data.card.teamIn.toDouble() >=
                  increase.quantity.toDouble()) {
            // 在 i - i+1阶段
            String text = ((rightIncrease.quantity.toDouble() -
                        widget.shopSummaryModel.data.card.teamIn.toDouble()) /
                    10000)
                .toStringAsFixed(2);
            camelTitle = "距下一节点还差$text万元";
            //已经玩的销售额
            double nodeTeamIn =
                widget.shopSummaryModel.data.card.teamIn.toDouble() -
                    increase.quantity.toDouble();
            //当前节点需要的总销售额
            double nodeQuantity = rightIncrease.quantity.toDouble() -
                increase.quantity.toDouble();
            double nodePercent = nodeTeamIn / nodeQuantity;
            // 判断出在进度条上应该指定的位置
            if (i == 0) {
              percent = nodePercent * 0.1875 + 0.1333;
            } else {
              percent = nodePercent * 0.1875 + 0.1333 + (i) * 0.1875;
            }
          }
          titleList.add(
              "销售额: ${(increase.quantity.toDouble() / 10000).toStringAsFixed(0)}万元\n提成比例: ${increase.percent.toString()}%");
        }
        nodeTitleList = titleList;
      }
      camelPopTitle =
          "团队销售额: ${_getTeamInTitle(widget.shopSummaryModel.data.card.teamIn.toDouble())}\n提成比例: ${widget.shopSummaryModel.data.card.percent.toString()}%";
    }

    DateTime createTime;
    if (!TextUtils.isEmpty(UserManager.instance.user.info.createdAt)) {
      createTime = DateTime.parse(UserManager.instance.user.info.createdAt);
    }
    double cardWidth = MediaQuery.of(context).size.width - 30;
    double cardHeight = 345 / cardWidth * 190;
    // UserLevelTool.cardImagePath(UserLevelTool.roleLevelEnum(_shopSummaryModel.data.roleLevel));
    // percent = 0.3;
    progressGlobalkey?.currentState?.updateView(percent: percent);

    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 5),
      height: cardHeight,
      width: cardWidth,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, bottom: 0, top: 0,
            child: Image.asset(
              UserLevelTool.cardImagePath(_roleLevel),
              fit: BoxFit.fill,
            ),
            // child: Image.asset(UserLevelTool.currentCardImagePath(), fit: BoxFit.fill,),
          ),
          Positioned(
              left: 10,
              right: 10,
              height: 45,
              top: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text:
                                "${UserManager.instance.user.info.nickname}的店铺",
                            style: TextStyle(color: nameColor, fontSize: 16)),
                        TextSpan(
                            text: "(${UserLevelTool.currentRoleLevel()})",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: nameColor.withOpacity(0.8),
                                fontSize: 12)),
                      ])),
                      Text(
                        createTime != null
                            ? '注册时间 ${createTime.year}-${createTime.month}-${createTime.day}'
                            : "",
                        style: TextStyle(
                            color: nameColor.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      AppRouter.push(
                        globalContext,
                        RouteName.SHOP_PAGE_USER_RIGHTS_PAGE,
                      );
                    },
                    child: Image.asset(
                      UserLevelTool.medalImagePath(_roleLevel),
                      width: 45,
                      height: 45,
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: nameColor.withOpacity(0.7),
                    size: 15,
                  ),
                ],
              )),
          Positioned(
            left: 25,
            right: 25,
            bottom: 10 / 190.0 * cardHeight,
            top: 65.0 / 190.0 * cardHeight,
            child: ShopPageLineProgressWidget(
              key: progressGlobalkey,
              nodeTitleList: nodeTitleList,
              camelPopTitle: camelPopTitle,
              camelTitle: camelTitle,
              width: cardWidth - 50,
              // width: cardWidth,
              percent: percent,
              nodeCount: nodeCount,
            ),
          ),
        ],
      ),
    );
  }

  _masterAndOtherHeadWidget() {
    DateTime createTime;
    if (!TextUtils.isEmpty(UserManager.instance.user.info.createdAt)) {
      createTime = DateTime.parse(UserManager.instance.user.info.createdAt);
    }
    String userlevel =
        UserLevelTool.roleLevel(widget.shopSummaryModel.data.roleLevel);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 84,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "${UserManager.instance.user.info.nickname}的店铺",
                    style: TextStyle(color: nameColor, fontSize: 16)),
                TextSpan(
                    text: "($userlevel)",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: nameColor.withOpacity(0.8),
                        fontSize: 12)),
              ])),
              Text(
                createTime != null
                    ? '注册时间 ${createTime.year}-${createTime.month}-${createTime.day}'
                    : "",
                style: TextStyle(
                    color: nameColor.withOpacity(0.7),
                    fontWeight: FontWeight.w300,
                    fontSize: 8),
              ),
            ],
          ),
          Spacer(),
          // Image.asset(UserLevelTool.currentMedalImagePath(), width: 45, height: 45,),
          GestureDetector(
            onTap: () {
              AppRouter.push(
                globalContext,
                RouteName.SHOP_PAGE_USER_RIGHTS_PAGE,
              );
            },
            child: Image.asset(
              UserLevelTool.medalImagePath(UserRoleLevel.Master),
              width: 45,
              height: 45,
            ),
          ),
          Container(
            width: 10,
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: nameColor.withOpacity(0.7),
            size: 25,
          ),
        ],
      ),
    );
  }

  _columnTitleWidget(info, title) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            info,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          Container(height: 5),
          Text(
            title,
            style: TextStyle(color: Color(0xff999999), fontSize: 12),
          ),
        ],
      ),
    );
  }

  _detailWidget() {
    return Container(
        height: 110,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: 56,
                child: Image.asset(
                  'assets/shop_page_appbar_detail_bg.png',
                  fit: BoxFit.fill,
                )),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.cumulativeIncome != null) {
                      widget.cumulativeIncome();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    child: Row(
                      children: <Widget>[
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "累计收益",
                              style: AppTextStyle.generate(16,
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: "(瑞币)",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 10))
                        ])),
                        Spacer(),
                        Text(
                            widget.shopSummaryModel.data.accumulateIncome.all
                                .toStringAsFixed(2),
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                        Icon(Icons.keyboard_arrow_right,
                            size: 22, color: Color(0xff999999)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                          child: _columnTitleWidget(
                              widget.shopSummaryModel.data.accumulateIncome
                                  .selfShopping
                                  .toStringAsFixed(2),
                              "自购收益(瑞币)")),
                      Expanded(
                          child: _columnTitleWidget(
                              widget
                                  .shopSummaryModel.data.accumulateIncome.share
                                  .toStringAsFixed(2),
                              "导购收益(瑞币)")),
                      _roleLevel == UserRoleLevel.Master &&
                              (UserLevelTool.currentUserLevelEnum() ==
                                  UserLevel.Others)
                          ? Container()
                          : Expanded(
                              child: _columnTitleWidget(
                                  widget.shopSummaryModel.data.accumulateIncome
                                      .team
                                      .toStringAsFixed(2),
                                  "团队收益(瑞币)")),
                    ],
                  ),
                ))
              ],
            ),
          ],
        ));
  }
}
