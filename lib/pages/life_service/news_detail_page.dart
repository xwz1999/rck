import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/life_service/news_detail_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';

///成语接龙
class NewsDetailPage extends StatefulWidget {
  final NewsDetailModel newsDetailModel;

  NewsDetailPage({
    Key? key,
    required this.newsDetailModel,
  }) : super(key: key);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>
    with TickerProviderStateMixin {
  late NewsDetailModel newsDetailModel;

  @override
  void initState() {
    super.initState();
    newsDetailModel = NewsDetailModel(
        detail: Detail(
          title: '黄子韬入盟GK，娱乐、电竞圈互串双丰收？',
          date: "2021-03-08 13:21:00",
          authorName: "杨啸宇",
        ),
        content:"<p >本文转自：青岛新闻网<\/p><p >青岛新闻网6月27日讯（记者 张晓楠）昨日，青岛市迎来强降雨天气，青岛市运输事业发展中心按照上级工作部署，立即启动应急预案并下发防汛预警响应通知，主要负责同志第一时间到达现场指挥调度，组织各行业按照应急预案立即开展防汛应对，重点做好城市公交、地铁等行业的防汛保障措施。截至目前，青岛市运输各行业运行态势平稳。<\/p><p >\n            <img width='100%' src='https:\/\/dfzximg01.dftoutiao.com\/news\/20220627\/20220627141616_dc9a0cba251d060e421a406b9bc2bbb0_1.jpeg' data-weight='550' data-width='550' data-height='413'><\/p><p >据悉，此轮降雨是青岛市入夏以来的第一次强降雨，时间集中、范围集中，运输行业闻“汛”而动，全面进入应急备战状态。道路“两客一危”行业通过动态监控平台，第一时间向车辆和企业发送了防汛应对通知。同时进一步落实应急运力保障，客运行业安排50辆客车，货运行业安排150辆货车作为应急运力，随时待命。公共交通行业适时调整运营情况，截至27日早8点，地铁方面运行正常。强降雨期间公交车停运线路5条，停运车辆62辆，临时绕行线路41条，缩线运行线路15条，暂缓发车线路18条。6月26日晚受强降雨天气影响，抵青部分列车出现不同程度延误，接到列车延误具体信息后，按照市交通运输局安排部署,市运输中心立即启动高铁晚点客流接驳预案，联系企业紧急抽调应急运力，采取延长公交营运时间、增开接驳班次等措施，积极做好旅客到站后的接驳、转运工作。27日凌晨3时许，所有到站旅客全部疏散完毕，期间共计增发13车次，运送旅客约650人次。出租客运行业通过车载智能终端信息屏快速发布天气情况，及时联系周边在营车辆前往火车北站协助配合疏运乘客。同时督促驾驶员做好强降雨大风雷电防范，主动避让积水路段，确保安全行车。维修驾培、铁路及港航等行业第一时间传达部署防汛工作要求，组织启动应急响应措施，保证应急物资及人员全部到位。<\/p><p >青岛市运输中心主任乔文锋现场调度运输行业防汛工作时指出，各处要时刻保持高度清醒、高度敏感、高度警惕，坚持以大概率思维应对小概率事件，全面贯彻落实省市及交通运输局工作部署，坚持以防为主、防抗救相结合，宁可十防九空、不可一失万无，要通过本次强降雨天气防范应对，查找不足和短板，组织各行业进一步完善应急体系和防汛预案，做好人员、物资、应急准备。同时加强培训演练，提升应急处置能力，推动防汛主体责任落实落细，坚决打赢打好今年防汛每场硬仗，确保人民群众生命财产安全。<\/p>",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('新闻详情',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
      ),
      body: ListView(

        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.rw),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      newsDetailModel.detail!.title ?? '' ,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22.rsp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    )),
              ],
            ),
          ),
          5.hb,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.rw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(newsDetailModel.detail!.authorName ?? '',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.rsp,
                    )),
                16.wb,
                Padding(
                  padding: EdgeInsets.only(top: 3.rw),
                  child: Text(newsDetailModel.detail!.date ?? '',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12.rsp,
                      )),
                ),
              ],
            ),
          ),
          20.hb,
          _htmlWidget(),
        ],
      )

    );
  }

  _htmlWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.rw),
      child: HtmlWidget(
        newsDetailModel.content ?? '',
        textStyle: TextStyle(color: Color(0xFF333333)),
      ),
    );
  }
}
