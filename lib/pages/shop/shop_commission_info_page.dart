import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/commission_income_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';

class ShopCommissionInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopCommissionInfoPageState();
  }
  
}

class _ShopCommissionInfoPageState extends BaseStoreState<ShopCommissionInfoPage>{

  CommissionIncomeModel _model;
  List<IncomeList> _listData = [];
  List<String > _dateList = [];
  var _selectValue;
  int _page = 0;
  GSRefreshController _gsRefreshController;

  @override
  void initState() { 
    super.initState();
    _gsRefreshController = GSRefreshController();
    _getDateTime();
    _selectValue = _dateList.first;
    _getIncomeSalesList();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "提成明细",
      ),
      // body: _bodyWidget(),
      body: _model == null ? loadingWidget() : RefreshWidget(
        onRefresh: (){
          _page = 0;
          _getIncomeSalesList();
        },
        onLoadMore:
          _listData == null || _listData.length < (_page+1)*20 ? null : () {
                  _page++;
                  _getIncomeSalesList();
                },
        controller: _gsRefreshController,
        body: _bodyWidget(),
      ),
    );
  }
  
  _bodyWidget(){
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: <Widget>[
        _model ==null?SliverToBoxAdapter(child: Container()): SliverToBoxAdapter(
          child: _titleWidget(),
        ),
        _model ==null?SliverToBoxAdapter(child: Container()): SliverToBoxAdapter(
          child: _cardWidget(
            _model.data.statistics.income.toDouble(), 
            _model.data.statistics.salesAmount, 
            _model.data.statistics.orderCount,),
        ),
        _model ==null?SliverToBoxAdapter(child: Container()): SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              height: 45, alignment: Alignment.centerLeft,
              color: AppColor.frenchColor,
              child: Text('明细', style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),),
            ),
          ),
        _listData == null || _listData.length == 0 ? 
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            child: noDataView('没有数据...'),
          )
        ): 
        SliverList(
          delegate: new SliverChildListDelegate(
            _listData.map<Widget>((IncomeList data){
              return _itemWidget(data);
            }).toList()
          )),
      ],
    );
  }

  _titleWidget(){
    return Container(
      height: 60, color: Colors.white,
      // color: AppColor.tableViewGrayColor,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15),
            width: 90, height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.tableViewGrayColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('  本月', style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(12))),
                Container(width: 10,),
                _popupMenuWidget(),
                // GestureDetector(
                //   onTap: (){
                //     _showPasswordBottomSheet();
                //   },
                //   child: Container(color: Colors.yellow, width: 60,),
                // ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16,),
              ],
            ),
          ),
          Spacer(),
          Container(width: 10,),
        ],
      ),
    );
  }

  _cardWidget(num amount, num sales, num orderNumber){
    return Container(
      height: 130, margin: EdgeInsets.only(left: 16,right: 16, bottom: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red
        ),
        child: Column(
          children: <Widget>[
            _cardTextItem('收益', amount.toString(), false),
            Spacer(),
            Row(
              children: <Widget>[
                _cardTextItem('销售额', sales.toString(),false),
                Spacer(),
                _cardTextItem('订单数', orderNumber.toString(),true),
              ],
            )
          ],
        ),
      ),
    );
  }

  _cardTextItem(String title, String amount, bool moneyIconHidden,){
    return Container(
      child: Column(
        children: <Widget>[
          Container( alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: ScreenAdapterUtils.setSp(12),),),
          ),
          Container( alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text:moneyIconHidden ? "":'￥', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: ScreenAdapterUtils.setSp(11),),),
                  TextSpan(text:amount, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: ScreenAdapterUtils.setSp(18),),),
                ]
              ),
            )
          ),
        ],
      ),
    );
  }

  _popupMenuWidget(){
    return PopupMenuButton(
      color: Colors.white,
      offset: Offset(0, 100),
      child: Text(_selectValue==null?'':_selectValue, style: TextStyle(color: Colors.black),),
      padding: EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context) {
        return _dateList.map<PopupMenuItem<String>>((value){
          return PopupMenuItem<String>(child: Text(value, style: TextStyle(color: Colors.black),), value: value,);
        }).toList();
      },
      onSelected: (String value) {
        _selectValue = value;
        _page = 0;
        _gsRefreshController.requestRefresh();
        setState(() {});
      },
    );
  }

  _getDateTime(){
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;
    if (month.toString().length==1) {
      _dateList.add("$year-0$month");
    }else{
      _dateList.add("$year-$month");
    }
    int count = 5;
    while(count > 0){
      count --;
      if (month == 1) {
        year--;
        month = 12;
      }else{
        month --;
      }
      if (month.toString().length==1) {
        _dateList.add("$year-0$month");
      }else{
        _dateList.add("$year-$month");
      }
    }
  }
  _itemWidget(IncomeList data){
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 10,),
                Image.asset(data.amount>0?'assets/icon_income_in.png':'assets/icon_income_out.png',width: 40, height: 40,),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 35, alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 20),
                        child: Text(data.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(15)),),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.amount>0?'+'+data.amount.toString():data.amount.toString() ,
                        style: TextStyle(color: data.amount>0?Colors.red:Colors.green, fontSize: ScreenAdapterUtils.setSp(18)),),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(data.comment, style:TextStyle(color: Colors.black.withOpacity(0.5),fontSize: ScreenAdapterUtils.setSp(12) ),)
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(data.orderTime, style:TextStyle(color: Colors.black.withOpacity(0.5),fontSize: ScreenAdapterUtils.setSp(12) ),)
                ),
                Spacer(),
                Container(
                  height: 0.3,
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getIncomeSalesList() async {
    ResultData resultData = await HttpManager.post(ShopApi.income_sales_list, {
      "userId": UserManager.instance.user.info.id,
      "page":_page,
      "date":_selectValue,
    });
    _gsRefreshController.isRefresh()?_gsRefreshController.refreshCompleted():null;
    _gsRefreshController.isLoading()?_gsRefreshController.loadComplete():null;

    if (!resultData.result) {
      GSDialog.of(context).showError(context, resultData.msg);
      return;
    }
    CommissionIncomeModel model = CommissionIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      GSDialog.of(context).showError(context, model.msg);
      return;
    }
    _model = model;
    if (_page == 0) {
      _listData = model.data.list;
    }else{
      _listData.addAll(model.data.list);
    }
    setState(() {});
  }

  _showPasswordBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
          return SizedBox(
            height: 220.0+190.0,
            child: Container(color: Colors.red),
          );
      },
    ).then((val) {
      if (mounted) {
        
      }
    });
  }

}
