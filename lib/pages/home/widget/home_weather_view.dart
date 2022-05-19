import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/utils/date/recook_lunar.dart';
import 'package:lunar_calendar_converter/lunar_solar_converter.dart';

import 'home_date_detail_page.dart';
import 'home_weather_detail_page.dart';

class HomeWeatherWidget extends StatefulWidget {
  final HomeWeatherModel homeWeatherModel;
  final Color backgroundColor;

  HomeWeatherWidget({Key key, this.homeWeatherModel, this.backgroundColor})
      : super(key: key);

  @override
  HomeWeatherWidgetState createState() => HomeWeatherWidgetState();
}

class HomeWeatherWidgetState extends State<HomeWeatherWidget>
    with SingleTickerProviderStateMixin {
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    if (widget.backgroundColor != null) {
      _backgroundColor = widget.backgroundColor;
    } else {
      _backgroundColor = AppColor.themeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10 * 2.sp,
    );
    DateTime nowDateTime = DateTime.now();
    Solar solar = Solar(
        solarYear: nowDateTime.year,
        solarDay: nowDateTime.day,
        solarMonth: nowDateTime.month);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);

    return Container(
      color: _backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 40 + ScreenUtil().statusBarHeight,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            padding: EdgeInsets.only(left: 23, right: 16,top: 5.rw),
            child: widget.homeWeatherModel == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.only(bottom: 10.w),
                        child: Row(
                          children: <Widget>[
                            Text(
                              _normalText(widget.homeWeatherModel.tem),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "℃",
                                  style: textStyle,
                                ),
                                Text(
                                  " ",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: (){
                              if (widget.homeWeatherModel != null) {
                                if (widget.homeWeatherModel.aqi != null)
                                  Get.to(HomeWeatherDetailPage(
                                      homeWeatherModel: widget.homeWeatherModel));
                              }
                            },
                            child: Row(
                        children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _normalText(widget.homeWeatherModel.wea),
                                      style: textStyle,
                                    ),
                                    Container(width: 2),
                                    Image.asset(
                                      _getWeatherImage(_normalText(
                                          widget.homeWeatherModel.weaImg)),
                                      height: 10,
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ExtendedText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                "湿度:${_normalText(widget.homeWeatherModel.humidity)} 温度:${_normalText(widget.homeWeatherModel.tem2)}-${_normalText(widget.homeWeatherModel.tem1)}℃",
                                            style: textStyle),
                                        // TextSpan(text:"  温度:${_normalText(widget.homeWeatherModel.tem2)}-${_normalText(widget.homeWeatherModel.tem1)}℃", style: textStyle),
                                        WidgetSpan(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 5, right: 2),
                                            child: Image.asset(
                                              "assets/weatherCake/airquality.png",
                                              height: 11,
                                              width: 11,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text:
                                                "${_normalText(widget.homeWeatherModel.air)}${_normalText(widget.homeWeatherModel.airLevel)}",
                                            style: textStyle),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                Get.to(HomeDateDetailPage());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      "${nowDateTime.year}.${nowDateTime.month}.${nowDateTime.day}${_normalText(widget.homeWeatherModel.week)}",
                                      style: textStyle),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      RecookLunar(lunar).toString(),
                                      style: textStyle,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                          ))
                      //
                      // Expanded(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       Row(
                      //         children: <Widget>[
                      //           Text(
                      //             _normalText(widget.homeWeatherModel.wea),
                      //             style: textStyle,
                      //           ),
                      //           Container(width: 2),
                      //           Image.asset(
                      //             _getWeatherImage(_normalText(
                      //                 widget.homeWeatherModel.weaImg)),
                      //             height: 10,
                      //             width: 10,
                      //           ),
                      //           Spacer(),
                      //           GestureDetector(
                      //             onTap: () {
                      //               Get.to(HomeDateDetailPage());
                      //             },
                      //             child: Text(
                      //                 "${nowDateTime.year}.${nowDateTime.month}.${nowDateTime.day}${_normalText(widget.homeWeatherModel.week)}",
                      //                 style: textStyle),
                      //           )
                      //         ],
                      //       ),
                      //       Flex(
                      //         direction: Axis.horizontal,
                      //         children: <Widget>[
                      //           Expanded(
                      //             child: ExtendedText.rich(
                      //               TextSpan(
                      //                 children: [
                      //                   TextSpan(
                      //                       text:
                      //                           "湿度:${_normalText(widget.homeWeatherModel.humidity)} 温度:${_normalText(widget.homeWeatherModel.tem2)}-${_normalText(widget.homeWeatherModel.tem1)}℃",
                      //                       style: textStyle),
                      //                   // TextSpan(text:"  温度:${_normalText(widget.homeWeatherModel.tem2)}-${_normalText(widget.homeWeatherModel.tem1)}℃", style: textStyle),
                      //                   WidgetSpan(
                      //                     child: Container(
                      //                       margin: EdgeInsets.only(
                      //                           left: 5, right: 2),
                      //                       child: Image.asset(
                      //                         "assets/weatherCake/airquality.png",
                      //                         height: 11,
                      //                         width: 11,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   TextSpan(
                      //                       text:
                      //                           "${_normalText(widget.homeWeatherModel.air)}${_normalText(widget.homeWeatherModel.airLevel)}",
                      //                       style: textStyle),
                      //                 ],
                      //               ),
                      //               maxLines: 1,
                      //               overflow: TextOverflow.clip,
                      //             ),
                      //           ),
                      //           Expanded(
                      //               child: GestureDetector(
                      //                   onTap: () {
                      //                     Get.to(HomeDateDetailPage());
                      //                   },
                      //                   child: Container(
                      //                     alignment: Alignment.centerRight,
                      //                     child: Text(
                      //                       RecookLunar(lunar).toString(),
                      //                       style: textStyle,
                      //                     ),
                      //                   ))),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  _normalText(str) {
    if (TextUtils.isEmpty(str)) {
      return "";
    }
    return str;
  }

  _getWeatherImage(wea_img) {
    return "assets/weatherCake/$wea_img.png";
  }
}
