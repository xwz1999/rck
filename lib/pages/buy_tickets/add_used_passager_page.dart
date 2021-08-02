import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'airplane_reserve_page.dart';
import 'functions/passager_func.dart';
import 'models/passager_model.dart';

class AddUsedPassagerPage extends StatefulWidget {
  final int type;
  final PassagerModel item;
  AddUsedPassagerPage({
    Key key,
    @required this.type,
    this.item,
  }) : super(key: key);

  @override
  _AddUsedPassagerPageState createState() => _AddUsedPassagerPageState();
}

class _AddUsedPassagerPageState extends State<AddUsedPassagerPage> {
  List<PassagerModel> _passengerList = [];
  String _name = '';
  String _num = '';
  String _phone = '';
  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;
  String _code = '';
  @override
  void initState() {
    super.initState();
    print(widget.type);
    if (widget.item != null) {
      _controller1 = new TextEditingController(text: widget.item.name);
      _controller2 =
          new TextEditingController(text: widget.item.residentIdCard);
      _controller3 = new TextEditingController(text: widget.item.phone);
      _name = widget.item.name;
      _num = widget.item.residentIdCard;
      _phone = widget.item.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        elevation: 0,
        title: widget.type == 1 ? '添加常用旅客' : '编辑常用旅客',
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      floatingActionButton: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 25.rw),
        width: 345.rw,
        child: widget.type == 1 ? _addPassger() : _addDeletePassger(),
      ),
      body: _bulidBody(),
    );
  }

  _bulidBody() {
    return Column(
      children: [
        _editItem('乘客姓名', '请输入乘客姓名', 1),
        _divider(),
        _editItem('证件类型', '身份证', 2),
        _divider(),
        _editItem('证件号码', '请填写证件号码', 3),
        _divider(),
        _editItem('手机号码', '请填写手机号码', 4),
      ],
    );
  }

  _editItem(String head, String content, int type) {
    return Container(
      color: Colors.white,
      height: 48.rw,
      padding: EdgeInsets.symmetric(horizontal: 15.rw),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            10.wb,
            Text(
              head,
              style: TextStyle(fontSize: 16.rsp, color: Color(0xFF333333)),
            ),
            30.wb,
            type != 2
                ? TextField(
                    inputFormatters: [
                      type == 3 || type == 4
                          ? FilteringTextInputFormatter.digitsOnly
                          : FilteringTextInputFormatter.singleLineFormatter,
                      type == 3
                          ? LengthLimitingTextInputFormatter(18)
                          : type == 4
                              ? LengthLimitingTextInputFormatter(11)
                              : LengthLimitingTextInputFormatter(20)
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.rw),
                      hintText: content,
                      border: InputBorder.none,
                      hintStyle: AppTextStyle.generate(14 * 2.sp,
                          color: Color(0xff666666)),
                    ),
                    controller: type == 1
                        ? _controller1
                        : type == 3
                            ? _controller2
                            : _controller3,
                    keyboardType: type == 3 || type == 4
                        ? TextInputType.number
                        : TextInputType.text,
                    style: AppTextStyle.generate(14 * 2.sp),
                    maxLength: 18,
                    maxLines: 1,
                    onChanged: (text) {
                      if (type == 1) {
                        _name = text;
                      } else if (type == 3) {
                        _num = text;
                      } else if (type == 4) {
                        _phone = text;
                      }
                    },
                  ).expand()
                : Row(
                    children: [
                      20.wb,
                      Text(
                        content,
                        style: TextStyle(
                            fontSize: 14.rsp, color: Color(0xFF333333)),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  _addPassger() {
    return CustomImageButton(
      height: 48.rw,
      //padding: EdgeInsets.symmetric(vertical: 8),
      title: "保存旅客信息",
      backgroundColor: AppColor.themeColor,
      color: Colors.white,
      fontSize: 16 * 2.sp,
      borderRadius: BorderRadius.all(Radius.circular(4.rw)),
      onPressed: () async {
        if (_name == '') {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "请您先输入您的姓名",
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                },
              ));
        } else if (_num == '') {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "请您先输入您的身份证号",
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                },
              ));
        } else if (_phone == '') {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "请您先输入您的手机号码",
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                },
              ));
        } else {
          _code = await PassagerFunc.addPassager(
              null, UserManager.instance.user.info.id, _name, _num, _phone);
        }
        if (_code == 'SUCCESS') {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "保存成功！",
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                  Get.back(result: 'SUCCESS');
                },
              ));
        }
      },
    );
  }

  _addDeletePassger() {
    return Row(
      children: [
        CustomImageButton(
          height: 48.rw,
          width: 116.rw,
          //padding: EdgeInsets.symmetric(vertical: 8),
          title: "删除",
          backgroundColor: Colors.white,
          color: AppColor.themeColor,
          fontSize: 16 * 2.sp,
          borderRadius: BorderRadius.all(Radius.circular(4.rw)),
          border: Border.all(color: AppColor.themeColor, width: 1.rw),
          onPressed: () async {
            Alert.show(
                context,
                NormalTextDialog(
                  type: NormalTextDialogType.delete,
                  content: "是否删除这条旅客信息？",
                  items: ["取消"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                  deleteItem: "删除",
                  deleteListener: () async {
                    Alert.dismiss(context);
                    _code = await PassagerFunc.deletePassager(widget.item.id);
                    if (_code == 'SUCCESS') {
                      Alert.show(
                          context,
                          NormalTextDialog(
                            type: NormalTextDialogType.normal,
                            title: "提示",
                            content: "删除成功！",
                            items: ["确认"],
                            listener: (index) {
                              Alert.dismiss(context);
                              Get.back(result: 'SUCCESS');
                            },
                          ));
                    }
                  },
                ));
          },
        ),
        20.wb,
        CustomImageButton(
          height: 48.rw,
          width: 219.rw,
          //padding: EdgeInsets.symmetric(vertical: 8),
          title: "保存旅客信息",
          backgroundColor: AppColor.themeColor,
          color: Colors.white,
          fontSize: 16 * 2.sp,
          borderRadius: BorderRadius.all(Radius.circular(4.rw)),
          onPressed: () async {
            if (_name == '') {
              Alert.show(
                  context,
                  NormalTextDialog(
                    type: NormalTextDialogType.normal,
                    title: "提示",
                    content: "请您先输入您的姓名",
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                    },
                  ));
            } else if (_num == '') {
              Alert.show(
                  context,
                  NormalTextDialog(
                    type: NormalTextDialogType.normal,
                    title: "提示",
                    content: "请您先输入您的身份证号",
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                    },
                  ));
            } else if (_phone == '') {
              Alert.show(
                  context,
                  NormalTextDialog(
                    type: NormalTextDialogType.normal,
                    title: "提示",
                    content: "请您先输入您的手机号码",
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                    },
                  ));
            } else {
              _code = await PassagerFunc.addPassager(widget.item.id,
                  UserManager.instance.user.info.id, _name, _num, _phone);
            }
            if (_code == 'SUCCESS') {
              Alert.show(
                  context,
                  NormalTextDialog(
                    type: NormalTextDialogType.normal,
                    title: "提示",
                    content: "保存成功！",
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                      Get.back(result: 'SUCCESS');
                    },
                  ));
            }
          },
        )
      ],
    );
  }

  _divider() {
    return Divider(
      color: Color(0xFFEEEEEE),
      height: 0.5.rw,
      thickness: rSize(0.5),
    );
  }
}
