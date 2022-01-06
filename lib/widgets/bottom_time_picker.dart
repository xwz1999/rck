import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/widgets/month_select_widget.dart';
import 'package:jingyaoyun/widgets/title_switch.dart';

enum BottomTimePickerType {
  BottomTimePickerMonth, 
  BottomTimePickerYear, 
  BottomTimePickerDay}

class BottomTimePicker extends StatefulWidget {
  final Function cancle;
  final Function(DateTime, BottomTimePickerType) submit;
  final List<BottomTimePickerType> timePickerTypes;
  // final BottomTimePickerType customTimePickerType;
  // BottomTimePicker({Key key, this.cancle, this.submit, this.customTimePickerType}) : super(key: key);
  BottomTimePicker({Key key, this.cancle, this.submit, this.timePickerTypes}) : super(key: key);

  @override
  _BottomTimePickerState createState() => _BottomTimePickerState();
}

class _BottomTimePickerState extends State<BottomTimePicker> {
  List<BottomTimePickerType> _timePickerTypes;
  // BottomTimePickerType _customTimePickerType;
  DateTime _dateTime;
  int _index = 0;
  @override
  void initState() { 
    super.initState();
    if (widget.timePickerTypes == null) {
      _timePickerTypes = [BottomTimePickerType.BottomTimePickerYear ,BottomTimePickerType.BottomTimePickerMonth, BottomTimePickerType.BottomTimePickerDay];
    }else{
      _timePickerTypes = widget.timePickerTypes;
    }
    // if (_customTimePickerType == BottomTimePickerType.BottomTimePickerMonth) _index = 0;
    // if (_customTimePickerType == BottomTimePickerType.BottomTimePickerYear) _index = 1;
    // if (_customTimePickerType == BottomTimePickerType.BottomTimePickerDay) _index = 2;

    _dateTime = DateTime.now();
  }
  _titleSwitchTitles(){
    List<String> titles = [];
    for (BottomTimePickerType type in _timePickerTypes) {
      switch (type) {
        case BottomTimePickerType.BottomTimePickerDay:
          titles.add("按天");
          break;
        case BottomTimePickerType.BottomTimePickerMonth:
          titles.add("按月");
          break;
        case BottomTimePickerType.BottomTimePickerYear:
          titles.add("按日");
          break;
        default:
      }
    }
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
       child: Column(
         children: <Widget>[
            _toolWidget(),
            Container(
              height: 0.5,
              color: Colors.black.withOpacity(0.1).withAlpha(30),
            ),
            _timePickerTypes.length == 1 ? 
            Container():
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: TitleSwitch(
                index: 0,
                width: 120,
                titles: _titleSwitchTitles(),
                selectIndexBlock: (index){
                  _index = index;
                  setState(() {});
                },
                backgroundWidget: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xffE8E8E8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _contentWidget(),
            ),
         ],
       ),
    );  
  }

  _toolWidget(){
    return Container(
      height: 44,
      child: Row(
        children: <Widget>[
          TextButton(
            onPressed: (){
              if (widget.cancle!=null) widget.cancle();
            }, 
            child: Text("取消", style: TextStyle(color: Color(0xff999999), fontSize: 15),)
          ),
          Expanded(
            child: Text("选择时间", textAlign: TextAlign.center ,style: TextStyle( color: Colors.black, fontSize: 17),),
          ),
          TextButton(
            onPressed: (){
              if (widget.submit!=null){
                widget.submit(_dateTime, _timePickerTypes[_index]);
              }
            }, 
            child: Text("确认", style: TextStyle(color: AppColor.themeColor, fontSize: 15),),
          )
        ],
      ),
    );
  }

  _pickerCell(String title){
    return Text(title, style: TextStyle(color: Colors.black,));
  }

  _contentWidget(){
    List<DateTime> yearList = [];
    List<Widget> yearWidgetList = [];
    DateTime nowTime = DateTime.now();
    yearList.add(nowTime);
    yearWidgetList.add(_pickerCell("${nowTime.year}年"));
    for (var i = 1; i < 10; i++) {
      DateTime cellTime = DateTime.parse("${nowTime.year-i}-${nowTime.month.toString().padLeft(2,'0')}-01");
      yearList.add(cellTime);
      yearWidgetList.add(_pickerCell("${cellTime.year}年"));
    }

    return Container(
      child: _timePickerTypes[_index] == BottomTimePickerType.BottomTimePickerMonth
      ? MonthSelectWidget(
        timeChange: (time){
          _dateTime = time;
        },
      )
      : _timePickerTypes[_index] == BottomTimePickerType.BottomTimePickerYear 
      ? CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 30, 
        onSelectedItemChanged: (index){
          _dateTime = yearList[index];
        }, 
        children: yearWidgetList
      ) 
      // : _index == 2 ? MonthSelectWidget(
      // : MonthSelectWidget(
      //   timeChange: (time){
      //     _dateTime = time;
      //   },
      // )
      : _timePickerTypes[_index] == BottomTimePickerType.BottomTimePickerDay 
      ? CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (dateTime){
          _dateTime = dateTime;
        }
      )
      : Container(),
      // CupertinoDatePicker(
      //   mode: CupertinoDatePickerMode.date, 
      //   onDateTimeChanged: (DateTime value) {
      //     _dateTime = value;
      //   },
      // ),
    );
  }
}


class TimeSelectTitleWidget extends StatefulWidget {
  final Function click;
  final String title;
  final Color backgroundColor;
  final Color color;
  TimeSelectTitleWidget({Key key, this.title, this.click, this.backgroundColor = Colors.white, this.color}) : super(key: key);

  @override
  _TimeSelectTitleWidgetState createState() => _TimeSelectTitleWidgetState();
}

class _TimeSelectTitleWidgetState extends State<TimeSelectTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: GestureDetector(
         child: _selectWidget(widget.title),
         onTap: (){
           if(widget.click!=null){
             widget.click();
           }
         },
       ),
    );
  }
  _selectWidget(String title,) {
    return Container(
      height: 32.0,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: widget.color!=null?widget.color: Colors.black, fontSize: 13),
          ),
          Container(
            width: 0,
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: widget.color!=null?widget.color: Color(0xff8f8f8f),
          ),
        ],
      ),
    );
  }
}
