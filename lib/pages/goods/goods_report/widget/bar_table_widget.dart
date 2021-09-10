import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:recook/pages/goods/model/goods_report_model.dart';

class BarTableWidget extends StatefulWidget {
  final List<TopTen> topTenList;
  final int timetype;

  const BarTableWidget(
      {Key key, @required this.topTenList, @required this.timetype})
      : super(key: key);
  @override
  State<BarTableWidget> createState() => BarTableWidgetState();
}



class BarTableWidgetState extends State<BarTableWidget> {
  List<TopTen> _topTenList = [];
  @override
  void initState() {
    super.initState();
    _topTenList = widget.topTenList;
    setState(() {

    });
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
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Color(0xFF333333),
              fontSize: 10,
            ),
            margin: 5,
            getTitles: (double value) {
              return _getProvice(_topTenList[value.toInt()].province);
            },
          ),
          leftTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
            interval: _getInterval(_getMaxNum())==0?1:_getInterval(_getMaxNum())??1, //间隔
            getTextStyles: (context, value) => const TextStyle(
                color: Color(
                  0xFF333333,
                ),
                fontSize: 10),
            margin: 5,
          ),
        ),
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) =>
              value % _getInterval(_getMaxNum()) == 0, //换成计算值
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
    for (int i = 0; i < _topTenList.length; i++) {
      barList.add(_barChartGroupData(i, _topTenList[i].sum.toDouble()));
    }
    return barList;
  }

  _barChartGroupData(int x, num y) {
    return BarChartGroupData(
      x: x,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
            width: 16,
            y: y,
            colors: [Color(0xFFC31B20)],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );
  }

  _getProvice(String provice) {
    provice = provice.replaceAll('维吾尔自治区', '');
    provice = provice.replaceAll('回族自治区', '');
    provice = provice.replaceAll('壮族自治区', '');
    provice = provice.replaceAll('自治区', '');
    provice = provice.replaceAll('省', '');
    provice = provice.replaceAll('市', '');
    return provice;
  }

  _getInterval(num maxNum) {
    //得到一个10的倍数的间隔值
    if (maxNum < 10)
      return maxNum.toDouble();
    else {
      int num1 = maxNum ~/ 4;
      int a = num1 % 10;
      if (a > 0) {
        print(((num1 ~/ 10) * 10 + 10).toDouble());
        return ((num1 ~/ 10) * 10 + 10).toDouble();
      }
    }
  }

  // _getMaxNum() {
  //   num max = 0;
  //   for (int i = 0; i < _saleList.length; i++) {
  //     if (max < _saleList[i].saleNum) {
  //       max = _saleList[i].saleNum;
  //     }
  //   }
  //   return max;
  // }

  _getMaxNum() {
    _topTenList.sort((a, b) => b.sum.compareTo(a.sum));
    return _topTenList.first.sum;
  }
}
