import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/app_image_resources.dart';

class ShopPageIncomeCardModel{
  final String title;
  final String info;
  ShopPageIncomeCardModel(this.title, this.info);
}

class ShopPageIncomeCardWidget extends StatefulWidget {
  final ShopPageIncomeCardModel headModel;
  final List<ShopPageIncomeCardModel> subModels;
  ShopPageIncomeCardWidget({Key key, this.headModel, this.subModels}) : super(key: key);

  @override
  _ShopPageIncomeCardWidgetState createState() => _ShopPageIncomeCardWidgetState();
}

class _ShopPageIncomeCardWidgetState extends State<ShopPageIncomeCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: _barWidget(),
    );
  }

  _barWidget(){
      double width = ScreenUtil.screenWidthDp-30;
      double height = 170.0/345*width; 
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: width, height: height,
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
                  titleText: widget.headModel==null?"": widget.headModel.title,
                  infoText: widget.headModel==null?"": widget.headModel.info,
                  infoFontSize: 20
                ),
              ),
              Spacer(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _infoRowList()
                ),
              )
            ],
          ),
        ),
      );
    }

  List<Widget> _infoRowList(){
    List<Widget> widgetList = [];
    widgetList = widget.subModels.map((model){
      return _textColumn(
        titleText: model==null?"": model.title,
        infoText: model==null?"": model.info,
      );
    }).toList();
    return widgetList;
  }

  Widget _textColumn(
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