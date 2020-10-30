import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/classify/order_preview_page.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/pages/live/live_stream/live_sku_widget.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart'
    show GoodsLists;
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/utils/custom_route.dart';

class GoodsListDialog extends StatefulWidget {
  final List<GoodsLists> models;
  final bool onLive;
  final bool isLive;
  final Function(int explain) onExplain;
  final int initExplain;
  final int id;
  GoodsListDialog({
    Key key,
    @required this.models,
    this.isLive = false,
    this.onExplain,
    this.onLive,
    this.initExplain,
    this.id,
  }) : super(key: key);

  @override
  _GoodsListDialogState createState() => _GoodsListDialogState();
}

class _GoodsListDialogState extends State<GoodsListDialog> {
  int explain = 0;
  @override
  void initState() {
    super.initState();
    explain = widget.initExplain;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.9,
      initialChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(15),
                  vertical: rSize(10),
                ),
                child: Row(
                  children: [
                    Text('全部宝贝 ${widget.models.length}'),
                    Spacer(),
                    Image.asset(
                      R.ASSETS_LIVE_FANCY_CART_RED_PNG,
                      height: rSize(40),
                      width: rSize(40),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(rSize(15)),
                  ),
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildGoodsCard(widget.models[index], index);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: rSize(0.5),
                      thickness: rSize(0.5),
                      color: Color(0xFFEEEEEE),
                      indent: rSize(15),
                      endIndent: rSize(15),
                    );
                  },
                  itemCount: widget.models.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildGoodsCard(GoodsLists model, int index) {
    return Container(
      padding: EdgeInsets.all(rSize(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(rSize(4)),
            child: Stack(
              children: [
                Container(
                  color: AppColor.frenchColor,
                  child: FadeInImage.assetNetwork(
                    placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                    image: Api.getImgUrl(model.mainPhotoUrl),
                    height: rSize(104),
                    width: rSize(104),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    height: rSize(14),
                    width: rSize(28),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: rSP(10),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF959C9F),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(rSize(4)),
                      ),
                    ),
                  ),
                ),
                model.isExplain == 1
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: rSize(22),
                          child: Text(
                            '讲解中',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: rSP(12),
                            ),
                          ),
                          color: Color(0xFFDB2D2D).withOpacity(0.8),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          rWBox(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.goodsName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF0A0001),
                    fontSize: rSP(14),
                  ),
                ),
                Text(
                  model.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                      color: Colors.black54, fontWeight: FontWeight.w300),
                ),
                InkWell(
                  onTap: () {
                    AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                        arguments: BrandGoodsListPage.setArguments(
                          model.brandId,
                          model.brandName,
                        ));
                  },
                  child: Row(
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                        image: Api.getImgUrl(model.brandImg),
                        width: rSize(13),
                        height: rSize(13),
                      ),
                      rWBox(4),
                      Text(
                        model.brandName,
                        style: TextStyle(
                          color: Color(0xffc70404),
                          fontSize: ScreenAdapterUtils.setSp(12),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SmallCouponWidget(number: num.parse(model.coupon)),
                    rWBox(4),
                    AppConfig.getShowCommission()
                        ? Container(
                            height: rSize(18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(rSize(1)),
                              border: Border.all(
                                color: Color(0xFFCC1B4F),
                                width: rSize(0.5),
                              ),
                            ),
                            child: Text(
                              '赚${model.commission}',
                              style: TextStyle(
                                color: Color(0xFFCC1B4F),
                                fontSize: rSP(12),
                                height: 1,
                              ),
                            ),
                          )
                        : SizedBox(),
                    Spacer(),
                    Text(
                      '剩余',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(11),
                      ),
                    ),
                    Text(
                      '${model.inventory}件',
                      style: TextStyle(
                        color: Color(0xFFC91147),
                        fontSize: rSP(11),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '券后',
                      style: TextStyle(
                        color: Color(0xFFFA6400),
                        fontSize: rSP(12),
                      ),
                    ),
                    Text(
                      '¥',
                      style: TextStyle(
                        color: Color(0xFFC92219),
                        fontSize: rSP(12),
                      ),
                    ),
                    Text(
                      '${model.discountPrice}',
                      style: TextStyle(
                        color: Color(0xFFC92219),
                        fontSize: rSP(18),
                      ),
                    ),
                    rWBox(14),
                    Text(
                      '¥${model.originalPrice}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Color(0xFF898989),
                        fontSize: rSP(12),
                      ),
                    ),
                    Spacer(),
                    widget.isLive
                        ? explain == model.id
                            ? SizedBox(
                                height: rSize(22),
                                width: rSize(58),
                                child: OutlineButton(
                                  onPressed: () {
                                    explain = 0;
                                    widget.onExplain(0);
                                    setState(() {});
                                    HttpManager.post(LiveAPI.liveStopExplain, {
                                      'liveItemId': widget.id,
                                      'goodsId': model.id,
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(rSize(11)),
                                  ),
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    '取消讲解',
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Color(0xFFDB2D2D),
                                      fontSize: rSP(12),
                                    ),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFDB2D2D),
                                    width: rSize(1),
                                  ),
                                ),
                              )
                            : MaterialButton(
                                color: Color(0xFFDB2D2D),
                                height: rSize(22),
                                minWidth: rSize(58),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(rSize(11)),
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  explain = model.id;
                                  widget.onExplain(model.id);
                                  setState(() {});
                                  HttpManager.post(LiveAPI.liveStartExplain, {
                                    'liveItemId': widget.id,
                                    'goodsId': model.id,
                                  });
                                },
                                child: Text('讲解'),
                              )
                        : MaterialButton(
                            color: Color(0xFFDB2D2D),
                            height: rSize(22),
                            minWidth: rSize(58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(rSize(11)),
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (UserManager.instance.haveLogin) {
                                if (!widget.onLive)
                                  AppRouter.push(
                                      context, RouteName.COMMODITY_PAGE,
                                      arguments:
                                          CommodityDetailPage.setArguments(
                                        model.id,
                                      ));
                                else {
                                  HttpManager.post(LiveAPI.buyGoodsInform, {
                                    "liveItemId": widget.id,
                                    "goodsId": model.id,
                                  });
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(rSize(15)),
                                          ),
                                          color: Colors.white,
                                        ),
                                        height: rSize(480),
                                        child: InternalGoodsDetail(
                                          model: model,
                                          liveId: widget.id,
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                showToast('未登陆，请先登陆');
                                CRoute.push(context, UserPage());
                              }
                            },
                            child: Text('马上抢'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

showGoodsListDialog(
  BuildContext context, {
  @required List<GoodsLists> models,
  bool isLive = false,
  bool onLive,
  Function(int onExplain) onExplain,
  int initExplain,
  int id,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return GoodsListDialog(
        models: models,
        isLive: isLive,
        onExplain: onExplain,
        initExplain: initExplain,
        id: id,
        onLive: onLive,
      );
    },
  );
  // showGeneralDialog(
  //   context: context,
  //   pageBuilder: (context, animation, secondaryAnimation) {
  //     return Align(
  //       alignment: Alignment.bottomCenter,
  //       child: GoodsListDialog(
  //         models: models,
  //         isLive: isLive,
  //         onExplain: onExplain,
  //         initExplain: initExplain,
  //         id: id,
  //         onLive: onLive,
  //       ),
  //     );
  //   },
  //   transitionBuilder: (context, animation, secondaryAnimation, child) {
  //     return Transform.translate(
  //       offset: Offset(
  //           0, (1 - Curves.easeInOutCubic.transform(animation.value)) * 500),
  //       child: child,
  //     );
  //   },
  //   barrierColor: Colors.black26,
  //   barrierLabel: 'label',
  //   barrierDismissible: true,
  //   transitionDuration: Duration(milliseconds: 500),
  // );
}

/**
 * INTERNAL GOODS DETAIL
 */

class InternalGoodsDetail extends StatefulWidget {
  final GoodsLists model;
  final int liveId;

  InternalGoodsDetail({Key key, this.model, @required this.liveId})
      : super(key: key);

  @override
  _InternalGoodsDetailState createState() => _InternalGoodsDetailState();
}

class _InternalGoodsDetailState extends State<InternalGoodsDetail> {
  GoodsDetailModel goodsModel;
  Sku sku;
  int _num = 1;
  @override
  void initState() {
    super.initState();
    GoodsDetailModelImpl.getDetailInfo(
            widget.model.id, UserManager.instance.user.info.id)
        .then((model) {
      setState(() {
        goodsModel = model;
        sku = model.data.sku[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return goodsModel == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(rSize(15)),
                  children: [
                    Row(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(widget.model.mainPhotoUrl),
                          height: rSize(100),
                          width: rSize(100),
                        ),
                        rWBox(10),
                        Expanded(
                          child: SizedBox(
                            height: rSize(100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '¥ ${sku.discountPrice} ',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: rSP(16),
                                      ),
                                    ),
                                    AppConfig.getShowCommission()
                                        ? Text(
                                            '/',
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: rSP(16),
                                            ),
                                          )
                                        : SizedBox(),
                                    AppConfig.getShowCommission()
                                        ? Text(
                                            '赚${sku.commission}',
                                            style: TextStyle(
                                              color: Color(0xFFC92219),
                                              fontSize: rSP(10),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                Text(
                                  '库存 ${sku.inventory}件',
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: rSP(12),
                                  ),
                                ),
                                Text(
                                  '已选择：${sku.name}',
                                  style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: rSP(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Color(0xFFE6E6E6),
                      height: rSize(1),
                      thickness: rSize(1),
                    ),
                    rHBox(15),
                    LiveSKUWidget(
                      attributes: goodsModel.data.attributes,
                      skus: goodsModel.data.sku,
                      onPick: (children) {
                        List<int> selected = children.map((e) => e.id).toList()
                          ..sort((itemA, itemB) => itemA.compareTo(itemB));
                        String tempSku = '';
                        selected.forEach((element) {
                          tempSku += ',$element';
                        });
                        int index = goodsModel.data.sku.indexWhere((element) =>
                            (element.combineId) == tempSku.substring(1));
                        if (index == -1) {
                          showToast('没有该物品');
                        } else {
                          sku = goodsModel.data.sku[index];
                        }
                      },
                    ),
                    rHBox(15),
                    Row(
                      children: [
                        Text(
                          '数量',
                          style: TextStyle(
                            color: Color(0xFF141414),
                            fontSize: rSP(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: rSize(100),
                          child: PlusMinusView(
                            minValue: 1,
                            maxValue: sku != null
                                ? (sku.inventory < 50 ? sku.inventory : 50)
                                : (goodsModel.data.inventory < 50
                                    ? goodsModel.data.inventory
                                    : 50),
                            onInputComplete: (String getNum) {
                              _num = int.parse(getNum);
                            },
                            onValueChanged: (int getNum) {
                              _num = getNum;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width - rSize(30),
                height: rSize(38),
                child: Text('确认'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rSize(38 / 2)),
                ),
                color: Color(0xFFDB2D2D),
                onPressed: () {
                  GoodsDetailModelImpl.createOrderPreview(
                    UserManager.instance.user.info.id,
                    sku.id,
                    sku.name,
                    _num,
                    liveId: widget.liveId,
                  ).then((model) {
                    AppRouter.push(context, RouteName.GOODS_ORDER_PAGE,
                        arguments: GoodsOrderPage.setArguments(model));
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom + rSize(10),
              ),
            ],
          );
  }
}
