import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarTableWidget extends StatefulWidget {
  @override
  State<BarTableWidget> createState() => BarTableWidgetState();
}

class BarTableWidgetState extends State<BarTableWidget> {
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
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Spacer(),
                  Text('销售(个)',
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
                  child: _barChart(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _barChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        barTouchData: BarTouchData(
          enabled: true,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) =>
                const TextStyle(color: Color(0xff939393), fontSize: 10),
            margin: 10,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return '浙江';
                case 1:
                  return '上海';
                case 2:
                  return '江苏';
                case 3:
                  return '广东';
                case 4:
                  return '吉林';
                case 5:
                  return '重庆';
                case 6:
                  return '四川';
                case 7:
                  return '云南';
                case 8:
                  return '黑龙江';
                case 9:
                  return '湖南';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: 200, //换成计算值
            getTextStyles: (context, value) => const TextStyle(
                color: Color(
                  0xff939393,
                ),
                fontSize: 10),
            margin: 0,
          ),
        ),
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) => value % 200 == 0, //换成计算值
          getDrawingHorizontalLine: (value) => FlLine(
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
            left: BorderSide(color: Color(0xFFEEEEEE), width: 1),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        groupsSpace: 15,
        barGroups: getData(),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    List<BarChartGroupData> barList = [];
    for (int i = 0; i < 10; i++) {
      barList.add(_barChartGroupData(i, i * 100.0 + 50));
    }
    return barList;
  }

  _barChartGroupData(int x, num y) {
    return BarChartGroupData(
      x: x,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
            width: 15,
            y: y,
            colors: [Color(0xFFC31B20)],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );
  }
}
