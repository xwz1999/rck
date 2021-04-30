import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/tabBar/TabbarWidget.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class DeleteAcountValidationPage extends StatefulWidget {
  DeleteAcountValidationPage({Key key}) : super(key: key);

  @override
  _DeleteAcountValidationPageState createState() =>
      _DeleteAcountValidationPageState();
}

class _DeleteAcountValidationPageState
    extends State<DeleteAcountValidationPage> {
  TextEditingController _controller = TextEditingController();
  Timer _timer;
  int _timeCount = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '身份验证',
      body: Center(
        child: Column(
          children: [
            64.w.heightBox,
            '请输入短信验证码'.text.color(Color(0xFF333333)).size(60.sp).make(),
            30.w.heightBox,
            '我们将发送短信验证码到你的手机号'.text.color(Color(0xFF888888)).size(34.sp).make(),
            hidePhone(UserManager.instance.user.info.phone)
                .text
                .color(Color(0xFF333333))
                .size(48.sp)
                .make(),
            72.w.heightBox,
            _validationCode(),
            28.w.heightBox,
            _sendMessage(),
          ],
        ),
      ),
      bottomNavi: _bottomButton(),
    );
  }

  Widget _bottomButton() {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 22.w),
      minWidth: 686.w,
      height: 94.w,
      color: Color(0xFFD5101A),
      onPressed: () {
        if (_controller.text.isEmptyOrNull) {
          ReToast.err(text: '验证码不能为空');
        } else {
          _showDeleteDialog();
        }
      },
      child: '下一步'.text.color(Colors.white).size(36.sp).make(),
    ).pOnly(bottom: MediaQuery.of(context).padding.bottom);
  }

  String hidePhone(String phone) {
    if (phone.length != 11) {
      return '手机号不正确';
    } else {
      return phone.substring(0, 3) + '****' + phone.substring(7, 11);
    }
  }

  _showDeleteDialog() {
    return showDialog(
      context: context,
      builder: (context) => NormalTextDialog(
        title: '注销提示',
        content: '确定注销账户？',
        items: ['取消'],
        type: NormalTextDialogType.delete,
        listener: (index) {
          switch (index) {
            case 0:
              Get.offAll(() => TabBarWidget());
              break;
          }
        },
        deleteItem: '确定',
        deleteListener: () {
          _deleteAcount();
        },
      ),
    );
  }

  Future _deleteAcount() async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.deleteAccount, {
      "user_id": UserManager.instance.user.info.id,
      "code": _controller.text,
    });

    if (!resultData.result) {
      _controller?.clear();
      ReToast.err(text: resultData.msg);
      return;
    }
    BaseModel baseModel = BaseModel.fromJson(resultData.data);
    if (baseModel.code != HttpStatus.SUCCESS) {
      _controller?.clear();
      ReToast.err(text: resultData.msg);
      return;
    }
    UserManager.logout();
    ReToast.success(text:'注销成功');
  }

  Widget _validationCode() {
    return SizedBox(
      height: 112.w,
      width: 300.w + 114.w * 2,
      child: PinInputTextField(
        controller: _controller,
        decoration: BoxLooseDecoration(
          radius: Radius.circular(0),
          bgColorBuilder: FixedColorBuilder(Colors.white),
          strokeColorBuilder: FixedColorBuilder(
            Color(0xFFAAAAAA),
          ),
          textStyle: TextStyle(
            color: Color(0xFF000000),
            fontSize: 80.sp,
            // fontWeight: FontWeight.bold,
          ),
        ),
        cursor: Cursor(
          color: Colors.black,
          height: 80.w,
          enabled: true,
          width: 2.w,
        ),
        pinLength: 4,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {});
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
      ),
    );
  }

  Widget _sendMessage() {
    return GestureDetector(
        onTap: _timer != null
            ? null
            : () async {
                await _getValidationCode();
              },
        child: '${_timer != null ? '验证码已发送' : '点击发送验证码'}'
            .text
            .color(Color(0xFFD5101A))
            .size(34.sp)
            .make());
  }

  Future _getValidationCode() async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.getDeleteMessage, null);
    if (!resultData.result) {
      ReToast.err(text: resultData.msg);
      return;
    }
    BaseModel baseModel = BaseModel.fromJson(resultData.data);
    if (baseModel.code != HttpStatus.SUCCESS) {
      ReToast.err(text: resultData.msg);
      return;
    }
    startTimer();
    ReToast.success(text: '发送成功');
  }

  startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_timeCount <= 0) {
        _timeCount = 60;
        _controller?.clear();
        _timer.cancel();
        _timer = null;
        setState(() {});
      }
      _timeCount--;
      setState(() {});
    });
  }
}
