

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class OrderCentralView extends StatefulWidget {
  final Function(int index) clickListener;

  const OrderCentralView({Key key, this.clickListener}) : super(key: key);

  @override
  _OrderCentralViewState createState() => _OrderCentralViewState();
}

class _OrderCentralViewState extends BaseStoreState<OrderCentralView> {
  // final double _iconSize = rSize(25);
  final double _iconSize = rSize(30);
  final double _fontSize = 12 * 2.sp;

  @override
  bool needStore() {
    return true;
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _buildBody(context);
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(10), vertical: rSize(8)),
      // margin: EdgeInsets.only(left: rSize(10), right: rSize(10)),
      // margin: EdgeInsets.symmetric(
      //     vertical: rSize(8), horizontal: rSize(10)),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '零售订单',
                    style:
                        AppTextStyle.generate(16, fontWeight: FontWeight.w700),
                  ),
                  // child: Text(
                  //   "订单中心",
                  //   style: AppTextStyle.generate(16, fontWeight: FontWeight.w700),
                  // ),
                ),
                CustomImageButton(
                  title: "全部订单",
                  fontSize: 12 * 2.sp,
                  color: Colors.black45,
                  onPressed: () {
                    widget.clickListener(0);
                  },
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black38,
                  size: 18 * 2.sp,
                ),
                // Icon(
                //   AppIcons.icon_next,
                //   size: 14*2.sp,
                //   color: Colors.grey,
                // )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: rSize(10)),
                  dotPosition: DotPosition(right: rSize(8), top: 0),
                  dotNum: getStore().state.userBrief.orderCenter.waitPay == 0
                      ? ''
                      : getStore()
                          .state
                          .userBrief
                          .orderCenter
                          .waitPay
                          .toString(),
                  dotColor: AppColor.themeColor,
                  icon: Image.asset(
                    R.ASSETS_USER_PAY_PNG,
                    width: 30,
                    height: 30,
                  ),
                  title: "待付款",
                  fontSize: _fontSize,
                  color: Colors.grey[700],
                  contentSpacing: 8,
                  onPressed: () {
                    widget.clickListener(1);
                  },
                ),
              ),
              Expanded(
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: rSize(10)),
                  dotPosition: DotPosition(right: rSize(8), top: 0),
                  dotNum: getStore().state.userBrief.orderCenter.waitSend == 0
                      ? ''
                      : getStore()
                          .state
                          .userBrief
                          .orderCenter
                          .waitSend
                          .toString(),
                  dotColor: AppColor.themeColor,
                  icon: Image.asset(
                    R.ASSETS_USER_DELIVER_PNG,
                    width: 30,
                    height: 30,
                  ),
                  title: "待发货",
                  fontSize: _fontSize,
                  color: Colors.grey[700],
                  contentSpacing: 8,
                  onPressed: () {
                    widget.clickListener(2);
                  },
                ),
              ),
              Expanded(
                child: CustomImageButton(
                  padding: EdgeInsets.symmetric(vertical: rSize(10)),
                  dotPosition: DotPosition(right: rSize(8), top: 0),
                  dotNum: getStore().state.userBrief.orderCenter.waitRecv == 0
                      ? ''
                      : getStore()
                          .state
                          .userBrief
                          .orderCenter
                          .waitRecv
                          .toString(),
                  dotColor: AppColor.themeColor,
                  icon: Image.asset(
                    R.ASSETS_USER_LOGISTICS_PNG,
                    width: 30,
                    height: 30,
                  ),
                  title: "待收货",
                  fontSize: _fontSize,
                  color: Colors.grey[700],
                  contentSpacing: 8,
                  onPressed: () {
                    widget.clickListener(3);
                  },
                ),
              ),
              // Expanded(
              //   child: CustomImageButton(
              //     padding: EdgeInsets.symmetric(vertical: rSize(10)),
              //     dotPosition: DotPosition(right: rSize(8), top: 0),
              //     dotNum: getStore().state.userBrief.orderCenter.evaNum == 0
              //         ? ''
              //         : getStore()
              //         .state
              //         .userBrief
              //         .orderCenter
              //         .evaNum
              //         .toString(),
              //     dotColor: AppColor.themeColor,
              //     icon: Image.asset(
              //       R.ASSETS_USER_REVIEW_PNG,
              //       width: 30,
              //       height: 30,
              //     ),
              //     title: "评价",
              //     color: Colors.grey[700],
              //     fontSize: _fontSize,
              //     contentSpacing: 8,
              //     onPressed: () {
              //       widget.clickListener(4);
              //     },
              //   ),
              // ),
              Expanded(
                child: CustomImageButton(
                  // dotNum: null,
                  // padding: EdgeInsets.symmetric(vertical: rSize(10)),
                  // dotColor: AppColor.themeColor,
                  padding: EdgeInsets.symmetric(vertical: rSize(10)),
                  dotPosition: DotPosition(right: rSize(8), top: 0),
                  dotNum: getStore().state.userBrief.orderCenter.afterNum == 0
                      ? ''
                      : getStore()
                      .state
                      .userBrief
                      .orderCenter
                      .afterNum
                      .toString(),
                  dotColor: AppColor.themeColor,
                  icon: Image.asset(
                    R.ASSETS_USER_AFTER_SALE_PNG,
                    width: 30,
                    height: 30,
                  ),
                  title: "售后/退货",
                  color: Colors.grey[700],
                  fontSize: _fontSize,
                  contentSpacing: 8,
                  onPressed: () {
                    widget.clickListener(5);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
