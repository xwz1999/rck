import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/invite_list_model.dart';
import 'package:recook/pages/user/widget/user_group_card.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UpgradeeCardSendPageV2 extends StatefulWidget {
  UpgradeeCardSendPageV2({Key key}) : super(key: key);

  @override
  _UpgradeeCardSendPageV2State createState() => _UpgradeeCardSendPageV2State();
}

class _UpgradeeCardSendPageV2State extends State<UpgradeeCardSendPageV2> {
  int _page = 1;

  Future<List<InviteModel>> fetchList(int page, String searchCond) async {
    ResultData resultData = await HttpManager.post(UserApi.invite, {
      "userId": UserManager.instance.user.info.id,
      "SearchCond": searchCond,
      "page": page,
    });
    if (resultData == null ||
        resultData.data == null ||
        resultData.data['data'] == null) return [];
    return (resultData.data['data'] as List)
        .map((e) => InviteModel.fromJson(e))
        .toList();
  }

  List<InviteModel> _models = [];

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '权益卡赠送',
      body: RefreshWidget(
        onRefresh: () async {
          _page = 1;
          await fetchList(_page, '');
          _refreshController.refreshCompleted();
          setState(() {});
        },
        controller: _refreshController,
        body: ListView.builder(
          itemBuilder: (context, index) {
            final item = _models[index];
            return UserGroupCard(
              name: item.nickname,
              wechatId: item.wechatNo,
              phone: item.phoneNum,
              shopRole: UserLevelTool.roleLevelEnum(item.role),
              groupCount: item.count,
              headImg: item.headImgUrl,
              id: item.userId,
              isRecommend: false,
              remarkName: item.remarkName,
              onTap: () => Get.back(result: item.userId),
            );
          },
          itemCount: _models.length,
        ),
      ),
    );
  }
}
