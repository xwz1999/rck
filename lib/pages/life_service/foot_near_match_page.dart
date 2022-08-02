import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/models/life_service/nba_model.dart';
import 'package:recook/pages/life_service/hw_calculator_result_page.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class FootNearMatchPage extends StatefulWidget {
  final GSRefreshController refreshController;
  final String type;
  FootNearMatchPage({
    Key? key, required this.refreshController, required this.type,
  }) : super(key: key);

  @override
  _FootNearMatchPageState createState() => _FootNearMatchPageState();
}

class _FootNearMatchPageState extends State<FootNearMatchPage>
    with SingleTickerProviderStateMixin {


  NbaModel? nbaModel;
  bool _onLoad = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  _bodyWidget() {
    return RefreshWidget(
      enableOverScroll: false,
      controller: widget.refreshController,
      color: AppColor.themeColor,
      onRefresh: () async {
        nbaModel = await LifeFunc.getFootModel(widget.type)??null;
        widget.refreshController.refreshCompleted();
        _onLoad = false;
        setState(() {});
      },
      body:_onLoad?SizedBox(): nbaModel==null
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      ): nbaModel!.matchs==null
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: nbaModel!.matchs!.length,
        padding: EdgeInsets.only(
          top: 5.rw,
        ),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(nbaModel!.matchs![nbaModel!.matchs!.length-index-1]),
      ),
    );
  }

  _itemWidget(Matchs matchs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.rw, top: 10.rw, bottom: 10.rw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                matchs.date ?? ' ',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
              ),
              16.wb,
              Text(
                matchs.week ?? '',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              ...matchs.list!
                  .map((e) => Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 14.rw, bottom: 14.rw),
                              child: Text(
                                e.team1 ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 12.rsp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                20.hb,
                                Text(
                                  e.timeStart ?? '',
                                  style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 14.rsp,
                                      fontWeight: FontWeight.bold),
                                ),
                                10.hb,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e.team1Score ?? '',
                                      style: e.status==3?TextStyle(
                                          color: int.parse(
                                              e.team2Score ?? '0') >
                                              int.parse(e.team1Score ?? '0')
                                              ? Color(0xFF333333)
                                              : Color(0xFF999999),
                                          fontSize: 22.rsp,
                                          fontWeight: FontWeight.bold): TextStyle(
                                          color:  Color(0xFF999999),
                                          fontSize: 22.rsp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    60.wb,
                                    Container(
                                      width: 8.rw,
                                      height: 2.rw,
                                      color: Color(0xFF333333),
                                    ),
                                    60.wb,
                                    Text(
                                      e.team2Score ?? '',
                                      style: e.status==3?TextStyle(
                                          color: int.parse(
                                              e.team2Score ?? '0') >
                                              int.parse(e.team1Score ?? '0')
                                              ? Color(0xFF333333)
                                              : Color(0xFF999999),
                                          fontSize: 22.rsp,
                                          fontWeight: FontWeight.bold): TextStyle(
                                          color:  Color(0xFF999999),
                                          fontSize: 22.rsp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.rw, horizontal: 8.rw),
                                  decoration: BoxDecoration(
                                    color: _getCColor(e.status ?? '1'),
                                  ),
                                  child: Text(
                                    e.statusText ?? '',
                                    style: TextStyle(
                                        color: _getTColor(e.status ?? '1'),
                                        fontSize: 10.rsp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                20.hb,
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              e.team2 ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 12.rsp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ],
          ),
        )
      ],
    );
  }


  _getCColor(String status) {
    switch (status) {
      case '1':
        return Color(0xFFF2FFFA);
      case '2':
        return Color(0xFFF1F7FF);
      case '3':
        return Color(0xFFF9F9F9);
      case '4':
        return Color(0xFFFFF1F1);
    }
  }

  _getTColor(String status) {
    switch (status) {
      case '1':
        return Color(0xFF39D29D);
      case '2':
        return Color(0xFF006BFF);
      case '3':
        return Color(0xFF999999);
      case '4':
        return Color(0xFFDB2D2D);
    }
  }
}
