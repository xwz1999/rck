import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/live/models/tencent_im_user_model.dart';
import 'package:tencent_im_plugin/entity/group_info_entity.dart';
import 'package:tencent_im_plugin/entity/group_member_entity.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

class TencentIMTool {
  static TencentIMUserModel model;
  static int loginCount = 0;
  static Future login() async {
    if (model == null) model = await getTencentImUser();
    DPrint.printLongJson('${model.sign}');
    await TencentImPlugin.login(
      identifier: model.identifier,
      userSig: model.sign,
    ).catchError((e) {
      loginCount++;
      model = null;
      if (loginCount < 20) login();
    });
  }

  static Future<TencentIMUserModel> getTencentImUser() async {
    final bool isLogin = UserManager.instance.haveLogin;
    ResultData resultData = await HttpManager.post(
      isLogin ? LiveAPI.tencentUser : LiveAPI.tencentUserNotLogin,
      {},
    );
    if (resultData?.data['data'] == null)
      return TencentIMUserModel.empty();
    else
      return TencentIMUserModel.fromJson(resultData?.data['data']);
  }
}

class TencentGroupTool {
  ///Group Id
  String id;

  ///用户数量
  int memberLength = 0;
  TencentGroupTool.fromId(this.id);

  ///申请加入直播见
  Future joinGroup() async {
    await TencentImPlugin.applyJoinGroup(
      groupId: this.id,
      reason: 'join group',
    );
  }

  ///获取直播间人数
  Future<List<GroupMemberEntity>> groupMembers() async {
    List<GroupMemberEntity> result =
        await TencentImPlugin.getGroupMembers(groupId: id);
    memberLength = result.length;
    return result;
  }

  Future<GroupInfoEntity> getGroupInfo() async {
    return await TencentImPlugin.getGroupInfo(id: id);
  }
}
