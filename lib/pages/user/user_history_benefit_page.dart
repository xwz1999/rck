import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/user/functions/user_benefit_func.dart';
import 'package:jingyaoyun/pages/user/model/user_accumulate_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class UserHistoryBenefitPage extends StatefulWidget {
  UserHistoryBenefitPage({Key key}) : super(key: key);

  @override
  _UserHistoryBenefitPageState createState() => _UserHistoryBenefitPageState();
}

class _UserHistoryBenefitPageState extends State<UserHistoryBenefitPage> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  ///累计收益
  ///
  UserAccumulateModel _model = UserAccumulateModel.zero();

  _renderColumn(String title, String subTitle) {
    return Column(
      children: [
        title.text.size(14.rsp).black.make(),
        2.hb,
        subTitle.text.size(14.rsp).black.make(),
      ],
    ).expand();
  }

  _renderDivider() {
    return Container(
      height: 22.rw,
      width: 1.rw,
      color: Color(0xFF979797),
    );
  }

  Widget _buildToast() {
    return Builder(
      builder: (context) {
        //role == UserRoleLevel.Diamond_1 || role == UserRoleLevel.Diamond_2 || role == UserRoleLevel.Diamond_3
        UserRoleLevel role = UserLevelTool.currentRoleLevelEnum();

        final part1 = [
          TextSpan(
            text: '自营店铺补贴',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '：每月1日结算您自营店铺上一个自然月确认收货的订单，按自营店铺销售额的3%计算补贴。\n'),
        ];
        final part2 = [
          TextSpan(
            text: '分销店铺补贴',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '：每月1日结算您分销店铺上一个自然月确认收货的订单，按分销店铺销售额的4%计算补贴。\n'),
        ];
        final part3 = [
          TextSpan(
            text: '代理店铺补贴',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '：每月1日结算您代理店铺上一个自然月确认收货的订单，按代理店铺销售额的5%计算补贴。\n'),
        ];
        return Text.rich(TextSpan(
          children: [
            ...part1,
            if (role == UserRoleLevel.Gold ||
                role == UserRoleLevel.Silver ||
                role == UserRoleLevel.Diamond_1 ||
                role == UserRoleLevel.Diamond_2 ||
                role == UserRoleLevel.Diamond_3)
              ...part2,
            if (role == UserRoleLevel.Diamond_1 ||
                role == UserRoleLevel.Diamond_2 ||
                role == UserRoleLevel.Diamond_3)
              ...part3,
          ],
          style: TextStyle(
            color: Color(0xFF333333),
          ),
        ));
      },
    );
  }

  _buildCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA6A6AD).withOpacity(0.41),
            offset: Offset(0, 2.rw),
            blurRadius: 6.rw,
          ),
        ],
        borderRadius: BorderRadius.circular(4.rw),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(UserLevelTool.currentCardImagePath()),
              ),
            ),
            padding: EdgeInsets.only(
                top: 20.rw, bottom: 10.rw, left: 20.rw, right: 20.rw),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          title: "累计收益",
                          content: "您的账户使用至今所有已到账收益之和",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '累计总收益(瑞币)'.text.black.make(),
                      8.hb,
                      (_model?.data?.allAmount?.toStringAsFixed(2) ?? '')
                          .text
                          .black
                          .size(34.rsp)
                          .make(),
                    ],
                  ).expand(),
                ),
                Image.asset(
                  UserLevelTool.currentMedalImagePath(),
                  width: 48.rw,
                  height: 48.rw,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.rw),
            child: Row(
              children: [
                GestureDetector(
                  child: _renderColumn(
                      '自购收益', _model?.data?.purchaseAmountValue ?? ''),
                  onTap: () {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          title: "自购收益",
                          content: "您本人下单并确认收货后，您获得的佣金。",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  },
                ).expand(),
                _renderDivider(),
                GestureDetector(
                  child: _renderColumn(
                      '导购收益', _model?.data?.guideAmountValue ?? ''),
                  onTap: () {
                    Alert.show(
                        context,
                        NormalTextDialog(
                          title: "导购收益",
                          content: "会员通过您导购的商品链接，购买并确认收货的佣金收益",
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  },
                ).expand(),
                _renderDivider(),
                GestureDetector(
                  child: _renderColumn('店铺补贴', _model?.data?.trrValue ?? ''),
                  onTap: () {
                    Alert.show(
                        context,
                        NormalContentDialog(
                          title: "店铺补贴",
                          content: _buildToast(),
                          items: ["确认"],
                          listener: (index) {
                            Alert.dismiss(context);
                          },
                        ));
                  },
                ).expand(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RecookBackButton(white: true),
        backgroundColor: Color(0xFF16182B),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '累计总收益',
          style: TextStyle(
            fontSize: 18.rsp,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          _model = await UserBenefitFunc.accmulate();
          setState(() {});
          _refreshController.refreshCompleted();
        },
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 36.rw, vertical: 20.rw),
          children: [
            _buildCard(),
          ],
        ),
      ),
    );
  }
}
