import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/life_service/nba_rank_model.dart';
import 'package:recook/pages/life_service/life_func.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';

class NBAMatchSortPage extends StatefulWidget {
  NBAMatchSortPage({
    Key? key,
  }) : super(key: key);

  @override
  _NBAMatchSortPageState createState() => _NBAMatchSortPageState();
}

class _NBAMatchSortPageState extends State<NBAMatchSortPage>
    with SingleTickerProviderStateMixin {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  NBARankModel? nbaRankModel;
  bool _onLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bodyWidget();
  }

  _bodyWidget() {
    return RefreshWidget(
      enableOverScroll: false,
      controller: _refreshController,
      color: AppColor.themeColor,
      onRefresh: () async {
        nbaRankModel = await LifeFunc.getNBARankModel()??null;
        _refreshController.refreshCompleted();
        _onLoad = false;
        setState(() {});
      },
      body:_onLoad?SizedBox(): (nbaRankModel==null||nbaRankModel!.ranking==null)
          ? NoDataView(
        title: "没有数据哦～",
        height: 600,
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: nbaRankModel!.ranking!.length,
        padding: EdgeInsets.only(
          top: 5.rw,
        ),
        itemBuilder: (BuildContext context, int index) =>
            _itemWidget(nbaRankModel!.ranking![index]),
      ),
    );
  }

  _itemWidget(Ranking ranking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 12.rw, top: 10.rw, bottom: 10.rw, right: 12.rw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                ranking.name ?? '',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
              ),
              Spacer(),
              Text(
                '胜场/负场',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
              ),
              32.wb,
              Text(
                '胜率',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12.rsp),
              ),
              38.wb,
              Text(
                '场均得分/失分',
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
              ...ranking.list!
                  .map((e) => Padding(
                    padding:  EdgeInsets.symmetric(vertical: 5.rw),
                    child: Row(
                          children: [
                            24.wb,
                            Text(
                             ( e.rankId??"").length<2? ( '0${e.rankId}'): e.rankId??"",
                              style: TextStyle(color: Color(0xFFDB2D2D), fontSize: 14.rsp,fontWeight: FontWeight.bold),
                            ),
                            20.wb,
                            Image.asset(_getTeamImg(e.team??''),width:40.rw ,height: 40.rw,),
                            12.wb,
                            Text(
                              e.team??'',
                              style: TextStyle(color: Color(0xFF333333), fontSize: 13.rsp,fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              '${e.wins??''}/${e.losses??''}',
                              style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                            ),
                            66.wb,
                            Text(
                              e.winsRate??'',
                              style: TextStyle(color: Color(0xFF333333), fontSize: 12.rsp,fontWeight: FontWeight.bold),
                            ),
                            60.wb,
                            Text(
                              '${e.avgScore??''}/${e.avgLoseScore??''}',
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
    );
  }

  _getTeamImg(String name) {
    switch (name) {
      case '亚特兰大老鹰':
        return Assets.life.imgLaoying.path;
      case '华盛顿奇才':
        return Assets.life.imgQicai.path;
      case '布鲁克林篮网':
        return Assets.life.imgLanwang.path;
      case '圣安东尼奥马刺':
        return Assets.life.imgMachi.path;
      case '克里夫兰骑士':
        return Assets.life.imgQishi.path;
      case '波士顿凯尔特人':
        return Assets.life.imgKetr.path;
      case '达拉斯独行侠':
        return Assets.life.imgDuxingx.path;
      case '新奥尔良鹈鹕':
        return Assets.life.imgTihu.path;
      case '犹他爵士':
        return Assets.life.imgJueshi.path;
      case '波特兰开拓者':
        return Assets.life.imgKaituozhe.path;
      case '夏洛特黄蜂':
        return Assets.life.imgHuangfeng.path;
      case '洛杉矶快船':
        return Assets.life.imgKuaichuan.path;
      case '印第安纳步行者':
        return Assets.life.imgBuxingzhe.path;
      case '密尔沃基雄鹿':
        return Assets.life.imgXionglu.path;
      case '奥兰多魔术':
        return Assets.life.imgMoshu.path;
      case '迈阿密热火':
        return Assets.life.imgRehuo.path;
      case '费城76人':
        return Assets.life.img76ren.path;
      case '纽约尼克斯':
        return Assets.life.imgNikesi.path;
      case '芝加哥公牛':
        return Assets.life.imgGongniu.path;
      case '多伦多猛龙':
        return Assets.life.imgMenglong.path;
      case '孟菲斯灰熊':
        return Assets.life.imgHuixiong.path;
      case '明尼苏达森林狼':
        return Assets.life.imgSenlinlang.path;
      case '丹佛掘金':
        return Assets.life.imgJuejin.path;
      case '菲尼克斯太阳':
        return Assets.life.imgTaiyang.path;
      case '俄克拉荷马城雷霆':
        return Assets.life.imgLeiting.path;
      case '底特律活塞':
        return Assets.life.imgHuosai.path;
      case '萨克拉门托国王':
        return Assets.life.imgGuowang.path;
      case '金州勇士':
        return Assets.life.imgYongshi.path;
      case '休斯顿火箭':
        return Assets.life.imgHuojian.path;
      case '洛杉矶湖人':
        return Assets.life.imgHuren.path;
    }
  }
}
