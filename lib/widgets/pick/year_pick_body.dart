
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/header.dart';
import 'package:velocity_x/velocity_x.dart';

import 'picker_box.dart';

class YearPickBody extends StatefulWidget {
  final DateTime initTime;

  const YearPickBody({Key? key, required this.initTime});

  @override
  _YearPickBodyState createState() => _YearPickBodyState();
}

class _YearPickBodyState extends State<YearPickBody> {
  final FixedExtentScrollController _yearController =
      FixedExtentScrollController();

  DateTime get _pickedTime => DateTime(_pickYear,);

  List<int> get _years => List.generate(
      DateTime.now().year - 1970 + 1, (index) => widget.initTime.year - index);
  int _pickYearIndex = 0;

  int get _pickYear => _years[_pickYearIndex];


  Color _getColor(int index) {
    switch (index) {
      case 0:
        return  const Color(0xFF111111);
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
    super.initState();
  }

  @override
  void dispose() {
    _yearController.dispose();
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
                  decoration: BoxDecoration(
                      color:  Color(0xFFdedee0).withOpacity(0.2),),
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

        ],
      ),
    );
  }
}
