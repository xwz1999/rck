import 'package:flutter/material.dart';

import 'package:recook/const/resource.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/live_brand_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class BrandGoodsView extends StatefulWidget {
  final VoidCallback onTapBrand;
  BrandGoodsView({Key key, this.onTapBrand}) : super(key: key);

  @override
  _BrandGoodsViewState createState() => _BrandGoodsViewState();
}

class _BrandGoodsViewState extends State<BrandGoodsView>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;
  GSRefreshController _controller = GSRefreshController();
  List<LiveBrandModel> _brandModels = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        getLiveBrandModel().then((models) {
          setState(() {
            _brandModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      body: GridView.builder(
        itemBuilder: (context, index) {
          return _buildGridCard(_brandModels[index]);
        },
        itemCount: _brandModels.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: rSize(15),
        ),
      ),
    );
  }

  _buildGridCard(LiveBrandModel model) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        PickCart.brandModel = model;
        widget.onTapBrand();
      },
      child: Column(
        children: [
          FadeInImage.assetNetwork(
            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
            image: Api.getImgUrl(model.logoUrl),
            height: rSize(64),
            width: rSize(64),
          ),
          Spacer(),
          Text(
            model.name,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(14),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<LiveBrandModel>> getLiveBrandModel() async {
    ResultData resultData = await HttpManager.post(LiveAPI.liveBrandList, {
      'page': _page,
      'limit': 10,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => LiveBrandModel.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
