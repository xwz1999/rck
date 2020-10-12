import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/brand_goods_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/goods_window_view.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class LivePickGoodsPage extends StatefulWidget {
  LivePickGoodsPage({Key key}) : super(key: key);

  @override
  _LivePickGoodsPageState createState() => _LivePickGoodsPageState();
}

class _LivePickGoodsPageState extends State<LivePickGoodsPage>
    with TickerProviderStateMixin {
  int _goodsPage = 1;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: RecookBackButton.text(),
        leadingWidth: rSize(28 + 30.0),
        title: Text(
          '选择直播商品',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: rSP(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: rSize(15)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(rSize(15)),
                ),
                height: rSize(30),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: rSize(12),
                        right: rSize(4),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFF999999),
                        size: rSize(15),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: rSize(15 + 12 + 4.0),
                      minHeight: rSize(15),
                    ),
                    isDense: true,
                    hintStyle: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: rSP(13),
                    ),
                    hintText: '搜索你想要添加的商品',
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: rSize(95),
                vertical: rSize(15),
              ),
              height: rSize(32),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: '商品橱窗'),
                  Tab(text: '品牌'),
                ],
                labelStyle: TextStyle(
                  fontSize: rSP(13),
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Color(0xFF333333),
                unselectedLabelColor: Color(0xFF333333).withOpacity(0.3),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: RecookIndicator(
                    borderSide: BorderSide(
                  width: rSize(3),
                  color: Color(0xFFDB2D2D),
                )),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  GoodsWindowView(),
                  BrandGoodsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<GoodsWindowModel> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.shopWindow, {
      'page': _goodsPage,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return null;
    else
      return GoodsWindowModel.fromJson(resultData.data['data']);
  }
}
