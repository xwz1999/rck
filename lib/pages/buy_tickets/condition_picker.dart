import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

import 'as_date_range_picker_part.dart';
import 'models/airport_city_model.dart';

class AS2DatePicker extends StatefulWidget {
  final List<String> fromNameList;
  final List<String> endNameList;

  AS2DatePicker({
    this.fromNameList,
    this.endNameList,
    Key key,
  }) : super(key: key);

  @override
  _AS2DatePickerState createState() => _AS2DatePickerState();
}

class _AS2DatePickerState extends State<AS2DatePicker> {
  int _selected = 0;

  List<Item> _chooseDate;
  List<Item> _chooseDepart;
  List<Item> _chooseArrive;
  List<Item> _chooseCompany;
  List<Item> _chooseSpace;
  Options options;
  DateTime get now => DateTime.now();
  PageController _pageController;
  DateTimeRange get singleHour => DateTimeRange(
        start: now,
        end: now.add(Duration(hours: 1)),
      );
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initData();
  }

  initData() {
    options = Options(depart: '', arrive: '', date: '', company: '', space: '');
    _chooseDate = [];
    _chooseDepart = [];
    _chooseArrive = [];
    _chooseCompany = [];
    _chooseSpace = [];
    _chooseDate.add(Item(item: '不限', choice: true));
    _chooseDate.add(Item(item: '00:00-06:00', choice: false));
    _chooseDate.add(Item(item: '06:00-12:00', choice: false));
    _chooseDate.add(Item(item: '12:00-18:00', choice: false));
    _chooseDate.add(Item(item: '18:00-24:00', choice: false));

    if (widget.fromNameList != null) {
      for (int i = 0; i < widget.fromNameList.length; i++) {
        _chooseDepart.add(Item(item: widget.fromNameList[i], choice: false));
      }
      _chooseDepart.insert(0, Item(item: '不限', choice: true));
    }

    if (widget.endNameList != null) {
      for (int i = 0; i < widget.endNameList.length; i++) {
        _chooseArrive.add(Item(item: widget.endNameList[i], choice: false));
      }
      _chooseArrive.insert(0, Item(item: '不限', choice: true));
    }

    _chooseCompany.add(Item(item: '不限', choice: true));
    _chooseCompany.add(Item(item: '中国国航', choice: false, code: 'CA'));
    _chooseCompany.add(Item(item: '海南航空', choice: false, code: 'HU'));
    _chooseCompany.add(Item(item: '东方航空', choice: false, code: 'MU'));
    _chooseCompany.add(Item(item: '南方航空', choice: false, code: 'CZ'));
    _chooseCompany.add(Item(item: '深圳航空', choice: false, code: 'ZH'));
    _chooseCompany.add(Item(item: '上海航空', choice: false, code: 'FM'));
    _chooseCompany.add(Item(item: '厦门航空', choice: false, code: 'MF'));
    _chooseCompany.add(Item(item: '河北航空', choice: false, code: 'NS'));
    _chooseCompany.add(Item(item: '联合航空', choice: false, code: 'KN'));
    _chooseCompany.add(Item(item: '长龙航空', choice: false, code: 'GJ'));
    _chooseCompany.add(Item(item: '首都航空', choice: false, code: 'JD'));

    _chooseSpace.add(Item(item: '不限', choice: true));
    _chooseSpace.add(Item(item: '经济仓', choice: false));
    _chooseSpace.add(Item(item: '商务舱/头等舱', choice: false));
  }

  //左边选择标题框
  Widget _buildDayButton(int index, String title) {
    bool sameDay = _selected == index;
    return MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      color: sameDay ? Colors.white : Color(0xFFF6F6F6),
      onPressed: () {
        _pageController?.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        );
        setState(() => _selected = index);
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      height: 40.rw,
      child: title.text.black.size(14.rsp).make(),
    );
  }

  Widget get _renderCheckBox => Container(
        height: 14.rw,
        width: 14.rw,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Icon(
          Icons.check,
          size: 12.rw,
          color: Colors.white,
        ),
      );

  Widget get _renderNoCheckBox => Container(
        height: 14.rw,
        width: 14.rw,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            border: Border.all(color: Color(0xFFC9C9C9), width: 1.rw)),
        child: Icon(
          Icons.check,
          size: 12.rw,
          color: Colors.white,
        ),
      );
  Widget _renderButton(String title, VoidCallback onPressed, bool selected) {
    return MaterialButton(
      onPressed: onPressed,
      height: 40.rw,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(23))),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        children: [
          50.wb,
          AnimatedDefaultTextStyle(
            child: title.text.make(),
            style: TextStyle(
                color: selected ? Colors.red : Colors.black, fontSize: 14.rsp),
            duration: Duration(milliseconds: 300),
          ),
          Spacer(),
          selected ? _renderCheckBox : _renderNoCheckBox,
          //20.wb,
        ],
      ),
    );
  }

  Widget _buildDateList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _renderButton(_chooseDate[index].item, () {
            setState(() => {
                  options.date = '',
                  for (var i = 0; i < _chooseDate.length; i++)
                    {_chooseDate[i].choice = false},
                  _chooseDate[index].choice = true,
                });
          }, _chooseDate[index].choice);
        }
        return _renderButton(_chooseDate[index].item, () {
          setState(() => {
                options.date = _chooseDate[index].item,
                for (var i = 0; i < _chooseDate.length; i++)
                  {_chooseDate[i].choice = false},
                _chooseDate[index].choice = true,
              });
        }, _chooseDate[index].choice);
      },
      itemCount: _chooseDate.length,
    );
  }

  Widget _buildDepartList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _renderButton(_chooseDepart[index].item, () {
            setState(() => {
                  options.depart = '',
                  for (var i = 0; i < _chooseDepart.length; i++)
                    {_chooseDepart[i].choice = false},
                  _chooseDepart[index].choice = true,
                });
          }, _chooseDepart[index].choice);
        }
        return _renderButton(_chooseDepart[index].item, () {
          setState(() => {
                options.depart = _chooseDepart[index].item,
                for (var i = 0; i < _chooseDepart.length; i++)
                  {_chooseDepart[i].choice = false},
                _chooseDepart[index].choice = true,
              });
        }, _chooseDepart[index].choice);
      },
      itemCount: _chooseDepart.length,
    );
  }

  Widget _buildArriveList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _renderButton(_chooseArrive[index].item, () {
            setState(() => {
                  options.arrive = '',
                  for (var i = 0; i < _chooseArrive.length; i++)
                    {_chooseArrive[i].choice = false},
                  _chooseArrive[index].choice = true,
                });
          }, _chooseArrive[index].choice);
        }
        return _renderButton(_chooseArrive[index].item, () {
          setState(() => {
                options.arrive = _chooseArrive[index].item,
                for (var i = 0; i < _chooseArrive.length; i++)
                  {_chooseArrive[i].choice = false},
                _chooseArrive[index].choice = true,
              });
        }, _chooseArrive[index].choice);
      },
      itemCount: _chooseArrive.length,
    );
  }

  Widget _buildCompanyList() {
    return ListView.builder(
      //padding: EdgeInsets.all(8.rw),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _renderButton(_chooseCompany[index].item, () {
            setState(() => {
                  options.company = '',
                  for (var i = 0; i < _chooseCompany.length; i++)
                    {_chooseCompany[i].choice = false},
                  _chooseCompany[index].choice = true,
                });
          }, _chooseCompany[index].choice);
        }
        return _renderButton(_chooseCompany[index].item, () {
          setState(() => {
                options.company = _chooseCompany[index].code,
                for (var i = 0; i < _chooseCompany.length; i++)
                  {_chooseCompany[i].choice = false},
                _chooseCompany[index].choice = true,
              });
        }, _chooseCompany[index].choice);
      },
      itemCount: _chooseCompany.length,
    );
  }

  Widget _buildSpaceList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _renderButton(_chooseSpace[index].item, () {
            setState(() => {
                  options.space = '',
                  for (var i = 0; i < _chooseSpace.length; i++)
                    {_chooseSpace[i].choice = false},
                  _chooseSpace[index].choice = true,
                });
          }, _chooseSpace[index].choice);
        }
        return _renderButton(_chooseSpace[index].item, () {
          setState(() => {
                options.space = _chooseSpace[index].item,
                for (var i = 0; i < _chooseSpace.length; i++)
                  {_chooseSpace[i].choice = false},
                _chooseSpace[index].choice = true,
              });
        }, _chooseSpace[index].choice);
      },
      itemCount: _chooseSpace.length,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330.rw,
      child: Material(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.rw)),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20.rw),
                  child: Text(
                    '筛选',
                    style: TextStyle(
                        color: AppColor.textMainColor,
                        fontSize: 18.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Color(0xFF999999),
                    size: 20.rw,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 95.rw,
                  child: Material(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        _buildDayButton(0, '出发机场'),
                        _buildDayButton(1, '到达机场'),
                        _buildDayButton(2, '起飞时间'),
                        _buildDayButton(3, '航空公司'),
                        _buildDayButton(4, '舱位'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    children: [
                      _buildDepartList(),
                      _buildArriveList(),
                      _buildDateList(),
                      _buildCompanyList(),
                      _buildSpaceList(),
                    ],
                    controller: _pageController,
                  ),
                ),
              ],
            ).expand(),
            Container(
                padding:
                    EdgeInsets.only(left: 13.rw, bottom: 20.rw, right: 13.rw),
                width: double.infinity,
                child: Row(
                  children: [
                    CustomImageButton(
                      height: 40.rw,
                      width: 114.rw,
                      padding: EdgeInsets.symmetric(vertical: 6.rw),
                      title: "重置",
                      border:
                          Border.all(color: AppColor.textSubColor, width: 1.rw),
                      backgroundColor: AppColor.whiteColor,
                      color: AppColor.textSubColor,
                      fontSize: 16.rsp,
                      borderRadius: BorderRadius.all(Radius.circular(4.rw)),
                      onPressed: () {
                        initData();
                        setState(() {});
                      },
                    ),
                    20.wb,
                    CustomImageButton(
                      height: 40.rw,
                      width: 224.rw,
                      padding: EdgeInsets.symmetric(vertical: 6.rw),
                      title: "确定",
                      backgroundColor: AppColor.themeColor,
                      color: Colors.white,
                      fontSize: 16.rsp,
                      borderRadius: BorderRadius.all(Radius.circular(4.rw)),
                      onPressed: () {
                        Get.back(result: options);
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class Item {
  String item;
  bool choice;
  String code;
  Item({
    this.item,
    this.choice,
    this.code,
  });
}

class Options {
  String depart;
  String arrive;
  String date;
  String company;
  String space;
  Options({
    this.depart,
    this.arrive,
    this.date,
    this.company,
    this.space,
  });
}
