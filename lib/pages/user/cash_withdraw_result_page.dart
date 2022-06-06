

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/withdraw_detail_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/toast.dart';

class CashWithdrawResultPage extends StatefulWidget {
  final Map? arguments;
  const CashWithdrawResultPage({Key? key, this.arguments}) : super(key: key);
  static setArguments({num? id}){
    return {"id": id};
  }
  @override
  _CashWithdrawResultPageState createState() => _CashWithdrawResultPageState();
}

class _CashWithdrawResultPageState extends BaseStoreState<CashWithdrawResultPage> {

  Color titleColor = Colors.black.withOpacity(0.6);

  String iconNormal = 'assets/cash_result_normal.png';
  String iconSelect = "assets/cash_result_select.png";
  String iconSuccess = "assets/cash_result_success.png";
  WithdrawDetailModel? _withdrawDetailModel;
  @override
  void initState() { 
    super.initState();
    getWithdrawDetail();
  }
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '申请结果',
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        background: Colors.white,
        elevation: 0,
      ),
      body: _withdrawDetailModel==null? loadingView()
       :Container(
        color: AppColor.frenchColor,
        padding: EdgeInsets.only(top: 1),
        child: ListView(
          children: <Widget>[
            _cashProgressWidget(),
            _cashStateWidget(),
            _cashInfoWidget(),
            _cashRemindWidget(),
            _completeButtonWidget(),
          ],
        ),
      ),
    );
  }

  _cashProgressWidget(){
    return Container(
      height: 100, color: Colors.white,
      child: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cashProgressColumnCellWidget(_withdrawDetailModel!.data!.status == 1? iconSuccess:iconSelect, "提交申请", _withdrawDetailModel!.data!.createdAt),
              ),
              Expanded(
                flex: 1,
                child: _cashProgressColumnCellWidget(_withdrawDetailModel!.data!.status == 1? iconNormal:iconSuccess, "提交成功", TextUtils.isEmpty(_withdrawDetailModel!.data!.doneTime)?"":_withdrawDetailModel!.data!.doneTime),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 28.5),
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4+25),
            height: 0.3,
            child: Container(color: Color(0xffc8c8c8),),
          ),
        ],
      ),
    );
  }

  _cashProgressColumnCellWidget(imagePath,title, time){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(imagePath, width: 28, height: 28,),
        Container(height: 11,),
        Text(title, style: TextStyle(color: Colors.black, fontSize: 11),),
        Container(height: 5,),
        Text(time, style: TextStyle(color: Colors.black87, fontSize: 10),),
      ],
    );
  }

  _cashStateWidget(){
    DateTime dateTime = DateTime.parse(_withdrawDetailModel!.data!.auditTime!);
    return Container(
      margin: EdgeInsets.only(top: 1), padding: EdgeInsets.only(left: 17, right: 17 ,top: 20, bottom: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 2.6, height: 13, margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColor.themeColor,
                  borderRadius: BorderRadius.circular(1.3)
                ),
              ),
              Text(_withdrawDetailModel!.data!.status==1?"提现申请已提交，请等待审核":"提现成功", style: TextStyle(fontSize: 12, color: Colors.black),),
            ],
          ),
          Container(height: 4,),
          Text(_withdrawDetailModel!.data!.status==1?"    审核日是${dateTime.month}月${dateTime.day}日":"    预计3个工作日到账", style: TextStyle(color: titleColor, fontSize: 11),)
        ],
      ),
    );
  }
  _cashInfoWidget(){

    return Container(
      padding: EdgeInsets.symmetric(horizontal:10, vertical: 15),
      margin: EdgeInsets.only(left: 17, right: 17, top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white, border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.3)
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("提现小贴士", style: TextStyle(color: titleColor, fontSize: 13),),
          _castInfoRowWidget(title: "本次申请提现金额:", info: "￥${_withdrawDetailModel!.data!.amount!.toStringAsFixed(2)}"),
          _castInfoRowWidget(title: "平台代扣代付税费:", info: "￥${_withdrawDetailModel!.data!.taxFee??0.toStringAsFixed(2)}"),
          _castInfoRowWidget(title: "实际到账金额:", info: "￥${_withdrawDetailModel!.data!.actualAmount??0.toStringAsFixed(2)}"),
          _castInfoRowWidget(title: "申请提现人:", info: _withdrawDetailModel!.data!.userName),
          _castInfoRowWidget(title: "提现方式:", info: TextUtils.isEmpty(_withdrawDetailModel!.data!.bankAccount)? "支付宝 | ${_withdrawDetailModel!.data!.alipay}":"银行 | ${_withdrawDetailModel!.data!.bankAccount}"),
          _castInfoRowWidget(title: "申请提现时间:", info: _withdrawDetailModel!.data!.createdAt),
        ],
      ),
    );
  }

  _castInfoRowWidget({title = "", info = ""}){
    return Container(
      margin: EdgeInsets.only(top: 7),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(title, style: TextStyle(color: titleColor, fontSize: 11),),
          ),
          Expanded(
            flex: 3,
            child: Text(info, maxLines: 2, style: TextStyle(color: titleColor, fontSize: 11),),
          )
        ],
      ),
    );
  }

  _cashRemindWidget(){
    Color infoColor = Colors.black.withOpacity(0.5);
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10, vertical: 15),
      margin: EdgeInsets.only(left: 17, right: 17, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white, border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.3)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("提现小贴士", style: TextStyle(color: titleColor, fontSize: 13),),
          Container(height: 10,),
          Text("什么是审核日", style: TextStyle(color: titleColor, fontSize: 12),),
          Text("每月10号和25号为审核日，您的提现申请会在审核日进行审核", style: TextStyle(color: infoColor, fontSize: 10),),
          Container(height: 10,),
          Text("审核通过后几天能到账？", style: TextStyle(color: titleColor, fontSize: 12),),
          Text("审核通过后3个工作日内会到账，请留意银行或支付宝通知", style: TextStyle(color: infoColor, fontSize: 10),),
        ],
      ),
    );
  }

  _completeButtonWidget(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity, height: 45,
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: CustomImageButton(
        onPressed: ()=> Navigator.maybePop(context),
        title: "完成",
        borderRadius: BorderRadius.circular(3),
        style: TextStyle(color: Colors.white, fontSize: 17),
        backgroundColor: AppColor.themeColor,
      ),
    );
  }

  getWithdrawDetail() async {
    ResultData resultData = await HttpManager.post(UserApi.withdraw_detail, {
      "id": widget.arguments!["id"],
    });
    if (!resultData.result) {
       Toast.showError(resultData.msg);
      return;
    }
    WithdrawDetailModel model = WithdrawDetailModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    _withdrawDetailModel = model;
    setState(() {});
  }

}
