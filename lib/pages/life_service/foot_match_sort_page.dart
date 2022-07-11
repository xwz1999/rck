import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/foot_rank_model.dart';
import 'package:recook/models/life_service/hw_calculator_model.dart';
import 'package:recook/models/life_service/nba_model.dart';
import 'package:recook/models/life_service/nba_rank_model.dart';
import 'package:recook/pages/life_service/hw_calculator_result_page.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

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

  late FootRankModel footRankModel;

  @override
  void initState() {
    super.initState();
    footRankModel = FootRankModel(ranking: [

      FRanking(
            rankId: '1',
            team: '马德里',
            wins: '49',
            losses: '23',
            draw: '8',
            goals: '65',
            losingGoals: '24',
            goalDifference: '41',
            scores: '83'
          ),
      FRanking(
          rankId: '1',
          team: '马德里',
          wins: '49',
          losses: '23',
          draw: '8',
          goals: '65',
          losingGoals: '24',
          goalDifference: '41',
          scores: '83'
      ),
      FRanking(
          rankId: '1',
          team: '马德里',
          wins: '49',
          losses: '23',
          draw: '8',
          goals: '65',
          losingGoals: '24',
          goalDifference: '41',
          scores: '83'
      ),
      FRanking(
          rankId: '1',
          team: '马德里',
          wins: '49',
          losses: '23',
          draw: '8',
          goals: '65',
          losingGoals: '24',
          goalDifference: '41',
          scores: '83'
      ),
      FRanking(
          rankId: '1',
          team: '马德里',
          wins: '49',
          losses: '23',
          draw: '8',
          goals: '65',
          losingGoals: '24',
          goalDifference: '41',
          scores: '83'
      ),

    ]);
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
        widget.refreshController.refreshCompleted();
        //setState(() {});
      },
      body: ListView(
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
                ...footRankModel.ranking!
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
