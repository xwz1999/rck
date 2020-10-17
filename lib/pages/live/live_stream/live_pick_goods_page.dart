import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_search_goods_page.dart';
import 'package:recook/pages/live/live_stream/pick_view/brand_goods_list_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/brand_goods_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/goods_window_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class LivePickGoodsPage extends StatefulWidget {
  final Function(List<int> ids) onPickGoods;
  LivePickGoodsPage({Key key, @required this.onPickGoods}) : super(key: key);

  @override
  _LivePickGoodsPageState createState() => _LivePickGoodsPageState();
}

class _LivePickGoodsPageState extends State<LivePickGoodsPage>
    with TickerProviderStateMixin {
  int _goodsPage = 1;
  TabController _tabController;
  TabController _parentTabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    _parentTabController = TabController(
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
        leading: _parentTabController.index == 0
            ? RecookBackButton.text()
            : RecookBackButton(
                onTap: () {
                  _parentTabController.animateTo(0);
                  setState(() {});
                },
              ),
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
      body: TabBarView(
        controller: _parentTabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child: CustomImageButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      CRoute.push(context, PickSearchGoodsPage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: rSize(15)),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(rSize(15)),
                      ),
                      height: rSize(30),
                      child: Row(
                        children: [
                          Padding(
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
                          Text(
                            '搜索你想要添加的商品',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: rSP(13),
                            ),
                          ),
                        ],
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
                      GoodsWindowView(
                        onPick: () {
                          setState(() {});
                        },
                      ),
                      BrandGoodsView(
                        controller: _parentTabController,
                        onTapBrand: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BrandGoodsListView(
            onPick: () {
              setState(() {});
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Builder(
          builder: (context) {
            return Material(
              color: Colors.white,
              child: Stack(
                children: [
                  Row(
                    children: [
                      rWBox(15),
                      Text(
                        '已选${PickCart.picked.length}/50',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(14),
                        ),
                      ),
                      Spacer(),
                      MaterialButton(
                        height: rSize(28),
                        minWidth: rSize(72),
                        onPressed: () {
                          widget.onPickGoods(PickCart.picked.keys.toList());
                          Navigator.pop(context);
                        },
                        child: Text('完成'),
                        color: Color(0xFFDB2D2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(rSize(14)),
                        ),
                      ),
                      rWBox(15),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        onPressed: () {
                          showCustomModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return DraggableScrollableSheet(
                                minChildSize: 0.5,
                                maxChildSize: 0.9,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Material(
                                    color: Colors.white,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final model = PickCart.picked.values
                                            .toList()[index];
                                        return SizedBox(
                                          height: rSize(86 + 15.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: rSize(15),
                                              vertical: rSize(15 / 2),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${index + 1}',
                                                  style: TextStyle(
                                                    color: Color(0xFF595C5F),
                                                    fontSize: rSP(14),
                                                  ),
                                                ),
                                                rWBox(10),
                                                FadeInImage.assetNetwork(
                                                  placeholder: R
                                                      .ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                                  image: Api.getImgUrl(
                                                      model.mainPhotoUrl),
                                                  height: rSize(86),
                                                  width: rSize(86),
                                                ),
                                                rWBox(10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        model.goodsName,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: rSP(14),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '¥${model.originalPrice}',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: rSP(14),
                                                            ),
                                                          ),
                                                          Text(
                                                            '/赚${model.commission}',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFC92219),
                                                              fontSize: rSP(14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: PickCart.picked.length,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          '查看已选商品 ▼',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: rSP(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
