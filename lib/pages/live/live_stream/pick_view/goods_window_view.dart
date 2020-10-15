import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/widgets/refresh_widget.dart';

class GoodsWindowView extends StatefulWidget {
  final VoidCallback onPick;
  GoodsWindowView({Key key, this.onPick}) : super(key: key);

  @override
  _GoodsWindowViewState createState() => _GoodsWindowViewState();
}

class _GoodsWindowViewState extends State<GoodsWindowView>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _controller = GSRefreshController();
  List<GoodsList> _goodsModels = [];
  int _page = 1;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
     if(mounted) _controller.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      controller: _controller,
      onRefresh: () {
        _page = 1;
        getGoodsWindowModels().then((models) {
          setState(() {
            _goodsModels = models;
          });
          _controller.refreshCompleted();
        });
      },
      onLoadMore: () {
        _page++;
        getGoodsWindowModels().then((models) {
          setState(() {
            _goodsModels.addAll(models);
          });
          _controller.loadComplete();
        });
      },
      body: ListView.builder(
        itemBuilder: (context, index) {
          final model = _goodsModels[index];
          return LiveGoodsCard(
            onPick: () {
              setState(() {
                widget.onPick();
              });
            },
            model: model,
          );
        },
        itemCount: _goodsModels.length,
      ),
    );
  }

  Future<List<GoodsList>> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.shopWindow, {
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data']['list'] == null)
      return null;
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
