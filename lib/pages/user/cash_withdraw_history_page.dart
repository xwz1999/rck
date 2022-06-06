import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/withdraw_history_model.dart';
import 'package:recook/pages/user/cash_withdraw_result_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';

class CashWithdrawHistoryPage extends StatefulWidget {
  @override
  _CashWithdrawHistoryPageState createState() => _CashWithdrawHistoryPageState();
}

class _CashWithdrawHistoryPageState extends BaseStoreState<CashWithdrawHistoryPage> {

  GSRefreshController? _refreshController;
  WithdrawHistoryModel? _withdrawHistoryModel;
  @override
  void initState() {
    super.initState();
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "提现记录",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        background: Colors.white,
        appBackground: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 1,
            color: AppColor.frenchColor,
          ),
          Expanded(
            child: RefreshWidget(
              controller: _refreshController,
              onRefresh: (){
                getWithdrawHistoryList();
              },
              body: _withdrawHistoryModel==null || _withdrawHistoryModel!.data!.length==0 ? 
              noDataView("没有记录...")
              :ListView.builder(
                itemCount: _withdrawHistoryModel!.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Data data = _withdrawHistoryModel!.data![index];
                  return GestureDetector(
                    onTap: (){
                      AppRouter.push(context, RouteName.CASH_WITHDRAW_RESULT_PAGE, arguments: CashWithdrawResultPage.setArguments(id: data.id));
                    },
                    child: _itemWidget(data),
                  );
                },
              )
            )
          )
        ],
      ),
    );
  }

  _itemWidget(Data model){
    return Container(
      color: Colors.white,
      height: 88, width: double.infinity,
      padding: EdgeInsets.only(left: 17),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("提现金额 ", style: TextStyle(color: Color(0xFF333333), fontSize: 16.rsp),),
                          Text("¥${model.amount}", style: TextStyle(color: Color(0xFF333333), fontSize: 16.rsp),),
                        ],
                      ),
                      Container(height: 3,),
                      Row(
                        children: [
                          Text("税费${model.taxFee}元，实际到账", style: TextStyle(color: Color(0xFF333333) ,fontSize: 12.rsp),),
                          Text("${model.actualAmount}元", style: TextStyle(color: Color(0xFFD5101A), fontSize: 12.rsp),),
                        ],
                      ),
                      Container(height: 3,),
                      Text("${model.createdAt.toString()}", style: TextStyle(color: Color(0xFF7F7F7F), fontSize: 12, fontWeight: FontWeight.w300),),
                    ],
                  ),
                  Spacer(),
                  Text(model.status==1?"提交申请":"提现成功", style: TextStyle(color: Colors.black, fontSize: 15),),
                  Icon(Icons.keyboard_arrow_right, size: 27, color: Colors.grey, )
                ],
              ),
            ),
          ),
          Container(height: 1, color: AppColor.frenchColor,)
        ],
      ),
    );
  }

  getWithdrawHistoryList() async {
    ResultData resultData = await HttpManager.post(UserApi.withdraw_list, {
      "userId": UserManager.instance!.user.info!.id,
      // "date": "2020-04",	//string 非必须 预留的日期，可以不传，传递到月份“2020-04“
    });
    _refreshController!.refreshCompleted();
    if (!resultData.result) {
       Toast.showError(resultData.msg);
      return;
    }
    WithdrawHistoryModel model = WithdrawHistoryModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return;
    }
    _withdrawHistoryModel = model;
    setState(() {});
  }

}
