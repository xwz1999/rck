/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-30  09:24 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ImageSelectedView<T> extends StatefulWidget {
  final int maxImages;
  final int crossAxisCount;
  final EdgeInsetsGeometry padding;
  final double axisSpacing;
  final double crossAxisSpacing;
  final List<T> images;
  final VoidCallback? addListener;
  final Function(int index)? clickListener;
  final Function(int index)? deleteListener;
  final Widget Function(int index, T item) itemBuilder;

  const ImageSelectedView({
    Key? key,
    required this.itemBuilder,
    required this.images,
    this.maxImages = 9,
    this.crossAxisCount = 4,
    this.padding = const EdgeInsets.all(3),
    this.axisSpacing = 5,
    this.crossAxisSpacing = 5,
    this.addListener,
    this.clickListener,
    this.deleteListener,
  })  : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageSelectedViewState();
  }
}

class _ImageSelectedViewState extends State<ImageSelectedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: widget.padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.axisSpacing),
          itemCount: widget.images.length >= widget.maxImages
              ? widget.images.length
              : widget.images.length + 1,
          itemBuilder: (_, index) {
            if (index == widget.images.length) {
              return CustomImageButton(
                border: Border.all(
                    style: BorderStyle.solid,
                    width: 0.3 * 2.w,
                    color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(8.rw)),
                icon: Icon(AppIcons.icon_add, color: Colors.grey),
                color: Colors.grey,
                title: "添加图片",
                fontSize: 14 * 2.sp,
                contentSpacing: rSize(10),
                onPressed: () {
                  if (widget.addListener != null) {
                    widget.addListener!();
                  }
                },
              );
            }
            return Container(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  widget.itemBuilder(index, widget.images[index]),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CustomImageButton(
                      icon: Icon(
                        AppIcons.icon_delete,
                        color: Colors.white,
                        size: rSize(18),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.rw)),
                      backgroundColor: Colors.black38,
                      onPressed: () {
                        if (widget.deleteListener != null) {
                          widget.deleteListener!(index);
                        }
                        // setState(() {
                        // widget.images.removeAt(index);
                        // });
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
