import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/bottom_time_picker.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

abstract class ShopPageIncomeWidgetState<T extends StatefulWidget>
    extends BaseStoreState<T> {
  showTimePickerBottomSheet(
      {List<BottomTimePickerType> timePickerTypes,
      Function(DateTime, BottomTimePickerType) submit}) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 350 + MediaQuery.of(context).padding.bottom,
            child: BottomTimePicker(
              timePickerTypes: timePickerTypes==null? [BottomTimePickerType.BottomTimePickerMonth]:timePickerTypes,
              cancle: () {
                Navigator.maybePop(context);
              },
              submit: submit != null
                  ? submit
                  : (time, type) {
                      Navigator.maybePop(context);
                      // _selectTime = "${time.year.toString()}-${time.month.toString().padLeft(2, "0")}";
                      setState(() {});
                    },
            ));
      },
    ).then((val) {
      if (mounted) {}
    });
  }

  Widget cellWidget(
      {EdgeInsets padding,
      String time = "日期",
      String sales = "销售额",
      String orderNum = "订单数",
      String income = "预估收益",
      TextStyle incomeStyle}) {
    TextStyle blackStyle = TextStyle(color: Colors.black, fontSize: 14);
    TextStyle redStyle = TextStyle(
        color: AppColor.redColor, fontSize: 14, fontWeight: FontWeight.w500);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: Divider.createBorderSide(context, color: AppColor.frenchColor, width: 1)
        )
      ),
      padding: padding != null ? padding : EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      height: 42,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  time,
                  style: blackStyle,
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  sales,
                  style: blackStyle,
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                orderNum,
                style: blackStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                income,
                style: incomeStyle != null ? incomeStyle : redStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  noDataView(String text, {Widget icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 140, height: 130,
          child: Image.asset(ShopImageName.income_nodata),
          margin: EdgeInsets.symmetric(horizontal: 30),
        ),
        TextUtils.isEmpty(text) ? Container() : Text(text, style: TextStyle(color: Colors.black),)
      ],
    );
  }

  Widget noMoreDataView({String text, Widget icon}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          icon!=null?icon: Image.asset(ShopImageName.shop_page_smile, width: 22, height: 12,),
          Container(height: 10,),
          Text(TextUtils.isEmpty(text)? "这是我最后的底线" : text, style: TextStyle(color: Color(0xff666666),fontSize: 12 ),)
        ],
      ),
    );
  }

  Widget memberWidget({String url = "", String name = "", String phone = "", int roleLevel = 0, String amount = ""}){
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _imageView(headImgUrl: url),
          Container(width: 10,),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container( 
                          child: Row(
                            children: <Widget>[
                              Text(name, style: TextStyle(color: Colors.black, fontSize: 14 ),),
                              Spacer(),
                              Text(amount, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500 ),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _subInfoView(phoneNum: phone, level: roleLevel),
                      )
                    ],
                  ),
                ),
                Container( height: 0.5, color: AppColor.frenchColor, )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _imageView({String headImgUrl = ""}) {
    return Container( //头像
      width: 40, height: 40,
      // margin: EdgeInsets.only(left: 12, right: 12, top: 7.5, bottom: 7.5),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getResizeImgUrl(headImgUrl, 300),
            placeholder: AppImageName.placeholder_1x1,
          ),),
      ),
    );
  }

  _subInfoView({String phoneNum = "", int level = 0}){
    return Container(
      child: Row(
        children: <Widget>[
          Image.asset("assets/invite_detail_phone.png", width: 13, height: 13,),
          Container(width: 4,),
          Container(width: 100, child: Text(TextUtils.isEmpty(phoneNum)?"未设置":phoneNum, style: TextStyle(fontSize: 11, color: Colors.grey),), ),
          Container(width: 24,),
          _roleLevelWidget(level: level)
        ],
      ),
    );
  }

  _roleLevelWidget({int level=0}){
    return CustomImageButton(
      onPressed: (){},
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      backgroundColor: Colors.white.withAlpha(0),
      fontSize: 11,
      color: Colors.grey,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      direction: Direction.horizontal,
      contentSpacing: 2,
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.modulate),
        child: Image.asset(UserLevelTool.currentUserLevelIcon(), width: 13, height: 13,),
      ),
      title:UserLevelTool.roleLevel(level),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Widget textColumn(
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center, String titleText="" ,Color titleColor = Colors.black26 ,double titleFontSize=12, Alignment titleAligment=Alignment.centerLeft, 
      String infoText="" ,Color infoColor=Colors.black,  double infoFontSize=16,Alignment infoAligment=Alignment.centerLeft}
    ){
    return Column(
      crossAxisAlignment: crossAxisAlignment,
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
