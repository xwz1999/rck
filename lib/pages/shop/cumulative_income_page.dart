import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/base/mixin_test.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/team_income_model.dart';
import 'package:recook/pages/shop/commission_income_widget.dart';
import 'package:recook/redux/theme_redux.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/dashed_rect.dart';
import 'package:intl/intl.dart';

class CumulativeIncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CumulativeIncomePageState();
  }
  
}

class _CumulativeIncomePageState extends BaseStoreState<CumulativeIncomePage> with TickerProviderStateMixin {
  
  TeamIncomeModel _teamIncomeModel;
  bool _noData = false;
  
  String _selectYear;
  
  @override
  void initState() { 
    _selectYear = DateTime.now().year.toString();
    _getShopIncome();
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: AppColor.blackColor,
        themeData: AppThemes.themeDataMain.appBarTheme,
        elevation: 0,
        title: "累计收益",
      ),
      body: _body(),
    );
  }

  _body(){
    return Container(
      color: AppColor.frenchColor,
      width: double.infinity, height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, top: 0,
            height: 200/375*ScreenUtil.screenWidthDp,
            child: Image.asset(ShopImageName.income_appbar_bg, fit: BoxFit.fill,),
          ),
          Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                _barWidget(),
                _selectTimeWidget(),
                _infoWidget()
              ],
            )
          )
        ],
      ),
    );
  }

  _showTimePickerBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: [BottomTimePickerType.BottomTimePickerYear],
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: (time, type) {
                Navigator.maybePop(context);
                _selectYear = time.year.toString();
                setState(() {});
                _getShopIncome();
              },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

    _selectTimeWidget(){
      return Container(
        padding: EdgeInsets.only(left: 15, right:15, top: 10),
        height: 50,
        child: Row(
          children: <Widget>[
            TimeSelectTitleWidget(
              title: _selectYear,
              click: (){
                _showTimePickerBottomSheet();
              },
            ),
            Spacer(),
            Container(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "年度收益:", style: TextStyle(color: Color(0xff999999),fontSize: 14, ),),
                    TextSpan(text:_teamIncomeModel==null?"0.00": _teamIncomeModel.data.yearIncome?.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.w500 , color: AppColor.redColor, fontSize: 14)),
                  ]
                )
              ),
            ),
          ],
        ),
      );
    }

    _barWidget(){
      double width = ScreenUtil.screenWidthDp-30;
      double height = 170.0/345*width; 
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: width, height: height+40,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft, height: 40,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "收益汇总", style: TextStyle(color: Colors.white, fontSize: ScreenAdapterUtils.setSp(14))),
                    TextSpan(text: "(瑞币)", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: ScreenAdapterUtils.setSp(10))),
                  ]
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(ShopImageName.income_card)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: _textColumn(
                        titleText: "累计收益",
                        infoText: _teamIncomeModel==null?"0.00": _teamIncomeModel.data.accumulateIncome.all?.toStringAsFixed(2),
                        infoFontSize: 20
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _textColumn(
                            titleAligment: Alignment.centerLeft,
                            titleText: "自购收益",
                            infoText: _teamIncomeModel==null?"0.00": _teamIncomeModel.data.accumulateIncome.selfShopping?.toStringAsFixed(2),
                          ),
                          Spacer(),
                          _textColumn(
                            titleText: "导购收益",
                            infoText: _teamIncomeModel==null?"0.00": _teamIncomeModel.data.accumulateIncome.share?.toStringAsFixed(2),
                          ),
                          _teamIncomeModel!=null && _teamIncomeModel.data.roleVisable? Spacer():Container(),
                          _teamIncomeModel!=null && _teamIncomeModel.data.roleVisable? 
                          _textColumn(
                            titleText: "团队收益",
                            infoText: _teamIncomeModel==null?"0.00": _teamIncomeModel.data.accumulateIncome.team?.toStringAsFixed(2),
                            infoColor: UserLevelTool.roleLevelEnum(_teamIncomeModel?.data?.roleLevel) == UserRoleLevel.Master?
                              Colors.black26: Colors.black
                          )
                          : Container()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    _infoWidget(){
      double width = ScreenUtil.screenWidthDp;
      double height = 140*width/375;
      return Container(
        constraints: BoxConstraints(minHeight: height, minWidth: width, ),
        decoration: BoxDecoration(
          image: DecorationImage(
            // centerSlice: Rect.fromLTRB(30, 90, 30, 30),
            centerSlice: Rect.fromLTWH(30, 100, 30, 1),
            image: AssetImage(ShopImageName.income_page_bg,),
          )
        ),
        child: Container(
          margin: EdgeInsets.only(top: 30,bottom: 30),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30), height: 60,
                child: Row(
                  children: <Widget>[
                    Text("月度收益", style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500), ),
                    Spacer(),
                    Text(_teamIncomeModel==null ? "" : "共${_teamIncomeModel.data.incomes.length}期收益", style: TextStyle(fontSize: 14, color: Colors.black26, ), ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 13 , vertical: 10),
                width: double.infinity,
                child: DashedRect( color: Color(0xffe6e6e6), strokeWidth: 2, gap: 5,),
              ),
              _teamIncomeModel == null || !(_teamIncomeModel.data.incomes!=null && _teamIncomeModel.data.incomes.length>0) ? 
              Container(
                width: 140, height: 130,
                child: Image.asset(ShopImageName.income_nodata),
                margin: EdgeInsets.symmetric(horizontal: 30),
              )
              : Container(
                child: Column(
                  children: _itemList()
                ),
              )
            ],
          ),
          // height: height+500, 
        ),
      );
    }

  _itemList(){
    List<Widget> widgetList = [];
    for (var i = 0; i < _teamIncomeModel.data.incomes.length; i++) {
      widgetList.add(_itemWidget(_teamIncomeModel.data.incomes[i], isFirst: i==0, isLast: i == _teamIncomeModel.data.incomes.length-1));
    }
    return widgetList;
  }

  _itemWidget(Incomes income, {bool isFirst = false, bool isLast = false}){
    // DateTime time = DateTime.parse(income.month);
    DateFormat sourceFormat = DateFormat("yyyy-MM");
    DateTime time = sourceFormat.parse(income.month);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30), height: 130,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, top: 10, bottom: 10,
            child: Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Color(0xfff7f8fa),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: time.month.toString(), style: TextStyle(color: Colors.black, fontSize: 18),),
                          TextSpan(text: "月", style: TextStyle(color: Colors.black, fontSize: 13),)
                        ]
                      )),
                      Spacer(),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "总收益:", style: TextStyle(color: Colors.black26, fontSize: 14),),
                          TextSpan(text: income.totalIncome.toStringAsFixed(2), style: TextStyle(color: AppColor.redColor, fontSize: 14),)
                        ]
                      )),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      _textColumn(
                        titleColor: Color(0xff666666),
                        titleAligment: Alignment.centerLeft,
                        titleText: "自购收益",
                        infoText: income.myIncome.toStringAsFixed(2),
                      ),
                      Spacer(),
                      _textColumn(
                        titleColor: Color(0xff666666),
                        titleAligment: Alignment.centerLeft,
                        titleText: "导购收益",
                        infoText: income.shareIncome.toStringAsFixed(2),
                      ),
                      _teamIncomeModel.data.roleVisable?Spacer():Container(),
                      _teamIncomeModel.data.roleVisable? _textColumn(
                        titleColor: UserLevelTool.roleLevelEnum(_teamIncomeModel?.data?.roleLevel) == UserRoleLevel.Master?
                          Colors.black26 : Color(0xff666666),
                        titleAligment: Alignment.centerLeft,
                        titleText: "团队收益",
                        infoText: income.teamIncome<0? "未结算": income.teamIncome.toStringAsFixed(2),
                        infoColor: UserLevelTool.roleLevelEnum(_teamIncomeModel?.data?.roleLevel) == UserRoleLevel.Master?
                          Colors.black26 : income.teamIncome<0? AppColor.redColor:Colors.black,
                        infoFontSize: income.teamIncome<0?12:16
                      )
                      : Container()
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 10, top: 0, width: 3, height: 19,
            child: Offstage(
              offstage: isFirst,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
                  color: AppColor.redColor
                ),
              )
            )
          ),
          Positioned(
            right: 10, top: 0, width: 3, height: 19,
            child: Offstage(
              offstage: isFirst,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
                  color: AppColor.redColor
                ),
              )
            )
          ),
          Positioned(
            left: 10, bottom: 0, width: 3, height: 19,
            child: Offstage(
              offstage: isLast,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  color: AppColor.redColor
                ),
              )
            )
          ),
          Positioned(
            right: 10, bottom: 0, width: 3, height: 19,
            child: Offstage(
              offstage: isLast,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  color: AppColor.redColor
                ),
              )
            )
          ),
        ],
      ),
    );
  }


  _getShopIncome() async {
    ResultData resultData = await HttpManager.post(ShopApi.shop_addup_income, {
      "userId": UserManager.instance.user.info.id,
      "year": TextUtils.isEmpty(_selectYear)? DateTime.now().year.toString() : _selectYear,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    TeamIncomeModel model = TeamIncomeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _teamIncomeModel = model;
    setState(() {});
  }

  _textColumn(
      {String titleText="" ,Color titleColor = Colors.black26 ,double titleFontSize=12, Alignment titleAligment=Alignment.centerLeft, 
      String infoText="" ,Color infoColor=Colors.black,  double infoFontSize=16,Alignment infoAligment=Alignment.centerLeft}
    ){
    return Column(
      children: <Widget>[
        Container(
          alignment: titleAligment,
          child: Text(titleText, style: TextStyle(color: titleColor,fontSize: titleFontSize ), ),
        ),
        Container(height: 5,),
        Container(
          alignment: infoAligment,
          child: Text(infoText,style: TextStyle(color: infoColor,fontSize: infoFontSize ), ),
        )
      ],
    );
  }

}







/*
@override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        title: "累计收入",
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.black,
            labelColor: AppColor.themeColor,
            indicatorColor: AppColor.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: false,
            labelPadding: EdgeInsets.all(0),
            labelStyle: AppTextStyle.generate(14, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text:"团队收入", ),
              Tab(text:"提成收入", ),
          ]),
        ),
      ),
      body: CacheTabBarView(
        controller: _tabController,
        children: <Widget>[
          TeamIncomeWidget(),
          CommissionIncomeWidget(),
          // Container()
          // FocusPage(),
          // // FocusPage(),
          // RecommendPage(),
      ],),
    );
  }
*/