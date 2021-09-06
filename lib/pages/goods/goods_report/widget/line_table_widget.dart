import 'package:fl_chart/fl_chart.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:recook/pages/goods/model/goods_report_model.dart';

class LineTablewidget extends StatefulWidget {
  final List<SaleNum> saleList;
  final int timetype;

  const LineTablewidget(
      {Key key, @required this.saleList, @required this.timetype})
      : super(key: key);
  @override
  State<LineTablewidget> createState() => LineTablewidgetState();
}

class LineTablewidgetState extends State<LineTablewidget> {
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  List<SaleNum> _saleList = [];
  @override
  void initState() {
    super.initState();
    _saleList = widget.saleList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Colors.white),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _getTitle(),
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Spacer(),
                  Text('累计销售(个)',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                      )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: _lineChart(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _lineChart() {
    return LineChart(
      sampleData2,
    );
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        // minX: 0,
        //maxX: 210,
        //maxY: 500,
        minY: 0,
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
        ),
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        show: true,
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(),
        // getTitles: (value) {
        //   switch (value.toInt()) {
        //     case 250:
        //       return '250';
        //     case 500:
        //       return '500';
        //     case 750:
        //       return '750';
        //     case 1000:
        //       return '1000';
        //   }
        //   return '';
        // },
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_3,
      ];

  SideTitles leftTitles({GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 5,
        interval: _getInterval(_getMaxNum())==0?1:_getInterval(_getMaxNum())??1, //间隔
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xFF333333),
          fontSize: 10,
        ),
      );
  // SideTitles leftTitles1({GetTitleFunction getTitles}) => SideTitles(
  //       getTitles: getTitles,
  //       showTitles: true,
  //       margin: 10,
  //       // interval: _getInterval(_getMaxNum()) < 5
  //       //     ? null
  //       //     : _getInterval(_getMaxNum()), //间隔
  //       reservedSize: 30,
  //       getTextStyles: (context, value) => const TextStyle(
  //         color: Color(0xFF333333),
  //         fontSize: 12,
  //       ),
  //     );

  SideTitles get bottomTitles => SideTitles(
      showTitles: true,
      reservedSize: 20,
      margin: 5,
      getTextStyles: (context, value) => const TextStyle(
            color: Color(0xFF333333),
            fontSize: 12,
          ),
      getTitles: (value) {
        if (widget.timetype == 1) {
          switch (value.toInt()) {
            case 1:
              return '一';
            case 2:
              return '二';
            case 3:
              return '三';
            case 4:
              return '四';
            case 5:
              return '五';
            case 6:
              return '六';
            case 7:
              return '日';
          }
          return '';
        } else if (widget.timetype == 2) {
          switch (value.toInt()) {
            case 1:
              return '1';
            case 2:
              return '5';
            case 3:
              return '10';
            case 4:
              return '15';
            case 5:
              return '20';
            case 6:
              return '25';
          }
          return '';
        } else if (widget.timetype == 3) {
          switch (value.toInt()) {
            case 1:
              return '1';
            case 2:
              return '2';
            case 3:
              return '3';
            case 4:
              return '4';
            case 5:
              return '5';
            case 6:
              return '6';
            case 7:
              return '7';
            case 8:
              return '8';
            case 9:
              return '9';
            case 10:
              return '10';
            case 11:
              return '11';
            case 12:
              return '12';
          }
          return '';
        } else {
          return (value != null ? (value + 2019).toInt() : '').toString();
        }
      });

  FlGridData get gridData => FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) =>
            value % _getInterval(_getMaxNum()) == 0,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFEEEEEE),
            strokeWidth: 1,
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          left: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
      isCurved: false,
      //curveSmoothness: 0,
      colors: [Color(0xFFC2181C)],
      barWidth: 2,
      isStrokeCapRound: false,
      dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
                radius: 3,
                color: Colors.white,
                strokeWidth: 1,
                strokeColor: Color(0xFFC2181C));
          }),
      belowBarData: BarAreaData(show: false),
      spots: _getSpot());

  _getInterval(num maxNum) {
    //得到一个10的倍数的间隔值
    if (maxNum < 10)
      return maxNum.toDouble();
    else {
      int num1 = maxNum ~/ 4;
      int a = num1 % 10;
      if (a > 0) {
        print((num1 ~/ 10) * 10 + 10);
        return ((num1 ~/ 10) * 10 + 10).toDouble();
      }
    }
  }

  _getSpot() {
    List<FlSpot> flspotList = [];
    for (int i = widget.saleList.length - 1; i >= 0; i--) {
      flspotList.add(FlSpot(widget.saleList[i].sortId.toDouble(),
          widget.saleList[i].saleNum.toDouble()));
      print(widget.saleList[i].sortId);
    }
    return flspotList.isEmpty?[FlSpot(1,0)]:flspotList;
  }

  _getTitle() {
    switch (widget.timetype) {
      case 1:
        return '本周';
      case 2:
        return DateUtil.formatDate(_dateNow, format: 'yyyy年MM月');
      case 3:
        return DateUtil.formatDate(_dateNow, format: 'yyyy年');
      case 4:
        return '';
    }
  }

  _getMaxNum() {
    num max = 0;
    for (int i = 0; i < _saleList.length; i++) {
      if (max < _saleList[i].saleNum) {
        max = _saleList[i].saleNum;
      }
    }
    return max;
  }
}
