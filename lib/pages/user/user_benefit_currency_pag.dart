// import 'dart:math';
//
// import 'package:expandable/expandable.dart';
// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jingyaoyun/manager/user_manager.dart';
// import 'package:jingyaoyun/pages/shop/order/shop_order_detail_page.dart';
// import 'package:jingyaoyun/pages/user/order/order_detail_page.dart';
// import 'package:jingyaoyun/pages/user/user_benefit_shop_page.dart';
// import 'package:jingyaoyun/pages/user/user_benefit_sub_page.dart';
// import 'package:jingyaoyun/pages/user/widget/user_group_card.dart';
// import 'package:jingyaoyun/widgets/animated_rotate.dart';
// import 'package:jingyaoyun/widgets/bottom_time_picker.dart';
// import 'package:jingyaoyun/widgets/custom_app_bar.dart';
// import 'package:jingyaoyun/widgets/custom_image_button.dart';
//
// import 'package:velocity_x/velocity_x.dart';
// import 'package:jingyaoyun/constants/header.dart';
// import 'package:jingyaoyun/pages/user/functions/user_benefit_func.dart';
// import 'package:jingyaoyun/pages/user/model/user_accumulate_model.dart';
// import 'package:jingyaoyun/utils/user_level_tool.dart';
// import 'package:jingyaoyun/widgets/recook_back_button.dart';
// import 'package:jingyaoyun/widgets/refresh_widget.dart';
//
// import 'model/user_benefit_extra_detail_model.dart';
// import 'model/user_income_model.dart';
//
// class UserBenefitCurrencyPage extends StatefulWidget {
//   final UserBenefitPageType type;
//   final String receivedType;
//   UserBenefitCurrencyPage(
//       {Key key, @required this.type, @required this.receivedType})
//       : super(key: key);
//
//   @override
//   _UserBenefitCurrencyPageState createState() =>
//       _UserBenefitCurrencyPageState();
// }
//
// class _UserBenefitCurrencyPageState extends State<UserBenefitCurrencyPage> {
//   GSRefreshController _refreshController =
//       GSRefreshController(initialRefresh: true);
//   Map<UserBenefitPageType, String> _typeTitleMap = {
//     UserBenefitPageType.SELF: '????????????',
//     UserBenefitPageType.GUIDE: '????????????',
//     UserBenefitPageType.TEAM: '????????????',
//   };
//   String get _title => _typeTitleMap[widget.type];
//
//   ///?????????????????????
//   bool get _notSelfNotGUide =>
//       widget.type != UserBenefitPageType.SELF &&
//       widget.type != UserBenefitPageType.GUIDE;
//
//   String _amount = '0.00';
//   String _all = '0.00';
//   String _selfALL = '0.00';
//   String _distributionALL = '0.00';
//   String _agentALL = '0.00';
//
//   bool _itemReverse = false;
//
//   bool _yearChoose = false; //0?????? 1??????
//   bool _monthChoose = true; //0?????? 1??????
//
//   bool _selfChoose = true; //??????????????????
//   bool _distributionChoose = false; //??????????????????
//   bool _agentChoose = false; //??????????????????
//
//   ///????????????
//   ///
//   UserAccumulateModel _model = UserAccumulateModel.zero();
//   DateTime _date = DateTime.now();
//   String formatType = 'yyyy-MM'; //???????????????????????????
//   String TableformatType = 'M???d???'; //????????????
//
//   int team_level = 1;
//   String _TformatType = 'yyyy-MM'; //??????????????????
//   String _TTableformatType = 'M???d???'; //????????????????????????
//
//   UserIncomeModel _models; //??????????????????????????????
//   bool _onload = true;
//   List _gone = [];
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.receivedType == '?????????') {
//       _TformatType = 'yyyy-MM';
//       _TTableformatType = 'M???d???';
//     } else if (widget.receivedType == '?????????') {
//       _TformatType = 'yyyy';
//       _TTableformatType = 'M???';
//     }
//     if (!_notSelfNotGUide) {
//       if (widget.receivedType == '?????????') {
//         if (_yearChoose == true) {
//           formatType = 'yyyy';
//         } else if (_monthChoose == true) {
//           formatType = 'yyyy-MM';
//         }
//       } else if (widget.receivedType == '?????????') {
//         if (_yearChoose == true) {
//           formatType = 'yyyy';
//         } else if (_monthChoose == true) {
//           formatType = 'yyyy-MM';
//         }
//       }
//     } else {
//       //????????????
//
//       if (widget.receivedType == '?????????') {
//         formatType = 'yyyy-MM';
//       } else if (widget.receivedType == '?????????') {
//         formatType = 'yyyy';
//       }
//     }
//   }
//
//   _chooseMonth() {
//     String MonthText = '';
//     if (widget.receivedType == '?????????') {
//       MonthText = '???????????????(???)';
//     } else if (widget.receivedType == '?????????') {
//       MonthText = '???????????????(???)';
//     }
//     return CustomImageButton(
//       onPressed: () {
//         _yearChoose = false;
//         _monthChoose = true;
//         formatType = 'yyyy-MM';
//         TableformatType = 'M???d???';
//
//         _refreshController.requestRefresh();
//         setState(() {});
//       },
//       child: Text(MonthText,
//           style: TextStyle(
//               fontSize: 14.rsp,
//               color: getColor(_monthChoose),
//               fontWeight: getWeight(_monthChoose))),
//     ).expand();
//   }
//
//   _chooseYear() {
//     String YearText = '';
//
//     if (widget.receivedType == '?????????') {
//       YearText = '???????????????(???)';
//     } else if (widget.receivedType == '?????????') {
//       YearText = '???????????????(???)';
//     }
//     return CustomImageButton(
//       onPressed: () {
//         _yearChoose = true;
//         _monthChoose = false;
//         formatType = 'yyyy';
//         TableformatType = 'M???';
//
//         _refreshController.requestRefresh();
//         setState(() {});
//       },
//       child: Text(YearText,
//           style: TextStyle(
//               fontSize: 14.rsp,
//               color: getColor(_yearChoose),
//               fontWeight: getWeight(_yearChoose))),
//     ).expand();
//   }
//
//   _chooseSelf() {
//     return CustomImageButton(
//       onPressed: () {
//         _selfChoose = true;
//         _distributionChoose = false;
//         _agentChoose = false;
//         team_level = 1;
//         _refreshController.requestRefresh();
//         setState(() {});
//       },
//       child: widget.receivedType == '?????????'
//           ? Column(
//               children: [
//                 10.hb,
//                 Text('????????????',
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_selfChoose),
//                         fontWeight: getWeight(_selfChoose))),
//                 Text(_selfALL,
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_selfChoose),
//                         fontWeight: getWeight(_selfChoose))),
//               ],
//             )
//           : Text('????????????',
//               style: TextStyle(
//                   fontSize: 14.rsp,
//                   color: getColor(_selfChoose),
//                   fontWeight: getWeight(_selfChoose))),
//     ).expand();
//   }
//
//   _chooseDistribution() {
//     return CustomImageButton(
//       onPressed: () {
//         _selfChoose = false;
//         _distributionChoose = true;
//         _agentChoose = false;
//         team_level = 2;
//         _refreshController.requestRefresh();
//         setState(() {});
//       },
//       child: widget.receivedType == '?????????'
//           ? Column(
//               children: [
//                 10.hb,
//                 Text('????????????',
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_distributionChoose),
//                         fontWeight: getWeight(_distributionChoose))),
//                 Text(_distributionALL,
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_distributionChoose),
//                         fontWeight: getWeight(_distributionChoose))),
//               ],
//             )
//           : Text('????????????',
//               style: TextStyle(
//                   fontSize: 14.rsp,
//                   color: getColor(_distributionChoose),
//                   fontWeight: getWeight(_distributionChoose))),
//     ).expand();
//   }
//
//   _chooseAgent() {
//     return CustomImageButton(
//       onPressed: () {
//         _selfChoose = false;
//         _distributionChoose = false;
//         _agentChoose = true;
//         team_level = 3;
//         _refreshController.requestRefresh();
//         setState(() {});
//       },
//       child: widget.receivedType == '?????????'
//           ? Column(
//               children: [
//                 10.hb,
//                 Text('????????????',
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_agentChoose),
//                         fontWeight: getWeight(_agentChoose))),
//                 Text(_agentALL,
//                     style: TextStyle(
//                         fontSize: 14.rsp,
//                         color: getColor(_agentChoose),
//                         fontWeight: getWeight(_agentChoose))),
//               ],
//             )
//           : Text('????????????',
//               style: TextStyle(
//                   fontSize: 14.rsp,
//                   color: getColor(_agentChoose),
//                   fontWeight: getWeight(_agentChoose))),
//     ).expand();
//   }
//
//   _renderDivider() {
//     return Container(
//       height: 20.rw,
//       width: 1.rw,
//       color: Color(0xFF979797),
//     );
//   }
//
//   ///???????????????
//   showTimePickerBottomSheet(
//       {List<BottomTimePickerType> timePickerTypes,
//       Function(DateTime, BottomTimePickerType) submit}) {
//     showModalBottomSheet(
//       isScrollControlled: false,
//       context: context,
//       builder: (BuildContext context) {
//         return SizedBox(
//             height: 350 + MediaQuery.of(context).padding.bottom,
//             child: BottomTimePicker(
//               timePickerTypes: !_notSelfNotGUide
//                   ? _monthChoose == true
//                       ? [BottomTimePickerType.BottomTimePickerMonth]
//                       : [BottomTimePickerType.BottomTimePickerYear]
//                   : timePickerTypes,
//               cancle: () {
//                 Navigator.maybePop(context);
//               },
//               submit: submit != null
//                   ? submit
//                   : (time, type) {
//                       Navigator.maybePop(context);
//                       _date = time;
//                       setState(() {});
//                     },
//             ));
//       },
//     ).then((val) {
//       if (mounted) {}
//     });
//   }
//
//   Widget _buildTag() {
//     String benefitValue = '';
//     String text = '????????????';
//
//     if (_notSelfNotGUide) {
//       if (widget.receivedType == '?????????') {
//         text = '????????????????????????';
//       } else {
//         text = '????????????????????????';
//       }
//     } else {
//       if (widget.receivedType == '?????????' && _yearChoose == true) {
//         text = '????????????????????????';
//       } else if (widget.receivedType == '?????????' && _monthChoose == true) {
//         text = '????????????????????????';
//       } else if (widget.receivedType == '?????????' && _yearChoose == true) {
//         text = '????????????????????????';
//       } else if (widget.receivedType == '?????????' && _monthChoose == true) {
//         text = '????????????????????????';
//       }
//     }
//
//     return Row(
//       children: [
//         Text(
//           text ?? '',
//           style: TextStyle(color: Color(0xFF999999), fontSize: 16.rsp),
//           textAlign: TextAlign.center,
//         ),
//         Column(
//           children: [
//             5.hb,
//             Text(
//               _amount ?? '0.00',
//               style: TextStyle(color: Color(0xFFD5101A), fontSize: 16.rsp),
//               textAlign: TextAlign.center,
//             )
//           ],
//         ),
//         20.wb
//       ],
//     );
//     // return '????????????(??????)???${benefitValue.toStringAsFixed(2)}'
//     //     .text
//     //     .color(Color(0xFF999999))
//     //     .size(16.rsp)
//     //     .make();
//   }
//
//   Widget _buildCard() {
//     String CumulativeText = '';
//     if (widget.receivedType == '?????????') {
//       CumulativeText = '?????????????????????(??????)';
//     } else if (widget.receivedType == '?????????') {
//       CumulativeText = '?????????????????????(??????)';
//     }
//     UserRoleLevel role = UserLevelTool.currentRoleLevelEnum();
//
//     return Container(
//       margin:
//           EdgeInsets.only(left: 30.rw, right: 30.rw, top: 20.rw, bottom: 20.rw),
//       clipBehavior: Clip.antiAlias,
//       height: 146.rw,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5.rw),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 2.rw),
//             color: Color.fromRGBO(166, 166, 173, 0.43),
//             blurRadius: 6.rw,
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.rw),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, 1.rw),
//                     color: Color.fromRGBO(166, 166, 173, 0.43),
//                     blurRadius: 6.rw,
//                   )
//                 ],
//                 image: DecorationImage(
//                   fit: BoxFit.fill,
//                   image: AssetImage(UserLevelTool.currentCardImagePath()),
//                 ),
//                 color: Colors.transparent),
//             padding: EdgeInsets.only(
//                 top: 20.rw, bottom: 10.rw, left: 20.rw, right: 20.rw),
//             child: Row(
//               children: [
//                 Container(
//                   padding: role != UserRoleLevel.Diamond_1 &&
//                           role != UserRoleLevel.Diamond_2 &&
//                           _notSelfNotGUide
//                       ? EdgeInsets.only(top: 22.rw)
//                       : EdgeInsets.only(top: 0.rw),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CumulativeText.text.color(Color(0xFF3A3943)).make(),
//                       8.hb,
//                       (_all ?? '0.00').text.black.size(34.rsp).make(),
//                     ],
//                   ),
//                 ).expand(),
//                 Image.asset(
//                   UserLevelTool.currentMedalImagePath(),
//                   width: 48.rw,
//                   height: 48.rw,
//                 ),
//               ],
//             ),
//           ).expand(),
//           role == UserRoleLevel.Diamond_1 ||
//                   role == UserRoleLevel.Diamond_2 ||
//                   !_notSelfNotGUide
//               ? Container(
//                   height: 50.rw,
//                   child: Row(
//                     children: [
//                       _notSelfNotGUide ? _chooseSelf() : SizedBox(),
//                       _notSelfNotGUide
//                           ? role == UserRoleLevel.Diamond_1 ||
//                                   role == UserRoleLevel.Diamond_2
//                               ? _renderDivider()
//                               : SizedBox()
//                           : SizedBox(),
//                       _notSelfNotGUide
//                           ? role == UserRoleLevel.Diamond_1 ||
//                                   role == UserRoleLevel.Diamond_2
//                               ? _chooseDistribution()
//                               : SizedBox()
//                           : SizedBox(),
//                       _notSelfNotGUide
//                           ? role == UserRoleLevel.Diamond_1
//                               ? _renderDivider()
//                               : SizedBox()
//                           : SizedBox(),
//                       _notSelfNotGUide
//                           ? role == UserRoleLevel.Diamond_1
//                               ? _chooseAgent()
//                               : SizedBox()
//                           : SizedBox(),
//                       !_notSelfNotGUide ? _chooseMonth() : SizedBox(),
//                       !_notSelfNotGUide ? _renderDivider() : SizedBox(),
//                       !_notSelfNotGUide ? _chooseYear() : SizedBox(),
//                     ],
//                   ),
//                 )
//               : SizedBox(),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.frenchColor,
//       appBar: CustomAppBar(
//         appBackground: Color(0xFF16182B),
//         leading: RecookBackButton(white: true),
//         elevation: 0,
//         title: Text(
//           _title,
//           style: TextStyle(
//             fontSize: 18.rsp,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: RefreshWidget(
//         controller: _refreshController,
//         onRefresh: () async {
//           int BenefitType = 0;
//
//           if (widget.type == UserBenefitPageType.SELF) {
//             BenefitType = 1;
//           } else if (widget.type == UserBenefitPageType.GUIDE) {
//             BenefitType = 2;
//           }
//
//           if (!_notSelfNotGUide) {
//             if (widget.receivedType == '?????????') {
//               if (_yearChoose == true) {
//                 _models = await UserBenefitFunc.receicedIncome(
//                     DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
//               } else if (_monthChoose == true) {
//                 _models = await UserBenefitFunc.receicedIncome(
//                     DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
//               }
//             } else if (widget.receivedType == '?????????') {
//               if (_yearChoose == true) {
//                 _models = await UserBenefitFunc.notReceicedIncome(
//                     DateUtil.formatDate(_date, format: 'yyyy'), BenefitType);
//               } else if (_monthChoose == true) {
//                 _models = await UserBenefitFunc.notReceicedIncome(
//                     DateUtil.formatDate(_date, format: 'yyyyMM'), BenefitType);
//               }
//             }
//             _onload = false;
//           } else {
//             //????????????
//
//             if (widget.receivedType == '?????????') {
//               _models = await UserBenefitFunc.teamNotReceicedIncome(team_level);
//             } else if (widget.receivedType == '?????????') {
//               _models = await UserBenefitFunc.teamReceicedIncome(
//                   int.parse(DateUtil.formatDate(_date, format: 'yyyy')),
//                   team_level);
//
//               _selfALL = _models?.team?.toStringAsFixed(2);
//               _distributionALL = _models?.recommend?.toStringAsFixed(2);
//               _agentALL = _models?.reward?.toStringAsFixed(2);
//             }
//
//             _onload = false;
//           }
//           _amount = _models?.amount?.toStringAsFixed(2);
//           _all = _models?.all?.toStringAsFixed(2);
//           //?????????????????????????????????
//           for (int i = 0; i < _models?.detail?.length; i++) {
//             _gone.add(true);
//           }
//           for (int i = 0; i < _gone.length; i++) {
//             _gone[i] = true;
//           }
//           print(_models?.amount?.toStringAsFixed(2));
//           print(_models?.all?.toStringAsFixed(2));
//           setState(() {});
//           _refreshController.refreshCompleted();
//         },
//         body: Column(
//           children: [
//             _buildCard(),
//             Row(
//               children: [
//                 28.wb,
//                 Column(
//                   children: [
//                     !_notSelfNotGUide
//                         ? MaterialButton(
//                             shape: StadiumBorder(),
//                             elevation: 0,
//                             color: Colors.white,
//                             onPressed: () {
//                               showTimePickerBottomSheet(
//                                   submit: (time, type) {
//                                     Navigator.maybePop(context);
//                                     _date = time;
//                                     _refreshController.requestRefresh();
//                                     setState(() {});
//                                   },
//                                   timePickerTypes: [
//                                     BottomTimePickerType.BottomTimePickerMonth
//                                   ]);
//                             },
//                             height: 28.rw,
//                             child: Row(
//                               children: [
//                                 DateUtil.formatDate(_date, format: formatType)
//                                     .text
//                                     .black
//                                     .size(14.rsp)
//                                     .make(),
//                                 Icon(
//                                   Icons.arrow_drop_down,
//                                   color: Colors.black87,
//                                 ),
//                               ],
//                             ),
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                           )
//                         : widget.receivedType == '?????????'
//                             ? Container(
//                                 padding: EdgeInsets.only(left: 30.w),
//                                 child: DateUtil.formatDate(_date,
//                                         format: formatType)
//                                     .text
//                                     .black
//                                     .size(14.rsp)
//                                     .make(),
//                               )
//                             : MaterialButton(
//                                 shape: StadiumBorder(),
//                                 elevation: 0,
//                                 color: Colors.white,
//                                 onPressed: () {
//                                   showTimePickerBottomSheet(
//                                       submit: (time, type) {
//                                         Navigator.maybePop(context);
//                                         _date = time;
//                                         _refreshController.requestRefresh();
//                                         setState(() {});
//                                       },
//                                       timePickerTypes: [
//                                         BottomTimePickerType
//                                             .BottomTimePickerYear
//                                       ]);
//                                 },
//                                 height: 28.rw,
//                                 child: Row(
//                                   children: [
//                                     DateUtil.formatDate(_date,
//                                             format: formatType)
//                                         .text
//                                         .black
//                                         .size(14.rsp)
//                                         .make(),
//                                     Icon(
//                                       Icons.arrow_drop_down,
//                                       color: Colors.black87,
//                                     ),
//                                   ],
//                                 ),
//                                 materialTapTargetSize:
//                                     MaterialTapTargetSize.shrinkWrap,
//                               )
//                   ],
//                 ),
//                 Spacer(),
//                 Column(
//                   children: [
//                     _onload ? SizedBox() : _buildTag(),
//                   ],
//                 ),
//                 15.wb,
//               ],
//             ),
//             20.hb,
//             //_notSelfNotGUide ? _buildMidCard() : SizedBox(),
//             SizedBox(
//               height: 45.rw,
//               child: _buildTableTitle1(),
//             ),
//             Expanded(
//                 child: Container(
//               child: _onload ? SizedBox() : _buildTableList(),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   getColor(bool tip) {
//     if (tip == true) {
//       return Colors.black;
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   getWeight(bool tip) {
//     if (tip == true) {
//       return FontWeight.bold;
//     } else {
//       return FontWeight.normal;
//     }
//   }
//
//   _buildTableList() {
//     return new ListView.builder(
//       itemCount: _models.detail.length,
//       itemBuilder: (context, i) {
//         UserIncomeModel userIncomeModel = _models;
//         return _buildTableBody(userIncomeModel.detail[i], i);
//       },
//     );
//   }
//
//   _buildTableTitle1() {
//     String tableText = '';
//     if (_notSelfNotGUide) {
//       if (widget.receivedType == '?????????') {
//         tableText = '???????????????(??????)';
//       } else if (widget.receivedType == '?????????') {
//         tableText = '???????????????(??????)';
//       }
//     } else {
//       if (widget.receivedType == '?????????') {
//         tableText = '???????????????(??????)';
//       } else if (widget.receivedType == '?????????') {
//         tableText = '???????????????(??????)';
//       }
//     }
//
//     return Row(
//       children: [
//         Container(
//           height: 88.w,
//           width: 150.w,
//           color: Colors.white,
//           child: Text(
//             !_notSelfNotGUide
//                 ? '??????'
//                 : widget.receivedType == '?????????'
//                     ? '??????'
//                     : '??????',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF333333),
//               fontSize: 16.rsp,
//             ),
//           ).centered(),
//         ),
//         Container(
//           height: 88.w,
//           width: 180.w,
//           color: Colors.white,
//           child: Text(
//             '?????????',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF333333),
//               fontSize: 16.rsp,
//             ),
//           ).centered(),
//         ),
//         Container(
//           height: 88.w,
//           width: 100.w,
//           color: Colors.white,
//           child: Text(
//             '?????????',
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF333333),
//               fontSize: 16.rsp,
//             ),
//           ).centered(),
//         ),
//         Container(
//           height: 88.w,
//           width: 320.w,
//           color: Colors.white,
//           child: Text(
//             tableText,
//             style: TextStyle(
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF333333),
//               fontSize: 16.rsp,
//             ),
//           ).centered(),
//         ),
//       ],
//     );
//   }
//
//   _buildTableBody(var detail, int num) {
//     String _time = detail.date.toString() + '000'; //dart?????????????????????13???
//
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (!_notSelfNotGUide) {
//               if (detail.count > 1) {
//                 _gone[num] = !_gone[num];
//                 setState(() {});
//               } else if (detail.count == 1) {
//                 if(detail.detail!=null){
//                   AppRouter.push(context, RouteName.SHOP_ORDER_DETAIL,
//                       arguments: OrderDetailPage.setArguments(
//                           detail.detail[0].id)); //????????????????????????????????????????????????
//                 }
//
//               }
//             } else {
//               int type = 0;
//               if (_selfChoose) {
//                 type = 1;
//               } else if (_distributionChoose) {
//                 type = 2;
//               } else if (_agentChoose) {
//                 type = 3;
//               }
//
//               Get.to(UserBenefitShopPage(
//                   teamType: type,
//                   receivedType: widget.receivedType,
//                   date: DateTime.fromMillisecondsSinceEpoch(int.parse(_time))));
//             }
//           },
//           child: Row(
//             children: [
//               Container(
//                 height: 88.w,
//                 width: 150.w,
//                 color: Colors.white,
//                 child: Text(
//                   !_notSelfNotGUide
//                       ? DateUtil.formatDate(
//                           DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
//                           format: TableformatType)
//                       : DateUtil.formatDate(
//                           DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
//                           format: _TTableformatType),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 16.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 45.rw,
//                 width: 180.w,
//                 color: Colors.white,
//                 child: Text(
//                   detail.sale.toStringAsFixed(2),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 16.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 88.w,
//                 width: 100.w,
//                 color: Colors.white,
//                 child: Text(
//                   detail.count.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 16.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 88.w,
//                 width: 320.w,
//                 color: Colors.white,
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.only(left: 60.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         detail.coin.toStringAsFixed(2),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xffD5101A),
//                           fontSize: 16.rsp,
//                         ),
//                       ).centered(),
//                     ),
//                     !_notSelfNotGUide
//                         ? detail.count > 1
//                             ? _gone[num]
//                                 ? Icon(Icons.keyboard_arrow_right,
//                                     size: 22, color: Color(0xff999999))
//                                 : Icon(Icons.keyboard_arrow_down,
//                                     size: 22, color: Color(0xff999999))
//                             : Icon(null, size: 22, color: Color(0xff999999))
//                         : Icon(null, size: 22, color: Color(0xff999999)),
//                     20.wb
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         !_notSelfNotGUide
//             ? Offstage(
//                 offstage: _gone[num],
//                 child: Column(
//                   children: [
//                     ..._models.detail[num].detail.map(
//                       (e) {
//                         return _buildHideBody(
//                             e.id, e.date, e.sale, e.count, e.coin);
//                       },
//                     ),
//                   ],
//                   //itemCount: _models.detail[index].detail.length,
//                   //return _buildHideBody(_models.detail[num].detail[index]);
//                 ),
//               )
//             : SizedBox()
//       ],
//     );
//   }
//
//   _buildHideBody(
//     num id,
//     num date,
//     num sale,
//     num count,
//     num coin,
//   ) {
//     String _time = date.toString() + '000'; //dart?????????????????????13???
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if(id!=null&&id!=0){
//
//               AppRouter.push(context, RouteName.SHOP_ORDER_DETAIL,
//                   arguments: OrderDetailPage.setArguments(id));
//             }
//           },
//           child: Row(
//             children: [
//               Container(
//                 height: 88.w,
//                 width: 150.w,
//                 color: Color(0xFFF2F8FF),
//                 child: Text(
//                   _yearChoose
//                       ? DateUtil.formatDate(
//                           DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
//                           format: 'M???d???')
//                       : DateUtil.formatDate(
//                           DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
//                           format: 'HH:mm:ss'),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 12.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 45.rw,
//                 width: 180.w,
//                 color: Color(0xFFF2F8FF),
//                 child: Text(
//                   sale.toStringAsFixed(2),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 12.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 88.w,
//                 width: 100.w,
//                 color: Color(0xFFF2F8FF),
//                 child: Text(
//                   count.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF333333),
//                     fontSize: 12.rsp,
//                   ),
//                 ).centered(),
//               ),
//               Container(
//                 height: 88.w,
//                 width: 320.w,
//                 color: Color(0xFFF2F8FF),
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         coin.toStringAsFixed(2),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xffD5101A),
//                           fontSize: 12.rsp,
//                         ),
//                       ).centered(),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
