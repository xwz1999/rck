import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/sub_page/topic_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/recook_indicator.dart';

class UserAttentionPage extends StatefulWidget {
  UserAttentionPage({Key key}) : super(key: key);

  @override
  _UserAttentionPageState createState() => _UserAttentionPageState();
}

class _UserAttentionPageState extends State<UserAttentionPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '我的关注',
      whiteBg: true,
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(rSize(38)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(110)),
          child: TabBar(
            tabs: [
              Tab(text: '用户'),
              Tab(text: '话题'),
            ],
            indicatorPadding: EdgeInsets.symmetric(
              horizontal: 0,
            ),
            indicator: RecookIndicator(
              borderSide: BorderSide(
                color: Color(0xFFDB2D2D),
                width: rSize(3),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xFF333333),
            unselectedLabelColor: Color(0xFF666666),
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              return _buildUserCard();
            },
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return _buildTopicCard();
            },
          ),
        ],
      ),
    );
  }

  _buildUserCard() {
    return _buildUserBaseCard(
      prefix: CircleAvatar(
        radius: rSize(42 / 2),
      ),
      title: 'Kyleigh Corkery',
      subTitlePrefix: '关注 234',
      subTitleSuffix: '粉丝 10万',
    );
  }

  _buildTopicCard() {
    return _buildUserBaseCard(
      prefix: Image.asset(
        R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
        height: rSize(42),
        width: rSize(42),
      ),
      title: '# 高颜值厨房好物',
      subTitlePrefix: '共23条内容',
      subTitleSuffix: '537人参与',
    );
  }

  Widget _buildUserBaseCard({
    Widget prefix,
    String title,
    String subTitlePrefix,
    String subTitleSuffix,
  }) {
    return CustomImageButton(
      onPressed: () {
        CRoute.push(context, TopicPage());
      },
      child: Container(
        padding: EdgeInsets.all(rSize(15)),
        child: Row(
          children: [
            prefix,
            SizedBox(width: rSize(15)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rSize(3)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subTitlePrefix,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(13),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subTitleSuffix,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: rSize(15)),
            SizedBox(
              height: rSize(28),
              width: rSize(78),
              child: OutlineButton(
                child: Text('已关注'),
                onPressed: () {},
                textColor: Color(0xFF666666),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(14)),
                ),
                borderSide: BorderSide(color: Color(0xFF666666)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
