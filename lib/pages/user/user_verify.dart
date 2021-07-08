import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/mvp/user_presenter_impl.dart';
import 'package:recook/pages/user/user_verify_result.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';

class VerifyPage extends StatefulWidget {
  final Map arguments;
  VerifyPage({Key key, this.arguments}) : super(key: key);
  // final Map arguments;
  // const VerifyPage({Key key, this.arguments}) : super(key: key);
  // static setArguments(Function callback){
  //   return {
  //     "callback": callback
  //   };
  // }

  @override
  State<StatefulWidget> createState() {
    return _VerifyPageState();
  }
}

class _VerifyPageState extends BaseStoreState<VerifyPage> {
  //http实例
  UserPresenterImpl _presenter;

  TextEditingController _nameEditController;
  TextEditingController _idCardController;

  bool _isCashWithdraw = false;

  @override
  void initState() {
    super.initState();
    _isCashWithdraw = widget.arguments == null
        ? false
        : widget.arguments['isCashWithdraw'] ?? false;
    _presenter = UserPresenterImpl();
    _nameEditController = TextEditingController();
    _idCardController = TextEditingController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        background: AppColor.frenchColor,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "实名认证",
        elevation: 0,
        backEvent: () {
          pop();
        },
      ),
      backgroundColor: AppColor.frenchColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView(
            children: <Widget>[
              _alertWidget(),
              _nameWidget(),
              Container(
                height: 0.2,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Container(
                  color: Color(0xffe9e9e9),
                ),
              ),
              _idcardWidget(),
              _saveButton(context),
              Container(
                padding: EdgeInsets.only(top: 20.w),
                alignment: Alignment.center,
                child: _verifyReseason(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _alertWidget() {
    return Container(
      alignment: Alignment.center,
      height: 30,
      color: Color(0xfffff5e1),
      width: double.infinity,
      child: Text(
        '身份认证仅限一次，请确保认证身份是本人',
        style: TextStyle(color: Color(0xffe9a213), fontSize: 13),
      ),
    );
  }

  _nameWidget() {
    return Container(
      height: 51,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(
              "真实姓名",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              keyboardType: TextInputType.text,
              controller: _nameEditController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_submitted) {
                setState(() {});
              },
              onChanged: (text) {
                setState(() {});
              },
              placeholder: "请输入",
              placeholderStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
              decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  textBaseline: TextBaseline.ideographic),
            ),
          ),
        ],
      ),
    );
  }

  _idcardWidget() {
    return Container(
      height: 51,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(
              "身份证号",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              maxLength: 18,
              keyboardType: TextInputType.text,
              controller: _idCardController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_submitted) {
                setState(() {});
              },
              onChanged: (text) {
                setState(() {});
              },
              placeholder: "请输入",
              placeholderStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
              decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  textBaseline: TextBaseline.ideographic),
            ),
          ),
        ],
      ),
    );
  }

  _verifyReseason() {
    return MaterialButton(
      padding: EdgeInsets.all(4.rw),
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 2.w),
            child: Icon(
              Icons.help_outline,
              size: 20.rw,
              color: Color(0xFFD5101A),
            ),
          ),
          10.wb,
          Text(
            "为什么要实名认证",
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
      onPressed: () {
        Alert.show(
            context,
            NormalContentDialog(
              type: NormalTextDialogType.remind,
              title: null,
              content: Text(
                '根据海关规定，购买跨境商品需要办理清关手续，请您配合进行实名认证，以确保购买的商品顺利通过海关检查。（瑞库客承诺用户上传的身份信息将仅用于办理跨境商品的清关手续，不作他途使用，并对身份信息加密）实名认证的规则：购买跨境商品需填写瑞库客账号注册人的真实姓名及身份证号码。',
                style: TextStyle(color: Colors.black),
              ),
              items: ["我知道了"],
              listener: (index) {
                Alert.dismiss(context);
              },
            ));
      },
    );
  }

  bool _canSubmit() {
    if (!TextUtils.isEmpty(_nameEditController.text) &&
        (!TextUtils.isEmpty(_idCardController.text) &&
            _idCardController.text.length == 18)) {
      return true;
    } else {
      return false;
    }
  }

  Container _saveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
      child: CustomImageButton(
        padding: EdgeInsets.symmetric(vertical: 8),
        title: "确认提交",
        disabledColor: Color.fromARGB(255, 100, 100, 100),
        backgroundColor:
            !_canSubmit() ? AppColor.greyColor : AppColor.themeColor,
        color: Colors.white,
        fontSize: 16 * 2.sp,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        onPressed: !_canSubmit()
            ? null
            : () {
                _verifyIDCard(context);
              },
      ),
    );
  }

  _verifyIDCard(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    //网络请求验证
    HttpResultModel resultModel = await _presenter.realInfo(
        UserManager.instance.user.info.id,
        _nameEditController.text,
        _idCardController.text);
    //绑定失败
    if (resultModel.code != HttpStatus.SUCCESS) {
      Map arguments = VerifyResultPage.setArgument(false);
      arguments.putIfAbsent('isCashWithdraw', () => _isCashWithdraw);
      AppRouter.pushAndReplaced(context, RouteName.USER_VERIFY_RESULT,
          arguments: arguments);
      // Toast.showError(resultModel.msg);
      return;
    } else {
      setState(() {
        UserManager.instance.user.info.realName = _nameEditController.text;
        UserManager.instance.user.info.idCard = _idCardController.text;
        UserManager.instance.user.info.realInfoStatus = true;
      });
      UserManager.updateUserInfo(getStore());
      AppRouter.pushAndReplaced(context, RouteName.USER_VERIFY_RESULT,
          arguments: VerifyResultPage.setArgument(true));
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:recook/base/base_store_state.dart';
// import 'package:recook/constants/header.dart';
// import 'package:recook/manager/http_manager.dart';
// import 'package:recook/manager/user_manager.dart';
// import 'package:recook/widgets/custom_app_bar.dart';
// import 'package:recook/widgets/custom_image_button.dart';
// import 'package:recook/widgets/edit_tile.dart';
// import 'package:recook/widgets/toast.dart';
// import 'package:recook/pages/user/mvp/user_presenter_impl.dart';

// class VerifyPage extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _VerifyPageState();
//   }
// }

// class _VerifyPageState extends BaseStoreState<VerifyPage>{
//   //http实例
//   UserPresenterImpl _presenter;
//   String realName;      //真实姓名
//   String idCard;        //身份证号
//   // String bankAddress = "";   //开户银行地址
//   // String bankNumber;    //银行卡号

//   @override
//   void initState() {
//     super.initState();
//     _presenter = UserPresenterImpl();
//   }

//   @override
//   Widget buildContext(BuildContext context, {store}) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         themeData: AppThemes.themeDataGrey.appBarTheme,
//         title: "实名认证",
//         elevation: 1,
//         backEvent: (){
//           pop();
//         },
//       ),
//       backgroundColor: AppColor.frenchColor,
//       body: _buildBody(context),
//     );
//   }

//   _buildBody(BuildContext context){
//     return GestureDetector(
//       onTap: (){
//         FocusScope.of(context).requestFocus(new FocusNode());
//       },
//       child: Container(
//         child: MediaQuery.removePadding(
//           context: context,
//           removeTop: true,
//           removeBottom: true,
//           child: ListView(
//             padding: EdgeInsets.all(10),
//             children: <Widget>[
//               Container(height: 10, ),
//               Container(
//               child:
//               Text("为保障账户安全，需保证姓名，身份证，银行卡开户人为同一人",
//                 style: AppTextStyle.generate(13*2.sp,
//                 color: Colors.grey,)),
//               padding: EdgeInsets.all(rSize(10)),
//               alignment: Alignment.center,
//               ),
//               Container(height: 20,),
//               EditTile(title: "真实姓名", hint: "请输入真实姓名", textChanged: (value){
//                 realName = value;
//               },),
//               EditTile(title: "身份证号", hint: "请输入身份证号", textChanged: (value){
//                 idCard = value;
//               },),
//               // EditTile(title: "银行开户行", hint: "请输入开户行", textChanged: (value){
//               //   bankAddress = value;
//               // },),
//               EditTile(title: "银行卡号", hint: "请输入正确的银行卡号", textChanged: (value){
//                 bankNumber = value;
//               },),
//               Container(
//                 height: 100,
//               ),
//               _saveButton(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Container _saveButton(BuildContext context){
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 40),
//       child: CustomImageButton(
//         padding: EdgeInsets.symmetric(vertical: 8),
//         title: "立即验证",
//         backgroundColor: AppColor.themeColor,
//         color: Colors.white,
//         fontSize: 16*2.sp,
//         borderRadius: BorderRadius.all(Radius.circular(8)),
//         onPressed: (){
//           _verifyIDCard(context);
//         },
//       ),
//     );
//   }

//   _verifyIDCard(BuildContext context) async{
//     if (TextUtils.isEmpty(realName)) {
//       Toast.showError("真实姓名不能为空");
//       return;
//     }

//     if (TextUtils.isEmpty(idCard)) {
//       Toast.showError("身份证号码不能为空");
//       return;
//     }

//     // if (TextUtils.isEmpty(bankAddress)) {
//     //   Toast.showError("银行开户行不能为空");
//     //   return;
//     // }

//     if (TextUtils.isEmpty(bankNumber)) {
//       Toast.showError("银行卡号不能为空");
//       return;
//     }
//     //网络请求验证
//     HttpResultModel resultModel = await _presenter.realBinding(
//       UserManager.instance.user.info.id, realName, idCard, bankAddress, bankNumber
//       );
//     //绑定失败
//     if (resultModel.code != HttpStatus.SUCCESS) {
//       Toast.showError(resultModel.msg);
//       return;
//     }else{
//       // Navigator.maybePop<dynamic>(context, true);
//       Navigator.pop(context, true);
//     }

//   }

// }
