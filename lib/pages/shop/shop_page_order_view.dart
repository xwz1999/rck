import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/shop_summary_model.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ShopPageOrderView extends StatefulWidget {
  final Function(int index) clickListener;
  final ShopSummaryModel shopSummaryModel;

  const ShopPageOrderView({Key key, this.shopSummaryModel, this.clickListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShopPageOrderViewState();
  }
}

class _ShopPageOrderViewState extends State<ShopPageOrderView> {
  TextStyle selectStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColor.themeColor,
      fontSize: ScreenAdapterUtils.setSp(13));
  TextStyle normalStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.32),
      fontSize: ScreenAdapterUtils.setSp(12));
  TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.black.withOpacity(0.9),
      fontSize: ScreenAdapterUtils.setSp(12));
  TextStyle greyTitleStyle = TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.black.withOpacity(0.32),
      fontSize: ScreenAdapterUtils.setSp(12));
  TextStyle numberStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: ScreenAdapterUtils.setSp(15));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.frenchColor,
      child: _orderWidget(),
    );
  }

  _orderWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        // border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1))
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(bottom: 10),
      height: 130,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                ),
                Container(
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(
                      text: '订单中心  ',
                      style: AppTextStyle.generate(16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '(导购)',
                      style: AppTextStyle.generate(14,
                          fontWeight: FontWeight.w400),
                    ),
                  ])),
                ),
                Spacer(),
                GestureDetector(
                  child: _rightArrowWidget('全部订单'),
                  onTap: () {
                    widget.clickListener(0);
                  },
                )
              ],
            ),
          ),
          Container(
            height: 0.4,
            color: Colors.black12,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 88,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomImageButton(
                    padding: EdgeInsets.symmetric(vertical: rSize(10)),
                    dotPosition: DotPosition(right: 15, top: 8),
                    dotNum:
                        widget.shopSummaryModel.data.orderCenter.waitSend == 0
                            ? null
                            : widget.shopSummaryModel.data.orderCenter.waitSend
                                .toString(),
                    dotColor: AppColor.themeColor,
                    icon: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/shop_deliver.png',
                          fit: BoxFit.cover,
                          width: 25,
                          height: 25,
                        )),
                    title: "待发货",
                    fontSize: ScreenAdapterUtils.setSp(12),
                    color: Colors.grey[700],
                    contentSpacing: 5,
                    onPressed: () {
                      widget.clickListener(1);
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    padding: EdgeInsets.symmetric(vertical: rSize(10)),
                    dotPosition: DotPosition(right: 15, top: 8),
                    dotNum:
                        widget.shopSummaryModel.data.orderCenter.waitRecv == 0
                            ? null
                            : widget.shopSummaryModel.data.orderCenter.waitRecv
                                .toString(),
                    dotColor: AppColor.themeColor,
                    icon: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/shop_shipped.png',
                          fit: BoxFit.cover,
                          width: 25,
                          height: 25,
                        )),
                    title: "已发货",
                    fontSize: ScreenAdapterUtils.setSp(12),
                    color: Colors.grey[700],
                    contentSpacing: 5,
                    onPressed: () {
                      widget.clickListener(2);
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    padding: EdgeInsets.symmetric(vertical: rSize(10)),
                    // dotPosition: DotPosition(right: 15,top: 8),
                    // dotNum: widget.shopSummaryModel.data.orderStatistics.shipCount== 0 ?null:widget.shopSummaryModel.data.orderStatistics.shipCount.toString(),
                    // dotColor: AppColor.themeColor,
                    icon: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/shop_received.png',
                          fit: BoxFit.cover,
                          width: 25,
                          height: 25,
                        )),
                    title: "已收货",
                    fontSize: ScreenAdapterUtils.setSp(12),
                    color: Colors.grey[700],
                    contentSpacing: 5,
                    onPressed: () {
                      widget.clickListener(3);
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    padding: EdgeInsets.symmetric(vertical: rSize(10)),
                    // dotPosition: DotPosition(right: 15,top: 8),
                    // dotNum: widget.shopSummaryModel.data.orderStatistics.shipCount== 0 ?null:widget.shopSummaryModel.data.orderStatistics.shipCount.toString(),
                    // dotColor: AppColor.themeColor,
                    icon: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/shop_aftersale.png',
                          fit: BoxFit.cover,
                          width: 25,
                          height: 25,
                        )),
                    title: "售后/退货",
                    fontSize: ScreenAdapterUtils.setSp(12),
                    color: Colors.grey[700],
                    contentSpacing: 5,
                    onPressed: () {
                      widget.clickListener(4);
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

  _rightArrowWidget(title) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(title,
              style: TextStyle(color: Color(0xff999999), fontSize: 12)),
        ),
        Icon(Icons.keyboard_arrow_right, size: 16, color: Colors.grey),
        Container(
          width: 10,
        )
      ],
    );
  }

  // _iconTitleWidget(icon, title, Function click){
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Container(
  //         height: 40, alignment: Alignment.center,
  //         child: Image.asset(icon, fit: BoxFit.cover,width: 25, height: 25,)
  //       ),
  //       Container(height: 5,),
  //       Container(
  //         alignment: Alignment.topCenter,
  //         child: Text(title, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black.withOpacity(0.8), fontSize: ScreenAdapterUtils.setSp(13)),),
  //       ),
  //     ],
  //   );
  // }

}
