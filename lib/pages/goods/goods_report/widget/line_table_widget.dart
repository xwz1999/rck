import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// class _LineChart extends StatelessWidget {
//   const _LineChart();
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       sampleData2,
//       //swapAnimationDuration: const Duration(milliseconds: 250),
//     );
//   }

//   LineChartData get sampleData2 => LineChartData(
//         lineTouchData: lineTouchData2,
//         gridData: gridData,
//         titlesData: titlesData2,
//         borderData: borderData,
//         lineBarsData: lineBarsData2,
//         //minX: 0,
//         //maxX: 210,
//         //maxY: 500,
//         minY: 0,
//       );

//   LineTouchData get lineTouchData2 => LineTouchData(
//         enabled: false,
//       );

//   FlTitlesData get titlesData2 => FlTitlesData(
//         show: true,
//         bottomTitles: bottomTitles,
//         leftTitles: leftTitles(
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 250:
//                 return '250';
//               case 500:
//                 return '500';
//               case 750:
//                 return '750';
//               case 1000:
//                 return '1000';
//             }
//             return '';
//           },
//         ),
//       );

//   List<LineChartBarData> get lineBarsData2 => [
//         lineChartBarData2_3,
//       ];

//   SideTitles leftTitles({GetTitleFunction getTitles}) => SideTitles(
//         getTitles: getTitles,
//         showTitles: true,
//         margin: 10,
//         reservedSize: 30,
//         getTextStyles: (context, value) => const TextStyle(
//           color: Color(0xFF333333),
//           fontSize: 12,
//         ),
//       );

//   SideTitles get bottomTitles => SideTitles(
//         showTitles: true,
//         reservedSize: 20,
//         margin: 5,
//         getTextStyles: (context, value) => const TextStyle(
//           color: Color(0xFF333333),
//           fontSize: 12,
//         ),
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 1:
//               return '一';
//             case 2:
//               return '二';
//             case 3:
//               return '三';
//             case 4:
//               return '四';
//             case 5:
//               return '五';
//             case 6:
//               return '六';
//             case 7:
//               return '日';
//           }
//           return '';
//         },
//       );

//   FlGridData get gridData => FlGridData(
//         show: true,
//         checkToShowHorizontalLine: (value) => value % 250 == 0,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xFFEEEEEE),
//             strokeWidth: 1,
//           );
//         },
//       );

//   FlBorderData get borderData => FlBorderData(
//         show: true,
//         border: const Border(
//           bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
//           left: BorderSide(color: Color(0xFFEEEEEE), width: 1),
//           right: BorderSide(color: Colors.transparent),
//           top: BorderSide(color: Colors.transparent),
//         ),
//       );

//   LineChartBarData get lineChartBarData2_3 => LineChartBarData(
//         isCurved: false,
//         //curveSmoothness: 0,
//         colors: [Color(0xFFC2181C)],
//         barWidth: 2,
//         isStrokeCapRound: false,
//         dotData: FlDotData(
//             show: true,
//             getDotPainter: (spot, percent, barData, index) {
//               return FlDotCirclePainter(
//                   radius: 3,
//                   color: Colors.white,
//                   strokeWidth: 1,
//                   strokeColor: Color(0xFFC2181C));
//             }),
//         belowBarData: BarAreaData(show: false),
//         spots: [
//           FlSpot(1, 100),
//           FlSpot(2, 110),
//           FlSpot(3, 250),
//           FlSpot(4, 400),
//           FlSpot(5, 300),
//           FlSpot(6, 700),
//           FlSpot(7, 1000),
//         ],
//       );
// }

class LineTablewidget extends StatefulWidget {
  @override
  State<LineTablewidget> createState() => LineTablewidgetState();
}

class LineTablewidgetState extends State<LineTablewidget> {
  @override
  void initState() {
    super.initState();
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
                '本周',
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
        //minX: 0,
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
        leftTitles: leftTitles(
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
            ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_3,
      ];

  SideTitles leftTitles({GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 10,
        interval: 500,
        reservedSize: 30,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 20,
        margin: 5,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xFF333333),
          fontSize: 12,
        ),
        getTitles: (value) {
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
        },
      );

  FlGridData get gridData => FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 250 == 0,
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
        spots: [
          FlSpot(1, 100),
          FlSpot(2, 110),
          FlSpot(3, 250),
          FlSpot(4, 400),
          FlSpot(5, 300),
          FlSpot(6, 700),
          FlSpot(7, 2000),
        ],
      );

  _getInterval(int maxNum) {
    //得到一个10的倍数的间隔值
    if (maxNum < 4)
      return maxNum;
    else {
      int num1 = maxNum ~/ 4;
      int a = num1 % 10;
      if (a > 0) {
        return (num1 ~/ 10) * 10 + 10;
      }
    }
  }
}
