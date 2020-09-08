import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/shop_upgrade_code_model.dart';
import 'package:recook/models/shop_upgrade_role_message_model.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/text_page.dart';

class ShopRecommendUpgradePage extends StatefulWidget {
  ShopRecommendUpgradePage({Key key}) : super(key: key);

  @override
  _ShopRecommendUpgradePageState createState() => _ShopRecommendUpgradePageState();
}

class _ShopRecommendUpgradePageState extends BaseStoreState<ShopRecommendUpgradePage> {
  double _width;
  double _height;
  final double _uiWidth = 375;
  final double _uiHeight = 767.6;

  ShopUpgradeCodeModel _shopUpgradeCodeModel;
  ShopUpgradeRoleMessageModel _roleMessageModel;

  @override
  void initState() {
    _getUpCode();
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _width = MediaQuery.of(context).size.width;
    _height = _width/_uiWidth*_uiHeight;

    return Scaffold(
      appBar: CustomAppBar(
        appBackground: Colors.white,
        elevation: 0,
        title: "推荐升级",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: SingleChildScrollView(
        // controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              width: _width, height: _height,
              child: Stack(
                children: <Widget>[
                  _backgroundImageWidget(),
                  _shopUpgradeCodeModel!=null? _methodWidget():Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _backgroundImageWidget(){
    return Container(
      width: _width, height: _height,
      child: Image.asset("assets/shop_recommend_upgrade_bg.png", fit: BoxFit.fill,),
    );
  }
  _methodWidget(){
    return Container(
      width: _width, height: _height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height: 660/_uiWidth*_width, width: _width,),
          FlatButton(
            onPressed: (){
              // DPrint.printf("查看详细规则");
              _pushToRoleMessagePage();
            }, 
            child: Container(height: 30/_uiHeight*_height, width: _width,),),
          // Container(height: 80/_uiHeight*_height,),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 30/_uiWidth*_width),
          //   height: 40/_uiHeight*_height, width: _width,
          //   child: Row(
          //     children: <Widget>[
          //       RichText(
          //         text: TextSpan(
          //           children: [
          //             TextSpan(text:"拥有升级码(个) ", style: TextStyle(color: Colors.grey, fontSize: 15)),
          //             TextSpan(text: "${_shopUpgradeCodeModel.data.unusedCode.length}", style: TextStyle(color: Colors.black, fontSize: 15)),
          //           ]
          //         )
          //       ),
          //       Spacer(),
          //       GestureDetector(
          //         onTap: (){
          //           // DPrint.printf("查看升级邀请码");
          //           AppRouter.push(context, RouteName.SHOP_UPGRADE_CODE_PAGE, 
          //             arguments: ShopUpgradeCodePage.setArguments(shopUpgradeCodeModel: _shopUpgradeCodeModel));
          //         },
          //         child: Row(
          //           children: <Widget>[
          //             Text("查看升级码", style: TextStyle(color: Color(0xffba6b12), fontSize: 13),),
          //             Icon(Icons.keyboard_arrow_right, size: 17, color: Color(0xffba6b12),),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Container(height: 35/_uiHeight*_height,),
          Container(height: 10/_uiHeight*_height,),
          GestureDetector(
            onTap: (){
              // ShareTool().inviteShare(context, code: UserManager.instance.user.info.introCode);
              ShareTool().diamondsInviteShare(code: UserManager.instance.user.info.introCode);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("推荐好友入驻", style: TextStyle(color: Colors.white, fontSize: 17),),
              decoration: BoxDecoration(
                color: Color(0xffd5101a),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffd5101a),
                    blurRadius: 1,
                  )
                ]
              ),
              margin: EdgeInsets.symmetric(horizontal: 15/_uiWidth*_width),
              height: 44/_uiHeight*_height, width: _width,),
          ),
          Spacer(),
        ],
      ),
    );
  }

  _getUpCode() async {
    ResultData resultData = await HttpManager.post(ShopApi.role_query_up_code , {
      "userId": UserManager.instance.user.info.id,
      // "userId": 1000004
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    ShopUpgradeCodeModel model = ShopUpgradeCodeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _shopUpgradeCodeModel = model;
    setState(() {});
    // _shopSummaryModel = model;
    // setState(() {});
  }
  _pushToRoleMessagePage(){
    if (_roleMessageModel == null) {
      _getRule();
      return;
    }
    AppRouter.push(context, RouteName.TEXTPAGE, arguments: TextPage.setArguments(title: "详细规则", info: _roleMessageModel.data));
  }

  _getRule() async {
    showLoading("");
    ResultData resultData = await HttpManager.post(ShopApi.role_query_rule , {
      "level": UserManager.instance.user.info.userLevel,
      // "level": 10
    });
    dismissLoading();
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    ShopUpgradeRoleMessageModel model = ShopUpgradeRoleMessageModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _roleMessageModel = model;
    AppRouter.push(context, RouteName.TEXTPAGE, arguments: TextPage.setArguments(title: "详细规则", info: _roleMessageModel.data));
  }

}