/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-19  13:29
 * remark    :
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/logistic_list_model.dart';

class LogisticDetailItem extends StatelessWidget {
  final LogisticStatus? expressStatus;
  final bool firstItem;
  final bool lastItem;

  const LogisticDetailItem(
      {Key? key,
      this.expressStatus,
      this.firstItem = false,
      this.lastItem = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildItem(context);
  }

  _buildItem(context) {
    return Row(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _time(),
        SizedBox(
          width: 5,
        ),
        _line(context),
        SizedBox(
          width: 5,
        ),
        _context()
      ],
    );
  }

  _time() {
    return Container(
      width: rSize(80),
      child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
              text: expressStatus!.ftime!.substring(0, 10),
              style: AppTextStyle.generate(13 * 2.sp, color: Colors.grey),
              children: [
                TextSpan(
                    text: "\n${expressStatus!.ftime!.substring(10)}",
                    style: AppTextStyle.generate(12 * 2.sp,
                        color: Colors.grey, fontWeight: FontWeight.w300))
              ])),
    );
  }

  _line(context) {
    double dotSize = firstItem ? rSize(12) : rSize(7);
    Color? dotColor = firstItem ? AppColor.themeColor : Colors.grey[400];

    return Container(
      constraints: BoxConstraints(
        maxHeight: rSize(75),
      ),
      width: rSize(15),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              child: Container(
            width: 0.5 * 2.w,
            color: firstItem ? Colors.transparent : Colors.grey[300],
          )),
          Container(
            margin: EdgeInsets.symmetric(vertical: rSize(5)),
            padding: EdgeInsets.symmetric(vertical: rSize(10)),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
                color: dotColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Flexible(
              child: Container(
            width: 0.5 * 2.w,
            color: lastItem ? Colors.transparent : Colors.grey[300],
          )),
        ],
      ),
    );
  }

  _context() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          expressStatus!.context!,
          style: AppTextStyle.generate(
              ScreenAdapterUtils.setWidth(firstItem ? 14 : 13),
              color: firstItem ? Colors.black : Colors.grey[500]),
          // maxLines: 3,
        ),
      ),
    );
  }
}
