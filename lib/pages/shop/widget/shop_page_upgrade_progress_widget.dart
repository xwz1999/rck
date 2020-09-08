import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/utils/user_level_tool.dart';

class ShopCircularPercentIndicatorModel {
  final bool add;
  final bool money;
  final String bottomText;
  final double progress;
  final centerIcon;
  ShopCircularPercentIndicatorModel(
      {this.add=false, this.money=false, this.bottomText = "", this.progress = 0, this.centerIcon});

  static defult({add=false, money=false, bottomText = "", progress = 0, centerIcon}){
    if (progress>1) {
      progress = 1.0;
    }
    if (progress < 0) {
      progress = 0.0;
    }
    return ShopCircularPercentIndicatorModel(add: add, money: money, bottomText: bottomText, progress: progress, centerIcon: centerIcon);
  }
  
}

class ShopPageUpgradeProgress extends StatefulWidget {
  final ShopSummaryModel shopSummaryModel;
  ShopPageUpgradeProgress({Key key, this.shopSummaryModel}) : super(key: key);

  @override
  _ShopPageUpgradeProgressState createState() =>
      _ShopPageUpgradeProgressState();
}

class _ShopPageUpgradeProgressState
    extends BaseStoreState<ShopPageUpgradeProgress> {
  double _width;
  double _height;
  final double _uiWidth = 375.0;
  final double _uiHeight = 200.0;

  final Color masterColor = Color(0xffd81a30);
  final Color silverColor = Color(0xff5f727c);
  final Color goldColor = Color(0xffe1b367);

  Color progressGoldColor = Color(0xffFFC53E);
  final Color progressBgColor = Color(0xffF5F5F5);

  ShopSummaryModel _shopSummaryModel;
  UserRoleLevel _roleLevel = UserRoleLevel.Vip;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    _shopSummaryModel = widget.shopSummaryModel;
    _roleLevel = UserLevelTool.roleLevelEnum(_shopSummaryModel.data.roleLevel);
    progressGoldColor = _roleLevel == UserRoleLevel.Master
        ? masterColor
        : _roleLevel == UserRoleLevel.Silver ? silverColor : goldColor;

    
    _width = MediaQuery.of(context).size.width;
    _height = _uiHeight * _uiWidth / _width;
    // DateTime date = DateTime.parse(_shopSummaryModel.data.expireDate);
    return Container(
      color: AppColor.frenchColor,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        width: _width,
        height: _height,
        child: Row(
          children: _rowChildrenWidget(),
        ),
      ),
    );
  }

  List<Widget> _rowChildrenWidget() {
    String masterIconSaleUp = "assets/shop_page_progress_icon_master_sale.png";
    String masterIconPersonUp = "assets/shop_page_progress_icon_master_person.png";
    String silverIconPersonUp = "assets/shop_page_progress_icon_silver_person.png";
    String silverIconSaleUp = "assets/shop_page_progress_icon_silver_sale.png";
    String silverIconPersonKeep = silverIconPersonUp; // "assets/shop_page_progress_icon_gold_sale.png";
    String silverIconSaleKeep = silverIconSaleUp;     // "assets/shop_page_progress_icon_gold_sale.png";
    String goldIconSaleKeep = "assets/shop_page_progress_icon_gold_sale.png";
    String goldIconPersonKeep = "assets/shop_page_progress_icon_gold_person.png";

    List<Widget> returnList = [];
    DateTime date = DateTime.parse(_shopSummaryModel.data.assessment.aTime);
    double upSale = double.parse(_shopSummaryModel.data.assessment.upper.sale);
    int upPerson = int.parse(_shopSummaryModel.data.assessment.upper.developNew);
    double keepSale = double.parse(_shopSummaryModel.data.assessment.keeper.sale);
    int keepPerson = int.parse(_shopSummaryModel.data.assessment.keeper.developNew);
    if (_roleLevel == UserRoleLevel.Master) {
      // 只有升级到白银店铺
      int standardSale = _shopSummaryModel.data.assessment.upStandard.role300.quantity.toInt();
      int standardPerson = _shopSummaryModel.data.assessment.upStandard.role300.person.toInt();
      bool fullSale = upSale >= standardSale;
      bool fullPerson = upPerson>=standardPerson;
      String expireDate = "在" + "${date.year}-${date.month}-${date.day}前完成升级";
      returnList.add(
        Expanded(
          child: _itemWidget(
            widgetList: _itemProgressRows(list: [
              fullPerson ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: masterIconSaleUp,
                  money: true,
                  progress: upSale.toDouble()/standardSale.toDouble(),
                  bottomText: fullSale ? "已满足升级标准" : "还需销售额\n${standardSale-upSale}元"),
              fullSale ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: masterIconPersonUp,
                  add: true,
                  progress: upPerson.toDouble()/standardPerson.toDouble(),
                  bottomText: fullPerson ? "已满足升级标准" : "还需推广\n${(standardPerson - upPerson)}人"),
            ]),
            title: "升至白银店铺",
            headText: expireDate,
          ),
        ),
      );
    }
    if (_roleLevel == UserRoleLevel.Gold) {
      // 只有保级黄金店铺标准
      int standardSale = _shopSummaryModel.data.assessment.keepStandard.role200.quantity.toInt();
      int standardPerson = _shopSummaryModel.data.assessment.keepStandard.role200.person.toInt();
      bool fullSale = keepSale >= standardSale;
      bool fullPerson = keepPerson>=standardPerson;
      String expireDate = "在" + "${date.year}-${date.month}-${date.day}前完成保级";
      returnList.add(
        Expanded(
          child: _itemWidget(
            widgetList: _itemProgressRows(list: [
              fullPerson ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: goldIconSaleKeep,
                  money: true,
                  progress: keepSale.toDouble()/standardSale.toDouble(),
                  bottomText: fullSale ? "已满足保级标准" : "还需销售额\n${standardSale-keepSale}元"),
              fullSale ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: goldIconPersonKeep,
                  add: true,
                  progress: keepPerson.toDouble()/standardPerson.toDouble(),
                  bottomText: fullPerson ? "已满足保级标准" : "还需推广\n${(standardPerson - keepPerson)}人"),
            ]),
            title: "保级黄金店铺",
            headText: expireDate,
          ),
        ),
      );
    }
    if (_roleLevel == UserRoleLevel.Silver) {
      // 保级白银标准  升级黄金标准
      int upStandardSale = _shopSummaryModel.data.assessment.upStandard.role200.quantity.toInt();
      int upStandardPerson = _shopSummaryModel.data.assessment.upStandard.role200.person.toInt();
      bool fullUpSale = upSale >= upStandardSale;
      bool fullUpPerson = upPerson >= upStandardPerson;
      //
      int keepStandardSale = _shopSummaryModel.data.assessment.keepStandard.role300.quantity.toInt();
      int keepStandardPerson = _shopSummaryModel.data.assessment.keepStandard.role300.person.toInt();
      bool fullKeepSale = keepSale >= keepStandardSale;
      bool fullKeepPerson = keepPerson >= keepStandardPerson;
      String expireDate = "在" + "${date.year}-${date.month}-${date.day}前完成升级";
      returnList.add(
        Expanded(
          child: _itemWidget(
            widgetList: _itemProgressRows(list: [
              fullUpPerson ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: silverIconSaleUp,
                  money: true,
                  progress: upSale.toDouble()/upStandardSale.toDouble(),
                  bottomText: fullUpSale ? "已满足升级标准" : "还需销售额\n${upStandardSale-upSale}元"),
              fullUpSale ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: silverIconPersonUp,
                  add: true,
                  progress: upPerson.toDouble()/upStandardPerson.toDouble(),
                  bottomText: fullUpPerson ? "已满足升级标准" : "还需推广\n${(upStandardPerson - upPerson)}人"),
            ]),
            title: "升级黄金店铺",
            headText: expireDate,
          ),
        ),
      );
      returnList.add(
        Container(
          margin: EdgeInsets.only(top: 65, bottom: 22),
          width: 0.5,
          color: Color(0xffeeeeee),
        ),
      );
      returnList.add(
        Expanded(
          child: _itemWidget(
            widgetList: _itemProgressRows(list: [
              fullKeepPerson ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: silverIconSaleKeep,
                  money: true,
                  progress: keepSale.toDouble()/keepStandardSale.toDouble(),
                  bottomText: fullKeepSale ? "已满足保级标准" : "还需销售额\n${keepStandardSale-keepSale}元"),
              fullKeepSale ? null : 
                ShopCircularPercentIndicatorModel.defult(
                  centerIcon: silverIconPersonKeep,
                  add: true,
                  progress: keepPerson.toDouble()/keepStandardPerson.toDouble(),
                  bottomText: fullKeepPerson ? "已满足保级标准" : "还需推广\n${(keepStandardPerson - keepPerson)}人"),
            ]),
            title: "保级白银店铺",
            headText: "",
          ),
        ),
      );
    }

    return returnList;
  }

  List<Widget> _itemProgressRows(
      {List<ShopCircularPercentIndicatorModel> list}) {
    List<Widget> widgetList = [];
    for (ShopCircularPercentIndicatorModel model in list) {
      if (model == null) {
        continue;
      }
      widgetList.add(
        Expanded(
          child: Column(
            children: <Widget>[
              _circularWidget(model.progress, model.add, model.money, centerIcon: model.centerIcon),
              Text(
                model.bottomText,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.black, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    }
    if (widgetList.length == 2) {
      widgetList.insert(
        1,
        Text(
          "或\n\n",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }
    return widgetList;
  }

  _itemWidget(
      {title = "",
      headText = "",
      bottomText = "",
      List<Widget> widgetList,
      Function onTap}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (onTap != null) onTap();
              },
              child: Container(
                margin: EdgeInsets.only(top: 5 / _uiHeight * _height),
                child: onTap != null ? _arrowTitle(title) : _normalTitle(title),
                height: 40 / _uiHeight * _height,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                headText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xffaaaaaa), fontSize: 13),
              ),
            ),
            Container(
              height: 10 / _uiHeight * _height,
            ),
            Flex(
              direction: Axis.horizontal,
              children: widgetList != null ? widgetList : [],
              // children: <Widget>[
              //   Expanded(
              //     child: Column(
              //       children: <Widget>[
              //         _circularWidget(0.33),
              //         Text(bottomText,textAlign: TextAlign.center, maxLines: 2,
              //           overflow: TextOverflow.clip, style: TextStyle(color: Colors.black, fontSize: 11),),
              //       ],
              //     ),
              //   ),
              //   Text("或\n\n", style: TextStyle(color: Colors.grey, fontSize: 15),),
              //   Expanded(
              //     child: Column(
              //       children: <Widget>[
              //         _circularWidget(0.33),
              //         Text(bottomText,textAlign: TextAlign.center, maxLines: 2,
              //           overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 11),),
              //       ],
              //     ),
              //   ),
              // ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     Column(
            //       children: <Widget>[
            //         _circularWidget(0.33),
            //          Text(bottomText,textAlign: TextAlign.center, maxLines: 2,
            //           overflow: TextOverflow.clip, style: TextStyle(color: Colors.black, fontSize: 13),),
            //       ],
            //     ),
            //     Text("或\n\n", style: TextStyle(color: Colors.grey, fontSize: 15),),
            //     Column(
            //       children: <Widget>[
            //         _circularWidget(0.33),
            //         Text(bottomText,textAlign: TextAlign.center, maxLines: 2,
            //                 overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 13),),
            //       ],
            //     ),
            //   ],
            // ),
            // Container(height: 5/_uiHeight*_height,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //    Text(bottomText,textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 13),)
            //   ],
            // )
          ],
        ));
  }

  _normalTitle(title) {
    if (TextUtils.isEmpty(title)) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 5),
          height: 18 / _uiHeight * _height,
          width: 2.5 / _uiWidth * _width,
          color: Color(0xffd5101a),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 17),
        )
      ],
    );
  }

  _arrowTitle(title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Icon(
          Icons.keyboard_arrow_right,
          size: 16,
          color: Colors.grey,
        ),
        Container(
          width: 10,
        ),
      ],
    );
  }

  _circularWidget(progress, bool add, bool money, {centerIcon}) {
    Color progressColor = progressGoldColor;
    double width = 70 / _uiHeight * _height;
    return Container(
      width: width,
      height: width,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: CircularPercentIndicator(
              radius: 60.0 / _uiHeight * _height, //大小
              lineWidth: 5.0, //指示线条大小
              percent: progress, //当前进度
              center: centerIcon is String && !TextUtils.isEmpty(centerIcon) ?
               Image.asset(centerIcon, width: 15, height: 15,):
               centerIcon is Widget? centerIcon
               :Icon(
                money ? Icons.star_border : Icons.person_outline,
                color: progressColor,
                size: 15,
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: progressColor,
              backgroundColor: Color(0xfff5f5f5),
            ),
          ),
          Center(
              child: Container(
            width: width,
            height: width,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: width / 2 - 4,
                  top: 3,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: progressColor,
                    ),
                    width: 8,
                    height: 8,
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 7,
                    ),
                    // child: add
                    //     ? Icon(
                    //         Icons.arrow_upward,
                    //         color: Colors.white,
                    //         size: 7,
                    //       )
                    //     : Icon(
                    //         Icons.remove,
                    //         color: Colors.white,
                    //         size: 7,
                    //       ),
                        ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
