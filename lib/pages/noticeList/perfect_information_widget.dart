import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';

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
          height: ScreenAdapterUtils.setHeight(200),
          width: ScreenUtil().screenWidth,
          margin: EdgeInsets.symmetric(horizontal: rSize(50)),
          padding: EdgeInsets.symmetric(
              horizontal: rSize(10),
              vertical: ScreenAdapterUtils.setHeight(10)),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenAdapterUtils.setHeight(30),
                alignment: Alignment.center,
                child: Text(
                  "完善信息",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: ScreenAdapterUtils.setSp(18)),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: ScreenAdapterUtils.setHeight(40),
                      child: InputView(
                        controller: _textEditingController,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        hint: "请输入您的昵称",
                        hintStyle: TextStyle(
                            color: AppColor.greyColor,
                            fontSize: ScreenAdapterUtils.setSp(16),
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
                height: ScreenAdapterUtils.setHeight(30),
                backgroundColor: AppColor.redColor,
                borderRadius:
                    BorderRadius.circular(ScreenAdapterUtils.setHeight(30) / 2),
                title: "确定",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: ScreenAdapterUtils.setSp(18),
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
                height: ScreenAdapterUtils.setHeight(30),
                backgroundColor: Colors.white,
                borderRadius:
                    BorderRadius.circular(ScreenAdapterUtils.setHeight(30) / 2),
                title: "跳过",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColor.greyColor,
                    fontSize: ScreenAdapterUtils.setSp(15),
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
