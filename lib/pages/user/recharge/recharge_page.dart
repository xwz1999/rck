import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/pages/user/recharge/recharge_page_second.dart';
import 'package:recook/pages/wholesale/func/wholesale_func.dart';
import 'package:recook/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:recook/pages/wholesale/wholesale_customer_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook_back_button.dart';

class RechargePage extends StatefulWidget {
  RechargePage({
    Key key,
  }) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage>
    with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF3A3842),
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          appBackground: Color(0xFF3A3842),
          leading: RecookBackButton(
            white: true,
          ),
          elevation: 0,
          title: Text(
            "预存款充值",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.rsp,
            ),
          ),
        ),
            body: _bodyWidget());
  }

  _bodyWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          child: Container(
            padding: EdgeInsets.only(top: 12.rw, bottom: 12.rw),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.rw),
                  topRight: Radius.circular(8.rw)),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.wb,
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icRechargeBankRed.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "银行汇款",
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icRecharge.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "充值申请",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep3.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "平台审核",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    20.hb,
                    Image.asset(
                      Assets.icWithdrawalGoto.path,
                      width: 15.rw,
                      height: 15.rw,
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Image.asset(
                      Assets.icWithdrawalStep4.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "充值成功",
                      style: TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 12.rsp,
                      ),
                    ),
                  ],
                )),
                32.wb,
              ],
            ),
          ),
        ),
        Container(
          child: Stack(
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: new Container(
                    color: Colors.white.withOpacity(0.1),
                    width: double.infinity,
                    height: 56.rw,
                  ),
                ),
              ),
              Container(
                height: 56.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    32.wb,
                    Text(
                      "如有疑问，点击联系客服",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.rsp,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                        WholesaleCustomerModel model =
                        await WholesaleFunc.getCustomerInfo();

                        Get.to(() => WholesaleCustomerPage(
                          model: model,
                        ));
                      },
                      child: Container(
                        height: 32.rw,
                        width: 32.rw,
                        padding: EdgeInsets.all(7.rw),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.rw)),
                        child: Image.asset(
                          Assets.icKefu.path,
                          width: 18.rw,
                          height: 18.rw,
                        ),
                      ),
                    ),
                    32.wb,
                  ],
                ),
              ),
            ],
          ),
        ),
        20.hb,
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rw),
              child: Container(
                height: 12.rw,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.rw),
                  color: Color(0xFFD4363E),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.rw, right: 20.rw, top: 5.rw,bottom: 40.rw),
              child: Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 8.rw, right: 8.rw, bottom: 8.rw),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child:Column(
                              children: [
                                44.hb,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    32.wb,
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5.rw),
                                      child: Text(
                                        "收款账户信息",
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16.rsp,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ],
                                ),


                                44.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('账户名', '浙江京耀云供应链管理有限公司'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('开户银行', '上海浦东发展银行宁波鄞州支行'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem(
                                      '银行账户',
                                      '94170078801800002166',
                                    height: 1.2
                                  ),
                                ),
                                48.hb,
                                _copyMsg(),
                                40.hb,

                              ],
                            ),
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 19.rw, right: 19.rw, top: 5.rw),
              child: Container(
                height: 2.rw,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rw),
                    color: Color(0xFFC60C16),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 1.rw),
                          color: Color(0xFFD14C4C),
                          blurRadius: 5.rw,
                          spreadRadius: 1.rw)
                    ]),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rw,
          ),
          child: GestureDetector(
            onTap: (){
              Get.to(()=>RechargePageSecond());
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 36.rw,
              decoration: BoxDecoration(
                  color: Color(0xFFD5101A),
                  borderRadius:
                  BorderRadius.circular(18.rw)),
              child: Text(
                '已汇款，下一步',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.rsp,
                ),
              ),
            ),
          ),
        ),
        72.hb,
      ],
    );
  }

  _textItem(String title, String content, {bool show = false,double height }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60.rw,
          child: Text(
            title,
            style:
            height!=null   ?TextStyle(
              color: Color(0xFF999999),
      fontSize: 14.rsp,
      fontWeight: FontWeight.bold,
      height: 1.2
    ):
            TextStyle(
              color: Color(0xFF999999),
              fontSize: 14.rsp,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
        16.wb,
        Expanded(
          child: Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.rsp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        show
            ? GestureDetector(
                onTap: () {
                  ClipboardData data = new ClipboardData(text: content);
                  Clipboard.setData(data);
                  ReToast.success(text: '复制成功');
                },
                child: Image.asset(
                  Assets.icWithdrawalCopy.path,
                  width: 16.rw,
                  height: 16.rw,
                ),
              )
            : SizedBox(),
      ],
    );
  }

  _copyMsg() {
    return GestureDetector(
            onTap: () {
              ClipboardData data = new ClipboardData(
                  text: '''浙江京耀云供应链管理有限公司
       上海浦东发展银行宁波鄞州支行
       94170078801800002166
        ''');
              Clipboard.setData(data);
              ReToast.success(text: '复制成功');
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icWithdrawalCopy.path,
                    width: 16.rw,
                    height: 16.rw,
                  ),
                  20.wb,
                  Text(
                    "复制汇款信息",
                    style: TextStyle(
                      color: Color(0xFFD5101A),
                      fontSize: 14.rsp,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

}

