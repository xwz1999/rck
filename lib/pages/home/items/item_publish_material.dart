/*
 * ====================================================
 * package   : pages.home.items
 * author    : Created by nansi.
 * time      : 2019/5/28  3:38 PM 
 * remark    : 
 * ====================================================
 */


import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/material_list_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/nine_grid_view.dart';

class PublishMaterialItem extends StatefulWidget {
  final VoidCallback focusListener;
  // final VoidCallback publishMaterialListener;
  final void Function(Goods) publishMaterialListener;
  final VoidCallback downloadListener;
  final VoidCallback copyListener;
  final VoidCallback moreListener;
  final void Function(int index) picListener;
  final MaterialModel model;

  const PublishMaterialItem(
      {Key key,
      this.focusListener,
      this.publishMaterialListener,
      this.downloadListener,
      this.moreListener,
      this.picListener,
      this.model,
      this.copyListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PublishMaterialItemState();
  }
}

class _PublishMaterialItemState extends State<PublishMaterialItem> {
  // bool _focused;

  @override
  void initState() {
    super.initState();
    // _focused = false;
  }

  @override
  Widget build(BuildContext context) {
    // List<String> list = [
    //   "http://pic1.win4000.com/mobile/2019-05-16/5cdd0991ec539.jpg",
    //   "http://img.tukexw.com/img/2c95d3d0d00cde29.jpg"
    // ];
    // int index11 = Random().nextInt(2);
    // int itemCount = Random().nextInt(5) + 1;
    int itemCount = widget.model.photos.length;
    Color focusedColor =
        !widget.model.isAttention ? Color(0xFFFF1E31) : Colors.grey[600];

    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CustomCacheImage(
                  fit: BoxFit.cover,
                  imageUrl: Api.getResizeImgUrl(widget.model.headImgUrl, 300),
                  placeholder: AppImageName.placeholder_1x1,
                  height: 40,
                  width: 40,
                ),
              ),
              Container(
                width: 8,
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
              widget.model.isOfficial
                  ? Container()
                  : CustomImageButton(
                      title: widget.model.isAttention ? "已关注" : "关注",
                      color: focusedColor,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: focusedColor, width: 0.8),
                      onPressed: () {
                        setState(() {
                          // _focused = !_focused;
                          widget.focusListener();
                        });
                      },
                    )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NineGridView(
                  builder: (context, index) {
                    return CustomCacheImage(
                        imageClick: () {
                          // DPrint.printf("点击了图片——————${widget.model.photos[index].url}");
                          widget.picListener(index);
                        },
                        // imageUrl: list[index11],
                        imageUrl: Api.getResizeImgUrl(
                            widget.model.photos[index].url, 300),
                        placeholder: AppImageName.placeholder_1x1,
                        fit: itemCount != 1 ? BoxFit.cover : BoxFit.scaleDown);
                  },
                  type: GridType.weChat,
                  itemCount: itemCount,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.model.text,
                    style: AppTextStyle.generate(15,
                        color: Colors.grey[700], fontWeight: FontWeight.w300),
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _bottomItems()
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _bottomItems() {
    if (!UserManager.instance.haveLogin) {
      return Row(
        children: <Widget>[
          Container(
            height: 1,
          )
        ],
      );
    }
    return Row(
      children: <Widget>[
        // CustomImageButton(
        //   icon: Icon(
        //     AppIcons.icon_wx_circle,
        //     size: 20,
        //   ),
        //   height: 30,
        //   title: "一键发圈",
        //   direction: Direction.horizontal,
        //   color: Colors.white,
        //   fontSize: ScreenAdapterUtils.setSp(12),
        //   backgroundColor: AppColor.themeColor,
        //   contentSpacing: 8,
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   onPressed: () {
        //     if (widget.publishMaterialListener != null && widget.model.goods != null) widget.publishMaterialListener(widget.model.goods);
        //   },
        // ),
        // Container(
        //   width: 10,
        // ),
        CustomImageButton(
          icon: Icon(
            AppIcons.icon_download,
            size: 16,
          ),
          height: 30,
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
        // IconButton(
        //     icon: Icon(
        //       AppIcons.icon_ellipsis,
        //       size: 20,
        //       color: Colors.grey[700],
        //     ),
        //     onPressed: () {
        //       DPrint.printf("obj");
        //     })
      ],
    );
  }
}
