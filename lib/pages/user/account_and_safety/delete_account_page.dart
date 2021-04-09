import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oktoast/oktoast.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class DeleteAccountPage extends StatefulWidget {
  DeleteAccountPage({Key key}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final deleteInfo = [
    '您的账户无法登录与使用',
    '身份、账户信息、会员权益将被清空且无法恢复',
    '您账户内的资产（余额、瑞币、优惠券、权益卡等）将会被清空且无法恢复',
    '您已完成的交易将无法处理售后',
    '您将无法便捷地查询帐号历史交易记录',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBackground: Colors.white,
        title: Text(
          '注销账户',
          style: TextStyle(
            color: AppColor.blackColor,
          ),
        ),
        themeData: AppBarTheme(brightness: Brightness.light),
        leading: _backButton(context),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(rSize(16)),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(4)),
                  ),
                  padding: EdgeInsets.zero,
                  color: Color(0xFFF0F0F0),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NormalTextDialog(
                        title: '注销提示',
                        content: '确定注销账户？',
                        items: ['取消'],
                        type: NormalTextDialogType.delete,
                        listener: (index) {
                          switch (index) {
                            case 0:
                              Navigator.pop(context);
                              break;
                          }
                        },
                        deleteItem: '确定',
                        deleteListener: () {
                          //TODO 注销账号
                          HttpManager.post(UserApi.deleteAccount, {
                            "user_id": UserManager.instance.user.info.id,
                          }).then((value) {
                            if (value.data['code'] == "SUCCESS") {
                              UserManager.logout();
                            } else {
                              showToast('注销失败${value.data['msg']}');
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    );
                  },
                  textColor: Color(0xFF666666),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: rSize(12),
                    ),
                    child: Text('确认注销'),
                  ),
                ),
              ),
              SizedBox(width: rSize(16)),
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rSize(4)),
                  ),
                  padding: EdgeInsets.zero,
                  color: Color(0xFFDB2D2D),
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: rSize(12),
                    ),
                    child: Text('不注销了'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(rSize(16)),
        children: [
          Text(
            '请注意，一旦注销账户：',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: rSize(30)),
        ]..addAll(deleteInfo.map((e) => _buildChildTile(e))),
      ),
    );
  }

  _buildChildTile(String title) {
    return Container(
      child: Row(
        children: [
          Container(
            width: rSize(8),
            height: rSize(8),
            margin: EdgeInsets.only(right: rSize(10)),
            decoration: BoxDecoration(
              color: Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(rSize(4)),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: rSP(14),
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: rSize(20)),
    );
  }

  _backButton(context) {
    if (Navigator.canPop(context)) {
      return IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    } else
      return SizedBox();
  }
}
