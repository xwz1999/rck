import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MonthSelectWidget extends StatefulWidget {
  final Function(DateTime) timeChange;
  MonthSelectWidget({Key key, this.timeChange}) : super(key: key);

  @override
  _MonthSelectWidgetState createState() => _MonthSelectWidgetState();
}

class _MonthSelectWidgetState extends State<MonthSelectWidget> {
  
  List<DateTime> _yearList = [];
  List<int> _monthList = [1,2,3,4,5,6,7,8,9,10,11,12];
  List<Widget> _yearWidgetList = [];
  List<Widget> _monthWidgetList = [];

  int _selectYear = 0;
  int _selectMonth = 0;

  @override
  void initState() {
    super.initState();
    DateTime nowTime = DateTime.now();
    // yearList.add(nowTime);
    // yearWidgetList.add(_pickerCell("${nowTime.year}年"));
    _selectYear = nowTime.year;
    _selectMonth = 1;
    _changeTimeBlock();
    for (var i = 0; i < 10; i++) {
      DateTime cellTime = DateTime.parse("${nowTime.year-i}-${nowTime.month.toString().padLeft(2,'0')}-01");
      _yearList.add(cellTime);
      _yearWidgetList.add(_pickerCell("${cellTime.year}年"));
    }
    for (int month in _monthList) {
      _monthWidgetList.add(_pickerCell("$month月"));
    }
  }
  
  _pickerCell(String title){
    return Text(title, style: TextStyle(color: Colors.black,));
  }

  _changeTimeBlock(){
    if (widget.timeChange != null) {
      DateTime time = DateTime.parse("${_selectYear.toString()}-${_selectMonth.toString().padLeft(2,'0')}-01");
      widget.timeChange(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Row(
         children: <Widget>[
          //  Container(width: 40,),
           Expanded(
             child: CupertinoPicker(
               backgroundColor: Colors.white,
               itemExtent: 30, 
               onSelectedItemChanged: (index){
                 _selectYear = _yearList[index].year;
                 _changeTimeBlock();
               }, 
               children: _yearWidgetList
               ),
           ),
           Expanded(
             child: CupertinoPicker(
               backgroundColor: Colors.white,
               itemExtent: 30, 
               onSelectedItemChanged: (index){
                 _selectMonth = _monthList[index];
                 _changeTimeBlock();
               }, 
               children: _monthWidgetList
               ),
           ),
          //  Container(width: 40,),
         ],
       ),
    );
  }
}
