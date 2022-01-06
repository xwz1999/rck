import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/live/live_stream/pick_view/hot_goods_view.dart';
import 'package:jingyaoyun/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:jingyaoyun/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:jingyaoyun/pages/live/models/goods_window_model.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

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
  bool _searching = false;
  FocusNode _focusNode = FocusNode();
  List<GoodsList> _hotList = [];
  @override
  void initState() {
    super.initState();
    getGoodsWindowModels().then((models) {
      setState(() {
        _hotList = models;
      });
    });
  }

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
        elevation: 0,
        backgroundColor: Colors.white,
        leading: RecookBackButton(),
        actions: [
          rWBox(10),
          Center(
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Text('确定'),
              height: rSize(28),
              minWidth: rSize(60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(14))),
            ),
          ),
          rWBox(15),
        ],
        title: TextField(
          autofocus: true,
          focusNode: _focusNode,
          controller: _editingController,
          style: TextStyle(
            color: Color(0xFF333333),
          ),
          onSubmitted: (text) {
            PickCart.addHistory(text);
            setState(() {
              _searching = true;
            });
            Future.delayed(Duration(milliseconds: 100), () {
              _controller.requestRefresh();
            });
          },
          onChanged: (text) {
            if (TextUtil.isEmpty(text)) _searching = false;
            setState(() {});
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: rSize(13)),
              child: Icon(
                Icons.search,
                size: rSize(16),
                color: Color(0xFF999999),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            hintText: '搜索你想要添加的商品',
            hintStyle: TextStyle(
              color: Color(0xFF999999),
              fontSize: rSP(13),
            ),
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
      body: !_searching
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PickCart.history.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(rSize(15)),
                        child: Text(
                          '历史搜索',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: rSize(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                PickCart.history.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rSize(15),
                        ),
                        child: Wrap(
                          spacing: rSize(5),
                          children: PickCart.history.map((e) {
                            return MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                _editingController.text = e;
                                _focusNode.requestFocus();
                                setState(() {});
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: rSize(12),
                                vertical: rSize(4),
                              ),
                              minWidth: 0,
                              height: rSize(28),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(rSize(14))),
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: rSP(14),
                                ),
                              ),
                              color: Color(0xFFF5F5F5),
                            );
                          }).toList(),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.all(rSize(15)),
                  child: Text(
                    '热门推荐',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSize(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: HotGoodsView(
                    onPick: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            )
          : RefreshWidget(
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

  Future<List<GoodsList>> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.hotGoods, {
      'page': 1,
      'limit': 5,
    });
    if (resultData?.data['data']['list'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
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
