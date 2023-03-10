// import 'package:flutter/material.dart';
// import 'package:jingyaoyun/constants/header.dart';
// import 'package:jingyaoyun/constants/styles.dart';
// import 'package:jingyaoyun/models/shop_summary_model.dart';

// enum IncomeType{
//   today,
//   yesterday,
//   seven
// }

// class ShopPagePerformanceView extends StatefulWidget {
//   final ShopSummaryModel shopSummaryModel;
//   final Function commissionInfoClick;
//   const ShopPagePerformanceView({Key key, this.shopSummaryModel, this.commissionInfoClick,}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _ShopPagePerformanceViewState();
//   }
// }

// class _ShopPagePerformanceViewState extends State<ShopPagePerformanceView>{

//   IncomeType _incomeType = IncomeType.today;

//   TextStyle selectStyle = TextStyle(fontWeight: FontWeight.w500 ,color: AppColor.themeColor, fontSize: 13);
//   // TextStyle normalStyle = TextStyle(fontWeight: FontWeight.w500 ,color: Colors.black.withOpacity(0.32), fontSize: 12*2.sp);
//   TextStyle normalStyle = TextStyle( fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 13);
//   TextStyle titleStyle = TextStyle(fontWeight: FontWeight.w400 ,color: Colors.black.withOpacity(0.9), fontSize: 14*2.sp);
//   TextStyle greyTitleStyle = TextStyle(fontWeight: FontWeight.w400 ,color: Colors.black.withOpacity(0.5), fontSize: 14*2.sp);
//   TextStyle numberStyle = TextStyle(fontWeight: FontWeight.w500 ,color: Colors.black, fontSize: 15*2.sp);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           _incomeWidget(),
//           // _performanceWidget()
//         ],
//       ),
//     );
//   }

//   _incomeWidget(){
//     num orderCount = 0;
//     num salesAmount = 0;
//     num predictionIncome = 0;
//     Month monthModel = widget.shopSummaryModel.data.distributionIncomeList.today;
//     if (_incomeType == IncomeType.today) {
//       monthModel = widget.shopSummaryModel.data.distributionIncomeList.today;
//     }
//     if (_incomeType == IncomeType.yesterday) {
//       monthModel = widget.shopSummaryModel.data.distributionIncomeList.yesterday;
//     }
//     if (_incomeType == IncomeType.seven) {
//       monthModel = widget.shopSummaryModel.data.distributionIncomeList.month;
//     }
//     salesAmount = num.parse(monthModel.quantity);
//     orderCount = num.parse(monthModel.order);
//     predictionIncome = num.parse(monthModel.income);
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//       ),
//       margin: EdgeInsets.only(bottom: 10),
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       height: 115,
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 47,
//             child: Row(
//               children: <Widget>[
//                 Container(width: 10,),
//                 Text('????????????', style:TextStyle(color: Colors.black, fontSize: 17)),
//                 Container(width: 10,),
//                 GestureDetector(
//                   child: Container( width: 35, child: Text('??????', style: _incomeType == IncomeType.today? selectStyle:normalStyle,),),
//                   onTap: (){
//                     _incomeType = IncomeType.today;
//                     setState(() {});
//                   },
//                 ),
//                 GestureDetector(
//                   child: Container( width: 35, child: Text('??????', style: _incomeType == IncomeType.yesterday? selectStyle:normalStyle,),),
//                   onTap: (){
//                     _incomeType = IncomeType.yesterday;
//                     setState(() {});
//                   },
//                 ),
//                 GestureDetector(
//                   child: Container( width: 35, child: Text('??????', style: _incomeType == IncomeType.seven? selectStyle:normalStyle,),),
//                   onTap: (){
//                     _incomeType = IncomeType.seven;
//                     setState(() {});
//                   },
//                 ),
//                 Spacer(),
//                 GestureDetector(
//                   child: _rightArrowWidget('??????????????????'),
//                   onTap: (){
//                     if (widget.commissionInfoClick!=null) {
//                       widget.commissionInfoClick();
//                     }
//                   },
//                 ),
//                 Container(width: 1,),
//               ],
//             ),
//           ),
//           Container(height: 1, color: Color(0xffeeeeee)),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: _incomeInfoTitleWidget('??????', '(???)', orderCount.toString())
//                   ),
//                   Expanded(
//                     child: _incomeInfoTitleWidget('?????????', '(???)', salesAmount.toString())
//                   ),
//                   Expanded(
//                     child: _incomeInfoTitleWidget('????????????', '(???)', predictionIncome.toString())
//                   ),
//                 ],
//               ),
//             )
//           ),
//         ],
//       ),
//     );
//   }

//   _incomeInfoTitleWidget(title, subTitle, info){
//     TextStyle titleStyle = TextStyle(color: Color(0xff999999), fontSize: 13);
//     TextStyle infoStyle = TextStyle(color: Colors.black, fontSize: 17);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Container(
//           alignment: Alignment.centerLeft,
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(text: title, style: titleStyle),
//                 TextSpan(text: ''+subTitle, style: titleStyle),
//               ]
//             ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.centerLeft,
//           child: Text(info, style: infoStyle,),
//         )
//       ],
//     );
//   }

//   _rightArrowWidget(title){
//     return Row(
//       children: <Widget>[
//         Container(
//           child: Text(title, style: TextStyle(color: Color(0xff999999), fontSize: 12)),
//         ),
//         Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 16),
//         Container(width: 10,)
//       ],
//     );
//   }

//   // _performanceWidget(){
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.all(Radius.circular(5)),
//   //       border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.1))
//   //     ),
//   //     margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
//   //     height: 110,
//   //     child: Column(
//   //       children: <Widget>[
//   //         Container(
//   //           height: 40,
//   //           child: Row(
//   //             children: <Widget>[
//   //               Container(width: 10,),
//   //               Container(child: Text('??????????????????', style: selectStyle,),),

//   //               Spacer(),
//   //               GestureDetector(
//   //                 child: _rightArrowWidget('??????????????????'),
//   //                 onTap: (){
//   //                   if (widget.performanceInfoClick != null) {
//   //                     widget.performanceInfoClick();
//   //                   }
//   //                 },
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //         Container(height: 0.4, color: Colors.black12,),
//   //         Container(
//   //           padding: EdgeInsets.symmetric(horizontal: 10),
//   //           height: 68,
//   //           child: Row(
//   //             children: <Widget>[
//   //               Expanded(
//   //                 child: _incomeInfoTitleWidget('?????????', '(???)', widget.shopSummaryModel.data.teamSalesStatistics.salesAmount.toString())
//   //               ),
//   //               Expanded(
//   //                 child: _incomeInfoTitleWidget('????????????', '(???)', widget.shopSummaryModel.data.teamSalesStatistics.teamIncome.toString())
//   //               ),
//   //               Expanded(
//   //                 child: _incomeInfoTitleWidget('????????????', '(???)', widget.shopSummaryModel.data.teamSalesStatistics.secondaryIncome.toString())
//   //               ),
//   //             ],
//   //           ),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }

// }
