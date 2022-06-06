import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeWeatherDetailPage extends StatefulWidget {
  final HomeWeatherModel? homeWeatherModel;
  HomeWeatherDetailPage({
    Key? key,
    this.homeWeatherModel,
  }) : super(key: key);

  @override
  _HomeWeatherDetailPageState createState() => _HomeWeatherDetailPageState();
}

class _HomeWeatherDetailPageState extends State<HomeWeatherDetailPage> {
  HomeWeatherModel? _homeWeatherModel;
  @override
  void initState() {
    super.initState();
    _homeWeatherModel = widget.homeWeatherModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.transparent,
        leading: RecookBackButton(
          white: _boolWhite(_homeWeatherModel!.weaImg),
        ),
        elevation: 0,
        title: Text(
          "天气",
          style: TextStyle(
            color: _getBackColor(_homeWeatherModel!.weaImg),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(child: Container(
            height: 379.rw+DeviceInfo.statusBarHeight! + DeviceInfo.appBarHeight,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(_getBackGroud(_homeWeatherModel!.weaImg)),
                    fit: BoxFit.fill)),
          )),
          _bodyWidget(),
        ],



      ),
    );
  }

  _bodyWidget() {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          child: Container(
            width: double.infinity,
            height: 379.rw,

            child: (Column(
              children: [
                140.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _homeWeatherModel!.city!,
                      style: TextStyle(fontSize: 20.rsp, color: Colors.white),
                    ),
                    5.wb,
                    Image.asset(
                      R.ASSETS_WEATHER_WEATHER_LOCATION_PNG,
                      width: 20.rw,
                      height: 19.5.rw,
                    )
                  ],
                ),
                12.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '°C',
                      style: TextStyle(
                          fontSize: 35.rsp, color: Colors.transparent),
                    ),
                    Text(
                      _homeWeatherModel!.tem!,
                      style: TextStyle(fontSize: 90.rsp, color: Colors.white),
                    ),
                    Text(
                      '°C',
                      style: TextStyle(fontSize: 35.rsp, color: Colors.white),
                    ),
                  ],
                ),
                14.hb,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _homeWeatherModel!.tem1!,
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    Text(
                      '°C',
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    Text(
                      '/',
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    Text(
                      _homeWeatherModel!.tem2!,
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    Text(
                      '°C',
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                  ],
                ),
                12.hb,
                Text(
                  _homeWeatherModel!.wea!,
                  style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      '空气',
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    Text(
                      _homeWeatherModel!.airLevel!,
                      style: TextStyle(fontSize: 18.rsp, color: Colors.white),
                    ),
                    20.wb,
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _homeWeatherModel!.alarm!.alarmContent != ''
                          ? () {
                              Alert.show(
                                  context,
                                  NormalTextDialog(
                                    title: '预警',
                                    content:
                                        _homeWeatherModel!.alarm!.alarmContent!,
                                    titleColor: Color(0xFFEE0000),
                                    //deleteItem: '确认',
                                    items: ['确认'],
                                    type: NormalTextDialogType.normal,
                                    listener: (_) => Navigator.pop(context),
                                    // deleteListener: () =>
                                    //     Navigator.pop(context, true),
                                  ));
                            }
                          : () {
                              Alert.show(
                                  context,
                                  NormalTextDialog(
                                    title: '预警',
                                    content: '暂无预警发布',
                                    //deleteItem: '确认',
                                    items: ['确认'],
                                    type: NormalTextDialogType.normal,
                                    listener: (_) => Navigator.pop(context),
                                    // deleteListener: () =>
                                    //     Navigator.pop(context, true),
                                  ));
                            },
                      child: Row(
                        children: [
                          30.wb,
                          Text(
                            '天气预警',
                            style: TextStyle(
                                fontSize: 14.rsp, color: Colors.white),
                          ),
                          Image.asset(
                            R.ASSETS_WEATHER_WEATHER_WANING_PNG,
                            height: 14.rw,
                            width: 16.rw,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '气象台更新时间：',
                      style: TextStyle(fontSize: 14.rsp, color: Colors.white),
                    ),
                    Text(
                      _homeWeatherModel!.updateTime!,
                      style: TextStyle(fontSize: 14.rsp, color: Colors.white),
                    ),
                    20.wb,
                  ],
                ),
                22.hb,
              ],
            )),
          ),
        ),
        Container(
          width: double.infinity,
          color: _getColor(_homeWeatherModel!.weaImg),
          child: Column(
            children: [
              _getDivider(),
              _bottomItem('湿度', '能见度', _homeWeatherModel!.humidity!,
                  _homeWeatherModel!.visibility!),
              _getDivider(),
              _bottomItem1(),
              _getDivider(),
              _bottomItem('PM2.5', 'PM10', _homeWeatherModel!.aqi.pm25Desc,
                  _homeWeatherModel!.aqi.pm10Desc),
              _getDivider(),
              _bottomItem('O3', 'NO2', _homeWeatherModel!.aqi.o3Desc,
                  _homeWeatherModel!.aqi.no2Desc),
              _getDivider(),
              _bottomItem('SO2', '是否需要佩戴口罩', _homeWeatherModel!.aqi.so2Desc,
                  _homeWeatherModel!.aqi.kouzhao),
              _getDivider(),
              _bottomItem('风向', '风速', _homeWeatherModel!.win!,
                  _homeWeatherModel!.winSpeed!),
              _getDivider(),
              _bottomItem('外出适宜', '开窗适宜', _homeWeatherModel!.aqi.waichu,
                  _homeWeatherModel!.aqi.kaichuang),
            ],
          ),
        )
      ],
    );
  }

  _getDivider() {
    return Divider(
      height: 1.rw,
      color: Colors.white,
      indent: 10.rw,
      endIndent: 10.rw,
    );
  }

  _bottomItem1() {
    return Container(
        height: 78.rw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            30.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70.rw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '空气质量',
                        style: TextStyle(color: Colors.white, fontSize: 16.rsp),
                      ),
                      Text(
                        _homeWeatherModel!.airLevel!,
                        style: TextStyle(color: Colors.white, fontSize: 24.rsp),
                      )
                    ],
                  ),
                )
              ],
            ),
            64.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _homeWeatherModel!.airTips!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 12.rsp),
                ),
              ],
            ).expand()
          ],
        ));
  }

  _bottomItem(String title1, String title2, String content1, String content2) {
    return Container(
        height: 78.rw,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            30.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title1,
                  style: TextStyle(color: Colors.white, fontSize: 16.rsp),
                ),
                Text(
                  content1,
                  style: TextStyle(color: Colors.white, fontSize: 24.rsp),
                )
              ],
            ).expand(),
            80.wb,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title2,
                  style: TextStyle(color: Colors.white, fontSize: 16.rsp),
                ),
                Text(
                  content2,
                  style: TextStyle(color: Colors.white, fontSize: 24.rsp),
                )
              ],
            ).expand()
          ],
        ));
  }

  _getBackGroud(String? weather) {
    switch (weather) {
      case 'xue':
        return R.ASSETS_WEATHER_XUN_BG_JPG;
      case 'lei':
        return R.ASSETS_WEATHER_LEI_BG_JPG;
      case 'shachen':
        return R.ASSETS_WEATHER_SHACHEN_BG_JPG;
      case 'wu':
        return R.ASSETS_WEATHER_WU_BG_JPG;
      case 'bingbao':
        return R.ASSETS_WEATHER_BINGBAO_BG_JPG;
      case 'yun':
        return R.ASSETS_WEATHER_YUN_BG_JPG;
      case 'yu':
        return R.ASSETS_WEATHER_YU_BG_JPG;
      case 'yin':
        return R.ASSETS_WEATHER_YIN_BG_JPG;
      case 'qing':
        return R.ASSETS_WEATHER_QING_BG_JPG;
    }
  }

  _getColor(String? weather) {
    switch (weather) {
      case 'xue':
        return Color(0xFF27080E);
      case 'lei':
        return Color(0xFF112027);
      case 'shachen':
        return Color(0xFFDC721C);
      case 'wu':
        return Color(0xFF013358);
      case 'bingbao':
        return Color(0xFF141D24);
      case 'yun':
        return Color(0xFF599BE9);
      case 'yu':
        return Color(0xFF414954);
      case 'yin':
        return Color(0xFF373F4A);
      case 'qing':
        return Color(0xFF64A8F1);
    }
  }

  _getBackColor(String? weather) {
    switch (weather) {
      case 'xue':
        return Color(0xFF333333);
      case 'lei':
        return Colors.white;
      case 'shachen':
        return Colors.white;
      case 'wu':
        return Colors.white;
      case 'bingbao':
        return Colors.white;
      case 'yun':
        return Color(0xFF333333);
      case 'yu':
        return Colors.white;
      case 'yin':
        return Colors.white;
      case 'qing':
        return Color(0xFF333333);
    }
  }

  _boolWhite(String? weather) {
    switch (weather) {
      case 'xue':
        return false;
      case 'lei':
        return true;
      case 'shachen':
        return true;
      case 'wu':
        return true;
      case 'bingbao':
        return true;
      case 'yun':
        return false;
      case 'yu':
        return true;
      case 'yin':
        return true;
      case 'qing':
        return false;
    }
  }
}
