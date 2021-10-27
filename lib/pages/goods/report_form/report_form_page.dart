import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/pages/goods/report_form/report_form_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ReportFormPage extends StatefulWidget {
  final int goodId;
  ReportFormPage({
    Key key,@required this.goodId,
  }) : super(key: key);

  @override
  _ReportFormPageState createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage>
    with TickerProviderStateMixin {
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  TabController _tabController;
  int _currentIndex = 0; //选中下标
  List _tabList = ['日', '月', '年', '总'];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // _tabController.addListener(() {
    //   print(_tabController.index.toString());
    //   _onTabChanged();
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "产品销售分析",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.rw),
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.rw),
        padding: EdgeInsets.only(top: 10.rw),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(6.rw))),
        child: (Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.rw)),
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3.rw,
                        height: 15.rw,
                        color: Color(0xFF5484D8),
                      ),
                      20.wb,
                      Text('产品报表',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16.rsp,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  30.hb,
                  Container(
                    height: 30.rw,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.rw)),
                        color: Color(0xFFD5D5D5)),
                    alignment: Alignment.center,

                    // width: DeviceInfo.screenWidth,
                    child: TabBar(
                        onTap: (index) {
                          _tabController.index = index;
                          setState(() {});
                        },
                        //isScrollable: ,

                        labelPadding: EdgeInsets.all(0),
                        controller: _tabController,
                        indicator: const BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: TextStyle(color: Colors.black54),
                        tabs: _tabList.map<Tab>((item) {
                          int index = _tabList.indexOf(item);
                          return _tabItem(item, index);
                        }).toList()),
                  ),
                  50.hb,
                  Container(
                    child: Row(
                      children: [
                        _titleWidget('订单数', '1000', '个'),
                        Container(
                          width: 1.rw,
                          height: 22.rw,
                          color: Color(0xFFE0E0E0),
                        ),
                        _titleWidget('销售额', '20000', '元'),
                        Container(
                          width: 1.rw,
                          height: 22.rw,
                          color: Color(0xFFE0E0E0),
                        ),
                        _titleWidget('预估收益', '100', '元'),
                        Container(
                          width: 1.rw,
                          height: 22.rw,
                          color: Color(0xFFE0E0E0),
                        ),
                        _titleWidget('实际收益', '200', '元'),
                      ],
                    ),
                  ),
                  40.hb,
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: List.generate(
                  _tabItems().length, (index) => ReportFormWidgetPage()),
            ))
          ],
        )));
  }

  _titleWidget(
    String text1,
    String text2,
    String text3,
  ) {
    return Column(
      children: [
        Text(
          text1,
          style: TextStyle(color: Color(0xFF707070), fontSize: 10.rsp),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text2,
              style: TextStyle(color: Color(0xFF2A2A2A), fontSize: 14.rsp),
            ),
            Text(
              text3,
              style: TextStyle(color: Color(0xFF707070), fontSize: 10.rsp),
            ),
          ],
        )
      ],
    ).expand();
  }

  List<Widget> _tabItems() {
    return _tabList.map<Widget>((item) {
      int index = _tabList.indexOf(item);
      return _tabItem(item, index);
    }).toList();
  }

  _tabItem(String item, int index) {
    return Tab(
        child: Row(
      children: [
        index == 1 || index == 2
            ? Container(
                width: index == 2 ? 0.5.rw : 1.rw,
                height: 22.rw,
                color: Color(0xFFA9A9A9),
              )
            : SizedBox(),
        Container(
          height: 30.rw,
          decoration: index != _tabController.index
              ? BoxDecoration(
                  color: Color(0xFFD5D5D5),
                  borderRadius: index == 0
                      ? BorderRadius.horizontal(
                          left: Radius.circular(6.rw),
                          right: Radius.circular(6.rw),
                        )
                      : index == 3
                          ? BorderRadius.horizontal(
                              right: Radius.circular(6.rw),
                            )
                          : BorderRadius.horizontal(
                              right: Radius.circular(0.rw),
                            )
                  //index == _tabController.index?
                  )
              : BoxDecoration(
                  border: Border.all(color: Color(0xFFD5D5D5), width: 1.rw),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item,
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
            ],
          ),
        ).expand(),
        index == 1 || index == 2
            ? Container(
                width: index == 1 ? 0.5.rw : 1.rw,
                height: 22.rw,
                color: Color(0xFFA9A9A9),
              )
            : SizedBox(),
      ],
    ));
  }

  _onTabChanged() {
    if (_currentIndex != _tabController.index) {
      //赋值 并更新数据
      this.setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }
}