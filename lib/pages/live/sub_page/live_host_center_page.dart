import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/functions/live_function.dart';
import 'package:recook/pages/live/live_stream/live_page.dart';
import 'package:recook/pages/live/models/live_base_info_model.dart';
import 'package:recook/pages/live/models/live_time_data_model.dart';
import 'package:recook/pages/live/pages/goods_window_page.dart';
import 'package:recook/pages/live/pages/live_goods_cart_page.dart';
import 'package:recook/pages/live/sub_page/data_manager_page.dart';
import 'package:recook/pages/live/sub_page/user_home/user_playback_view.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class LiveHostCenterPage extends StatefulWidget {
  final LiveBaseInfoModel model;
  LiveHostCenterPage({Key key, @required this.model}) : super(key: key);

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
            onPressed: () {
              checkStartLive(context, context);
            },
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
                      '累计获赞${widget.model.praise} 粉丝${widget.model.fans}',
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
                      _buildInfoCard(1),
                      _buildInfoCard(7),
                      _buildInfoCard(30),
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
            onTap: () {
              CRoute.push(
                context,
                RecookScaffold(
                  title: '直播回放',
                  body: UserPlaybackView(userId: widget.model.userId),
                ),
              );
            },
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
          _buildListTile(
            title: '直播车',
            leading: Image.asset(
              R.ASSETS_LIVE_LIVE_CART_ROUND_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
            onTap: () {
              CRoute.push(context, LiveGoodsCartPage());
            },
          ),
        ],
      ),
    );
  }

  Future<LiveTimeDataModel> getDataModel(int selectDay) async {
    ResultData resultData = await HttpManager.post(LiveAPI.dataCount, {
      'day': selectDay,
    });
    if (resultData?.data['data'] == null)
      return LiveTimeDataModel.zero();
    else
      return LiveTimeDataModel.fromJson(resultData?.data['data']);
  }

  _buildInfoCard(int day) {
    return FutureBuilder<LiveTimeDataModel>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            children: [
              _buildGridChild('${snapshot.data.praise}', '收获点赞'),
              _buildGridChild('${snapshot.data.look}', '观众人数'),
              _buildGridChild('${snapshot.data.fans}', '新增粉丝'),
              _buildGridChild('${snapshot.data.buy}', '购买人数'),
              _buildGridChild('${snapshot.data.salesVolume}', '销售金额'),
              _buildGridChild('${snapshot.data.anticipatedRevenue}', '预计收入'),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getDataModel(day),
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
