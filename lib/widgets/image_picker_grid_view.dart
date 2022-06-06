/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/13  9:38 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ImagePickerGridView extends StatefulWidget {
  final int crossItemCount;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List items;

  const ImagePickerGridView({
    Key? key,
    this.crossItemCount = 4,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(5.0),
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
    required this.items,
  });

  @override
  State<StatefulWidget> createState() {
    return _ImagePickerGridViewState();
  }
}

class _ImagePickerGridViewState extends State<ImagePickerGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: GridView.builder(
          padding: widget.padding,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            crossAxisCount: widget.crossItemCount,
          ),
          itemBuilder: (_, index) {
            return _buildDragItem(index);
          }),
    );
  }

  _buildDragItem(int index) {
    return LayoutBuilder(builder: (context, constraints) {
      return LongPressDraggable(
          data: index,
          child: DragTarget<int>(
            builder: (context, data, rejects) {
              print(data);
              return _buildItem();
            },
            onAccept: (fromindex) {
              print("onAccept --- $fromindex");
            },

            onLeave: (fromindex) {
              print("onLeave --- $fromindex");
            },

            onWillAccept: (froIndex) {
              print("onWillAccept --- $froIndex");

              return true;
            },
          ),
          childWhenDragging: Container(),
          feedback: Container(
            width: 100,
            height: 100,
            color: Colors.orange,
          ));
    });
  }

  _buildItem() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomImageButton(
                backgroundColor: Colors.blueGrey,
              )),
          Positioned(
              right: 0,
              top: 0,
              child: CustomImageButton(
                icon: Icon(
                  AppIcons.icon_delete,
                  color: Colors.grey[800],
                  size: 20,
                ),
                backgroundColor: Colors.white30,
              ))
        ],
      ),
    );
  }
}
