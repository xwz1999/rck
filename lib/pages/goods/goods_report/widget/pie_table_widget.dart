import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';

class PieTabWidget extends StatefulWidget {
  @override
  State<PieTabWidget> createState() => PieTabWidgetState();
}

class PieTabWidgetState extends State<PieTabWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Colors.white),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _pieChart(),
          ),
          _identification(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }

  _pieChart() {
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              final desiredTouch =
                  pieTouchResponse.touchInput is! PointerExitEvent &&
                      pieTouchResponse.touchInput is! PointerUpEvent;
              if (desiredTouch && pieTouchResponse.touchedSection != null) {
                touchedIndex =
                    pieTouchResponse.touchedSection.touchedSectionIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 20,
          //startDegreeOffset: 180,
          sections: showingSections()),
    );
  }

  _identification() {
    return Container(
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Indicator(
            color: Color(0xFFC31B20),
            text: '20～30岁',
            isSquare: false,
            size: 8,
          ),
          SizedBox(
            height: 4,
          ),
          Indicator(
            color: Color(0xFFFAAD5D),
            text: '30～40岁',
            isSquare: false,
            size: 8,
          ),
          SizedBox(
            height: 4,
          ),
          Indicator(
            color: Color(0xFF9C62DA),
            text: '40～50岁',
            isSquare: false,
            size: 8,
          ),
          SizedBox(
            height: 4,
          ),
          Indicator(
            color: Color(0xFF5285D8),
            text: '50～60岁',
            isSquare: false,
            size: 8,
          ),
          SizedBox(
            height: 4,
          ),
          Indicator(
            color: Color(0xFFC92FBB),
            text: '其他',
            isSquare: false,
            size: 8,
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      switch (i) {
        case 4:
          return PieChartSectionData(
            color: const Color(0xFFC31B20),
            value: 40,
            title: '40%',
            radius: 100,
            titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFFFAAD5D),
            value: 25,
            title: '25%',
            radius: 80,
            titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xFF9C62DA),
            value: 20,
            title: '20%',
            radius: 60,
            titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFF5285D8),
            value: 10,
            title: '10%',
            radius: 40,
            titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        case 0:
          return PieChartSectionData(
            color: const Color(0xFFC92FBB),
            value: 5,
            title: '5%',
            radius: 20,
            titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}
