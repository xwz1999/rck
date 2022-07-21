
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'picker_box.dart';

class CarMonthPickBody extends StatefulWidget {
  final DateTime initTime;

  const CarMonthPickBody({Key? key, required this.initTime});

  @override
  _CarMonthPickBodyState createState() => _CarMonthPickBodyState();
}

class _CarMonthPickBodyState extends State<CarMonthPickBody> {
  final FixedExtentScrollController _yearController =
      FixedExtentScrollController();
  final FixedExtentScrollController _monthController =
      FixedExtentScrollController();

  DateTime get _pickedTime => DateTime(_pickYear, _pickMonth);

  List<int> get _years => List.generate(
      DateTime.now().year - 1970 + 1, (index) => widget.initTime.year - index);
  int _pickYearIndex = 0;
  int _pickMonthIndex = 0;

  int get _pickYear => _years[_pickYearIndex];

  int get _pickMonth => _months[_pickMonthIndex];

  List<int> get _months => List.generate(
      _pickYear == DateTime.now().year ? DateTime.now().month : 12,
      (index) => index + 1);

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF027AFF);
      case 1:
        return const Color(0xFF999999);
      case 2:
        return const Color(0xFFCCCCCC);
      case 3:
        return const Color(0xFFDDDDDD);
      default:
        return const Color(0xFFDDDDDD);
    }
  }

  @override
  void initState() {
    _pickYearIndex = 0;
    _pickMonthIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickerBox(
      onPressed: () {
        Navigator.pop(context, _pickedTime);
      },
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
                itemExtent: 80.w,
                magnification: 1.0,
                looping: false,
                scrollController: _yearController,
                onSelectedItemChanged: (index) {
                  _pickYearIndex = index;
                  setState(() {});
                },
                selectionOverlay: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                      color: const Color(0xFF027AFF).withOpacity(0.05),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(8.w))),
                ),
                children: _years
                    .mapIndexed((e, index) => Center(
                          child: Text(
                            '$e年',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    _getColor((index - _pickYearIndex).abs())),
                          ),
                        ))
                    .toList()),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 80.w,
              magnification: 1.0,
              // offAxisFraction: 0.6,
              looping: true,
              selectionOverlay: Container(
                margin: EdgeInsets.only(right: 20.w),
                decoration: BoxDecoration(
                    color: const Color(0xFF027AFF).withOpacity(0.05),
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(8.w))),
              ),
              scrollController: _monthController,
              onSelectedItemChanged: (index) {
                _pickMonthIndex = index;
                setState(() {});
              },
              children: _months.isEmpty
                  ? [Container()]
                  : _months
                      .mapIndexed((e, index) => Center(
                            child: Text(
                              '$e月',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: _getColor(
                                      (index - _pickMonthIndex).abs())),
                            ),
                          ))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
