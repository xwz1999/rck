import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';

class LiveGoodsCard extends StatefulWidget {
  final VoidCallback onPick;
  final GoodsList model;
  LiveGoodsCard({Key key, @required this.onPick, @required this.model})
      : super(key: key);

  @override
  _LiveGoodsCardState createState() => _LiveGoodsCardState();
}

class _LiveGoodsCardState extends State<LiveGoodsCard> {
  @override
  Widget build(BuildContext context) {
    final bool picked = PickCart.picked.containsKey(widget.model.id);
    return SizedBox(
      height: rSize(86 + 15.0),
      child: MaterialButton(
        onPressed: () {
          if (picked)
            PickCart.picked.remove(widget.model.id);
          else {
            if (PickCart.picked.length < 50)
              PickCart.picked.putIfAbsent(widget.model.id, () => widget.model);
            else
              showToast('最多只能选择50个商品');
          }

          widget.onPick();
        },
        padding: EdgeInsets.symmetric(
          horizontal: rSize(15),
          vertical: rSize(15 / 2),
        ),
        child: Row(
          children: [
            RecookCheckBox(state: picked),
            rWBox(10),
            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: Api.getImgUrl(widget.model.mainPhotoUrl),
              height: rSize(86),
              width: rSize(86),
            ),
            rWBox(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '¥${widget.model.originalPrice}',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: rSP(14),
                        ),
                      ),
                      Text(
                        '/赚${widget.model.commission}',
                        style: TextStyle(
                          color: Color(0xFFC92219),
                          fontSize: rSP(14),
                        ),
                      ),
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
}
