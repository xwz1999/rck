import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/foot_rank_model.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'life_func.dart';

class FootMatchSortPage extends StatefulWidget {
  final GSRefreshController refreshController;
  final String type;
  FootMatchSortPage({
    Key? key, required this.refreshController, required this.type,
  }) : super(key: key);

  @override
  _FootMatchSortPageState createState() => _FootMatchSortPageState();
}

class _FootMatchSortPageState extends State<FootMatchSortPage>
    with SingleTickerProviderStateMixin {

  FootRankModel? footRankModel;
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
        print(widget.type);
        footRankModel = await LifeFunc.getFootRankModel(widget.type)??null;
        widget.refreshController.refreshCompleted();
        _onLoad = false;
        setState(() {});
      },
      body: _onLoad?SizedBox(): footRankModel==null
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      ): footRankModel!.ranking==null
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      )
          :ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 5.rw,
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 12.rw, top: 10.rw, bottom: 10.rw, right: 12.rw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '球队',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
                ),
                Spacer(),
                Text(
                  '胜/平/负',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
                ),
                48.wb,
                Text(
                  '进/失',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
                ),
                32.wb,
                Text(
                  '净胜',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
                ),
                32.wb,
                Text(
                  '积分',
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
                ...footRankModel!.ranking!
                    .map((e) => Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.rw),
                  child: Row(
                    children: [
                      24.wb,
                      Text(
                        ( e.rankId??"").length<2? ( '0${e.rankId}'): e.rankId??"",
                        style: TextStyle(color: Color(0xFFDB2D2D), fontSize: 14.rsp,fontWeight: FontWeight.bold),
                      ),
                      20.wb,
                      Text(
                        e.team??'',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 13.rsp,fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        '${e.wins??''}/${e.draw??''}/${e.losses??''}',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                      ),
                      66.wb,
                      Text(
                        '${e.goals??''}/${e.losingGoals??''}',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                      ),
                      60.wb,
                      Text(
                       e.goalDifference??'',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                      ),
                      50.wb,
                      Text(
                        e.scores??'',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                      ),
                      24.wb,
                    ],
                  ),
                ))
                    .toList(),
              ],
            ),
          )
        ],
      ),
    );
  }

}
