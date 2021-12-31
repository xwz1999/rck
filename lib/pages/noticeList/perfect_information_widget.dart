import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/input_view.dart';

class PerfectInformationWidget extends StatefulWidget {
  final Function(String) onSubmit;
  final Function onClose;
  PerfectInformationWidget({Key key, this.onClose, this.onSubmit})
      : super(key: key);

  @override
  _PerfectInformationWidgetState createState() =>
      _PerfectInformationWidgetState();
}

class _PerfectInformationWidgetState extends State<PerfectInformationWidget> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          height: 200 * 2.h,
          width: ScreenUtil().screenWidth,
          margin: EdgeInsets.symmetric(horizontal: rSize(50)),
          padding:
              EdgeInsets.symmetric(horizontal: rSize(10), vertical: 10 * 2.h),
          child: Column(
            children: <Widget>[
              Container(
                height: 30 * 2.h,
                alignment: Alignment.center,
                child: Text(
                  "完善信息",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 18 * 2.sp),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40 * 2.h,
                      child: InputView(
                        controller: _textEditingController,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        hint: "请输入您的昵称",
                        hintStyle: TextStyle(
                            color: AppColor.greyColor,
                            fontSize: 16 * 2.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      color: AppColor.frenchColor,
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              CustomImageButton(
                width: double.infinity,
                height: 30 * 2.h,
                backgroundColor: AppColor.redColor,
                borderRadius: BorderRadius.circular(30 * 2.h / 2),
                title: "确定",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 18 * 2.sp,
                    decoration: TextDecoration.none),
                onPressed: () {
                  if (TextUtils.isEmpty(_textEditingController.text)) {
                    GSDialog.of(context).showError(context, "请输入您的昵称");
                    return;
                  }
                  if (widget.onSubmit != null)
                    widget.onSubmit(_textEditingController.text);
                },
              ),
              CustomImageButton(
                width: double.infinity,
                height: 30 * 2.h,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(30 * 2.h / 2),
                title: "跳过",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColor.greyColor,
                    fontSize: 15 * 2.sp,
                    decoration: TextDecoration.none),
                onPressed: () {
                  if (widget.onClose != null) widget.onClose();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
