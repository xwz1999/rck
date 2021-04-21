/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/24  5:21 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

/*
  callback
 */
typedef AlertItemClickListener = Function(int index);
typedef DeleteItemClickListener = Function();

class _Styles {
  static final Color lineColor = Colors.grey[200];
  static final TextStyle contentStyle = TextStyle(
    color: Colors.black,
    fontSize: 14 * 2.sp,
  );
  static final TextStyle normalTextStyle = TextStyle(
      color: Colors.black, fontSize: 15 * 2.sp, fontWeight: FontWeight.w500);
  static final TextStyle deleteTextStyle = TextStyle(
      color: Colors.red, fontSize: 15 * 2.sp, fontWeight: FontWeight.w500);
  static final TextStyle disableTextStyle = TextStyle(
      color: Colors.grey, fontSize: 15 * 2.sp, fontWeight: FontWeight.w500);
}

class Alert {
  static show(BuildContext context, Dialog dialog) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return dialog;
        });
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

enum NormalTextDialogType { normal, delete }

///普通文本弹框
class NormalTextDialog extends Dialog {
  final String title;
  final String content;
  final String deleteItem;
  final List<String> items;
  final AlertItemClickListener listener;
  final DeleteItemClickListener deleteListener;
  final NormalTextDialogType type;

  const NormalTextDialog(
      {this.title,
      this.content,
      this.deleteItem = "删除",
      this.items,
      this.listener,
      this.deleteListener,
      this.type = NormalTextDialogType.normal})
      : assert(content != null, "content 不能为空");

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: _buildContent());
  }

  Container _buildContent() {
    return Container(
      padding: EdgeInsets.only(top: 8.0 * 2.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(mainAxisSize: MainAxisSize.min, children: _children()),
    );
  }

  _children() {
    List<Widget> children = [];
    if (this.title != null) {
      children.add(Container(
        padding: EdgeInsets.only(top: rSize(10)),
        child: Text(
          this.title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16 * 2.sp,
              fontWeight: FontWeight.w600),
        ),
      ));
    }

    children.add(Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(25), vertical: rSize(15)),
      child: Text(
        this.content,
        style: _Styles.contentStyle,
        textAlign: TextAlign.center,
      ),
    ));

    children.add(Container(
      height: 0.5,
      color: _Styles.lineColor,
    ));

    children.add(Container(
        height: rSize(40),
        child: Row(
          children: _buildItems(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
        )));

    return children;
  }

  _buildItems() {
    List<Widget> _items = this.items.map((String title) {
      int index = items.indexOf(title);
      return Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: index == this.items.length - 1 &&
                    this.type == NormalTextDialogType.normal
                ? null
                : Border(
                    right: BorderSide(
                        color: _Styles.lineColor, width: 0.5 * 2.w))),
        child: CustomImageButton(
            padding: EdgeInsets.symmetric(vertical: 8.0 * 2.w),
            title: title,
            onPressed: this.listener == null
                ? null
                : () {
                    this.listener(index);
                  },
            style: _Styles.normalTextStyle,
            disableStyle: _Styles.disableTextStyle),
      ));
    }).toList();

    if (this.type == NormalTextDialogType.delete) {
      _items.add(Expanded(
          child: Container(
        child: CustomImageButton(
            padding: EdgeInsets.symmetric(vertical: rSize(8)),
            title: this.deleteItem,
            onPressed: this.deleteListener == null
                ? null
                : () {
                    this.deleteListener();
                  },
            style: _Styles.deleteTextStyle,
            disableStyle: _Styles.disableTextStyle),
      )));
    }

    return _items;
  }
}

class NormalContentDialog extends Dialog {
  final String title;
  final Widget content;
  final String deleteItem;
  final List<String> items;
  final AlertItemClickListener listener;
  final DeleteItemClickListener deleteListener;
  final NormalTextDialogType type;

  NormalContentDialog({
    @required this.title,
    this.content,
    this.deleteItem,
    @required this.items,
    this.listener,
    this.deleteListener,
    this.type = NormalTextDialogType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: _buildContent());
  }

  Container _buildContent() {
    return Container(
      padding: EdgeInsets.only(top: 8.0 * 2.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _children(),
      ),
    );
  }

  _children() {
    List<Widget> children = [];
    if (this.title != null) {
      children.add(Container(
        padding: EdgeInsets.only(top: rSize(10)),
        child: Text(
          this.title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16 * 2.sp,
              fontWeight: FontWeight.w600),
        ),
      ));
    }

    children.add(Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(25), vertical: rSize(15)),
      // child: Text(this.content, style: _Styles.contentStyle),
      child: this.content,
    ));

    children.add(Container(
      height: 0.5,
      color: _Styles.lineColor,
    ));

    children.add(Container(
        height: rSize(40),
        child: Row(
          children: _buildItems(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
        )));

    return children;
  }

  _buildItems() {
    List<Widget> _items = this.items.map((String title) {
      int index = items.indexOf(title);
      return Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: index == this.items.length - 1 &&
                    this.type == NormalTextDialogType.normal
                ? null
                : Border(
                    right: BorderSide(
                        color: _Styles.lineColor, width: 0.5 * 2.w))),
        child: CustomImageButton(
            padding: EdgeInsets.symmetric(vertical: 8.0 * 2.w),
            title: title,
            onPressed: this.listener == null
                ? null
                : () {
                    this.listener(index);
                  },
            style: _Styles.normalTextStyle,
            disableStyle: _Styles.disableTextStyle),
      ));
    }).toList();

    if (this.type == NormalTextDialogType.delete) {
      _items.add(Expanded(
          child: Container(
        child: CustomImageButton(
            padding: EdgeInsets.symmetric(vertical: rSize(8)),
            title: this.deleteItem,
            onPressed: this.deleteListener == null
                ? null
                : () {
                    this.deleteListener();
                  },
            style: _Styles.deleteTextStyle,
            disableStyle: _Styles.disableTextStyle),
      )));
    }

    return _items;
  }
}
