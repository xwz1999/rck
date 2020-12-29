/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-09-01  16:14 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/evaluation_list_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/nine_grid_view.dart';
import 'package:recook/widgets/pic_swiper.dart';

class EvaluationItem extends StatefulWidget {
  final Data evaluation;

  const EvaluationItem({Key key, this.evaluation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EvaluationItemState();
  }
}

class _EvaluationItemState extends State<EvaluationItem> {
  @override
  Widget build(BuildContext context) {
    List<String> list = [];
    if (widget.evaluation.photos != null &&
        widget.evaluation.photos.length > 0) {
      list = widget.evaluation.photos.map((photo) {
        return Api.getResizeImgUrl(photo.url, 200);
      }).toList();
    }

    return Container(
      margin: EdgeInsets.only(bottom: rSize(5), top: rSize(5)),
      padding: EdgeInsets.symmetric(horizontal: rSize(15), vertical: rSize(15)),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _header(),
          Container(
            margin: EdgeInsets.only(left: rSize(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: rSize(10)),
                  child: Text(
                    widget.evaluation.content,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                        fontWeight: FontWeight.w300),
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                list != null && list.length > 0
                    ? NineGridView(
                        builder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              List<PicSwiperItem> picSwiperItem = [];
                              widget.evaluation.photos.forEach((photo) {
                                picSwiperItem.add(
                                    PicSwiperItem(Api.getImgUrl(photo.url)));
                              });
                              AppRouter.fade(
                                context,
                                RouteName.PIC_SWIPER,
                                arguments: PicSwiper.setArguments(
                                  index: index,
                                  pics: picSwiperItem,
                                ),
                              );
                            },
                            child: CustomCacheImage(
                                imageUrl: list[index], fit: BoxFit.cover),
                          );
                        },
                        type: GridType.weChat,
                        itemCount:
                            list != null && list.length >= 0 ? list.length : 0,
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _header() {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getImgUrl(widget.evaluation.headImgUrl),
            height: rSize(40),
            width: rSize(40),
          ),
        ),
        Container(
          width: rSize(8),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.evaluation.nickname,
                style: AppTextStyle.generate(15),
              ),
              Text(
                widget.evaluation.createdAt,
                style: AppTextStyle.generate(12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
