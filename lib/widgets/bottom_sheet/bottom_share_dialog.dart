/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/30  9:43 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

typedef ShareAction = Function(int index);

class BottomShareWidget extends StatefulWidget {
  BottomShareWidget({this.customTitle, this.action, this.items});

  final Widget? customTitle;
  final List<PlatformItem>? items;
  final ShareAction? action;

  @override
  State<StatefulWidget> createState() {
    return _BottomShareWidgetState();
  }
}

class _BottomShareWidgetState extends State<BottomShareWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: SafeArea(
            bottom: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.customTitle ??
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "分享至",
                        style: AppTextStyle.generate(15,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: widget.items!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        childAspectRatio: widget.items!.length <= 3 ? 1 : 1.3),
                    itemBuilder: (context, index) {
                      PlatformItem item = widget.items![index];
                      return CustomImageButton(
                        title: item.title,
                        contentSpacing: 5,
                        icon: item.icon,
                        style: AppTextStyle.generate(
                          12 * 2.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff666666),
                        ),
                        onPressed: () {
                          if (item.itemClick != null) {
                            item.itemClick!();
                          }
                          widget.action!(index);
                        },
                      );
                    }),
                MaterialButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Color(0xfff8f9fb), width: 1))),
                    child: Text(
                      "取消",
                      style:
                          AppTextStyle.generate(14, color: Color(0xff333333)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class PlatformItem {
  String title;
  Widget icon;
  Function? itemClick;
  PlatformItem(this.title, this.icon, {this.itemClick});
}

class ShareDialog {
  static show(BuildContext? context,
      {List<PlatformItem>? items,
      required ShareAction action,
      Widget? customTitle}) {
    // showCustomModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return BottomShareWidget(
    //         customTitle: customTitle,
    //         action: action,
    //         items: items,
    //       );
    //     });
    Get.bottomSheet(
      BottomShareWidget(
            customTitle: customTitle,
            action: action,
            items: items,
          ),
    );
  }

  static dismiss(BuildContext context) {
    Navigator.maybePop(context);
  }
}
