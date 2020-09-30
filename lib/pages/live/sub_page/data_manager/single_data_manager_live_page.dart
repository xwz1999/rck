import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_painters/pie_progress_painter.dart';
import 'package:recook/widgets/recook_back_button.dart';

class SingleDataManagerPage extends StatefulWidget {
  SingleDataManagerPage({Key key}) : super(key: key);

  @override
  _SingleDataManagerPageState createState() => _SingleDataManagerPageState();
}

class _SingleDataManagerPageState extends State<SingleDataManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9FB),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '单场数据',
          style: TextStyle(
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF9F9FB),
        leading: RecookBackButton(),
      ),
      body: ListView(
        padding: EdgeInsets.all(rSize(15)),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                R.ASSETS_LIVE_LIVE_DETAIL_PNG,
                height: rSize(16),
                width: rSize(16),
              ),
              SizedBox(width: rSize(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '07-30 14:28场',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                        height: 1,
                      ),
                    ),
                    SizedBox(height: rSize(6)),
                    Text(
                      '直播时间 14:28 - 17:12    共2小时44分',
                      style: TextStyle(
                        color: Color(0xFF333333).withOpacity(0.5),
                        fontSize: rSP(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: rSize(15)),
          AspectRatio(
            aspectRatio: 345 / 142,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rSize(10)),
                color: Colors.white,
              ),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 345.0 / 3.0 / (142.0 / 2.0),
                ),
                children: [
                  _buildCard('1.6万', '收获点赞'),
                  _buildCard('1244', '观众人数'),
                  _buildCard('154', '新增粉丝'),
                  _buildCard('123', '购买人数'),
                  _buildCard('3.5万', '销售金额'),
                  _buildCard('9812', '预计收入'),
                ],
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
          SizedBox(height: rSize(15)),
          _buildAudienceSource(),
        ],
      ),
    );
  }

  _buildCard(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: rSP(16),
          ),
        ),
        SizedBox(height: rSize(6)),
        Text(
          subTitle,
          style: TextStyle(
            color: Color(0xFF333333).withOpacity(0.7),
            fontSize: rSP(12),
          ),
        ),
      ],
    );
  }

  _buildAudienceSource() {
    return AspectRatio(
      aspectRatio: 345 / 197,
      child: Container(
        padding: EdgeInsets.all(rSize(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(rSize(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '观众来源',
              style: TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: rSP(14),
              ),
            ),
            Divider(
              height: rSize(21),
              color: Color(0XFFEEEEEE),
              thickness: rSize(1),
            ),
            Expanded(
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: PieProgressPainter(values: [
                        PieDataStructure(
                          color: Color(0xFFF33963),
                          value: 0.8,
                        ),
                        PieDataStructure(
                          color: Color(0xFFFD9530),
                          value: 0.1,
                        ),
                        PieDataStructure(
                          color: Color(0xFFFBD941),
                          value: 0.05,
                        ),
                        PieDataStructure(
                          color: Color(0xFFB6C0CC),
                          value: 0.05,
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(width: rSize(20)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAudienceTile(
                          color: Color(0xFFF33963),
                          value: 0.8,
                          title: '关注',
                        ),
                        _buildAudienceTile(
                          color: Color(0xFFFD9530),
                          value: 0.1,
                          title: '直播推荐',
                        ),
                        _buildAudienceTile(
                          color: Color(0xFFFBD941),
                          value: 0.05,
                          title: '分享',
                        ),
                        _buildAudienceTile(
                          color: Color(0xFFB6C0CC),
                          value: 0.05,
                          title: '其他',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAudienceTile({
    @required Color color,
    @required double value,
    @required String title,
  }) {
    return Row(
      children: [
        Container(
          height: rSize(6),
          width: rSize(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rSize(3)),
            color: color,
          ),
        ),
        SizedBox(width: rSize(8)),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF333333).withOpacity(0.7),
              fontSize: rSP(14),
            ),
          ),
        ),
        Text(
          '${(value * 100.0).toStringAsFixed(1)}%',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: rSP(14),
          ),
        ),
        SizedBox(width: rSize(6)),
      ],
    );
  }
}