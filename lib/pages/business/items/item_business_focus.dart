/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  2:59 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/nine_grid_view.dart';

// import 'package:fluwx/fluwx.dart' as fluwx;

class BusinessFocusItem extends StatefulWidget {
  final VoidCallback focusListener;
  final VoidCallback publishMaterialListener;
  final VoidCallback downloadListener;
  final VoidCallback copyListener;
  final Function(int) picListener;
  final VoidCallback moreListener;
  final MaterialModel model;

  const BusinessFocusItem(
      {Key key,
      this.focusListener,
      this.publishMaterialListener,
      this.downloadListener,
      this.picListener,
      this.moreListener,
      this.model,
      this.copyListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BusinessFocusItemState();
  }
}

class _BusinessFocusItemState extends State<BusinessFocusItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.model.photos.length;
    Color focusedColor =
        !widget.model.isAttention ? Color(0xFFFF1E31) : Colors.grey[600];

    return Container(
      margin: EdgeInsets.only(bottom: rSize(5), top: rSize(5)),
      padding: EdgeInsets.symmetric(horizontal: rSize(15), vertical: rSize(15)),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _header(focusedColor),
          Container(
            margin: EdgeInsets.only(top: rSize(10), left: rSize(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NineGridView(
                  builder: (context, index) {
                    return CustomCacheImage(
                        imageClick: () {
                          // DPrint.printf("点击了图片----${widget.model.goods.mainPhotoURL}");
                          widget.picListener(index);
                        },
                        imageUrl: Api.getResizeImgUrl(
                            widget.model.photos[index].url, 300),
                        placeholder: AppImageName.placeholder_1x1,
                        fit: itemCount != 1 ? BoxFit.cover : BoxFit.scaleDown);
                  },
                  type: GridType.weChat,
                  itemCount: itemCount,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: rSize(10)),
                  child: Text(
                    widget.model.text,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                        color: Colors.grey[700], fontWeight: FontWeight.w300),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _shareLink(),
                _bottomItems()
              ],
            ),
          )
        ],
      ),
    );
  }

  _shareLink() {
    if (widget.model.goods == null ||
        TextUtils.isEmpty(widget.model.goods.name)) return Container();
    Widget content = Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFFF2F4F7),
      child: Row(
        children: <Widget>[
          CustomCacheImage(
            imageUrl: Api.getResizeImgUrl(widget.model.goods.mainPhotoURL, 100),
            placeholder: AppImageName.placeholder_1x1,
            height: rSize(50),
            width: rSize(50),
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: rSize(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.goods.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                        fontWeight: FontWeight.w300, color: Colors.grey[600]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: rSize(5)),
                    child: Text(
                      "￥${widget.model.goods.price.toString()}",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                          fontWeight: FontWeight.w300, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomImageButton(
            icon: Icon(AppIcons.icon_share),
            onPressed: () {
              if (widget.publishMaterialListener != null) {
                widget.publishMaterialListener();
              }
            },
          )
        ],
      ),
    );
    return GestureDetector(
      child: content,
      onTap: () {
        if (widget.publishMaterialListener != null) {
          widget.publishMaterialListener();
        }
      },
    );
  }

  Row _header(Color focusedColor) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getResizeImgUrl(widget.model.headImgUrl, 300),
            placeholder: AppImageName.placeholder_1x1,
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
                widget.model.nickname,
                style: AppTextStyle.generate(15),
              ),
              Text(
                widget.model.createdAt,
                style: AppTextStyle.generate(12, color: Colors.grey),
              ),
            ],
          ),
        ),
        // widget.model.isOfficial
        //     ? Container()
        //     : CustomImageButton(
        //         title: widget.model.isAttention ? "已关注" : "关注",
        //         color: focusedColor,
        //         padding: EdgeInsets.symmetric(horizontal: rSize(8)),
        //         borderRadius: BorderRadius.all(Radius.circular(5)),
        //         border: Border.all(color: focusedColor, width: 0.8),
        //         onPressed: () {
        //           setState(() {
        //             widget.focusListener();
        //           });
        //         },
        //       )
      ],
    );
  }

  Widget _bottomItems() {
    return Container(
      margin: EdgeInsets.only(top: rSize(19)),
      child: Row(
        children: <Widget>[
          // CustomImageButton(
          //   icon: Icon(
          //     AppIcons.icon_wx_circle,
          //     size: rSize(16),
          //   ),
          //   height: rSize(30),
          //   title: "一键发圈",
          //   direction: Direction.horizontal,
          //   color: Colors.white,
          //   fontSize: ScreenAdapterUtils.setSp(12),
          //   backgroundColor: AppColor.themeColor,
          //   contentSpacing: 8,
          //   borderRadius: BorderRadius.all(Radius.circular(20)),
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   onPressed: () {
          //     Goods _goods = widget.model.goods;
          //     WeChatUtils.shareGoodsForMiniProgram(title: _goods.name, goodsId: _goods.id, thumbnail: Api.getImgUrl(_goods.mainPhotoURL));
          //   },
          // ),
          // Container(
          //   width: 10,
          // ),
          CustomImageButton(
            icon: Icon(
              AppIcons.icon_download,
              size: rSize(16),
            ),
            height: rSize(30),
            title: "下载发圈",
            direction: Direction.horizontal,
            color: Colors.black,
            fontSize: ScreenAdapterUtils.setSp(12),
            backgroundColor: Color(0xFFF3F3F3),
            contentSpacing: 8,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {
              widget.downloadListener();
            },
          ),
          SizedBox(
            width: 20,
          ),
          CustomImageButton(
            icon: Icon(
              Icons.content_copy,
              size: rSize(16),
            ),
            height: rSize(30),
            title: "复制文字",
            direction: Direction.horizontal,
            color: Colors.black,
            fontSize: ScreenAdapterUtils.setSp(12),
            backgroundColor: Color(0xFFF3F3F3),
            contentSpacing: 8,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {
              widget.copyListener();
            },
          ),
          Expanded(child: Container()),
          // CustomImageButton(
          //   icon: Icon(
          //     AppIcons.icon_ellipsis,
          //     size: rSize(18),
          //     color: Colors.grey[700],
          //   ),
          //   onPressed: () {

          //   },
          // )
        ],
      ),
    );
  }
}
