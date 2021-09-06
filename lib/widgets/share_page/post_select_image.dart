import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:extended_image/extended_image.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/widgets/custom_image_button.dart';

class PostSelectImage extends StatefulWidget {
  final GoodsDetailModel goodsDetailModel;
  final Function(List<MainPhotos>) selectImages;
  final EdgeInsets padding;
  
  PostSelectImage({Key key, this.goodsDetailModel, this.selectImages, this.padding = const EdgeInsets.symmetric(horizontal: 15)}) : super(key: key);

  @override
  _PostSelectImageState createState() => _PostSelectImageState();
}

class _PostSelectImageState extends State<PostSelectImage> {

  List<MainPhotos> selectImages = [];
  @override
  void initState() {
    super.initState();
    for (MainPhotos photo in widget.goodsDetailModel.data.mainPhotos) {
      if (photo.isSelect) selectImages.add(photo);
    }
    selectImages.sort((a, b){
      return a.isSelectNumber.compareTo(b.isSelectNumber);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.goodsDetailModel.data.mainPhotos.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(right: 5),
            child: _itemWidget(widget.goodsDetailModel.data.mainPhotos[index]),
          );
       },
      ),
    );
  }

  _itemWidget(MainPhotos photo){
    return CustomImageButton(
      padding: EdgeInsets.all(0),
      dotPosition: DotPosition(
        right: 5, top: 5
      ),
      onPressed: (){
        photo.isSelect = !photo.isSelect;
        if (photo.isSelect) {
          photo.isSelectNumber = selectImages.length+1;
          selectImages.add(photo);
        }else{
          selectImages.remove(photo);
        }
        for (MainPhotos selectP in selectImages) {
          selectP.isSelectNumber = selectImages.indexOf(selectP)+1;
        }
        setState(() {});
        if (widget.selectImages!=null) {
          widget.selectImages(selectImages);
        }
      },
      dotNum: photo.isSelect!=null&&photo.isSelect&&photo.isSelectNumber!=null&&photo.isSelectNumber>0?photo.isSelectNumber.toString():"",
      child: ExtendedImage.network(Api.getImgUrl(photo.url), fit: BoxFit.fill,),
      boxDecoration: BoxDecoration(
        color: AppColor.frenchColor,
        border: Border.all(color: photo.isSelect ? AppColor.themeColor : Colors.grey, width: 0.5),
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     color: AppColor.frenchColor,
    //     border: Border.all(color: Colors.grey, width: 0.2),
    //   ),
    //   margin: EdgeInsets.symmetric(horizontal: 5),
    //   child: ExtendedImage.network(Api.getImgUrl(photo.url), fit: BoxFit.fill,),
    // );
  }
}
