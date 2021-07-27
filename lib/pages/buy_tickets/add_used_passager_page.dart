import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'airplane_reserve_page.dart';

class AddUsedPassagerPage extends StatefulWidget {
  final int type;
  final Item item;
  AddUsedPassagerPage({
    Key key,
    @required this.type,
    this.item,
  }) : super(key: key);

  @override
  _AddUsedPassagerPageState createState() => _AddUsedPassagerPageState();
}

class _AddUsedPassagerPageState extends State<AddUsedPassagerPage> {
  List<Item> _passengerList = [];
  String _name = '';
  String _num = '';
  TextEditingController _controller1;
  TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    print(widget.type);
    if (widget.item != null) {
      _controller1 = new TextEditingController(text: widget.item.item);
      _controller2 = new TextEditingController(text: widget.item.num);
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.rw),
                      hintText: content,
                      border: InputBorder.none,
                      hintStyle: AppTextStyle.generate(14 * 2.sp,
                          color: Color(0xff666666)),
                    ),
                    controller: type == 1 ? _controller1 : _controller2,
                    keyboardType:
                        type == 3 ? TextInputType.number : TextInputType.text,
                    style: AppTextStyle.generate(14 * 2.sp),
                    maxLength: 18,
                    maxLines: 1,
                    onChanged: (text) {
                      if (type == 1) {
                        _name = text;
                      } else if (type == 3) {
                        _num = text;
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
      onPressed: () {},
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
          onPressed: () {},
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
          onPressed: () {},
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
