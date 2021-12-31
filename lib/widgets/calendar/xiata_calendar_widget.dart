import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jingyaoyun/utils/date/date_models.dart';
import 'package:jingyaoyun/utils/date/date_utils.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/utils/date/recook_date_util.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class XiataCalendarWidget extends StatefulWidget {
  final DateTime minDate;
  final DateTime maxDate;
  final MonthBuilder monthBuilder;
  final DayBuilder dayBuilder;
  final DateTime initialMinDate;
  //final DateTime initialMaxDate;
  final ValueChanged<DateTime> onDayPressed;
  final PeriodChanged onRangeSelected;
  final EdgeInsetsGeometry listPadding;

  XiataCalendarWidget(
      {@required this.minDate,
      @required this.maxDate,
      this.monthBuilder,
      this.dayBuilder,
      this.onDayPressed,
      this.onRangeSelected,
      this.initialMinDate,
      //this.initialMaxDate,
      this.listPadding})
      : assert(minDate != null);
  //assert(maxDate != null),
  //assert(minDate.isBefore(maxDate));

  @override
  _XiataCalendarWidgetState createState() => _XiataCalendarWidgetState();
}

class _XiataCalendarWidgetState extends State<XiataCalendarWidget> {
  DateTime _minDate;
  DateTime _maxDate;
  List<Month> _months;
  DateTime rangeMinDate;
  //DateTime rangeMaxDate;
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  @override
  void initState() {
    super.initState();
    _months = DateUtilss.extractWeeks(widget.minDate, widget.maxDate);
    _minDate = widget.minDate.removeTime();
    _maxDate = widget.maxDate.removeTime();
    rangeMinDate = widget.initialMinDate;
    //rangeMaxDate = widget.initialMaxDate;
    DateTime checkInDate = DateTime.now();

    Future.delayed(Duration(milliseconds: 500), () {
      int index = RecookDateUtil.monthBetween(DateTime.now(), checkInDate);
      _itemScrollController.scrollTo(
        index: index,
        alignment: checkInDate.day > 15 ? -0.3 : 0.3,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(XiataCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.minDate != widget.minDate
        // ||oldWidget.maxDate != widget.maxDate
        ) {
      _months = DateUtilss.extractWeeks(widget.minDate, widget.maxDate);
      _minDate = widget.minDate.removeTime();
      _maxDate = widget.maxDate.removeTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollablePositionedList.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemScrollController: _itemScrollController,
              padding: widget.listPadding ?? EdgeInsets.zero,
              itemCount: _months.length,
              itemBuilder: (BuildContext context, int position) {
                return _MonthView(
                  month: _months[position],
                  minDate: _minDate,
                  maxDate: _maxDate,
                  monthBuilder: widget.monthBuilder,
                  dayBuilder: widget.dayBuilder,
                  onDayPressed: widget.onRangeSelected != null
                      ? (DateTime date) {
                          if (rangeMinDate == null) {
                            setState(() {

                              rangeMinDate = date;
                              //rangeMaxDate = null;
                            });
                          } else {
                            setState(() {

                              //rangeMaxDate = date;
                              rangeMinDate = date;
                            });
                          }

                          //弹窗自动隐藏判断
                          widget.onRangeSelected(rangeMinDate);

                          if (widget.onDayPressed != null) {
                            widget.onDayPressed(date);
                          }
                        }
                      : widget.onDayPressed,
                  rangeMinDate: rangeMinDate,
                  //rangeMaxDate: rangeMaxDate
                );
              }),
        ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  final Month month;
  final DateTime minDate;
  final DateTime maxDate;
  final MonthBuilder monthBuilder;
  final DayBuilder dayBuilder;
  final ValueChanged<DateTime> onDayPressed;
  final DateTime rangeMinDate;
  //final DateTime rangeMaxDate;

  _MonthView(
      {@required this.month,
      @required this.minDate,
      @required this.maxDate,
      this.monthBuilder,
      this.dayBuilder,
      this.onDayPressed,
      this.rangeMinDate,
      //this.rangeMaxDate,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        monthBuilder != null
            ? monthBuilder(context, month.month, month.year)
            : _DefaultMonthView(month: month.month, year: month.year),
        Table(
          children: month.weeks
              .map((Week week) => _generateFor(context, week))
              .toList(growable: false),
        ),
      ],
    );
  }

  TableRow _generateFor(BuildContext context, Week week) {
    DateTime firstDay = week.firstDay;
    bool rangeFeatureEnabled = rangeMinDate != null;

    return TableRow(
        children: List<Widget>.generate(DateTime.daysPerWeek, (int position) {
      DateTime day = DateTime(week.firstDay.year, week.firstDay.month,
          firstDay.day + (position - (firstDay.weekday - 1)));

      if ((position + 1) < week.firstDay.weekday ||
          (position + 1) > week.lastDay.weekday ||
          day.isBefore(minDate) ||
          day.isAfter(maxDate)) {
        return const SizedBox();
      } else {
        bool isSelected = false;

        if (rangeFeatureEnabled) {
          if (rangeMinDate != null) {
            isSelected = day.isSameDay(rangeMinDate);
          } else {
            isSelected = day.isAtSameMomentAs(rangeMinDate);
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 4.rw,
          ),
          child: AspectRatio(
              aspectRatio: 46 / 64,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onDayPressed != null
                    ? () {
                        if (onDayPressed != null) {
                          DateTime nowDay = DateTime.now();
                          DateTime todayStart = DateTime(
                            nowDay.year,
                            nowDay.month,
                            nowDay.day,
                            0,
                          );
                          if (day.millisecondsSinceEpoch >=
                              todayStart.millisecondsSinceEpoch)
                            onDayPressed(day);
                        }
                      }
                    : null,
                child: dayBuilder != null
                    ? dayBuilder(context, day, isSelected: isSelected)
                    : _DefaultDayView(date: day, isSelected: isSelected),
              )),
        );
      }
    }, growable: false));
  }
}

class _DefaultMonthView extends StatelessWidget {
  final int month;
  final int year;

  _DefaultMonthView({@required this.month, @required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        DateFormat('MMMM yyyy').format(DateTime(year, month)),
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

class _DefaultDayView extends StatelessWidget {
  final DateTime date;
  final bool isSelected;

  _DefaultDayView({@required this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          color: isSelected == true ? Colors.red : Colors.green,
          shape: BoxShape.circle),
      child: Center(
        child: Text(
          DateFormat('d').format(date),
        ),
      ),
    );
  }
}

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);
typedef DayBuilder = Widget Function(BuildContext context, DateTime date,
    {bool isSelected});
typedef PeriodChanged = void Function(DateTime minDate);
