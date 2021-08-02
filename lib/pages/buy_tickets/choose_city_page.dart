import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/buy_tickets/tools/airport_city_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:recook/widgets/weather_page/weather_city_tool.dart';

import 'functions/passager_func.dart';

class ChooseCityPage extends StatefulWidget {
  final Map arguments;
  final int type;
  ChooseCityPage({Key key, this.arguments, this.type}) : super(key: key);
  static setArguments(
    String cityName,
  ) {
    return {
      "cityName": cityName,
    };
  }

  @override
  _ChooseCityPageState createState() => _ChooseCityPageState();
}

class _ChooseCityPageState extends BaseStoreState<ChooseCityPage> {
  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "A";
  List<WeatherCityModel> _cityList = [];
  List<AirportCityModel> _cityModelList = [];
  String _selectCity = "";
  List<AirportCityModel> _searchResultCityList = [];
  TextEditingController _textEditingController;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode.addListener(() {
      setState(() {});
    });
    String cityName = widget.arguments['cityName'];
    if (!TextUtils.isEmpty(cityName)) _selectCity = cityName;
    Function cancel = ReToast.loading();
    WeatherCityTool.getInstance().getCityList().then((onValue) {
      _cityList = onValue;
      setState(() {});
    });
    if (widget.type == 1) {
      Future.delayed(Duration.zero, () async {
        _cityModelList =
            await AriportCityTool.getInstance().getCityAirportList();
        setState(() {});
        print(_cityModelList);
        cancel();
      });
    }

    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        title: "选择城市",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        // color: AppColor.frenchColor,
        child: Column(
          children: <Widget>[
            _searchBar(),
            _focusNode.hasFocus ||
                    !TextUtils.isEmpty(_textEditingController.text)
                ? Expanded(child: _resultWidget())
                : Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (TextUtils.isEmpty(_selectCity)) return;

                            AirportCityModel model = AirportCityModel();
                            model.city = _selectCity;
                            Get.back(result: model);
                            //Navigator.pop(context, model);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 15.0),
                            color: Colors.white,
                            height: 50.0,
                            width: double.infinity,
                            child: Text(
                              "当前定位城市: $_selectCity",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AzListView(
                            shrinkWrap: false,
                            data: widget.type == 1 ? _cityModelList : _cityList,
                            topData: null,
                            itemBuilder: widget.type == 1
                                ? (context, model) => _buildListItem1(model)
                                : (context, model) => _buildListItem(model),
                            suspensionWidget: _buildSusWidget(_suspensionTag),
                            isUseRealIndex: true,
                            itemHeight: _itemHeight,
                            suspensionHeight: _suspensionHeight,
                            onSusTagChanged: (tag) {
                              setState(() {
                                _suspensionTag = tag;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem1(AirportCityModel model) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !(model.isShowSuspension == true),
          child: _buildSusWidget(model.getSuspensionTag()),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Get.back(result: model);
                  // Navigator.pop(context, model);
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  height: _itemHeight.toDouble() - 1,
                  child: Text(
                    model.city,
                    style: TextStyle(color: Colors.black, fontSize: 15 * 2.sp),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                ),
                color: AppColor.frenchColor,
                height: 1,
              )
            ],
          ),
        ),
      ],
    );
  }

  ///构建列表 item Widget.
  Widget _buildListItem(WeatherCityModel model) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !(model.isShowSuspension == true),
          child: _buildSusWidget(model.getSuspensionTag()),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Get.back(result: model);
                  //Navigator.pop(context, model);
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  height: _itemHeight.toDouble() - 1,
                  child: Text(
                    model.cityZh,
                    style: TextStyle(color: Colors.black, fontSize: 15 * 2.sp),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 15,
                ),
                color: AppColor.frenchColor,
                height: 1,
              )
            ],
          ),
        ),
      ],
    );
  }

  ///构建悬停Widget.
  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  _searchBar() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xfff3f4f5), borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Image.asset(
                "assets/search.png",
                width: 22,
                height: 22,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
                controller: _textEditingController,
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                placeholder: "请输入搜索词...",
                placeholderStyle: TextStyle(
                    color: Color(0xff999999),
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                onSubmitted: (text) {
                  AriportCityTool.getInstance().searchWithQuery(text, (list) {
                    _searchResultCityList = list;
                    setState(() {});
                  });
                },
                onChanged: (text) {
                  AriportCityTool.getInstance().searchWithQuery(text, (list) {
                    _searchResultCityList = list;
                    setState(() {});
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _resultWidget() {
    return Container(
      child: _searchResultCityList.length <= 0
          ? GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: noDataView("没有数据..."),
            )
          : ListView.builder(
              itemCount: _searchResultCityList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem1(_searchResultCityList[index]);
              },
            ),
    );
  }
}
