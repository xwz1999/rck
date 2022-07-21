import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/loan_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';
class LoanResultPage extends StatefulWidget {
  final LoanModel loanModel;
  final String year;
  final String type;

  const LoanResultPage(
      {Key? key,
      required this.loanModel,
      required this.year,
      required this.type})
      : super(key: key);

  @override
  _LoanResultPageState createState() => _LoanResultPageState();
}

class _LoanResultPageState extends State<LoanResultPage> {
  num endMoney = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    endMoney = num.parse(widget.loanModel.bj!.bxTotal ?? '0');
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('贷款公积金查询',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return widget.type == '等额本息'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(12.rw),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rw),
                    border:
                        Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('每月还款(元)',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.loanModel.bx!.bxPerMonth ?? '',
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                                fontSize: 36.rsp,
                                fontWeight: FontWeight.bold
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('本息合计(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bx!.bxTotal ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('每月利息(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bx!.lxPerMonth ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('总支付利息(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bx!.lxTotal ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('贷款年限(年)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.year,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        : ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.rw),
                    border:
                        Border.all(color: Color(0xFFE8E8E8), width: 0.5.rw)),
                margin: EdgeInsets.all(12.rw),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.rw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('每月本金(元)',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12.rsp,
                              )),
                          10.hb,
                          Text(widget.loanModel.bj!.capital ?? '',
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                                fontSize: 36.rsp,
                                fontWeight: FontWeight.bold
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('本息合计(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bj!.bxTotal ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('总支付利息(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bj!.lxTotal ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5.rw,
                      color: Color(0xFFE8E8E8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('首月利息(元)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bj!.lxFirstMonth ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('尾月利息(年)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.loanModel.bj!.lxLastMonth ?? '',
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5.rw,
                          height: 110.rw,
                          color: Color(0xFFE8E8E8),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(20.rw),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('贷款年限(年)',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12.rsp,
                                    )),
                                10.hb,
                                Text(widget.year,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.rsp,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _itemWidget('期数','还款金额(元)','剩余金额(元)',isTitle: true),
                  ...widget.loanModel.bj!.perMonth!.mapIndexed((e,index) {
                    endMoney = endMoney - num.parse(e);

                    return _itemWidget((index+1).toString(), e, endMoney.toStringAsFixed(2),isWhite:(index+2)%2==0);
                  } ).toList()
                ],
              )
            ],
          );
  }

  _itemWidget(String text1, String text2, String text3,{bool isTitle = false,bool isWhite = false}) {
    return Container(
      color: isWhite?Colors.white:Color(0xFFF9F9F9),
      padding: EdgeInsets.symmetric(vertical: 16.rw),
      child: Row(
        children: [
          24.wb,
          Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  text1,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: isTitle?12.rsp: 14.rsp,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  text2,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: isTitle?14.rsp: 16.rsp,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  text3,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: isTitle?14.rsp: 16.rsp,
                      fontWeight: FontWeight.bold),
                ),
              )),
          24.wb,
        ],
      ),
    );
  }
}
