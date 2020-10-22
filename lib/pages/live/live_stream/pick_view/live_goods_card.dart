import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/live/live_stream/pick_view/brand_goods_list_view.dart';
import 'package:recook/pages/live/live_stream/pick_view/pick_cart.dart';
import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/live/models/live_brand_model.dart';
import 'package:recook/pages/user/widget/recook_check_box.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';

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
    final bool picked = PickCart.picked
            .indexWhere((element) => element.id == widget.model.id) !=
        -1;
    return SizedBox(
      width: rSize(200),
      height: rSize(100 + 15.0),
      child: MaterialButton(
        onPressed: () {
          if (picked)
            PickCart.picked.removeWhere((e) => e.id == widget.model.id);
          else {
            if (PickCart.picked.length < 50)
              PickCart.picked.add(widget.model);
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
            ClipRRect(
              borderRadius: BorderRadius.circular(rSize(4)),
              child: Container(
                color: AppColor.frenchColor,
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(widget.model.mainPhotoUrl),
                  height: rSize(100),
                  width: rSize(100),
                ),
              ),
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
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      fontSize: rSP(15),
                    ),
                  ),
                  // Text(
                  //   widget.model.description,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                  //       color: Colors.black54, fontWeight: FontWeight.w300),
                  // ),
                  Spacer(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          PickCart.brandModel = LiveBrandModel(
                            id: widget.model.brandId,
                            name: widget.model.brandName,
                            logoUrl: widget.model.brandImg,
                          );
                          CRoute.push(
                            context,
                            RecookScaffold(
                              title: '品牌馆',
                              whiteBg: true,
                              body: BrandGoodsListView(
                                onPick: () {},
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                              image: Api.getImgUrl(widget.model.brandImg),
                              width: rSize(13),
                              height: rSize(13),
                            ),
                            rWBox(4),
                            Text(
                              widget.model.brandName,
                              style: TextStyle(
                                color: Color(0xffc70404),
                                fontSize: ScreenAdapterUtils.setSp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '¥${widget.model.originalPrice}'),
                        TextSpan(
                            text: '/赚${widget.model.commission}',
                            style: TextStyle(
                              color: Color(0xFFC92219),
                            )),
                      ],
                    ),
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: rSP(14),
                    ),
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
