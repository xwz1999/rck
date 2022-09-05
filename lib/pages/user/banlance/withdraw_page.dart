import 'dart:ui';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/banlance/withdraw_page_second.dart';
import 'package:recook/pages/user/functions/user_balance_func.dart';
import 'package:recook/pages/user/model/contact_info_model.dart';
import 'package:recook/pages/user/model/withdraw_amount_model.dart';
import 'package:recook/pages/user/widget/MySeparator.dart';
import 'package:recook/pages/user/withdraw_rule_page.dart';
import 'package:recook/pages/wholesale/func/wholesale_func.dart';
import 'package:recook/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:recook/pages/wholesale/wholesale_customer_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/toast.dart';

class WithDrawPage extends StatefulWidget {
  WithDrawPage({
    Key? key,
  }) : super(key: key);

  @override
  _WithDrawPageState createState() => _WithDrawPageState();
}

class _WithDrawPageState extends State<WithDrawPage>
    with TickerProviderStateMixin {

  ContactInfoModel? _model = ContactInfoModel(address: '',email: '',name: '',mobile: '');


  WithdrawAmountModel? _amount = WithdrawAmountModel(balance: 0,taxAmount: 0,withdrawal: 0,actualAmount: 0);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async{

      _model =  await UserBalanceFunc.getContractInfo();
      setState(() {

      });
    });
    getAllAmount();
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
            "申请提现",
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
                      Assets.icWithdrawalStep1Red.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                     Text(
                      "开发票",
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
                      Assets.icWithdrawalStep2.path,
                      width: 36.rw,
                      height: 36.rw,
                    ),
                    10.hb,
                    Text(
                      "申请提现",
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
                      "打款到账",
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
                        // WholesaleCustomerModel? model =
                        // await WholesaleFunc.getCustomerInfo();
                        //
                        // Get.to(() => WholesaleCustomerPage(
                        //   model: model,
                        // ));
                        if (UserManager.instance!.user.info!.id == 0) {
                          AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                          Toast.showError('请先登录...');
                          return;
                        }
                        BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");
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
                                    Text(
                                      "结算金额",
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14.rsp,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '¥' +
                                          TextUtils.getCount1((_amount!.balance??
                                              0.0))!,
                                      style: TextStyle(
                                          height: 1,
                                          color: Color(0xFF333333),
                                          fontSize: 14.rsp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    34.wb,
                                  ],
                                ),
                                20.hb,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    32.wb,
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(()=>WithdrawRulePage(type: UserManager.instance!.userBrief!.tax=='一般纳税人'?2:UserManager.instance!.userBrief!.tax==''?1:3,));///通过userInfo里的字段来判读
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "需缴税费金额",
                                            style: TextStyle(color: Color(0xFF333333), fontSize: 14.rsp),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(top: 2.rw),
                                            child: Icon(
                                              Icons.help_outline,
                                              size: 12,
                                              color: Color(0xff666666),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '¥' +
                                          TextUtils.getCount1((_amount!.taxAmount ??
                                              0.0))!,
                                      style: TextStyle(
                                          height: 1,
                                          color: Color(0xFF333333),
                                          fontSize: 14.rsp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    34.wb,
                                  ],
                                ),
                                20.hb,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    32.wb,
                                    Text(
                                      "实际结算金额",
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14.rsp,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '¥' +
                                          TextUtils.getCount1((_amount!.actualAmount??
                                              0.0))!,
                                      style: TextStyle(
                                          height: 1,
                                          color: Color(0xFF333333),
                                          fontSize: 14.rsp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    34.wb,
                                  ],
                                ),
                                20.hb,
                                Padding(
                                  padding: EdgeInsets.only(left: 16.rw,right: 16.rw),
                                  child: Text(
                                    "请开增值税专用发票，收到发票后的10个工作日内安排付款，注意查收！",
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    ),
                                  ),
                                ),

                                40.hb,
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.rw),
                                  child: MySeparator(
                                    color: Color(0xFFEEEEEE),
                                    height: 1.rw,
                                  ),
                                ),
                                40.hb,
                                Container(
                                  width: 86.rw,
                                  height: 42.rw,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Assets.imgYuanquan.path),
                                          fit: BoxFit.fill)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '对公开票信息',
                                    style: TextStyle(
                                      color: Color(0xFFCE1A23),
                                      fontSize: 14.rsp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                44.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('开票内容', '现代服务*推广服务费或营销服务费'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('单位全称', '浙江京耀云供应链管理有限公司'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('税号', '91330201MA7E4AA99L',height: 1),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem(
                                      '地址电话',
                                      '浙江省宁波高新区菁华路108号024幢4楼4-3  15267755720'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('开户行', '上海浦东发展银行宁波鄞州支行'),
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('银行账户', '94170078801800002166',height: 1),
                                ),
                                40.hb,
                                _copyMsg(),
                                40.hb,
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.rw),
                                  child: MySeparator(
                                    color: Color(0xFFEEEEEE),
                                    height: 1.rw,
                                  ),
                                ),
                                46.hb,
                                Row(
                                  children: [
                                    32.wb,
                                    Text(
                                      '其他信息',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14.rsp,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                32.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem(
                                      '收件地址',
                                      _model!.address!+' '+_model!.name!+' '+_model!.mobile!,
                                      show: true), //
                                ),
                                48.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: _textItem('收件邮箱', _model!.email,
                                      show: true,height: 1),
                                ),
                                60.hb,
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.rw,
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(()=>WithDrawPageSecond(amount: _amount, ));
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
                                        '已开票，下一步',
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
                            ),
                    ),
                  ),
                  Positioned(
                      top: 160.rw,
                      left: 0,
                      child: Container(
                        width: 16.rw,
                        height: 16.rw,
                        decoration: BoxDecoration(
                            color: Color(0xFF3A3842),
                            borderRadius: BorderRadius.circular(8.rw)),
                      )),
                  Positioned(
                      top: 160.rw,
                      right: 0,
                      child: Container(
                        width: 16.rw,
                        height: 16.rw,
                        decoration: BoxDecoration(
                            color: Color(0xFF3A3842),
                            borderRadius: BorderRadius.circular(8.rw)),
                      )),

                  Positioned(
                      bottom: 0.rw,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.rw),
                          child: _bottomWidget())),
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
      ],
    );
  }

  _textItem(String title, String? content, {bool show = false,double height = -1}) {
    return Container(
      color: Colors.transparent,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 60.rw,
            child: Text(
              title,
              style: TextStyle(

                color: Color(0xFF999999),
                fontSize: 14.rsp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          16.wb,
          Expanded(
            child:
          height!=-1?
          Padding(
            padding:  EdgeInsets.only(top: 2.rw),
            child: Text(
              content!,
              maxLines: 3,

              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14.rsp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ):
            Text(
              content!,
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
      ),
    );
  }

  _copyMsg() {
    return GestureDetector(
            onTap: () {
              ClipboardData data = new ClipboardData(
                  text: '''浙江京耀云供应链管理有限公司
                  91330201MA7E4AA99L
       浙江省宁波高新区菁华路108号024幢4楼4-3 15267755720
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
                    "复制开票信息",
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

  Future<WithdrawAmountModel?> getAllAmount(
      ) async {
    ///channel 1 购物车购买 0直接购买
    ResultData res = await HttpManager.post(APIV2.userAPI.allAmount, {
    });

    WithdrawAmountModel? model;

    if(res.data!=null){
      if(res.data['code']=='FAIL'){
        ReToast.err(text: res.data['msg']);
      }

      if(res.data['data']!=null){
        _amount = WithdrawAmountModel.fromJson(res.data['data']);

      }else
        _amount = null;
    }else
      _amount = null;


    setState(() {

    });

    return model;
  }


  _bottomWidget() {
    List<Widget> tiles = [];
    for (int i = 0; i < 14; i++) {
      tiles.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.rw),
          child: Container(
            width: 16.rw,
            height: 16.rw,
            decoration: BoxDecoration(
                color: Color(0xFF3A3842),
                borderRadius: BorderRadius.circular(8.rw)),
          ),
        ),
      );
    }
    return Row(children: tiles);
  }
}

