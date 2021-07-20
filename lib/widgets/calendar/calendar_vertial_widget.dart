import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:provider/provider.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/calendar/xiata_calendar_widget.dart';

typedef DatePickerCallBack = Function(BuildContext context, DateTime start);

class CalendarVerticalWidget extends StatefulWidget {
  final DateTime startDay;
  //final DateTime endDay;
  final DatePickerCallBack callBack;
  CalendarVerticalWidget({
    Key key,
    @required this.startDay,
    @required this.callBack,
  }) : super(key: key);

  @override
  _CalendarVerticalWidgetState createState() => _CalendarVerticalWidgetState();
}

class _CalendarVerticalWidgetState extends State<CalendarVerticalWidget> {
  //bool _isCheckOutDate = false;
  bool _isSelectDone = false;
  DateTime _firstDay = DateTime.fromMillisecondsSinceEpoch(0);
  //DateTime _endDay = DateTime.fromMillisecondsSinceEpoch(0);
  @override
  Widget build(BuildContext context) {
    //final appProvider = Provider.of<AppProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.rw)),
      child: Material(
        child: Container(
          height: 484.rw,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20.rw,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      '请选择出发日期',
                      style: TextStyle(
                        color: AppColor.textMainColor,
                        fontSize: 16.rsp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        null,
                        size: 20.rw,
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
              Container(
                height: 34.rw,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.rw),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: AppColor.textMainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('一'),
                      Text('二'),
                      Text('三'),
                      Text('四'),
                      Text('五'),
                      Text('六'),
                      Text('日'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: XiataCalendarWidget(
                  minDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    1,
                  ),
                  maxDate: DateTime.now().add(Duration(days: 365)),
                  initialMinDate: widget.startDay,
                  // initialMaxDate: appProvider.checkOutDate,
                  onRangeSelected: (minDate) {
                    _firstDay = minDate;
                    //_endDay = DateTime.fromMillisecondsSinceEpoch(0);
                    setState(() {
                      //_isCheckOutDate = minDate != null && maxDate == null;
                      _isSelectDone = minDate != null;
                    });
                    if (minDate != null) {
                      //_endDay = maxDate;
                      setState(() {});
                      widget.callBack(context, minDate);
                    }
                    if (_isSelectDone) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  listPadding: EdgeInsets.symmetric(horizontal: 14.rw),
                  monthBuilder: (context, month, year) {
                    if (DateTime.now().year == year &&
                        DateTime.now().month == (month + 1)) {
                      return SizedBox();
                    }
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$year\年$month\月',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.textMainColor,
                          fontSize: 14.rsp,
                        ),
                      ),
                      height: 36.rw,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5.rw,
                            color: Color(0xFFEEEEEE),
                          ),
                        ),
                      ),
                    );
                  },
                  dayBuilder: (context, date, {isSelected}) {
                    //今日
                    final bool isToday =
                        DateUtil.isToday(date.millisecondsSinceEpoch);
                    //七天内
                    final bool isSevenDay = date.millisecondsSinceEpoch <
                            DateTime.now()
                                .add(Duration(days: 6))
                                .millisecondsSinceEpoch &&
                        date.millisecondsSinceEpoch >
                            DateTime.now()
                                .subtract(Duration(days: 1))
                                .millisecondsSinceEpoch;

                    ///今日之前
                    final bool isBeforeToday = date.millisecondsSinceEpoch <
                        DateTime.now()
                            .subtract(Duration(days: 1))
                            .millisecondsSinceEpoch;
                    final bool isIn30Days =
                        _firstDay.millisecondsSinceEpoch == 0
                            ? false
                            : date.millisecondsSinceEpoch >
                                _firstDay
                                    .add(Duration(days: 30))
                                    .millisecondsSinceEpoch;
                    return Opacity(
                      opacity: isBeforeToday || isIn30Days ? 0.2 : 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.rw,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color:
                                isSelected ? Color(0xFF0086F5) : Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.rw,
                            horizontal: 4.rw,
                          ),
                          height: 64.rw,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Text(
                                date.day.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.rsp,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  height: 1,
                                ),
                              ),
                              Text(
                                isToday
                                    ? '今天'
                                    : DateModel.fromDateTime(date).lunarString,
                                style: TextStyle(
                                  fontSize: 10.rsp,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  height: 1,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
