import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/live/live_stream/live_pick_goods_page.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:oktoast/oktoast.dart';

class BrandGoodsListView extends StatefulWidget {
  final VoidCallback onPick;
  final int categoryId;
  final String name;
  final String logo;
  BrandGoodsListView(
      {Key key,
      @required this.onPick,
      @required this.categoryId,
      this.name,
      this.logo})
      : super(key: key);

  @override
  _BrandGoodsListViewState createState() => _BrandGoodsListViewState();
}

class _BrandGoodsListViewState extends State<BrandGoodsListView> {
  // int _goodsLength = 0;
  int _page = 1;
  GSRefreshController _controller = GSRefreshController(initialRefresh: true);
  List<GoodsList> _goodsList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '全部产品',
      whiteBg: true,
      bottomNavi: BottomAppBar(
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
                          widget.onPick();
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
                          if (PickCart.picked.isEmpty)
                            showToast('未选择商品');
                          else
                            showCustomModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  minChildSize: 0.5,
                                  maxChildSize: 0.9,
                                  builder: (BuildContext context,
                                      ScrollController scrollController) {
                                    return ReorderLiveGoodsListView();
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverToBoxAdapter(
              child: Container(
                height: rSize(64 + 30.0),
                padding: EdgeInsets.all(rSize(15)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: rSize(1),
                        ),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                        image: Api.getImgUrl(widget.logo),
                        height: rSize(64),
                        width: rSize(64),
                      ),
                    ),
                    rWBox(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: rSP(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Spacer(),
                        // Text(
                        //   '共$_goodsLength\件商品',
                        //   style: TextStyle(
                        //     color: Color(0xFF666666),
                        //     fontSize: rSP(14),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                indent: rSize(15),
                endIndent: rSize(15),
                color: Color(0xFFEEEEEE),
                height: rSize(0.5),
                thickness: rSize(0.5),
              ),
            ),
          ];
        },
        body: RefreshWidget(
          controller: _controller,
          onRefresh: () {
            _page = 1;
            getGoodsWindowModels().then((models) {
              setState(() {
                _goodsList = models;
              });
              _controller.refreshCompleted();
            });
          },
          onLoadMore: () {
            _page++;
            getGoodsWindowModels().then((models) {
              setState(() {
                _goodsList.addAll(models);
              });
              _controller.loadComplete();
            });
          },
          body: _goodsList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(R.ASSETS_IMG_NO_DATA_PNG),
                      rHBox(10),
                      Text(
                        '该类别没有商品',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(16),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return LiveGoodsCard(
                      onPick: () {
                        setState(() {});
                        widget.onPick();
                      },
                      model: _goodsList[index],
                    );
                  },
                  itemCount: _goodsList.length,
                ),
        ),
      ),
    );
  }

  Future<List<GoodsList>> getGoodsWindowModels() async {
    // ResultData resultData =
    //     await HttpManager.post(LiveAPI.liveBrandDetailList, {
    //   'brandId': PickCart.brandModel.id,
    //   'page': _page,
    //   'limit': 15,
    // });

    ResultData resultData =
        await HttpManager.post(GoodsApi.goods_sort_comprehensive, {
      'page': _page,
      'secondCategoryID': widget.categoryId,
    });
    if (resultData?.data['data'] == null)
      return [];
    else {
      return GoodsSimpleListModel.fromJson(resultData.data).data.map((e) {
        return GoodsList(
          id: e.id,
          goodsName: e.goodsName,
          brandId: e.brandId,
          brandImg: e.brandImg,
          brandName: e.brandName,
          description: e.description,
          inventory: e.inventory,
          salesVolume: e.salesVolume,
          startTime: e.startTime,
          mainPhotoUrl: e.mainPhotoUrl,
          percent: e.percent,
          promotionName: e.promotionName,
          originalPrice: e.originalPrice.toString(),
          discountPrice: e.discountPrice.toString(),
          commission: e.commission.toString(),
          tags: e.tags,
          endTime: e.endTime,
          coupon: e.coupon.toString(),
        );
      }).toList();
      // return (resultData.data['data'] as List)
      //     .map((e) => GoodsList.fromJson(e))
      //     .toList();
    }
  }
}
