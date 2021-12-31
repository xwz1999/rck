/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-17  09:41 
 * remark    : 
 * ====================================================
 */
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/models/province_city_model.dart';
import 'package:jingyaoyun/utils/text_utils.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'custom_bottom_sheet.dart';

typedef AddressSelectorCallback = Function(
    String province, String city, String disctrict);

class AddressSelector extends StatefulWidget {
  final ProvinceCityModel model;
  final String province;
  final String city;
  final String district;
  final AddressSelectorCallback callback;

  const AddressSelector(
      {@required this.model,
      this.province = "",
      this.city = "",
      this.district = "",
      this.callback})
      : assert(model != null),
        assert(callback != null);

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  List<List<String>> _items;
  List<String> _result;
  List<int> _indexs;
  Province _province;
  City _city;
  District _district;
  Color _selectedColor = AppColor.themeColor;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _items = [[], [], []];
    _indexs = [null, null, null];
    _result = [widget.province, widget.city, widget.district];
    _filterAddress();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
      onTap: () {},
      child: _buildBody(),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Container _buildBody() {
    return Container(
      height: (DeviceInfo.screenHeight * 0.75).rw,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[_header(), _tabBar(), _list()],
      ),
    );
  }

  Container _header() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Text(
            "配送至",
            style: TextStyle(
                fontSize: 18 * 2.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          Spacer(),
          CustomImageButton(
            padding: EdgeInsets.all(5),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            icon: Icon(
              AppIcons.icon_delete,
              color: Colors.grey[500],
              size: 12,
            ),
            backgroundColor: Colors.grey[200],
            onPressed: () {
              _dismiss();
            },
          )
        ],
      ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.zero,
        unselectedLabelColor: Colors.black,
        isScrollable: true,
        indicatorColor: _selectedColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(left: 5.rw, right: 5.rw),
        tabs: _tabItems());
  }

  _tabItems() {
    List<Widget> list = [];
    // for (int i = 0; i < _items.length; ++i) {
    for (int i = 0; i < _tabController.length; ++i) {
      List addressModels = _items[i];
      if (addressModels == null || addressModels.length == 0) {
        list.add(Container());
        continue;
      }
      list.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5.rw),
        height: 30.rw,
        alignment: Alignment.center,
        child: Text(
          TextUtils.isEmpty(_result[i]) ? "请选择" : _result[i],
          style: TextStyle(
              fontSize: 16 * 2.sp,
              color: _tabController.index == i ? _selectedColor : Colors.black),
        ),
      ));
    }

    return list;
  }

  Expanded _list() {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _items[_tabController.index].length,
          itemBuilder: (context, index) {
            String addr = _items[_tabController.index][index];
            bool selected = addr == _result[_tabController.index];
            return CustomImageButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Text(
                    addr,
                    style: TextStyle(
                        fontSize: 15 * 2.sp,
                        color: selected ? _selectedColor : Colors.black),
                  ),
                  Spacer(),
                  Offstage(
                      offstage: !selected,
                      child: Icon(
                        Icons.check,
                        size: 16 * 2.sp,
                      ))
                ]),
              ),
              onPressed: () {
                _itemSelected(index);
              },
            );
          }),
    );
  }

  void _filterAddress() {
    int index = 1;
    for (int i = 0; i < widget.model.data.length; ++i) {
      Province province = widget.model.data[i];
      String proAddressStr = province.name;
      _items[0].add(proAddressStr);
      if (proAddressStr != widget.province) {
        continue;
      }
      _indexs[0] = i;
      // index++;
      _province = province;

      for (int m = 0; m < province.cities.length; ++m) {
        City city = province.cities[m];
        String cityAddressStr = city.name;
        _items[1].add(cityAddressStr);
        if (cityAddressStr != widget.city) {
          continue;
        }
        _city = city;
        _indexs[1] = m;
        index++;

        for (int n = 0; n < city.districts.length; ++n) {
          District district = city.districts[n];
          String disAddressStr = district.name;
          _items[2].add(disAddressStr);
          if (disAddressStr != widget.district) {
            continue;
          }
          _indexs[2] = n;
          index++;
          _district = district;
        }
      }
    }
    _resetTabBar(index);
  }

  void _resetTabBar(int index) {
    _tabController?.removeListener(_tabBarListener);
    _tabController = TabController(length: index, vsync: this);
    _tabController.addListener(_tabBarListener);
    _tabController.index = index - 1;
  }

  _itemSelected(int index) {
    switch (_tabController.index) {
      case 0:
        {
          /// 选城市
          Province province = widget.model.data[index];
          _items[1].clear();
          _items[2].clear();
          _province = province;
          _result[0] = _province.name;
          _result[1] = "";
          _result[2] = "";
          _indexs[0] = index;
          _indexs[1] = null;
          _indexs[2] = null;
          _city = null;

          /// 没有次级列表返回
          if (_province.cities.length == 0) {
            _dismiss();
            widget.callback(_province.name, null, null);
            return;
          }

          province.cities.forEach((City city) {
            _items[1].add(city.name);
          });
          _resetTabBar(2);
          _scrollController.jumpTo(0);
          setState(() {});
        }
        break;
      case 1:
        {
          /// 选城市
          City city = _province.cities[index];
          _city = city;
          _district = null;
          _items[2].clear();
          _result[1] = _city.name;
          _indexs[1] = index;
          _result[2] = "";
          _indexs[2] = null;

          /// 没有次级列表返回
          if (city.districts.length == 0) {
            _dismiss();
            widget.callback(_province.name, _city.name, null);
            return;
          }

          city.districts.forEach((District district) {
            _items[2].add(district.name);
          });
          _resetTabBar(3);
          setState(() {});
          _scrollController.jumpTo(0);
        }
        break;
      case 2:
        {
          /// 选区
          District district = _city.districts[index];
          _district = district;
          _result[2] = _district.name;
          _indexs[2] = index;
          _dismiss();
          widget.callback(_province.name, _city.name, _district.name);
        }
    }
  }

  _tabBarListener() {
    if (_scrollController.hasClients) {
      _scrollController?.jumpTo(0);
      setState(() {});
    }
  }

  _dismiss() {
    Navigator.maybePop(_context);
  }
}

class AddressSelectorHelper {
  static show(BuildContext context,
      {@required ProvinceCityModel model,
      String province,
      String city,
      String district,
      AddressSelectorCallback callback}) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return AddressSelector(
            model: model,
            province: province,
            city: city,
            district: district,
            callback: callback,
          );
        });
  }
}
