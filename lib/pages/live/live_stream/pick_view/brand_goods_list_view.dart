import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/live/models/live_brand_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class BrandGoodsListView extends StatefulWidget {
  final VoidCallback onPick;
  BrandGoodsListView({Key key, @required this.onPick}) : super(key: key);

  @override
  _BrandGoodsListViewState createState() => _BrandGoodsListViewState();
}

class _BrandGoodsListViewState extends State<BrandGoodsListView> {
  int _goodsLength = 0;
  int _page = 1;
  GSRefreshController _controller = GSRefreshController();
  List<GoodsList> _goodsList = [];
  @override
  Widget build(BuildContext context) {
    LiveBrandModel model = PickCart.brandModel;
    return PickCart.brandModel == null
        ? SizedBox()
        : NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    height: rSize(64 + 30.0),
                    padding: EdgeInsets.all(rSize(15)),
                    child: Row(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(model.logoUrl),
                          height: rSize(64),
                          width: rSize(64),
                        ),
                        rWBox(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.name,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: rSP(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '共$_goodsLength\件商品',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: rSP(14),
                              ),
                            ),
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
              body: ListView.builder(
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
          );
  }

  Future<List<GoodsList>> getGoodsWindowModels() async {
    ResultData resultData =
        await HttpManager.post(LiveAPI.liveBrandDetailList, {
      'brandId': PickCart.brandModel.id,
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data']['list'] == null)
      return null;
    else {
      setState(() {
        _goodsLength = resultData?.data['data']['total'];
      });
      return (resultData.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
    }
  }
}
