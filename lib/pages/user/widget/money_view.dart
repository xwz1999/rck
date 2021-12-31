/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/6  3:56 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';

class MoneyView extends StatefulWidget {
  final Function(int index) listener;
  final Function() wechatListener;
  const MoneyView({Key key, this.listener, this.wechatListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoneyViewState();
  }
}

class _MoneyViewState extends BaseStoreState<MoneyView> {
  TextStyle _moneyStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.6),
      fontSize: 14 * 2.sp);
  TextStyle _subMoneyStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.6),
      fontSize: 14 * 2.sp);

  TextStyle _moneyTitleStyle = TextStyle(
      fontWeight: FontWeight.w400, color: Colors.black, fontSize: 19 * 2.sp);

  @override
  bool needStore() {
    return true;
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    // return _buildBody();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // _balanceWidget(),
        TextUtils.isEmpty(UserManager.instance.user.info.wxUnionId)
            ? _wechatBindingWidget()
            : Container(),
        // _incomeWidget(),
      ],
    );
  }

  _wechatBindingWidget() {
    Color greyColor = Color.fromARGB(255, 119, 119, 119);
    Container con = Container(
        padding: EdgeInsets.only(left: rSize(15), right: rSize(15)),
        height: 40,
        margin: EdgeInsets.only(
          left: rSize(10),
          right: rSize(10),
          top: rSize(8),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '您的账号还未绑定微信',
              style: TextStyle(color: greyColor, fontSize: 12),
            ),
            Spacer(),
            Text(
              '点击前往',
              style: TextStyle(color: greyColor, fontSize: 12),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black38,
              size: 18 * 2.sp,
            ),
          ],
        ));
    return GestureDetector(
      onTap: () {
        if (widget.wechatListener != null) {
          widget.wechatListener();
        }
      },
      child: con,
    );
  }

  Container _balanceWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: rSize(10),
        right: rSize(10),
        top: rSize(8),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Stack(children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: rSize(15), vertical: rSize(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: rSize(15), right: rSize(15), top: rSize(10)),
                child: Row(
                  children: <Widget>[
                    Text('我的余额', style: _moneyStyle),
                    Text('(元)', style: _subMoneyStyle),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: rSize(10),
                  left: rSize(15),
                  right: rSize(15),
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (widget.listener != null) {
                          widget.listener(0);
                        }
                      },
                      child: Text(
                        getStore().state.userBrief.balance.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColor.themeColor,
                            fontSize: 22 * 2.sp),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (widget.listener != null) {
                          widget.listener(1);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '提现',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.themeColor,
                            fontSize: 14 * 2.sp,
                          ),
                        ),
                        width: 70,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5, color: AppColor.themeColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10 * 2.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 240, 216),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                height: 35 * 2.h,
                child: Container(
                  alignment: Alignment.center,
                  // child: Text(getStore().state.userBrief.advice, style: TextStyle(fontSize: ScreenAdapterUtils.setSp(12.5), fontWeight: FontWeight.w300, color: Color.fromARGB(255, 180, 109, 78)),),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container _incomeWidget() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: rSize(10), vertical: rSize(8)),
      margin: EdgeInsets.only(
        left: rSize(10),
        right: rSize(10),
        top: rSize(8),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Stack(children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: rSize(15), vertical: rSize(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: rSize(15), right: rSize(15), top: rSize(10)),
                child: Row(
                  children: <Widget>[
                    Text(
                      '我的自购省',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.themeColor,
                          fontSize: 15 * 2.sp),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (widget.listener != null) {
                          widget.listener(2);
                        }
                      },
                      child: Text(
                        '查看自购明细',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black45,
                            fontSize: 12 * 2.sp),
                      ),
                    ),
                    // Text('查看订单明细' , style: TextStyle( fontWeight: FontWeight.w400, color: AppColor.greyColor, fontSize: 12*2.sp),),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black38,
                      size: 18 * 2.sp,
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 5 * 2.h),
              ),
              Container(
                height: 65,
                margin: EdgeInsets.only(
                  top: rSize(10),
                  left: rSize(15),
                  right: rSize(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: rSize(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Expanded(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Container(
                    //         alignment: Alignment.centerLeft,
                    //         child: RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(text:'已到账',style: _moneyStyle),
                    //               TextSpan(text: '  (元)' , style: _subMoneyStyle)
                    //             ]
                    //           ),
                    //         ),
                    //       ),
                    //       Container(height: 10,),
                    //       Container(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text('0.00', style: _moneyTitleStyle,),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (widget.listener != null) {
                          widget.listener(3);
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: '未到账', style: _moneyStyle),
                                TextSpan(text: '(元)', style: _subMoneyStyle)
                              ]),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            // child: Text(getStore().state.userBrief.buy.frozenCommission.toString(), style: _moneyTitleStyle,),
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (widget.listener != null) {
                          widget.listener(4);
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(text: '累计收入', style: _moneyStyle),
                                TextSpan(text: '(元)', style: _subMoneyStyle)
                              ]),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            // child: Text(getStore().state.userBrief.buy.cumulativeCommission.toString(), style: _moneyTitleStyle,),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // Expanded buildAccount(String title, String value, {VoidCallback onTap}) {
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             title,
  //             // style: AppTextStyle.generate(12, color: _greyColor),
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(top: 5),
  //             child: Text(
  //               value.toString(),
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //               style: AppTextStyle.generate(17*2.sp,
  //                   fontWeight: FontWeight.w500, color: Colors.black),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
