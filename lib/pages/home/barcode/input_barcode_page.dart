import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class InputBarcodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InputBarcodePageState();
  }
}

class _InputBarcodePageState extends BaseStoreState<InputBarcodePage> {

  final _textEditcontroller = TextEditingController();
  @override
  void initState() { 
    super.initState();
    
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          themeData: AppThemes.themeDataGrey.appBarTheme,
          appBackground: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: _bodyWidget(),
        )
      ),
    );
  }  

  _bodyWidget(){
    double width = MediaQuery.of(context).size.width;
    Color buttonColor = Color(0xffE98787);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            padding: EdgeInsets.only(left: 30, top: 20),
            child: Text("填写商品条码", style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(22)),),
          ),
          inputWidget(),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30,),
            child: CustomImageButton(
              height: ScreenAdapterUtils.setHeight(36),
              backgroundColor: AppColor.themeColor,
              title: "确认",
              color: Colors.white,
              fontSize: 16,
              onPressed: TextUtils.isEmpty(_textEditcontroller.text)?null:(){
                _getGoodsWithCode(_textEditcontroller.text);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CustomImageButton(
                    height: ScreenAdapterUtils.setHeight(36),
                    title: "切换扫描",
                    color: buttonColor,
                    border: Border.all(
                      color: buttonColor,
                    ),
                    fontSize: 16,
                    onPressed: (){
                      AppRouter.pushAndReplaced(context, RouteName.BARCODE_SCAN);
                    },
                  ),
                ),
                Container(width: 30,),
                Expanded(
                  child: CustomImageButton(
                    height: ScreenAdapterUtils.setHeight(36),
                    title: "返回首页",
                    color: buttonColor,
                    border: Border.all(
                      color: buttonColor,
                    ),
                    fontSize: 16,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget inputWidget(){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                // height: 60,
                alignment: Alignment.center,
                child: Text("商品条码", style: TextStyle(color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),),
              ),
              Container(width: 15,),
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: CupertinoTextField(
                    onChanged: (string){
                      setState(() {});
                    },
                    controller: _textEditcontroller,
                    placeholder: "请输入条码",
                    decoration: BoxDecoration(
                    ),
                    maxLength: 13,
                    maxLines: 1,
                    style: TextStyle(fontSize: ScreenAdapterUtils.setSp(15), color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                )
              ),
            ],
          ),
          Container(
            height: 1,
            color: AppColor.frenchColor,
          )
        ],
      ),
    );
  }

  _getGoodsWithCode(String code) async {
    ResultData resultData = await HttpManager.post(GoodsApi.goods_code_search, {
      "code":code,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    String goodsId = resultData.data['data']['goodsId'].toString();
    if (TextUtils.isEmpty(goodsId)) {
      return;
    }
    AppRouter.pushAndReplaced(globalContext, RouteName.COMMODITY_PAGE, arguments: CommodityDetailPage.setArguments(int.parse(goodsId)));
    return;
  }

}
