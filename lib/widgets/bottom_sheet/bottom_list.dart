/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-20  09:41 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';

class _BottomListWidget<T> extends StatelessWidget {
  final String title;
  final List<T> data;
  final Function(int index, T data) itemBuilder;
  final Function(int index, T data) clickListener;

  const _BottomListWidget(
      {@required this.data,
      @required this.itemBuilder,
      this.clickListener,
      this.title})
      // : assert(data != null && data.length > 0),
      : assert(data != null),
        assert(itemBuilder != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        constraints: BoxConstraints(maxHeight: DeviceInfo.screenHeight * 0.6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(rSize(8)))),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    vertical: rSize(8), horizontal: rSize(10)),
                child: Row(
                  children: <Widget>[
                    Offstage(
                      child: Text(
                        title,
                        style: AppTextStyle.generate(14 * 2.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      offstage: TextUtils.isEmpty(title),
                    ),
                    Spacer(),
                    CustomImageButton(
                      icon: Icon(
                        AppIcons.icon_delete,
                        size: rSize(18),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )),
            Expanded(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    return CustomImageButton(
                      child: itemBuilder(index, data[index]),
                      onPressed: () {
                        Navigator.pop(context);
                        if (clickListener != null) {
                          clickListener(index, data[index]);
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomList {
  static show<T>(BuildContext context,
      {String title,
      List<T> data,
      Function(int index, T data) itemBuilder,
      Function(int index, T data) clickListener}) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return _BottomListWidget<T>(
            title: title,
            data: data,
            itemBuilder: itemBuilder,
            clickListener: clickListener,
          );
        });
  }
}
