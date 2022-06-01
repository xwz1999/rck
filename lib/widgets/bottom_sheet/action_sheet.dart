/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/5  3:14 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:recook/widgets/custom_image_button.dart';

class _ActionSheetWidget extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> subTitles;
  final ActionSheetItemClickListener listener;

  _ActionSheetWidget({this.title, this.items, this.subTitles, this.listener})
      : assert(items != null && items.length > 0);

  @override
  __ActionSheetWidgetState createState() => __ActionSheetWidgetState();
}

class __ActionSheetWidgetState extends State<_ActionSheetWidget> {
  double _itemFont = 15 * 2.sp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white.withAlpha(220),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.title != null
                ? Container(
                    height: 40.rw,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style: TextStyle(color: Colors.grey, fontSize: 14 * 2.sp),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(bottom: 3, top: 1),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.items.length,
                    itemBuilder: (_, index) {
                      return _buildItem(index);
                    }),
              ),
            ),
            Container(
              color: Colors.white,
              child: SafeArea(
                bottom: true,
                child: Container(
                  height: rSize(40),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "取消",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: _itemFont,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(int index) {
    String item = widget.items[index];
    String subTitle;
    if (widget.subTitles != null && index < widget.subTitles.length) {
      subTitle = widget.subTitles[index];
    }
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: CustomImageButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (widget.listener != null) {
            widget.listener(index);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: rSize(12)),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: _itemFont,
                      fontWeight: FontWeight.w400),
                ),
                subTitle != null
                    ? Text(
                        subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12 * 2.sp,
                            fontWeight: FontWeight.w400),
                      )
                    : Container(),
              ],
            )),
      ),
    );
  }
}

typedef ActionSheetItemClickListener = Function(int index);

class ActionSheet {
  static show(BuildContext context,
      {String title,
      List<String> items,
      List<String> subTitles,
      ActionSheetItemClickListener listener}) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return _ActionSheetWidget(
            title: title,
            items: items,
            subTitles: subTitles,
            listener: listener,
          );
        });
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
    //Navigator.maybePop(context);
  }
}
