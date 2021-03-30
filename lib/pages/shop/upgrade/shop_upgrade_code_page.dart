import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/shop_upgrade_code_model.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ShopUpgradeCodePage extends StatefulWidget {
  final Map arguments;
  static setArguments({ShopUpgradeCodeModel shopUpgradeCodeModel,}){
    return {"shopUpgradeCodeModel": shopUpgradeCodeModel,};
  }
  ShopUpgradeCodePage({Key key, this.arguments}) : super(key: key);

  @override
  _ShopUpgradeCodePageState createState() => _ShopUpgradeCodePageState();
}

class _ShopUpgradeCodePageState extends BaseStoreState<ShopUpgradeCodePage> with TickerProviderStateMixin{
  
  ShopUpgradeCodeModel _shopUpgradeCodeModel;
  TabController _tabController;
  @override
  void initState() {
    _shopUpgradeCodeModel = widget.arguments["shopUpgradeCodeModel"];
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        title: "我的升级码",
        background: Colors.white,
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: Container(
        color: AppColor.frenchColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 2,),
            _headWidget(),
            Container(
              color: Colors.white,
              height: 40,
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                labelColor: AppColor.themeColor,
                indicatorColor: AppColor.themeColor,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: false,
                labelPadding: EdgeInsets.all(0),
                labelStyle: AppTextStyle.generate(15, fontWeight: FontWeight.w500),
                unselectedLabelStyle: AppTextStyle.generate(13, fontWeight: FontWeight.w500),
                tabs: [
                  Tab(text:"未使用", ),
                  Tab(text:"已使用", ),
              ]),
            ),
          Expanded(
            child: CacheTabBarView(
              controller: _tabController,
              children: <Widget>[
                _shopUpgradeCodeModel.data.unusedCode.length == 0?
                _noDataWidget("暂无升级码可用,快去邀请吧~")
                :ListView.builder(
                  itemCount: _shopUpgradeCodeModel.data.unusedCode.length,
                  itemBuilder: (_,index){
                    return _itemBuilder("1122233");
                  }
                ),
                _shopUpgradeCodeModel.data.usedCode.length == 0?
                _noDataWidget("暂无已使用的升级码,快去邀请吧~")
                :ListView.builder(
                  itemCount: _shopUpgradeCodeModel.data.usedCode.length,
                  itemBuilder: (_,index){
                    return _itemBuilder("1122233", used: true);
                  }
                ),
            ],),
          )
          ],
        ),
      )
    );
  }

  _itemBuilder(String text ,{bool used = false}){
    Color grayColor = Color(0xff999999);
    return Container(
      color: Colors.white,
      height: 48, width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 15),
            color: AppColor.frenchColor,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(text, style: TextStyle(color: used?grayColor:Colors.black, fontSize: 18),),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: CustomImageButton(
                    width: 72, height: 28,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: used?grayColor:AppColor.themeColor, width: 1),
                    title: used?"已使用":"去使用",
                    color: used?grayColor:AppColor.themeColor,
                    style: TextStyle(color: used?grayColor:AppColor.themeColor, fontSize: 13),
                    onPressed: used?null:(){
                      
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _noDataWidget(title){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 1,),
          Image.asset("assets/shop_upgrade_code_page_nodata.png", width: 99, height: 60,),
          Container(height: 20,),
          Text(title, style: TextStyle(color: Color(0xff666666), fontSize: 13),),
          Spacer(flex: 3,),
        ],
      ),
    );
  }

  _headWidget(){
    return Container(
      color: Colors.white, height: 140, width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10, bottom: 4),
            child: Text("可使用升级码(个)", style: TextStyle(fontSize: 15, color:Color(0xff999999)),),
          ),
          Text(_shopUpgradeCodeModel.data.unusedCode.length.toString(), style:TextStyle(fontSize: 24,color: Colors.black ) ),
          Spacer(),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _twoTitleWidget("累计获得",(_shopUpgradeCodeModel.data.unusedCode.length+_shopUpgradeCodeModel.data.usedCode.length).toString()),
                _twoTitleWidget("已使用", _shopUpgradeCodeModel.data.usedCode.length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _twoTitleWidget(title, info){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(title, style: TextStyle(color: Color(0xff999999), fontSize: 13)),
        Text(info, style: TextStyle(color: Colors.black, fontSize: 15)),
      ],
    );
  }



}
