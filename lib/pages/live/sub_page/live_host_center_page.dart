import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/pages/goods_window_page.dart';
import 'package:recook/pages/live/sub_page/data_manager_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class LiveHostCenterPage extends StatefulWidget {
  LiveHostCenterPage({Key key}) : super(key: key);

  @override
  _LiveHostCenterPageState createState() => _LiveHostCenterPageState();
}

class _LiveHostCenterPageState extends State<LiveHostCenterPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: RecookBackButton(),
        title: Text(
          '主播中心',
          style: TextStyle(
            color: Color(0xFF3333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            splashColor: Color(0xFFDB2D2D).withOpacity(0.3),
            onPressed: () {},
            child: Text(
              '去开播',
              style: TextStyle(
                color: Color(0xFFDB2D2D),
                fontSize: rSP(14),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(rSize(15)),
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(rSize(54 / 2.0)),
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image:
                      Api.getImgUrl(UserManager.instance.user.info.headImgUrl),
                  height: rSize(54),
                  width: rSize(54),
                ),
              ),
              SizedBox(width: rSize(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserManager.instance.user.info.nickname,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(18),
                      ),
                    ),
                    Text(
                      '累计获赞12.6万  粉丝5.2万',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: rSP(14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: rSize(20)),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: rSize(36),
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: Color(0xFF333333),
                          indicator: RecookIndicator(
                              borderSide: BorderSide(
                            color: Color(0xFFDB2D2D),
                            width: rSize(3),
                          )),
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(text: '今日'),
                            Tab(text: '近7天'),
                            Tab(text: '近30天'),
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      minWidth: rSize(48),
                      padding: EdgeInsets.zero,
                      child: Text(
                        '更多',
                        style: TextStyle(
                          color: Color(0xFFDB2D2D),
                        ),
                      ),
                      onPressed: () {
                        CRoute.push(context, DataManagerPage());
                      },
                    ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 345 / 180,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildInfoCard(),
                      _buildInfoCard(),
                      _buildInfoCard(),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rSize(4)),
              boxShadow: [
                BoxShadow(
                  blurRadius: rSize(4),
                  spreadRadius: rSize(2),
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, rSize(1)),
                ),
              ],
            ),
          ),
          SizedBox(height: rSize(10)),
          _buildListTile(
            title: '直播回放',
            leading: Image.asset(
              R.ASSETS_LIVE_LIVE_PLAYBACK_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
            onTap: () {},
          ),
          _buildListTile(
            title: '商品橱窗',
            leading: Image.asset(
              R.ASSETS_LIVE_SHOP_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
            onTap: () {
              CRoute.push(context, GoodsWindowPage());
            },
          ),
        ],
      ),
    );
  }

  _buildInfoCard() {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      children: [
        _buildGridChild('16万', '收获点赞'),
        _buildGridChild('9075', '观众人数'),
        _buildGridChild('162', '新增粉丝'),
        _buildGridChild('1928', '购买人数'),
        _buildGridChild('4.5万', '销售金额'),
        _buildGridChild('3248', '预计收入'),
      ],
    );
  }

  _buildGridChild(
    String title,
    String subTitle,
  ) {
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

  _buildListTile({
    @required VoidCallback onTap,
    @required Widget leading,
    @required String title,
  }) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: rSize(15)),
      onPressed: onTap,
      child: Row(
        children: [
          leading,
          SizedBox(width: rSize(10)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: rSP(14),
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF999999),
            size: rSize(12),
          ),
        ],
      ),
    );
  }
}
