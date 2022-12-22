import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/live/live_stream/pick_view/live_goods_card.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/widgets/refresh_widget.dart';

class GoodsCartView extends StatefulWidget {
  final VoidCallback? onPick;
  GoodsCartView({Key? key, this.onPick}) : super(key: key);

  @override
  _GoodsCartViewState createState() => _GoodsCartViewState();
}

class _GoodsCartViewState extends State<GoodsCartView>
    {
  GSRefreshController _controller = GSRefreshController();
  List<GoodsList> _goodsModels = [];
  int _page = 1;
  //bool _selectAll = false;

  bool get _chooseAll {
    for (var item in _goodsModels) {
      if (PickCart.picked.indexWhere((element) => element.id == item.id) ==
          -1) {
        return false;
      }
    }
    return true;
  }

  bool get _selectAll {
    for (var item in _goodsModels) {
      if (PickCart.carPicked.indexWhere((element) => element.id == item.id) ==
          -1) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    PickCart.type = 1;
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Column(
        children: [
          _goodsModels.isEmpty
              ? SizedBox()
              : MaterialButton(
                  onPressed: !PickCart.carManager
                      ? () {
                          if (_chooseAll) {
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
                          widget.onPick!();
                        }
                      : () {
                          if (_selectAll) {
                            //_selectAll = false;
                            PickCart.carPicked.removeWhere((carPicked) {
                              return _goodsModels.indexWhere((element) =>
                                      element.id == carPicked.id) !=
                                  -1;
                            });
                            setState(() {});
                          } else
                            //_selectAll = true;
                            _goodsModels.forEach((element) {
                              PickCart.carPicked.add(element);
                            });
                          widget.onPick!();
                        },
                  child: Row(
                    children: [
                      RecookCheckBox(
                          state:
                              !PickCart.carManager ? _chooseAll : _selectAll),
                      rWBox(10),
                      Text(
                        '全选',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(14),
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (PickCart.carManager) {
                              PickCart.carPicked.removeWhere((carPicked) {
                                return _goodsModels.indexWhere((element) =>
                                element.id == carPicked.id) !=
                                    -1;
                              });
                            } else {
                              PickCart.picked.removeWhere((picked) {
                                return _goodsModels.indexWhere(
                                        (element) => element.id == picked.id) !=
                                    -1;
                              });
                            }

                            PickCart.carManager = !PickCart.carManager;
                            widget.onPick!();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: rSP(15)),
                          child: Text(
                            PickCart.carManager ? '完成' : '管理',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: rSP(14),
                            ),
                          ),
                        ),
                        style: ButtonStyle(overlayColor:MaterialStateProperty.all(Colors.black26,)),
                      ),
                      // FlatButton(
                      //   splashColor: Colors.black26,
                      //   padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                      //   child: Text(
                      //     '删除',
                      //     style: TextStyle(
                      //       color: Color(0xFFDB2D2D),
                      //       fontSize: rSP(14),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     HttpManager.post(LiveAPI.removeFromCart, {
                      //       "ids": PickCart.carPicked.map((e) => e.id).toList(),
                      //     }).then((resultData) {
                      //       showToast(resultData.data['msg']);
                      //       _controller.requestRefresh();
                      //       setState(() {});
                      //     });
                      //   },
                      // ),
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
              body: _goodsModels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(R.ASSETS_IMG_NO_DATA_PNG),
                          rHBox(10),
                          Text(
                            '您没有历史记录',
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
                        final model = _goodsModels[index];
                        return LiveGoodsCard(
                          onPick: () {
                            setState(() {
                              widget.onPick!();
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
      ),
      bottomNavigationBar: PickCart.type == 1 && PickCart.carManager
          ? BottomAppBar(
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
                              '已选${PickCart.carPicked.length}个商品',
                              // : PickCart.type == 2
                              //     ? '已选${PickCart.goodsPicked.length}个商品'
                              //     : '已选${PickCart.picked.length}/50',
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
                                                       
                          HttpManager.post(LiveAPI.removeFromCart, {
                            "ids": PickCart.carPicked.map((e) => e.id).toList(),
                          }).then((resultData) {
                            showToast(resultData.data['msg']);
                            _controller.requestRefresh();
                            setState(() {});
                          });
                        
                              },
                              child: Text('删除'),
                              color: Color(0xFFDB2D2D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(rSize(14)),
                              ),
                            ),
                            rWBox(15),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : SizedBox(),
    );
  }

  Future<List<GoodsList>> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.cartList, {
      'page': _page,
      'limit': 15,
    });
    if (resultData.data['data']['list'] == null)
      return [];
    else
      return (resultData.data['data']['list'] as List)
          .map((e) => GoodsList.fromJson(e))
          .toList();
  }
}
