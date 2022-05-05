import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/utils/amount_format.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/result_page.dart';

class RuiCoinTransferToBalancePage extends StatefulWidget {
  final Map arguments;
  RuiCoinTransferToBalancePage({Key key, this.arguments}) : super(key: key);

  static setArguments(num total){
    return {
      "total": total,
    };
  }

  @override
  _RuiCoinTransferToBalancePageState createState() => _RuiCoinTransferToBalancePageState();
}

class _RuiCoinTransferToBalancePageState extends BaseStoreState<RuiCoinTransferToBalancePage> {

  //
  TextEditingController _textEditController ;
  FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() { 
    super.initState();
    _textEditController = TextEditingController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        background: Colors.white,
        appBackground: Colors.white,
        title: "转出到余额",
        elevation: 0,
      ),
      body: Listener(
        onPointerDown: (_){
          _contentFocusNode.unfocus();
        },
        child: Container(
          color: AppColor.frenchColor,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _infoWidget(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: CustomImageButton(
                  onPressed: !_canSubmit()? null
                    : (){
                    _coinToBalance(double.parse(_textEditController.text));
                    },
                  borderRadius: BorderRadius.circular(3),
                  height: 45, width: double.infinity,
                  title: "确认转出",
                  backgroundColor: AppColor.themeColor,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  disableStyle: TextStyle(color: Color(0xffbfbfbf), fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _canSubmit(){
    bool can = false;
    try {
      double amount = double.parse(_textEditController.text);
      if (amount > 0) {
        can = true;
      }
    } catch (e) {
      can = false;
    }
    return can;
  }

  _infoWidget(){
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 17),
      width: double.infinity, height: 120.0, color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            height: 40, alignment: Alignment.bottomLeft,
            child: Text("转出瑞币(个)", style: TextStyle(color: Colors.grey, fontSize: 16),),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Text("¥", style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.w400),),
                Expanded(
                  child: CupertinoTextField(
                    inputFormatters: [AmountFormat()],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: _textEditController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_submitted){
                      _contentFocusNode.unfocus();
                      setState(() {});
                    },
                    focusNode: _contentFocusNode,
                    onChanged: (text){
                      setState(() {});
                    },
                    placeholder: "本次最多可转出${widget.arguments["total"]}个",
                    placeholderStyle: TextStyle(color: Color(0xffcccccc), fontSize: 16, fontWeight: FontWeight.w300),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(0)
                    ),
                    style: TextStyle(color: Colors.black, textBaseline: TextBaseline.ideographic),
                  ),
                ),
                CustomImageButton(
                  onPressed: (){
                    _textEditController.text = widget.arguments["total"].toString();
                    setState(() {});
                  },
                  title: "全部",
                  style: TextStyle(color: AppColor.themeColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _coinToBalance(double coinNum) async {
    ResultData resultData = await HttpManager.post(UserApi.coin_to_balance, {
      "userId": UserManager.instance.user.info.id,
      "coinNum": coinNum<0?0:coinNum
    });

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    // UpgradeCardModel model = UpgradeCardModel.fromJson(resultData.data);
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      AppRouter.pushAndReplaced(context, RouteName.RESULT_PAGE, arguments: ResultPage.setArgument(isSuccess: false, title: "结果详情", info: model.msg));
      // GSDialog.of(context).showError(context, model.msg);
      return;
    }
    AppRouter.pushAndReplaced(context, RouteName.RESULT_PAGE, arguments: ResultPage.setArgument(isSuccess: true, title: "结果详情", info: "转出成功"));
  }


}
