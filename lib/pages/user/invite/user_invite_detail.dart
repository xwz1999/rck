import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/invite_list_model.dart';
import 'package:jingyaoyun/pages/store/modify_info_page.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInviteDetail extends StatefulWidget {
  final Map arguments;
  UserInviteDetail({Key key, this.arguments}) : super(key: key);

  static setArguments(InviteModel inviteModel) {
    return {
      "inviteModel": inviteModel,
    };
  }

  @override
  _UserInviteDetailState createState() => _UserInviteDetailState();
}

class _UserInviteDetailState extends BaseStoreState<UserInviteDetail> {

  InviteModel _inviteModel;
  @override
  void initState() { 
    super.initState();
    _inviteModel = widget.arguments["inviteModel"];
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "用户详情",
        elevation: 1,
        backEvent: (){
          pop();
        },),
        backgroundColor: AppColor.frenchColor,
        body: _body(),
    );
  }

  _body(){
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        _rowContainer("头像", headImage: true),
        _rowContainer("角色", vip: true),
        _rowContainer("昵称", subTitle: _inviteModel.nickname),
        GestureDetector(
          onTap: (){
            push(RouteName.MODIFY_DETAIL_PAGE,
                      arguments:
                          ModifyInfoPage.setArguments("修改备注", _inviteModel.remarkName, maxLength: 7))
                  .then((value) {
                if (value != null) {
                  _updateRemarkName(value);
                }
              });
          },
          child: _rowContainer("备注", subTitle: TextUtils.isEmpty(_inviteModel.remarkName)?"未设置":_inviteModel.remarkName, edit: true),
        ),
        _rowContainer("注册时间", subTitle: _inviteModel.createdAt),
        Container(height: 20,),
        GestureDetector(
          onTap: (){
            if (!TextUtils.isEmpty(_inviteModel.phoneNum)) launch("tel:${_inviteModel.phoneNum}");
          },
          child: _rowContainer("手机号", subTitle: TextUtils.isEmpty(_inviteModel.phoneNum)?"未设置":_inviteModel.phoneNum, phone: true),
        ),
        GestureDetector(
          onTap: (){
            if(TextUtils.isEmpty(_inviteModel.wechatNo)) return;
            ClipboardData data = new ClipboardData(text:_inviteModel.wechatNo.toString());
            Clipboard.setData(data);
            Toast.showSuccess('微信号已经保存到剪贴板');
          },
          child: _rowContainer("微信号", subTitle: TextUtils.isEmpty(_inviteModel.wechatNo)?"未设置":_inviteModel.wechatNo, copy: !TextUtils.isEmpty(_inviteModel.wechatNo)),
        ),
      ],
    );
  }
  
  _rowContainer(title, {bool headImage=false, bool vip = false, String subTitle = "", bool edit=false,bool copy=false,bool phone=false})
    {
    return Container(
      height: 60, width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0, right: 0, bottom: 0, top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: TextStyle(color: Colors.black,fontSize: 14 ),),
                  Spacer(),
                  
                  headImage?
                  _imageView()
                  :vip?
                  UserLevelTool.roleLevelWidget(level: UserLevelTool.roleLevel(_inviteModel.roleLevel))
                  // UserIconWidget.levelWidget(_inviteModel.role)
                  :!TextUtils.isEmpty(subTitle)?
                  Text(subTitle, style: TextStyle(color: Colors.grey, fontSize: 14),)
                  :Container(),

                  edit?
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset("assets/user_invite_detail_edit.png", width: 14, height: 14,),)
                  :copy?
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset('assets/user_invite_detail_copy.png', width: 14, height: 14),)
                  : phone?
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset('assets/callphone.png', width: 14, height: 14),)
                  :Container(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
  _imageView() {
    return Container( //头像
      // margin: EdgeInsets.only(left: 12, right: 12, top: 7.5, bottom: 7.5),
      width: 45, height: 45,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(22.5)),
          child: CustomCacheImage(
            fit: BoxFit.cover,
            imageUrl: Api.getResizeImgUrl(_inviteModel.headImgUrl, 120),
            placeholder: AppImageName.placeholder_1x1,
          ),),
      ),
    );
  }
  _updateRemarkName(String name) async {
    ResultData resultData = await HttpManager.post(UserApi.invite_remark_name, {
      "userId": _inviteModel.userId,
      "remarkName":name
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _inviteModel.remarkName = name;
    setState(() {});
  }
}
