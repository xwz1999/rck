import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class LiveGoodsCartPage extends StatefulWidget {
  LiveGoodsCartPage({Key key}) : super(key: key);

  @override
  _LiveGoodsCartPageState createState() => _LiveGoodsCartPageState();
}

class _LiveGoodsCartPageState extends State<LiveGoodsCartPage> {
  List<GoodsWindowModel> models = [];
  List<GoodsList> displayModels = [];

  List<num> _selectedIds = [];

  int page = 1;
  bool _isManager = false;
  bool _selectAll = false;

  GSRefreshController _controller = GSRefreshController();
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
    return RecookScaffold(
      whiteBg: true,
      title: '商品橱窗',
      body: Column(
        children: [
          Material(
            child: Row(
              children: [
                rWBox(15),
                Text(
                  '共${models.isEmpty ? 0 : models[0].total}个宝贝',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: rSP(14),
                  ),
                ),
                Spacer(),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      if (_isManager) {
                        _selectAll = false;
                        _selectedIds.clear();
                      }
                      _isManager = !_isManager;
                    });
                  },
                  padding: EdgeInsets.symmetric(horizontal: rSP(15)),
                  splashColor: Colors.black26,
                  child: Text(
                    _isManager ? '完成' : '管理',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: rSP(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isManager
              ? FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                  onPressed: _selectAll
                      ? () {
                          _selectAll = false;
                          _selectedIds.clear();
                          setState(() {});
                        }
                      : () {
                          _selectAll = true;
                          _selectedIds =
                              displayModels.map((e) => e.id).toList();
                          setState(() {});
                        },
                  splashColor: Colors.black26,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RecookCheckBox(state: _selectAll),
                      rWBox(10),
                      Text(
                        '全选',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: rSP(14),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Expanded(
            child: RefreshWidget(
              controller: _controller,
              onRefresh: () {
                page = 1;
                getGoodsWindowModels().then((model) {
                  setState(() {
                    models = [model];
                    displayModels = model.list;
                  });
                  _controller.refreshCompleted();
                }).catchError((_) {
                  _controller.refreshFailed();
                });
              },
              onLoadMore: () {
                page++;
                getGoodsWindowModels().then((model) {
                  setState(() {
                    models.add(model);
                    displayModels.addAll(model.list);
                  });
                  if (model.list.isEmpty)
                    _controller.loadNoData();
                  else
                    _controller.loadComplete();
                }).catchError((_) {
                  _controller.loadFailed();
                });
              },
              body: ListView.builder(
                itemBuilder: (context, index) {
                  final model = displayModels[index];
                  return _buildGoodsCard(model);
                },
                itemCount: displayModels.length,
              ),
            ),
          ),
          _isManager
              ? SafeArea(
                  bottom: true,
                  top: false,
                  child: Row(
                    children: [
                      rWBox(15),
                      Text(
                        '已选择${_selectedIds.length}/${models.isEmpty ? 0 : models[0].total}',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(14),
                        ),
                      ),
                      Spacer(),
                      FlatButton(
                        splashColor: Colors.black26,
                        padding: EdgeInsets.symmetric(horizontal: rSize(15)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              R.ASSETS_LOTTERY_REDEEM_LOTTERY_DELETE_PNG,
                              height: rSP(16),
                              width: rSP(16),
                            ),
                            rWBox(4),
                            Text(
                              '删除',
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                                fontSize: rSP(14),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          HttpManager.post(LiveAPI.removeFromCart, {
                            "ids": _selectedIds.map((e) => e.toInt()).toList(),
                          }).then((resultData) {
                            _selectedIds.clear();
                            _selectAll = false;
                            showToast(resultData.data['msg']);
                            _controller.requestRefresh();
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _buildGoodsCard(GoodsList model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: rSize(15 / 2)),
      height: rSize(120 + 15.0),
      child: FlatButton(
        splashColor: Colors.black26,
        onPressed: _isManager
            ? () {
                _selectAll = false;
                if (_selectedIds.contains(model.id)) {
                  _selectedIds.remove(model.id);
                } else {
                  _selectedIds.add(model.id);
                }
                setState(() {});
              }
            : () {
                AppRouter.push(
                  context,
                  RouteName.COMMODITY_PAGE,
                  arguments: CommodityDetailPage.setArguments(model.id),
                );
              },
        child: Row(
          children: [
            _isManager
                ? RecookCheckBox(state: _selectedIds.contains(model.id))
                : SizedBox(),
            _isManager ? rWBox(10) : SizedBox(),
            Container(
              color: AppColor.frenchColor,
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(model.mainPhotoUrl),
                height: rSize(120),
                width: rSize(120),
              ),
            ),
            rWBox(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 25,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 13 * 1.5,
                          height: 13 * 1.5,
                          child: TextUtils.isEmpty(model.brandImg)
                              ? SizedBox()
                              : ExtendedImage.network(
                                  Api.getImgUrl(model.brandImg),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          TextUtils.isEmpty(model.brandName)
                              ? ""
                              : model.brandName,
                          style: TextStyle(
                            color: Color(0xffc70404),
                            fontSize: ScreenAdapterUtils.setSp(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            (model.coupon != null && model.coupon != '0')
                                ? Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: SmallCouponWidget(
                                      height: 18,
                                      number: num.parse(model.coupon),
                                    ),
                                  )
                                : SizedBox(),
                            AppConfig.commissionByRoleLevel
                                ? Container(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 2),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                color: Color(0xffec294d),
                                                width: 0.5,
                                              )),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Text(
                                            "赚" + model.commission,
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(0),
                                              fontSize:
                                                  ScreenAdapterUtils.setSp(12),
                                            ),
                                          ),
                                        ),
                                        AppConfig.getShowCommission()
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "赚" + model.commission,
                                                  style: TextStyle(
                                                    color: Color(0xffeb0045),
                                                    fontSize: ScreenAdapterUtils
                                                        .setSp(12),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            Spacer(),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Text(
                            "已售${model.salesVolume}件",
                            style: TextStyle(
                              color: Color(0xff595757),
                              fontSize: ScreenAdapterUtils.setSp(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '¥${model.originalPrice}',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(14),
                        ),
                      ),
                      AppConfig.getShowCommission()
                          ? model.commission == '0'
                              ? SizedBox()
                              : Text(
                                  '/赚${model.commission}',
                                  style: TextStyle(
                                    color: Color(0xFFC92219),
                                    fontSize: rSP(14),
                                  ),
                                )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<GoodsWindowModel> getGoodsWindowModels() async {
    ResultData resultData = await HttpManager.post(LiveAPI.cartList, {
      'page': page,
      'limit': 15,
    });
    if (resultData?.data['data'] == null)
      return null;
    else
      return GoodsWindowModel.fromJson(resultData.data['data']);
  }
}
