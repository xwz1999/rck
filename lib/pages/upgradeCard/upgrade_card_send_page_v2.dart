import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/user_common_model.dart';
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

  Future<List<UserCommonModel>> fetchList(String searchCond) async {
    ResultData resultData = await HttpManager.post(APIV2.userAPI.myGroup, {
      "keyword": '',
    });
    if (resultData == null ||
        resultData.data == null ||
        resultData.data['data'] == null) return [];
    return (resultData.data['data'] as List)
        .map((e) => UserCommonModel.fromJson(e))
        .toList();
  }

  List<UserCommonModel> _models = [];

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '权益卡赠送',
      body: RefreshWidget(
        onRefresh: () async {
          _page = 1;
          _models = await fetchList('');
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
              phone: item.phone,
              shopRole: UserLevelTool.roleLevelEnum(item.roleLevel),
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
