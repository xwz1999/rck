import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/category_model.dart';
import 'package:jingyaoyun/pages/live/live_stream/pick_view/brand_goods_list_view.dart';
import 'package:jingyaoyun/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class AllGoodsView extends StatefulWidget {
  AllGoodsView({Key key}) : super(key: key);

  @override
  _AllGoodsViewState createState() => _AllGoodsViewState();
}

class _AllGoodsViewState extends State<AllGoodsView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  CategoryModel _displayModel;
  int _selectId = 0;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
     PickCart.type = 3;
    _getAllGoods().then((model) {
      _selectId = model.data.first.id;
      _tabController = TabController(length: model.data.length, vsync: this);
      setState(() {
        _displayModel = model;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _displayModel == null
        ? Center(
            child: Text(
              '加载中',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: rSP(20),
              ),
            ),
          )
        : Material(
            color: Color(0xFFF5F5F5),
            child: Row(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: rSize(105),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final listModel = _displayModel.data[index];
                          return Stack(
                            children: [
                              listModel.id == _selectId
                                  ? Container(
                                      color: Colors.white,
                                      width: rSize(105),
                                      height: rSize(50),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: rSize(32),
                                        color: Color(0xFFC92219),
                                        width: rSize(3),
                                      ),
                                    )
                                  : SizedBox(),
                              MaterialButton(
                                height: rSize(50),
                                minWidth: rSize(105),
                                onPressed: () {
                                  _tabController.animateTo(_displayModel.data
                                      .indexWhere((element) =>
                                          element.id == listModel.id));
                                  setState(() {
                                    _selectId = listModel.id;
                                  });
                                },
                                child: Text(
                                  listModel.name,
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: _displayModel.data.length,
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: _displayModel.data.map((e) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(rSize(10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                                image: Api.getImgUrl(e.logoUrl),
                                height: rSize(80),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return CustomImageButton(
                                    onPressed: () {
                                      CRoute.push(
                                        context,
                                        BrandGoodsListView(
                                          onPick: () {},
                                          categoryId: e.sub[index].id,
                                          name: e.sub[index].name,
                                          logo: e.sub[index].logoUrl,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(rSize(25)),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: R
                                                .ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                            image: Api.getImgUrl(
                                                e.sub[index].logoUrl),
                                            height: rSize(50),
                                            width: rSize(50),
                                          ),
                                        ),
                                        Text(
                                          e.sub[index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: e.sub.length,
                              ),
                            ),
                          ],
                        );
                      }).toList()),
                )),
              ],
            ),
          );
  }

  Future<CategoryModel> _getAllGoods() async {
    ResultData res = await HttpManager.post(GoodsApi.categories, {});
    if (!res.result)
      return null;
    else
      return CategoryModel.fromJson(res.data);
  }

  @override
  bool get wantKeepAlive => true;
}
