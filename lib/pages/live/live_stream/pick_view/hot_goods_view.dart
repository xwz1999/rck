import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/widgets/refresh_widget.dart';

class HotGoodsView extends StatefulWidget {
  final VoidCallback onPick;
  HotGoodsView({Key key, this.onPick}) : super(key: key);

  @override
  _HotGoodsViewState createState() => _HotGoodsViewState();
}

class _HotGoodsViewState extends State<HotGoodsView>
    with AutomaticKeepAliveClientMixin {
  GSRefreshController _controller = GSRefreshController();
  List<GoodsList> _goodsModels = [];
  int _page = 1;
  bool get _selectAll {
    for (var item in _goodsModels) {
      if (PickCart.picked.indexWhere((element) => element.id == item.id) ==
          -1) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    PickCart.type = 0;
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _goodsModels.isEmpty
            ? SizedBox()
            : MaterialButton(
                onPressed: () {
                  if (_selectAll) {
                    PickCart.picked.removeWhere((picked) {
                      return _goodsModels.indexWhere(
                              (element) => element.id == picked.id) !=
                          -1;
                    });
                  } else
                    _goodsModels.forEach((element) {
                      if (PickCart.picked.length < 50) {
                        PickCart.picked.add(element);
                      }
                    });
                  widget.onPick();
                },
                child: Row(
                  children: [
                    RecookCheckBox(state: _selectAll),
                    rWBox(10),
                    Text(
                      '全选',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                  ],
                ),
              ),
        Expanded(
          child: RefreshWidget(
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
                if (models.isEmpty)
                  _controller.loadNoData();
                else
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
          ),
        ),
      ],
    );
  }

  Future<List<GoodsList>> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.hotGoods, {
      'page': _page,
      'limit': 15,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
  }

  @override
  bool get wantKeepAlive => true;
}
