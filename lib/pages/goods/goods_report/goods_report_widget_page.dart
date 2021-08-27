import 'dart:math';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/pages/goods/goods_report/widget/bar_table_widget.dart';
import 'package:recook/pages/goods/goods_report/widget/circle_chart_widget.dart';
import 'package:recook/pages/goods/goods_report/widget/line_table_widget.dart';
import 'package:recook/pages/goods/goods_report/widget/map.dart';
import 'package:recook/pages/goods/goods_report/widget/pie_table_widget.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:velocity_x/velocity_x.dart';

class GoodsReportWidgetPage extends StatefulWidget {
  GoodsReportWidgetPage({
    Key key,
  }) : super(key: key);

  @override
  _GoodsReportWidgetPageState createState() => _GoodsReportWidgetPageState();
}

class _GoodsReportWidgetPageState extends State<GoodsReportWidgetPage>
    with TickerProviderStateMixin {
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  TabController _tabController;
  List _tabList = ['周', '月', '年', '总'];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor, body: _buildListView());
  }

  _buildListView() {
    return ListView(
      children: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.rw),
            padding: EdgeInsets.only(top: 10.rw),
            height: 470.rw,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
            child: (Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.rw,
                      height: 15.rw,
                      color: Color(0xFF5484D8),
                    ),
                    20.wb,
                    Text('产品参数',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                40.hb,
                _buildParameterText('品牌', '作家有出', '名称', '30cm多功能低压炒锅'),
                _buildParameterText('净重', '约2.54kg', '材质', '铝合金基材，玻璃，硅胶，傲视不锈钢'),
                _buildParameterText('尺寸', '约30cm*9.5cm', '适合炉灶', '通用'),
                50.hb,
                Container(
                  width: double.infinity,
                  height: 200.rw,
                  alignment: Alignment.center,
                  child: FadeInImage.assetNetwork(
                    placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                    image: Api.getImgUrl('/photo/15961790346127.png'),
                    height: 200.rw,
                    width: 200.rw,
                  ),
                )
              ],
            ))),
        Container(
            width: double.infinity,
            height: 320.rw,
            margin: EdgeInsets.only(top: 10.rw),
            padding: EdgeInsets.only(top: 10.rw),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
            child: (Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.rw,
                      height: 15.rw,
                      color: Color(0xFF5484D8),
                    ),
                    20.wb,
                    Text('累计销量',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                20.hb,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 10.rw),
                  height: 270.rw,
                  child: LineTablewidget(),
                )
              ],
            ))),
        Container(
            width: double.infinity,
            //height: 500.rw,
            margin: EdgeInsets.only(top: 10.rw),
            padding: EdgeInsets.only(top: 10.rw),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
            child: (Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.rw,
                      height: 15.rw,
                      color: Color(0xFF5484D8),
                    ),
                    20.wb,
                    Text('销售TOP10',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                20.hb,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 10.rw),
                  height: 270.rw,
                  child: BarTableWidget(),
                ),
                40.hb,
                Text('地图分布',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16.rsp,
                        fontWeight: FontWeight.bold)),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 15.rw),
                    height: 300.rw,
                    child: MapWidget()),
              ],
            ))),
        Container(
            width: double.infinity,
            height: 300.rw,
            margin: EdgeInsets.only(top: 10.rw),
            padding: EdgeInsets.only(top: 10.rw),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
            child: (Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.rw,
                      height: 15.rw,
                      color: Color(0xFF5484D8),
                    ),
                    20.wb,
                    Text('消费者年龄段',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 50.rw),
                  height: 240.rw,
                  child: PieTabWidget(),
                ),
              ],
            ))),
        Container(
            width: double.infinity,
            height: 250.rw,
            margin: EdgeInsets.only(top: 10.rw),
            padding: EdgeInsets.only(top: 10.rw),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
            child: (Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.rw,
                      height: 15.rw,
                      color: Color(0xFF5484D8),
                    ),
                    20.wb,
                    Text('消费者性别',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16.rsp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                100.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleChart(
                            size: 100.rw,
                            core: _percentage('30'),
                            color: Color(0xFF2C5EB3),
                            aspectRato: 0.3,
                            aboveStrokeWidth: 5.rw),
                        40.hb,
                        Text(
                          '男',
                          style: TextStyle(
                              color: Color(0xFF333333), fontSize: 18.rsp),
                        )
                      ],
                    ),
                    100.wb,
                    Column(
                      children: [
                        CircleChart(
                            size: 100.rw,
                            core: _percentage('70'),
                            color: Color(0xFFC31B20),
                            aspectRato: 0.7,
                            aboveStrokeWidth: 5.rw),
                        40.hb,
                        Text(
                          '女',
                          style: TextStyle(
                              color: Color(0xFF333333), fontSize: 18.rsp),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ))),
        100.hb,
      ],
    );
  }

  _percentage(String percent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          percent,
          style: TextStyle(color: Color(0xFF333333), fontSize: 30.rsp),
        ),
        Text(
          "%",
          style: TextStyle(color: Color(0xFF333333), fontSize: 22.rsp),
        ),
      ],
    );
  }

  _buildParameterText(
      String title1, String content1, String title2, String conten2) {
    return Row(
      children: [
        30.wb,
        Container(
          height: 60.rw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF999999)),
              ),
              Text(
                content1,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13.rsp,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ).expand(),
        20.wb,
        Container(
          height: 60.rw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF999999)),
              ),
              Text(
                conten2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.rsp,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ).expand(),
      ],
    );
  }
}
