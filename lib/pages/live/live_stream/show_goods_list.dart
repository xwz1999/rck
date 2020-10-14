import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/live/models/live_stream_info_model.dart'
    show GoodsLists;

class GoodsListDialog extends StatefulWidget {
  final List<GoodsLists> models;
  final bool isLive;
  final Function(int explain) onExplain;
  final int initExplain;
  final int id;
  GoodsListDialog({
    Key key,
    @required this.models,
    this.isLive = false,
    this.onExplain,
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
      builder: (context, scrollController) {
        return Column(
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
                      R.ASSETS_LIVE_FANCY_CART_PNG,
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
      height: rSize(104 + 15 + 15.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(rSize(4)),
            child: Stack(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(model.mainPhotoUrl),
                  height: rSize(104),
                  width: rSize(104),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Spacer(),
                Row(
                  children: [
                    SmallCouponWidget(number: num.parse(model.coupon)),
                    rWBox(4),
                    Container(
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
                    ),
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
                            onPressed: () {},
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
  Function(int onExplain) onExplain,
  int initExplain,
  int id,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: GoodsListDialog(
          models: models,
          isLive: isLive,
          onExplain: onExplain,
          initExplain: initExplain,
          id: id,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.translate(
        offset: Offset(
            0, (1 - Curves.easeInOutCubic.transform(animation.value)) * 500),
        child: child,
      );
    },
    barrierColor: Colors.black26,
    barrierLabel: 'label',
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 500),
  );
}
