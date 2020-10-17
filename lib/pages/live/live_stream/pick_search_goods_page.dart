import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

class PickSearchGoodsPage extends StatefulWidget {
  final Function(GoodsList model) onPick;
  PickSearchGoodsPage({Key key, this.onPick}) : super(key: key);

  @override
  _PickSearchGoodsPageState createState() => _PickSearchGoodsPageState();
}

class _PickSearchGoodsPageState extends State<PickSearchGoodsPage> {
  GSRefreshController _controller = GSRefreshController();
  TextEditingController _editingController = TextEditingController();
  int _page = 1;
  List<GoodsList> _goodsModels = [];

  @override
  void dispose() {
    _controller?.dispose();
    _editingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: RecookBackButton(),
        actions: [rWBox(10)],
        title: TextField(
          autofocus: true,
          controller: _editingController,
          style: TextStyle(
            color: Color(0xFF333333),
          ),
          onEditingComplete: () {
            _controller.requestRefresh();
          },
          decoration: InputDecoration(
            fillColor: Colors.black.withOpacity(0.1),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(rSize(10)),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(rSize(30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(rSize(30)),
            ),
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: RefreshWidget(
        controller: _controller,
        onRefresh: () {
          _page = 1;
          getModels().then((models) {
            setState(() {
              _goodsModels = models;
            });
            _controller.refreshCompleted();
          });
        },
        onLoadMore: () {
          _page++;
          getModels().then((models) {
            setState(() {
              _goodsModels.addAll(models);
            });
            _controller.loadComplete();
          });
        },
        body: ListView.builder(
          itemBuilder: (context, index) {
            return LiveGoodsCard(
                onPick: () {
                  setState(() {});
                  // Navigator.pop(context);
                },
                model: _goodsModels[index]);
          },
          itemCount: _goodsModels.length,
        ),
      ),
    );
  }

  Future<List<GoodsList>> getModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.goodsList, {
      'keyword': _editingController.text,
      'page': _page,
      'limit': 15,
    });

    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData?.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
  }
}
